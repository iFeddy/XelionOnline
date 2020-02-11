require( "common" )

MainLuaScriptPath 		= "Map/RouN"

MemBlock = {}

function SendNotice( MapIndex, Message )
cExecCheck("SendNotice")

	if MapIndex == nil or Message == nil then
		cAssertLog( "RouN script called with nil values" )
		return
	end
	cNoticeString( MapIndex, Message )
end

ScoreTable = 
{
    {
        CharName    = "Johnny",    	-- 순위
        Kill        = 5,    		-- 캐릭터 번호
        Death       = 2,    		-- 캐릭터 ID
        Score       = 200,    		-- 점수
		Handle 		= nil
    }
}

function Main( Field )
cExecCheck( 'RouN_Main' )

	Var = InstanceField[Field]

	if Var == nil then

		InstanceField[Field] = {}
		Var = InstanceField[Field]
		
		Var.MapIndex = Field
		Var.StepFunc = RoutineLoop
		
		--cSetFieldScript ( Var["MapIndex"], MainLuaScriptPath )
		--cFieldScriptFunc( Var["MapIndex"], "MapLogin", "PlayerMapLogin" )
	end

	Var.StepFunc(Var)
end

function RoutineLoop(Var)
cExecCheck( "RoutineLoop" )

	return
end

function PlayerMapLogin( MapIndex, Handle )
cExecCheck "PlayerMapLogin"

	if MapIndex == nil
	then
		DebugLog( "PlayerMapLogin::MapIndex == nil")
		return
	end

	if Handle == nil
	then
		DebugLog( "PlayerMapLogin::Handle == nil")
		return
	end

	local Var = InstanceField[ MapIndex ]

	if Var == nil
	then
		DebugLog( "PlayerMapLogin::Var == nil")
		return
	end

	cSetAIScript( MainLuaScriptPath , Handle )
	cAIScriptFunc( Handle , "ObjectDied", "PlayerDied" )
	
	cSetNPCParam( Handle, "MaxHP", 		999999 	)
	
	ScoreTable[1]["Handle"] = Handle

	cScoreTopList(MapIndex, "NewConditionOfHero", 0, 5000, ScoreTable )	
end

function PlayerDied( MapIndex, AttackerHandle, Handle )

	local PlayerName = cGetPlayerName(Handle)

end