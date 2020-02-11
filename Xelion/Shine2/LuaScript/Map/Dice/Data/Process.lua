--------------------------------------------------------------------------------
--                Promote Job2_Gamb Process Data                              --
--------------------------------------------------------------------------------

INVALID_HANDEL				= -1
ROULETTEGAME_PLAY_NUM 		= 5					-- 유저가 이 횟수보다 많이 룰렛 돌렸다면, 100% 당첨될 수 있도록 한다


-- 링크 위치 정보( 루멘 개선안 시기에 맞게 데이터 값 수정예정 )
LinkInfo =
{
	ReturnMap = { MapIndex = "Rou", X = 5323, Y = 4501 },
}


-- 지연 시간 정보
DelayTime =
{
	LimitTime				= 300,		-- 플레이 제한시간( 20분 )

	GapDialog				= 5,		-- 페이스컷 출력시간간격
	GapReturnNotice			= 5,		-- ReturnToHome()의 공지메시지 출력시간간격

	WaitMobRegen			= 1,		-- 몹 소환한 뒤, WaitMobRegen만큼 기다렸다가 몹 카운팅
	WaitSeconds				= 1.5,		-- 대사 완료후 이 시간만큼 있다가 다음단계 진행

	WaitBeforeWinOrLose		= 12,		-- ResultRouletteGame() -> WinRouletteGame Or LoseRouletteGame 시작 대기시간
	WaitReturnToHome		= 3,		-- ReturnToHome() 대기시간
}


-- 대사 정보
ChatInfo =
{
	ScriptFileName 		= MsgScriptFileDefault,

	WelcomeGamble =
	{
		{ SpeakerIndex = "Job2_JokerTm", MsgIndex = "Intro04", },					--This is a very simple game, you pick one die and spin the roulette.
		{ SpeakerIndex = "Job2_JokerTm", MsgIndex = "Intro05", },					--If your choice is wrong, you will have some fun time with my slaves.
	},

	PlayRouletteGame =
	{
		Roulette1 	= { SpeakerIndex = "Job2_JokerTm", MsgIndex = "Roulette1",},	-- Pick the die first and then spin the roulette.
		Luck 		= { SpeakerIndex = "Job2_JokerTm", MsgIndex = "Luck",},			-- Good luck to you.
		NoCards 	= { SpeakerIndex = "Job2_JokerTm", MsgIndex = "NoCards",},		-- Good luck to you.
		NoMoney 	= { SpeakerIndex = "Job2_JokerTm", MsgIndex = "NoMoney",},		-- Good luck to you.
	},

	Roulette_Click =
	{
		SpeakerIndex = "Job2_JokerTm", MsgIndex = "NotSelect", 						-- Pick the dicee first and then spin the roulette.
	},

	Roulette_Result =
	{
		PlayerWin = { SpeakerIndex = "Job2_JokerTm", MsgIndex = "PlayerWin",},		-- Congratulations
	},

	QuestSuccess =
	{
		{ SpeakerIndex = "Job2_JokerTm", MsgIndex = "LastScript0",},				-- From where my calculation has been wrong?? That piece of time-space! That must have blinded me!
		{ SpeakerIndex = "Job2_JokerTm", MsgIndex = "LastScript1",},				-- Yes, take that piece of time-space, so that it can blind your eyes too.
	},

}


-- ReturnToHome 공지
NoticeInfo =
{
	ScriptFileName = MsgScriptFileDefault,

	IDReturn =
	{
		{ Index = "RouReturn30", },		-- 30초 남음
		{ Index = nil,          },		-- 25초 남음 : 메세지 없음
		{ Index = "RouReturn20", },		-- 20초 남음
		{ Index = nil,          },		-- 15초 남음 : 메세지 없음
		{ Index = "RouReturn10", },		-- 10초 남음
		{ Index = "RouReturn5" , },		-- 05초 남음
	},
}


-- 이펙트 정보
EffectInfo =
{
	Roullete_start 			= { FileName = "Job2_Gamble", 	PlayTime = 10000 },
	Roullete_Match_Success 	= { FileName = "Job2_GamS", 	PlayTime = 1000 },
	Roullete_Match_Fail		= { FileName = "Job2_GamF", 	PlayTime = 1000 },
}


-- 룰렛, 주사위 애니메이션 정보
AnimationInfo =
{
	Roulette =
	{
		"Stop1",
		"Stop2",
		"Stop3",
		"Stop4",
		"Stop5",
		"Stop6",
	},

	Dice =
	{
		AniMove = "dice_move",
		AniOff 	= "dice_off",
		AniOn 	= "dice_on",
	},
}

RollMoneyPrice =
{
	Consumables = { Price = 2 },
	MobCards	= { Price = 2 },
	Buffs		= { Price = 2 }
}

CardInfo =  
{
	AceCard		= { Index = "CustomItemOrM22", Num = 1 },
	JokerCard	= { Index = "CustomItemOrM23", Num = 1 }
}

RewardItemInfo =
{
    Item     = { Index = "DiceGameVault", Num = 1 }
}

RewardBuffInfo =
{
	Stats =
	{
		[1] = { Index = "StaE_UserComeback05", Grade = 1, Duration = 14400000, },
		[2] = { Index = "StaAdlFLoussier_H", Grade = 1, Duration = 14400000, },
		[3] = { Index = "StaCosMusaAllStat", Grade = 1, Duration = 14400000, },
		[4] = { Index = "StaCosMusaCri", Grade = 1, Duration = 14400000, },
		[5] = { Index = "StaGldMoveSpeedUp", Grade = 1, Duration = 14400000, },
	},
}

RewardCardsInfo =
{
	Cards = 
	{
		{ InxName = "Vault_CC_Slime02", Num = 1 },
		{ InxName = "Vault_CC_Honeying02", Num = 1 },
		{ InxName = "Vault_CC_Mara02", Num = 1 },
		{ InxName = "Vault_CC_Marlone01", Num = 1 },
		{ InxName = "Vault_CC_T_IronGolem01", Num = 1 },
		{ InxName = "Vault_CC_C_JewelGolem01", Num = 1 },
		{ InxName = "Vault_CC_C_JewelGolem02", Num = 1 },
		{ InxName = "Vault_CC_T_IronGolem02", Num = 1 },
		{ InxName = "Vault_CC_Harpy02", Num = 1 },
		{ InxName = "Vault_CC_Helga01", Num = 1 },
		{ InxName = "Vault_CC_Helga02", Num = 1 },
		{ InxName = "Vault_CC_Leviathan01", Num = 1 },
		{ InxName = "Vault_CC_Humar02", Num = 1 },
		{ InxName = "Vault_CC_KalBanObeb02", Num = 1 },
		{ InxName = "Vault_CC_KalBanObeb03", Num = 1 },
		{ InxName = "Vault_CC_Psyken", Num = 1 },
		{ InxName = "Vault_CC_Karen02", Num = 1 },
		{ InxName = "Vault_CC_Karen01", Num = 1 },
		{ InxName = "Vault_CC_Mara01", Num = 1 },
		{ InxName = "Vault_CC_TombRaider03", Num = 1 },
		{ InxName = "Vault_CC_MageBook02", Num = 1 },
		{ InxName = "Vault_CC_Marlone02", Num = 1 },
		{ InxName = "Vault_CC_Marlone03", Num = 1 },
		{ InxName = "Vault_CC_PoisonGolem", Num = 1 },
		{ InxName = "Vault_CC_T_StoneGolem", Num = 1 },
		{ InxName = "Vault_CC_Ghost03", Num = 1 },
		{ InxName = "Vault_CC_SparkDog01", Num = 1 },
		{ InxName = "Vault_CC_Harpy01", Num = 1 },
		{ InxName = "Vault_CC_Harpy04", Num = 1 },
		{ InxName = "Vault_CC_GuardianMaster01", Num = 1 },
		{ InxName = "Vault_CC_Weasel01", Num = 1 },
		{ InxName = "Vault_CC_Helga03", Num = 1 },
		{ InxName = "Vault_CC_Lab_1901", Num = 1 },
		{ InxName = "Vault_CC_Seidstar02", Num = 1 },
		{ InxName = "Vault_CC_Humar01", Num = 1 },
		{ InxName = "Vault_CC_KalBanObeb01", Num = 1 },
		{ InxName = "Vault_CC_PsykenDog", Num = 1 },
		{ InxName = "Vault_CC_MushRoom02", Num = 1 },
		{ InxName = "Vault_CC_Phino02", Num = 1 },
		{ InxName = "Vault_CC_Ratman02", Num = 1 },
		{ InxName = "Vault_CC_Boar01", Num = 1 },
		{ InxName = "Vault_CC_Boogy02", Num = 1 },
		{ InxName = "Vault_CC_MaraSailor01", Num = 1 },
		{ InxName = "Vault_CC_MaraSailor02", Num = 1 },
		{ InxName = "Vault_CC_LizardMan01", Num = 1 },
		{ InxName = "Vault_CC_TombRaider02", Num = 1 },
		{ InxName = "Vault_CC_MageBook01", Num = 1 },
		{ InxName = "Vault_CC_Fox02", Num = 1 },
		{ InxName = "Vault_CC_SkelKnight02", Num = 1 },
		{ InxName = "Vault_CC_SkelKnight01", Num = 1 },
		{ InxName = "Vault_CC_FireGolem", Num = 1 },
		{ InxName = "Vault_CC_Ghost04", Num = 1 },
		{ InxName = "Vault_CC_WereBear02", Num = 1 },
		{ InxName = "Vault_CC_Goblin02", Num = 1 },
		{ InxName = "Vault_CC_Prisoner02", Num = 1 },
		{ InxName = "Vault_CC_NaiadSoul02", Num = 1 },
		{ InxName = "Vault_CC_CloverTrumpy04", Num = 1 },
		{ InxName = "Vault_CC_SpadeTrumpy01", Num = 1 },
		{ InxName = "Vault_CC_Harpy03", Num = 1 },
		{ InxName = "Vault_CC_BlackIncubus02", Num = 1 },
		{ InxName = "Vault_CC_Gagoyle02", Num = 1 },
		{ InxName = "Vault_CC_RubyGuardian-U02", Num = 1 },
		{ InxName = "Vault_CC_GuardianMaster02", Num = 1 },
		{ InxName = "Vault_CC_MagmaTon01", Num = 1 },
		{ InxName = "Vault_CC_Weasel02", Num = 1 },
		{ InxName = "Vault_CC_LivingTotem02", Num = 1 },
		{ InxName = "Vault_CC_Raplan02", Num = 1 },
		{ InxName = "Vault_CC_Leviathan02", Num = 1 },
		{ InxName = "Vault_CC_Lab_1902", Num = 1 },
		{ InxName = "Vault_CC_VehimothUndeath", Num = 1 },
		{ InxName = "Vault_CC_Slime03", Num = 1 },
		{ InxName = "Vault_CC_MushRoom01", Num = 1 },
		{ InxName = "Vault_CC_Imp02", Num = 1 },
		{ InxName = "Vault_CC_Imp01", Num = 1 },
		{ InxName = "Vault_CC_Honeying01", Num = 1 },
		{ InxName = "Vault_CC_Honeying03", Num = 1 },
		{ InxName = "Vault_CC_Phino01", Num = 1 },
		{ InxName = "Vault_CC_Ratman03", Num = 1 },
		{ InxName = "Vault_CC_Ratman01", Num = 1 },
		{ InxName = "Vault_CC_Boar02", Num = 1 },
		{ InxName = "Vault_CC_Boogy01", Num = 1 },
		{ InxName = "Vault_CC_Pinky01", Num = 1 },
		{ InxName = "Vault_CC_Kebing01", Num = 1 },
		{ InxName = "Vault_CC_LizardMan02", Num = 1 },
		{ InxName = "Vault_CC_LizardMan03", Num = 1 },
		{ InxName = "Vault_CC_TombRaider01", Num = 1 },
		{ InxName = "Vault_CC_Fox01", Num = 1 },
		{ InxName = "Vault_CC_Ghost02", Num = 1 },
		{ InxName = "Vault_CC_WereBear01", Num = 1 },
		{ InxName = "Vault_CC_Goblin01", Num = 1 },
		{ InxName = "Vault_CC_Harkan01", Num = 1 },
		{ InxName = "Vault_CC_Harkan02", Num = 1 },
		{ InxName = "Vault_CC_Prisoner01", Num = 1 },
		{ InxName = "Vault_CC_NaiadSoul01", Num = 1 },
		{ InxName = "Vault_CC_CloverTrumpy01", Num = 1 },
		{ InxName = "Vault_CC_CloverTrumpy02", Num = 1 },
		{ InxName = "Vault_CC_CloverTrumpy03", Num = 1 },
		{ InxName = "Vault_CC_SparkDog02", Num = 1 },
		{ InxName = "Vault_CC_SparkDog03", Num = 1 },
		{ InxName = "Vault_CC_SpadeTrumpy02", Num = 1 },
		{ InxName = "Vault_CC_SpadeTrumpy03", Num = 1 },
		{ InxName = "Vault_CC_BlackIncubus01", Num = 1 },
		{ InxName = "Vault_CC_MineMole02", Num = 1 },
		{ InxName = "Vault_CC_MineMole01", Num = 1 },
		{ InxName = "Vault_CC_Gagoyle01", Num = 1 },
		{ InxName = "Vault_CC_RubyGuardian-U01", Num = 1 },
		{ InxName = "Vault_CC_CrystalGuardian-U01", Num = 1 },
		{ InxName = "Vault_CC_CrystalGuardian-U02", Num = 1 },
		{ InxName = "Vault_CC_MagmaTon02", Num = 1 },
		{ InxName = "Vault_CC_Weasel03", Num = 1 },
		{ InxName = "Vault_CC_LivingTotem01", Num = 1 },
		{ InxName = "Vault_CC_Raplan01", Num = 1 },
		{ InxName = "Vault_CC_LivingStone01", Num = 1 },
		{ InxName = "Vault_CC_LivingStatue01", Num = 1 },
		{ InxName = "Vault_CC_Seidstar01", Num = 1 },
		{ InxName = "Vault_CC_Pergy02", Num = 1 },
		{ InxName = "Vault_CC_Pergy01", Num = 1 },
		{ InxName = "Vault_CC_Vehimoth", Num = 1 },
		{ InxName = "Vault_CC_DT_FDevildom01", Num = 1 },
		{ InxName = "Vault_CC_DT_FDevildom02", Num = 1 },
		{ InxName = "Vault_CC_DT_IDevildom01", Num = 1 },
		{ InxName = "Vault_CC_DT_IDevildom02", Num = 1 },
		{ InxName = "Vault_CC_DT_SDevildom01", Num = 1 },
		{ InxName = "Vault_CC_DT_SDevildom02", Num = 1 },
		{ InxName = "Vault_CC_DT_TDevildom01", Num = 1 },
		{ InxName = "Vault_CC_DT_TDevildom02", Num = 1 },
		{ InxName = "Vault_CC_DT_FFocalor_C", Num = 1 },
		{ InxName = "Vault_CC_DT_IFocalor_C", Num = 1 },
		{ InxName = "Vault_CC_DT_SFocalor_C", Num = 1 },
		{ InxName = "Vault_CC_DT_TFocalor_C", Num = 1 },
		{ InxName = "Vault_CC_WarBL_ICitrie", Num = 1 },
		{ InxName = "Vault_CC_WarBL_SCitrie", Num = 1 },
		{ InxName = "Vault_CC_WarL_FCitrie", Num = 1 },
		{ InxName = "Vault_CC_WarL_TCitrie", Num = 1 },
		{ InxName = "Vault_CC_EglackMad_S", Num = 1 },
		{ InxName = "Vault_CC_EglackMad_A", Num = 1 },
		{ InxName = "Vault_CC_FSpearman", Num = 1 },
		{ InxName = "Vault_CC_FRanger", Num = 1 },
		{ InxName = "Vault_CC_FKnuckleman", Num = 1 },
		{ InxName = "Vault_CC_FKnight", Num = 1 },
		{ InxName = "Vault_CC_SElfFig", Num = 1 },
		{ InxName = "Vault_CC_SElfMag", Num = 1 },
		{ InxName = "Vault_CC_FElfCle", Num = 1 },
		{ InxName = "Vault_CC_FElfArc", Num = 1 },
		{ InxName = "Vault_CC_FElfMag", Num = 1 },
		{ InxName = "Vault_CC_FElfFig", Num = 1 },
		{ InxName = "Vault_CC_FElfSage", Num = 1 },
		{ InxName = "Vault_CC_ArkGuard", Num = 1 },
		{ InxName = "Vault_CC_ArkNovice", Num = 1 },
		{ InxName = "Vault_CC_ArkArch", Num = 1 },
		{ InxName = "Vault_CC_ArkTech", Num = 1 },
		{ InxName = "Vault_CC_ArkMech", Num = 1 },
		{ InxName = "Vault_CC_ArkAstanica_A", Num = 1 },
		{ InxName = "Vault_CC_ArkAstanica_S", Num = 1 },
		{ InxName = "Vault_CC_SnowyPuggy", Num = 1 },
		{ InxName = "Vault_CC_Megan", Num = 1 },
		{ InxName = "Vault_CC_Yeti", Num = 1 },
		{ InxName = "Vault_CC_SmartYeti", Num = 1 },
		{ InxName = "Vault_CC_AngryYeti", Num = 1 },
		{ InxName = "Vault_CC_BigYeti", Num = 1 },
		{ InxName = "Vault_CC_SnowyWolf", Num = 1 },
		{ InxName = "Vault_CC_Mastodons", Num = 1 },
		{ InxName = "Vault_CC_S_CyrusWave_C", Num = 1 },
		{ InxName = "Vault_CC_S_CyrusWave_B", Num = 1 },
		{ InxName = "Vault_CC_S_CyrusTyphoon", Num = 1 },
		{ InxName = "Vault_CC_S_CyrusKey", Num = 1 },
		{ InxName = "Vault_CC_S_SirenWave", Num = 1 },
		{ InxName = "Vault_CC_S_SirenTyphoon", Num = 1 },
		{ InxName = "Vault_CC_S_Anais_B", Num = 1 },
		{ InxName = "Vault_CC_S_Anais_A", Num = 1 },
		{ InxName = "Vault_CC_ValeMastodons", Num = 1 },
		{ InxName = "Vault_CC_ValeSnowyPuggy", Num = 1 },
		{ InxName = "Vault_CC_ValeMegan", Num = 1 },
		{ InxName = "Vault_CC_ValeSnowyWolf", Num = 1 },
	},
}

