--------------------------------------------------------------------------------
--                  Promote Job2_Gamb Progress Func                           --
--------------------------------------------------------------------------------
------------------------------------------------------
-- InitDungeon : 초기화함수( 도어, 룰렛, 주사위, npc 리젠 )
------------------------------------------------------

function InitDungeon( Var )
cExecCheck "InitDungeon"

	-- DebugLog( "==========================InitDungeon_Start==========================" )

	if Var == nil
	then
		ErrorLog("InitDungeon::Var == nil")
		return
	end

	-- 플레이어의 첫 로그인을 기다린다.
	if Var["PlayerHandle"] == INVALID_HANDEL
	then
		-- DebugLog("플레이어 로그인 대기")
		if Var["InitialSec"] + WAIT_PLAYER_MAP_LOGIN_SEC_MAX <= cCurrentSecond()
		then
			ErrorLog("플레이어 맵에 로그인 안함")
			Var["StepFunc"] 	= QuestFailed
			return
		end

		return
	end
	
	-- Gate Regen
	local RegenExitGate  = RegenInfo["ExitGate"]
	local nExitGateHandle = cDoorBuild( Var["MapIndex"], RegenExitGate["Index"], RegenExitGate["x"], RegenExitGate["y"], RegenExitGate["dir"], RegenExitGate["scale"] )

	if nExitGateHandle ~= nil
	then
		if cSetAIScript ( MainLuaScriptPath, nExitGateHandle ) == nil
		then
			ErrorLog( "InitDungeon::cSetAIScript ( MainLuaScriptPath, nExitGateHandle ) == nil" )
		end

		if cAIScriptFunc( nExitGateHandle, "NPCClick", "Click_ExitGate" ) == nil
		then
			ErrorLog( "InitDungeon::cAIScriptFunc( nExitGateHandle, \"NPCClick\", \"Click_ExitGate\" ) == nil" )
		end
	else
		GoToFail( Var, "InitDungeon:: Exit Gate Regen Fail" )
		return
	end

	-- Door Regen
	for i = 1, #RegenInfo["Door"]
	do
		local CurRegenDoor 		= RegenInfo["Door"][i]
		local CurDoorHandle 	= cDoorBuild( Var["MapIndex"], CurRegenDoor["MobIndex"], CurRegenDoor["X"], CurRegenDoor["Y"], CurRegenDoor["Dir"], CurRegenDoor["Scale"] )

		if CurDoorHandle == nil
		then
			GoToFail( Var, "InitDungeon::Door was not created. : " )
			return
		end

		if Var["Door"]["Handle"] == nil
		then
			Var["Door"]["Handle"] = {}
		end
		cDoorAction( CurDoorHandle, CurRegenDoor["DoorBlock"], "close" )
		Var["Door"]["Handle"][i] 	= CurDoorHandle

	end
	-- DebugLog( "문 리젠 완료")


	-- NPC Regen
	local RegenNPC 		= RegenInfo["NPC"]
	local NPCHandle 	= cMobRegen_XY( Var["MapIndex"], RegenNPC["MobIndex"], RegenNPC["X"], RegenNPC["Y"], RegenNPC["Dir"] )

	if NPCHandle == nil
	then
		GoToFail( Var, "InitDungeon:: NPC Regen Fail" )
		return
	end

	Var["NPC"]["Handle"] = NPCHandle
	-- DebugLog( "npc 리젠 완료" )


	-- Roullet Regen
	local CurRoulette 		= RegenInfo["Roulette"]
	local RouletteHandle	= cMobRegen_XY( Var["MapIndex"], CurRoulette["MobIndex"], CurRoulette["X"], CurRoulette["Y"], CurRoulette["Dir"] )

	if RouletteHandle == nil
	then
		GoToFail( Var, "InitDungeon:: Roullet Regen Fail" )
		return
	end

	cSetAIScript	( MainLuaScriptPath, RouletteHandle )
	cAIScriptFunc	( RouletteHandle, "Entrance",  "DummyRoutineFunc" )
	cAIScriptFunc	( RouletteHandle, "NPCClick", "Roulette_Click" )
	cAIScriptFunc	( RouletteHandle, "NPCMenu",  "Menu" )

	Var["Roulette"]["Handle"] 	= RouletteHandle
	-- DebugLog( "Roulette 리젠 완료" )


	-- Dice Regen
	for i = 1, #RegenInfo["Dice"]
	do
		local CurRegenDice 		= RegenInfo["Dice"][i]
		local CurDiceHandle		= cMobRegen_XY( Var["MapIndex"], CurRegenDice["MobIndex"], CurRegenDice["X"], CurRegenDice["Y"], CurRegenDice["Dir"] )

		if CurDiceHandle == nil
		then
			GoToFail( Var, "InitDungeon:: Dice was not created. : "..i  )
			return
		end

		cSetAIScript	( MainLuaScriptPath, CurDiceHandle )
		cAIScriptFunc	( CurDiceHandle, "Entrance", "DummyRoutineFunc" )
		cAIScriptFunc	( CurDiceHandle, "NPCClick", "Dice_Click" )

		if Var["Dice"]["Handle"] == nil
		then
			Var["Dice"]["Handle"] = {}
		end

		Var["Dice"]["Handle"][i] = CurDiceHandle
	end
	-- DebugLog( "Dice 리젠 완료" )


	-- 리젠완료 후 다음단계 설정
	Var["StepFunc"] 		= WelcomeGamble
	Var["InitDungeon"]		= nil

end


------------------------------------------------------
-- WelcomeGamble : 조커 환영인사
------------------------------------------------------

function WelcomeGamble( Var )
cExecCheck "WelcomeGamble"

	-- DebugLog( "==========================WelcomeGamble_Start==========================" )

	if Var == nil
	then
		ErrorLog( "WelcomeGamble : Var nil" )
		return
	end

	-- WelcomeGamble 초기화
	local WelcomeGambleInfo 	= Var["WelcomeGamble"]

	if WelcomeGambleInfo == nil
	then
		-- DebugLog("WelcomeGamble :: 초기화")

		Var["WelcomeGamble"] 					= {}
		WelcomeGambleInfo	 					= Var["WelcomeGamble"]

		WelcomeGambleInfo["NextStepWaitTime"]	= Var["CurSec"] + ( DelayTime["GapDialog"] * #ChatInfo["WelcomeGamble"] ) + DelayTime["WaitSeconds"]
		WelcomeGambleInfo["DialogTime"]			= Var["CurSec"] + DelayTime["GapDialog"]
		WelcomeGambleInfo["DialogStep"]			= 1
	end

	if WelcomeGambleInfo["DialogTime"] ~= nil
	then
		-- DebugLog("WelcomeGamble :: 대화설정")

		if WelcomeGambleInfo["DialogTime"] > Var["CurSec"]
		then
			return
		end


		local CurMsg 			= ChatInfo["WelcomeGamble"]
		local DialogStep		= WelcomeGambleInfo["DialogStep"]
		local MaxDialogStep		= #ChatInfo["WelcomeGamble"]

		if DialogStep <= MaxDialogStep
		then
			cMobDialog( Var["MapIndex"], CurMsg[DialogStep]["SpeakerIndex"], ChatInfo["ScriptFileName"], CurMsg[DialogStep]["MsgIndex"] )

			WelcomeGambleInfo["DialogTime"]	= Var["CurSec"] + DelayTime["GapDialog"]
			WelcomeGambleInfo["DialogStep"]	= DialogStep + 1
		end

		if WelcomeGambleInfo["DialogStep"] > MaxDialogStep
		then
			WelcomeGambleInfo["DialogTime"]	= nil
			WelcomeGambleInfo["DialogStep"]	= nil
		end
	end

	if WelcomeGambleInfo["NextStepWaitTime"] > Var["CurSec"]
	then
		return
	end

	-- 타이머 설정
	if Var["LimitTime"] == 0
	then
		Var["LimitTime"] 		= Var["CurSec"] + DelayTime["LimitTime"]
		cTimer( Var["MapIndex"], DelayTime["LimitTime"] )
	end
	-- DebugLog( "LimitTime"..Var["LimitTime"] )

	-- DebugLog("다음단계로 이동")
	Var["StepFunc"]				= HowToRouletteGame
	Var["WelcomeGamble"]		= nil

end


------------------------------------------------------
-- HowToRouletteGame : 룰렛게임 규칙 대사처리, 관련된 변수들 초기화
------------------------------------------------------

function HowToRouletteGame( Var )
cExecCheck "HowToRouletteGame"

-- DebugLog("==========================HowToRouletteGame_Start==========================")

	if Var == nil
	then
		ErrorLog( "PlayRouletteGame : Var nil" )
		return
	end

	-- 실패조건에 해당하는지 체크
	if IsFail( Var ) == true
	then
		return
	end

	local PlayRouletteGameInfo = Var["PlayRouletteGame"]
	if PlayRouletteGameInfo == nil
	then
		Var["PlayRouletteGame"] 					= {}
		PlayRouletteGameInfo						= Var["PlayRouletteGame"]

		PlayRouletteGameInfo["RouletteHandle"]		= nil
		PlayRouletteGameInfo["SelectedDiceHandle"]	= nil
		PlayRouletteGameInfo["SelectedDiceNum"]		= nil

		PlayRouletteGameInfo["ReadyToGame"]			= false
		PlayRouletteGameInfo["OptionHandle"]		= nil
		PlayRouletteGameInfo["PlayerHandle"]		= nil

		PlayRouletteGameInfo["AnswerDiceNum"]		= nil
		PlayRouletteGameInfo["DialogTime"]			= Var["CurSec"] + DelayTime["GapDialog"]
	end

	-- 대사 할 시간 아직 안 됐으면 return, 시간 됐으면 대사처리
	if PlayRouletteGameInfo["DialogTime"] ~= nil
	then

		if PlayRouletteGameInfo["DialogTime"] > Var["CurSec"]
		then
			return
		end

		PlayRouletteGameInfo["DialogTime"] 		= nil
		Var["StepFunc"]							= PlayRouletteGame
	end
end


------------------------------------------------------
-- PlayRouletteGame : 유저가 주사위, 룰렛 택하는 단계
------------------------------------------------------

function PlayRouletteGame( Var )
cExecCheck "PlayRouletteGame"

	-- DebugLog("==========================PlayRouletteGame_Start==========================")

	if Var == nil
	then
		ErrorLog( "PlayRouletteGame : Var nil" )
		return
	end

	-- 실패조건에 해당하는지 체크
	if IsFail( Var ) == true
	then
		return
	end

	-- 초기화
	local PlayRouletteGameInfo = Var["PlayRouletteGame"]
	if PlayRouletteGameInfo == nil
	then
		ErrorLog( "PlayRouletteGame : PlayRouletteGameInfo nil" )
		return
	end

	-- 룰렛 돌릴 준비 X :  return / 룰렛 돌릴 준비 O : 룰렛도 주사위 선택하기위해 SetAnswerDice() 호출
	if PlayRouletteGameInfo["ReadyToGame"] == true
	then
		SetAnswerDice( Var )
		local AnswerDiceNumber = PlayRouletteGameInfo["AnswerDiceNum"]

		if AnswerDiceNumber == nil
		then
			ErrorLog( "PlayRouletteGame::AnswerDiceNumber == nil" );
			return
		end
		Var["StepFunc"] = ResultRouletteGame
	else
		return
	end

end


------------------------------------------------------
-- ResultRouletteGame : 룰렛게임 결과 처리( 룰렛, 주사위 애니메이션 처리 및 유저선택 주사위와, 룰렛선택 주사위를 비교, 그에 따른 처리 )
------------------------------------------------------

function ResultRouletteGame( Var )
cExecCheck "ResultRouletteGame"

	-- DebugLog("==========================ResultRouletteGame_Start==========================")

	if Var == nil
	then
		ErrorLog( "ResultRouletteGame : Var nil" )
		return
	end

	if IsFail( Var ) == true
	then
		return
	end

	local PlayRouletteGameInfo = Var["PlayRouletteGame"]
	if PlayRouletteGameInfo == nil
	then
		ErrorLog( "ResultRouletteGame : PlayRouletteGameInfo nil" )
		return
	end

	-- 초기화
	local ResultRouletteGameInfo = Var["ResultRouletteGame"]
	if ResultRouletteGameInfo == nil
	then
		Var["ResultRouletteGame"] 	= {}
		ResultRouletteGameInfo		= Var["ResultRouletteGame"]

		ResultRouletteGameInfo["AniStartTime"]		= Var["CurSec"]
		ResultRouletteGameInfo["NextStepWaitTime"]	= Var["CurSec"] + DelayTime["WaitBeforeWinOrLose"]

		local AnswerDiceNumber						= PlayRouletteGameInfo["AnswerDiceNum"]

		-- 조커 대사 처리( 행운을 빌지.. )
		cMobDialog( Var["MapIndex"], ChatInfo["PlayRouletteGame"]["Luck"]["SpeakerIndex"], ChatInfo["ScriptFileName"], ChatInfo["PlayRouletteGame"]["Luck"]["MsgIndex"] )

		-- 룰렛 애니메이션 시작
		cAnimate( PlayRouletteGameInfo["RouletteHandle"], "start", AnimationInfo["Roulette"][AnswerDiceNumber] )

		-- 주사위 애니메이션( 선택하지 않은 주사위들만 Animove애니메이션 재생 )
		for i =1, #Var["Dice"]["Handle"]
		do
			if Var["Dice"]["Handle"][i] ~= PlayRouletteGameInfo["SelectedDiceHandle"]
			then
				cAnimate( Var["Dice"]["Handle"][i], "start", AnimationInfo["Dice"]["AniMove"] )
			end
		end

		-- 룰렛 시작 이펙트
		cEffectRegen_Object	( Var["MapIndex"], EffectInfo["Roullete_start"]["FileName"], PlayRouletteGameInfo["RouletteHandle"], EffectInfo["Roullete_start"]["PlayTime"] )
	end

	-- 다음단계 진행할 시간인지 확인
	if ResultRouletteGameInfo["NextStepWaitTime"] > Var["CurSec"]
	then
		return

	end

	cAnimate( PlayRouletteGameInfo["RouletteHandle"], "stop" )

	for i =1, #Var["Dice"]["Handle"]
	do
		if Var["Dice"]["Handle"][i] ~= PlayRouletteGameInfo["SelectedDiceHandle"]
		then
			cAnimate( Var["Dice"]["Handle"][i], "start", AnimationInfo["Dice"]["AniOff"] )
		end
	end

	-- 유저가 선택한 주사위와, 룰렛이 선택한 주사위가 같다면
	if PlayRouletteGameInfo["SelectedDiceNum"] == PlayRouletteGameInfo["AnswerDiceNum"]
	then
		-- DebugLog("룰렛 맞추기 성공")
		cEffectRegen_Object	( Var["MapIndex"], EffectInfo["Roullete_Match_Success"]["FileName"], PlayRouletteGameInfo["RouletteHandle"], EffectInfo["Roullete_Match_Success"]["PlayTime"] )
		Var["StepFunc"] = WinRouletteGame

	-- 유저가 선택한 주사위와, 룰렛이 선택한 주사위가 다르다면
	else
		-- DebugLog("룰렛 맞추기 실패")
		cEffectRegen_Object	( Var["MapIndex"], EffectInfo["Roullete_Match_Fail"]["FileName"], PlayRouletteGameInfo["RouletteHandle"], EffectInfo["Roullete_Match_Fail"]["PlayTime"] )
		Var["StepFunc"] = LoseRouletteGame
	end


end


------------------------------------------------------
-- LoseRouletteGame  : 룰렛게임 실패시
------------------------------------------------------

function LoseRouletteGame( Var )
cExecCheck "LoseRouletteGame"

	-- DebugLog("==========================LoseRouletteGame_Start==========================")

	if Var == nil
	then
		ErrorLog( "LoseRouletteGame : Var nil" )
		return
	end

	-- 실패조건에 해당하는지 체크
	if IsFail( Var ) == true
	then
		return
	end

	local LoseRouletteGameInfo 		= Var["LoseRouletteGame"]
	if LoseRouletteGameInfo == nil
	then
		Var["LoseRouletteGame"] 	= {}
		LoseRouletteGameInfo		= Var["LoseRouletteGame"]

		-- 룰렛 게임 횟수 1 증가
		Var["RouletteCount"] 						= Var["RouletteCount"] + 1
		LoseRouletteGameInfo["WaitMobRegen"]		= Var["CurSec"] + DelayTime["WaitMobRegen"]
	end

	-- 몹 리젠시간만큼 기다린 후, 맵에 있는 몹의 수 카운트, 몹을 모두 죽인 후 다음단계진행가능
	if LoseRouletteGameInfo["WaitMobRegen"] < Var["CurSec"]
	then
		if cObjectCount( Var["MapIndex"], ObjectType["Mob"] ) <= 0
		then
			DiceLightOff( Var )
			Var["LoseRouletteGame"] 	= nil
			Var["PlayRouletteGame"] 	= nil
			Var["ResultRouletteGame"]	= nil
			Var["StepFunc"] 			= HowToRouletteGame
		end
	end
end


------------------------------------------------------
-- WinRouletteGame  : 룰렛게임 성공시
------------------------------------------------------

function WinRouletteGame( Var )
cExecCheck "WinRouletteGame"

	-- DebugLog("==========================WinRouletteGame_Start==========================")

	if Var == nil
	then
		ErrorLog( "WinRouletteGame : Var nil" )
		return
	end

	if IsFail( Var ) == true
	then
		return
	end

	local PlayRouletteGameInfo = Var["PlayRouletteGame"]
	local WinRouletteGameInfo = Var["WinRouletteGame"]
	if WinRouletteGameInfo == nil
	then
		Var["WinRouletteGame"] 					= {}
		WinRouletteGameInfo						= Var["WinRouletteGame"]

		WinRouletteGameInfo["DialogTime"] 		= Var["CurSec"] + DelayTime["GapDialog"]
		WinRouletteGameInfo["NextStepWaitTime"]	= Var["CurSec"] + ( DelayTime["GapDialog"] * #ChatInfo["Roulette_Result"] ) + DelayTime["WaitSeconds"]
	end

	-- 대사 할 시간 아직 안 됐으면 return, 시간 됐으면 대사처리
	if WinRouletteGameInfo["DialogTime"] ~= nil
	then
		if WinRouletteGameInfo["DialogTime"] > Var["CurSec"]
		then
			return
		end
	
		if PlayRouletteGameInfo["OptionHandle"] == 1 then
			local CurReward     = RewardItemInfo["Item"]
			local RewardList     = { cGetPlayerList(Var["MapIndex"]) }
			for i = 1, #RewardList
			do
				cRewardItem( RewardList[i], CurReward["Index"], CurReward["Num"] )
			end
		elseif PlayRouletteGameInfo["OptionHandle"] == 2 then
			local randomNum		= math.random(1, 334)
			local CurReward     = RewardCardsInfo["Cards"][randomNum]
			local RewardList    = { cGetPlayerList(Var["MapIndex"]) }
			for i = 1, #RewardList
			do
				cRewardItem( RewardList[i], CurReward["InxName"], CurReward["Num"] )
			end
		elseif PlayRouletteGameInfo["OptionHandle"] == 3 then
			local randomNum		= math.random(1, 6)
			local CurReward		= RewardBuffInfo["Stats"][randomNum]
			cSetAbstate( PlayRouletteGameInfo["PlayerHandle"], CurReward["Index"], CurReward["Grade"], CurReward["Duration"] )
		end

		cMobDialog( Var["MapIndex"], ChatInfo["Roulette_Result"]["PlayerWin"]["SpeakerIndex"], ChatInfo["ScriptFileName"], ChatInfo["Roulette_Result"]["PlayerWin"]["MsgIndex"] )
		WinRouletteGameInfo["DialogTime"] = nil
	end

	if WinRouletteGameInfo["NextStepWaitTime"] > Var["CurSec"]
	then
		return
	else
		Var["WinRouletteGame"] 			= nil
		Var["PlayRouletteGame"] 		= nil
		Var["ResultRouletteGame"]		= nil
		Var["StepFunc"] 				= HowToRouletteGame
	end

end


------------------------------------------------------
-- QuestFailed : 퀘스트 실패시
------------------------------------------------------

function QuestFailed( Var )
cExecCheck "QuestFailed"

	-- DebugLog("==========================QuestFailed_Start==========================")

	if Var == nil
	then
		ErrorLog( "QuestFailed : Var nil" )
		return
	end

	local QuestFailedInfo = Var["QuestFailed"]
	if QuestFailedInfo == nil
	then
		Var["QuestFailed"] 						= {}
		QuestFailedInfo							= Var["QuestFailed"]

		QuestFailedInfo["NextStepWaitTime"]		= Var["CurSec"] + DelayTime["WaitSeconds"]

		-- 맵에 있는 Job2_CloverT, Job2_DiaT를 제거
		VanishMob( Var )

		--타이머 삭제
		Var["LimitTime"] 	= "NoLimit"
		cTimer( Var["MapIndex"], 0 )
	end

	if QuestFailedInfo["NextStepWaitTime"] > Var["CurSec"]
	then
		-- DebugLog("QuestFailedInfo _ 대기중")
		return
	else
		Var["StepFunc"] 	= ReturnToHome
		Var["QuestFailed"]	= nil
	end

end


------------------------------------------------------
-- ReturnToHome : 귀환
------------------------------------------------------

function ReturnToHome( Var )
cExecCheck "ReturnToHome"

	-- DebugLog("==========================ReturnToHome_Start==========================")

	if Var == nil
	then
		ErrorLog( "ReturnToHome : Var nil" )
		return
	end

	local ReturnToHomeInfo = Var["ReturnToHome"]
	if ReturnToHomeInfo == nil
	then
		Var["ReturnToHome"] 	= {}
		ReturnToHomeInfo		= Var["ReturnToHome"]

		ReturnToHomeInfo["ReturnStepSec"] 			= Var["CurSec"]
		ReturnToHomeInfo["ReturnStepNo"] 			= 1
		ReturnToHomeInfo["WaitSecReturnToHome"] 	= Var["CurSec"] + DelayTime["WaitReturnToHome"]
	end

	if ReturnToHomeInfo["WaitSecReturnToHome"] > Var["CurSec"]
	then
		-- DebugLog( "집으로 돌아가기 대기.." )
		return
	end

	-- Return : return notice substep
	if ReturnToHomeInfo["ReturnStepNo"] <= #NoticeInfo["IDReturn"]
	then
		if ReturnToHomeInfo["ReturnStepSec"] < Var["CurSec"]
		then
			-- Notice of Escape
			if NoticeInfo["IDReturn"][ ReturnToHomeInfo["ReturnStepNo"] ]["Index"] ~= nil
			then
				cNotice( Var["MapIndex"], NoticeInfo["ScriptFileName"], NoticeInfo["IDReturn"][ ReturnToHomeInfo["ReturnStepNo"] ]["Index"] )
			end

			-- Go To Next Notice
			ReturnToHomeInfo["ReturnStepNo"]  = Var["ReturnToHome"]["ReturnStepNo"] + 1
			ReturnToHomeInfo["ReturnStepSec"] = Var["CurSec"] + DelayTime["GapReturnNotice"]
		end
		return
	end

	-- Return : linkto substep
	if ReturnToHomeInfo["ReturnStepNo"] > #NoticeInfo["IDReturn"]
	then
		-- DebugLog( "모든 대사 완료!" )
		if ReturnToHomeInfo["ReturnStepSec"] <= Var["CurSec"]
		then
			-- DebugLog( "이제진짜떠날시간" )
			cLinkToAll( Var["MapIndex"], LinkInfo["ReturnMap"]["MapIndex"], LinkInfo["ReturnMap"]["X"], LinkInfo["ReturnMap"]["Y"] )

			cVanishAll( Var["MapIndex"] )
			--Var["StepFunc"] = TheEnd
			Var["StepFunc"] = DummyFunc
			Var["ReturnToHome"] = nil

			-- 2014.12.23 추가작업
			cDropFilm( Var["MapIndex"], MainLuaScriptPath )

			-- DebugLog( "End ReturnToHome" )
			-- DebugLog("==========================TheEnd==========================")
		end
		return
	end
end
