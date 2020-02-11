--[[
Created by Myth ~
	Revision 1 : Basic Structure - 27-02-2013
		- Usage of External Modules
		- Spawn / Death Control
		- Debugging Features
	Revision 2 : Expanded Functions / Controllers - 27-02-2013
		- Better Time-Control
		- More Efficient Announcements
	Revision 3 : Cleaner Code - 08-04-2013
		- Cleaned code
		- Removed some loggers
		- Fixed up Stat-Control
]]
----------------------------------------------------------------------------------------------
require( "admin" )								--Admin List
require( "common" )								--Common Entry / Instance / Field Variables
require( "debug" )								--Debugging Functions / Features
require( "maps" )								--Map Names
require( "Map/MegaMob_UrgSwa01/MegaMob_Data" )			--External Script Data
----------------------------------------------------------------------------------------------
-- To do list:																				--
--	*Start base functions / create the structure											--
--	*Set up mob-handling / mob-spawn control												--
--	*Set up mob-stat control 																--
--	*Create announcements for boss-spawn and boss-deaths for current map					--
--	*Add announcements which work on timer to announce the bosses HP/Exp					--
--	Create an AI-Script for each Mega-Mob to be used in future								--
----------------------------------------------------------------------------------------------

------------------------------------------------------------------
--	Directory Listings for External Modules						--
------------------------------------------------------------------

MainDirectory = 'C:/Server/Villain/World00_Villain/9Data/Hero/LuaScript/'

DebugFile 	= 'debug.lua'	--Debug File (Used for extrnal Debug module)
MapFile 	= 'maps.lua'	--Map File (Used for extrnal Map-Name module)
AdminFile 	= 'admin.lua'	--Admin File (Used for extrnal Admin-Control module)

------------------------------------------------------------------
--	This file MUST be referenced properly, otherwise errors		--
--	will occur. Please be sure it's referenced correctly and 	--
--	that the x_Log.txt file is produced or has been appended.	--
--											Edited : 17-02-2013	--
------------------------------------------------------------------
---------------------- 	  Log Variables    -----------------------
------------------------------------------------------------------

FileInfo = {}
FileInfo.FileName		= 'MegaMob_UrgSwa01'	--File Name
FileInfo.MapName		= 'UrgSwa01'			--Map Name (InxName)

FileInfo.Require = {}
FileInfo.Require[1]		= 'MegaMob_Data.lua'	--External File for Data

LogParam = {}
LogParam.Enabled		= true				--Write Log for file
LogParam.HeaderWrite	= false				--Write with Header
LogParam.BodyWrite		= true				--Write with Body 	/ Not used currently
LogParam.SaveExtra		= false				--Save extra variables/paramaters or information
LogParam.Chunk			= 'Unknown'			--Name of the chunk/section for logging
LogParam.Split			= false				--Split (Write with Split)

------------------------------------------------------------------
---------------------- 	Static Variables   -----------------------
------------------------------------------------------------------

------------------------------------------------------------------
----------------------- Dynamic Variables  -----------------------
------------------------------------------------------------------

function StartUp(StartUpRun)
cExecCheck( "StartUp_Mega" )

	if StartUpRun == false then
	
		Mega = {}
		Mega.Difficulty		= nil	--Difficulty Level (Used for Stats/Exp) / Random (1-50)
		Mega.LifeTime		= nil	--LifeTime
		Mega.MobStats		= SpawnStats
		
		StartUpRun = true
	end

	return
end

------------------------------------------------------------------
------------------------------------------------------------------

function Main( Field )
cExecCheck( 'MegaMobMain' )
	
	Var = InstanceField[Field]

	if Var == nil then

		InstanceField[Field] = {}
		Var = InstanceField[Field]

		local StartUpRun = false
		StartUp(StartUpRun)
		
		Var.MapIndex = Field

		Var.StepFunc = RoutineControl

		Var.MegaMob 		= nil	--Mob Handle
		Var.MegaMobAlive 	= false --Alive or Dead
		Var.MobTimer		= 0		--LUA Controlled Timer
		Var.rSpawnTimer		= 0		--Respawn Timer (Used upon death)
		Var.IndexLocRnd		= nil	--Random Location List
		Var.IndexLocType	= nil	--Index Location Type (Letter)
		Var.IndexMobRnd		= nil	--Random Mob Number

		Var.AliveAnnounce	= 2 	--Time in Minutes (2 = 2 minutes) for each announcement

		Var.AnTimer = {}
		Var.AnTimer[1] = 0 --Main Time Controller
		Var.AnTimer[2] = 0 --Announce Timer
		Var.AnTimer[3] = 0 --Announce Timer
		Var.AnTimer[4] = 0 --Announce Timer
		Var.AnTimer[5] = 0 --Announce Timer

		Var.AdminTimer 		= 0 	--Timer for each Admin-Check
		Var.ActiveAdmin = {} 		--Default Empty for AdminList

		Var.List = {}		--List for various variables
		Var.LogUnk = {} 	--List for logging random variables (Is reset in Debug script)
		
---->	Used for Map-Name Fetch	<---------------------
		dofile(MainDirectory .. MapFile)
		MapNameReturn(Var)
------------------------------------------------------

---->	Used for Logging	<-------------------------
		local LType = 1
		LogControl(Var, Mega, LType)
------------------------------------------------------
	end

	Var.StepFunc(Var, Mega)
end

------------------------------------------------------------------
--------------------- 	Main Controller		 ---------------------
------------------------------------------------------------------

function RoutineControl(Var, Mega)
cExecCheck( "RoutineControl" )

	--Spawn-Control
	if Var.MegaMobAlive == false and Var.MobTimer <= cCurSec() then
		Mega_SpawnControl(Var, Mega)
	end

	--Mega-Control	
	if Var.MegaMobAlive == true then
		Mega_Control(Var, Mega)
	end

	--Announce-Control
	if Var.MegaMobAlive == true and cIsObjectDead( Var.MegaMob ) == nil then
		Mega_AnnounceControl(Var, Mega)
	end

	--Admin Control
	if Admin.Enabled == true and Var.AdminTimer <= cCurSec() then
---->	Used for Map-Name Fetch	<---------------------
		dofile(MainDirectory .. AdminFile)
		AdminBuffHandle(Var)
------------------------------------------------------

		--Set New Admin-Check Timer
		Var.AdminTimer = cCurSec() + (Admin.Timer * 60) --Converted to Minutes (x60))

---->	Used for Logging	<-------------------------
		local LType = 'AdminLog'
		LogControl(Var, Mega, LType)
------------------------------------------------------
	end

	return
end

------------------------------------------------------------------
-----------------------   	Controllers    -----------------------
------------------------------------------------------------------

function Mega_SpawnControl(Var, Mega)
cExecCheck( 'Mega_SpawnControl' )

	if Var.MegaMobAlive == false and Var.MobTimer <= cCurSec() then
		--Variables for location
		Var.IndexLocRnd = math.random(1, 10)	--Eventually use math.random(10) = 1~10 (For MaxLetterType / 1 for each SpawnLoc)
	
		--Variables for Mob-Type
		Var.IndexMobRnd = math.random(1, 10) 	--Eventually use math.random(1, 10) = 1~10 (For MaxMobType)
	
		--MobLifeTime
		Mega.LifeTime = math.random(15, 60) -- Eventually use math.random(15, 60) = 15 Minutes ~ 60 Minutes
		
		if Var.MobTimer <= cCurSec() then
			--MobLifeTime-Timer
			Var.MobTimer = cCurSec() + (Mega.LifeTime * 60) 	-- Eventually use * 60 to multiply value for count in minutes (not seconds)
		end
		
		--Randomize the location
		for k, v in ipairs(LFill) do
			if k == Var.IndexLocRnd then
				Var.IndexLocType = 'Index' .. v
				--Will pick the letter using numerical key (1 = A, 2 = B, 3 = C ~~)
			end
		end

		--First Spawn
		Var.MegaMob = cMobRegen_XY( Var.MapIndex, Spawn[Var.IndexMobRnd], SpawnLoc[Var.IndexLocType].x, SpawnLoc[Var.IndexLocType].y, 0)

		--Set AliveAnnounce Timer
		Var.AnTimer[2] = cCurSec() + (Var.AliveAnnounce * 60) -- Multiply by 60 to turn into minutes

		--Mob Alive
		Var.MegaMobAlive = true

		--Logging
		local LType = 2
		LogControl(Var, Mega, LType)
		
		--Stat Control
		Mega.Difficulty = math.random(5, 20)	--Randomize the figure / Used to multiply stats
		local MobType = Spawn[Var.IndexMobRnd] 	--TO DO; Future usage for AIScript control
		local MobHandle = Var.MegaMob 			--Local the handle

		SpawnParams(Mega, MobType, MobHandle)

		--Announce Spawn Manually
		--A %s has spawned on %s, it will be available for %s minutes.
		cScriptMessage(Var.MapIndex, "MegaMob_SpawnType", Type[Var.IndexMobRnd], Var.MapName, Mega.LifeTime)

----------Mob Spawn
	end

	return
end

function Mega_Control(Var, Mega)
cExecCheck( 'Mega_Control' )

	--Check if mob is spawned	
	if Var.MegaMobAlive == true then
		--Check if mob is alive
		if cIsObjectDead( Var.MegaMob ) == nil then
			--If timer runs out
			if Var.MobTimer <= cCurSec() then
--------------->	Used for Logging	<-------------------------
				local LType = 3
				LogControl(Var, Mega, LType)
------------------------------------------------------------------

				--Kill Mob Incase
				cNPCVanish( Var.MegaMob )
		
				--Reset Timer / Future Timer Spawn
				Var.rSpawnTimer 	= math.random(30, 60) 	-- Random Respawn (Converted into Minutes) (30 Minutes ~ 60 Minutes)

				--Announce Control
				local AKey = 1
				AnnounceControl(Var, Mega, AKey)
		
				--Rest Variables
				local RKey = 1
				Mega_Reset(Var, Mega, RKey)
			end
			--Mob Alive
		end

		--Check if mob is dead
		if Var.MegaMobAlive == true and cIsObjectDead( Var.MegaMob ) ~= nil then
			--Check timer is still ticking
			if Var.MobTimer >= cCurSec() then
--------------->	Used for Logging	<-------------------------
				local LType = 4
				LogControl(Var, Mega, LType)
------------------------------------------------------------------

				--Kill Mob Incase
				cNPCVanish( Var.MegaMob )
				
				--Reset Timer / Future Timer Spawn
				Var.rSpawnTimer 	= math.random(30, 60) 	-- Random Respawn (Converted into Minutes) (30 Minutes ~ 60 Minutes)

				--Announce Control
				local AKey = 1
				AnnounceControl(Var, Mega, AKey)
				
				--Rest Variables
				local RKey = 1
				Mega_Reset(Var, Mega, RKey)
			end
			--Mob Dead
		end
	end
	
	return
end

function Mega_AnnounceControl(Var, Mega)
cExecCheck( 'Mega_AnnounceControl' )

	--Announce Control / Alive
	if Var.MegaMobAlive == true and cIsObjectDead( Var.MegaMob ) == nil then
		for k, v in ipairs(Var.AnTimer) do
			--MainTime Controller
			if k == 1 then
				if v <= cCurSec() then
--------------->	Used for Logging	<-------------------------
					local LType = 5
					LogControl(Var, Mega, LType)
------------------------------------------------------------------

					Var.AnTimer[1] = cCurSec() + 15 -- Every 60 Seconds write all timers
				end
			end

			--MobAlive Announce
			if k == 2 then
				if v <= cCurSec() and Mega.LifeTime > 0 then
					local AKey = 2
					AnnounceControl(Var, Mega, AKey)

					Var.AnTimer[2] = cCurSec() + (Var.AliveAnnounce * 60)	-- Added to timer to announce (MobAlive for x minutes) (Will be every 2 minutes)
				end
			end

			--Manually adjust timers
			if k > 2 then
				if v <= cCurSec() then
					Var.AnTimer[k] = cCurSec() + 30 -- Default Timer Extension if not defined above
				end
			end
		end
	end

--------Control Function / Spreads out to other functions

	return
end

function Mega_Reset(Var, Mega, RType)
cExecCheck( "Mega_Reset" )

	if RType == 1 then
		--Reset Main
		Mega.LifeTime 		= 0
		Mega.Difficulty		= nil
		
		Var.MegaMob 		= nil
		Var.MegaMobAlive 	= false
		Var.MobTimer 		= cCurSec() + (Var.rSpawnTimer * 60) 	-- Eventually use * 60 to multiply value to use minutes (not seconds)
		Var.IndexLocRnd 	= nil
		Var.IndexLocType 	= nil
		Var.IndexMobRnd 	= nil
		
--------------->	Used for Logging	<-------------------------
		local LType = 6
		LogControl(Var, Mega, LType)
------------------------------------------------------------------

		return
	end
	
	if RType == 2 then
		--RKey = 2
		
		return
	end

	return
end

function AnnounceControl(Var, Mega, AType)
cExecCheck( "AnnounceControl" )

------Used for Log-Writing	<---------------------
	--Header Variables to parse to DebugLogging
	local Header = FileInfo

	--Log Paramaters to parse to DebugLogging
	local Log = LogParam
	Log.Chunk = 'AnnounceControl - Type: ' .. AType

	--Body Variables to parse to DebugLogging
	local Body = {}

	--MobDie Announce Death
	if AType == 1 then
		Body[1] = 'Mob Number: ' .. Var.IndexMobRnd .. ' | Mob Index: ' .. Spawn[Var.IndexMobRnd] .. ' | Mob Name: ' .. Type[Var.IndexMobRnd]
		Body[2] = 'Respawn Time: ' .. Var.rSpawnTimer
	end

	--MobAlive Announce Time
	if AType == 2 then
		Body[1] = 'Current Map: ' .. Var.MapName
		Body[2] = 'Mob Number: ' .. Var.IndexMobRnd .. ' | Mob Index: ' .. Spawn[Var.IndexMobRnd] .. ' | Mob Name: ' .. Type[Var.IndexMobRnd]
		Body[3] = 'Current Life Left: ' .. Mega.LifeTime
	end

	--Based upon the referenced file (Top of this script)
	dofile(MainDirectory .. DebugFile)
 	DebugLogging(Header, Body, Log)
--------------------------------------------------

	if AType == 1 then
		--Announce Death
		--A %s has been slain, You will see another MegaMob in approx %s minutes.
		cScriptMessage(Var.MapIndex, "MegaMob_DieType", Type[Var.IndexMobRnd], Var.rSpawnTimer)

		return
	end
	
	if AType == 2 then
	--Adjust Minute-Variable for Announce
		Mega.LifeTime = Mega.LifeTime - Var.AliveAnnounce --2 -- Will be minus 2 for 2 Minutes

		if Mega.LifeTime <= 0 then
			Mega.LifeTime = 0

			return
		end

		--Announce Still-Alive
		--A %s has been spotted on %s, It'll be available for %s minutes.
		cScriptMessage(Var.MapIndex, "MegaMob_AliveType", Type[Var.IndexMobRnd], Var.MapName, Mega.LifeTime)

		return
	end
end

	--Function Layout Area

------------------------------------------------------------------
----------------------- 	MobStat Control	  --------------------
------------------------------------------------------------------

function SpawnParams(Mega, MobType, MobHandle)
cExecCheck( "SpawnParams" )
	
	--cSetAIScript( "Map/MegaMob/MegaMob", MobType )	--In future, preset AIScripts for each mob-type

	--Set Stats using Difficulty (tempStat list)
	local Stat = {}
		Stat[1] 	= Mega.MobStats.HP 	* Mega.Difficulty	--HP
		Stat[2] 	= Mega.MobStats.Speed 					--SPEED
		Stat[3] 	= Mega.MobStats.HPRegen					--HPREGEN
		Stat[4] 	= Mega.MobStats.AC 	* Mega.Difficulty	--AC
		Stat[5] 	= Mega.MobStats.MR 	* Mega.Difficulty	--MR
		Stat[6] 	= Mega.MobStats.Exp * Mega.Difficulty	--EXP
		Stat[7] 	= Mega.MobStats.ItemDrop 				--ITEMDROP

	cSetNPCParam( MobHandle, "MaxHP",    Stat[1] )
	cSetNPCParam( MobHandle, "HP",       Stat[1] )
	cSetNPCParam( MobHandle, "RunSpeed", Stat[2] )
	cSetNPCParam( MobHandle, "HPRegen",  Stat[3] )
	cSetNPCParam( MobHandle, "AC",       Stat[4] )
	cSetNPCParam( MobHandle, "MR",       Stat[5] )
	cSetNPCParam( MobHandle, "MobEXP",   Stat[6] )
	cSetNPCIsItemDrop( MobHandle,        Stat[7] )

---->	Used for Logging	<-------------------------
	local LType = 7
	Var.LogUnk[1] = {}
	Var.LogUnk[1] = Stat

	LogControl(Var, Mega, LType)
------------------------------------------------------------

	return
end

------------------------------------------------------------------
----------------------- 		Log Control	  --------------------
------------------------------------------------------------------

function LogControl(Var, Mega, LType)
cExecCheck( 'LogControl' )

	--Header Variables to parse to DebugLogging
	local Header = FileInfo

	--Log Paramaters to parse to DebugLogging
	local Log = LogParam

	--Body Variables to parse to DebugLogging
	local Body = {}

	--Startup (MegaMobMain)
	if LType == 1 then
		--Log Variables
		Log.HeaderWrite = true
		Log.Split = true
		Log.Chunk = 'Main - MegaMob'

		--Body Variables
		Body[1] = Var.MapName
		Body[2] = MainDirectory

		--For each Required-File / Write
		for k, v in ipairs(FileInfo.Require) do
			table.insert(Body, v)
		end
	end

	--First Spawn (Mega_SpawnControl)
	if LType == 2 then
		--Log Variables
		Log.Chunk = 'Mega_SpawnControl - First Spawn'

		--Body Variables
		Body[1] = 'Mob Handle: ' .. Var.MegaMob
		Body[2] = 'Mob IndexType: ' .. Var.IndexLocType		-- Eg: IndexA or IndexB
		Body[3] = 'Mob Timer: ' .. Var.MobTimer
		Body[4] = 'Mob LifeTime: ' .. Mega.LifeTime .. ' minutes'
		Body[5] = 'Map Name: ' .. Var.MapName .. ' | Spawn Location: ' .. Var.IndexLocRnd
		Body[6] = 'Mob Number: ' .. Var.IndexMobRnd .. ' | Mob Index: ' .. Spawn[Var.IndexMobRnd] .. ' | Mob Name: ' .. Type[Var.IndexMobRnd]
		Body[7] = 'Current Time: ' .. cCurSec()
		Body[8] = 'Current UnkLists: ' .. #Var.LogUnk
	end

	--Mega Control / Time Expired (Mega_Control)
	if LType == 3 then
		--Log Variables
		Log.Chunk = 'Mega_Control - Time Expired'

		--Body Variables
		Body[1] = 'Mob Timer: ' .. Var.MobTimer
		Body[2] = 'Mob Number: ' .. Var.IndexMobRnd .. ' | Mob Index: ' .. Spawn[Var.IndexMobRnd] .. ' | Mob Name: ' .. Type[Var.IndexMobRnd]
	end

	--Mega Control / Mob Died (Mega_Control)
	if LType == 4 then	
		--Log Variables
		Log.Chunk = 'Mega_Control - Mob Died'
		
		--Body Variables
		Body[1] = 'Mob Timer: ' .. Var.MobTimer
		Body[2] = 'Mob Number: ' .. Var.IndexMobRnd .. ' | Mob Index: ' .. Spawn[Var.IndexMobRnd] .. ' | Mob Name: ' .. Type[Var.IndexMobRnd]
	end

	--Announce Control (Mega_AnnounceControl)
	if LType == 5 then
		for k = 1, #Var.AnTimer do
			local Header = FileInfo
			local Log = LogParam
			local Body = {}

			--Log Variables
			Log.Chunk = 'AnnounceRepeat - Timer: ' .. k
			
			--Body Variables
			Body[1] = 'Timer ' .. k .. ' | Current time: ' .. Var.AnTimer[k]

			--Based upon the referenced file (Top of this script)
			dofile(MainDirectory .. DebugFile)
			DebugLogging(Header, Body, Log)
		end

		return --Return back to avoid second-write
	end

	--Variable Reset (Mega_Reset)
	if LType == 6 then
		--Log Variable
		Log.Chunk = 'Mega_Reset - VariableReset'
		
		--Body Variables
		Body[1] = 'Respawn Time: ' .. Var.rSpawnTimer
		Body[2] = 'Current Time: ' .. cCurSec()
		Body[3] = 'Time For Respawn: ' .. Var.MobTimer
	end

	--Stat-Control (SpawmParams)
	if LType == 7 then
		--Log Variable
		Log.Chunk = 'SpawnParam - SetStats'

		--Body Variables
		Body[1] = 'Current Time: ' .. cCurSec()
		Body[2] = 'MobType: ' .. Spawn[Var.IndexMobRnd]
		Body[3] = 'Current Difficulty: ' .. Mega.Difficulty

		for k, v in ipairs(Var.LogUnk[1]) do
			for key, value in ipairs(StatType) do
				if k == key then
					table.insert(Body, value .. ': ' .. v)
				end
			end
		end
	end

	--Admin-Control Logging
	if LType == 'AdminLog' then
		--Log Variables
		Log.Chunk = 'AdminControl - Current Admin Variables'

		--Body Variables
		Body[1] = 'Current Admin-Timer: ' .. Var.AdminTimer
		Body[2] = 'Current Admin Count: ' .. #Var.ActiveAdmin

		--For each in ActiveAdmin List
		if #Var.ActiveAdmin ~= 0 then
			--Get PlayerList (Local)
			local PlayerList = { cGetPlayerList( Var.MapIndex ) }
			for k, v in ipairs(PlayerList) do
				for ke, val in ipairs(Var.ActiveAdmin) do
					--Get PlayerName (Local)
					local tempPlayerName = cGetPlayerName( v )
					
					--If PlayerName == AdminName
					if tempPlayerName == val then
						--Write Name
						local tempName = cGetPlayerName( PlayerList[k] )
						--Body[(#Body + 1)] = 'Admin Player Name: ' .. tempName
						table.insert(Body, 'Admin Player Name: ' .. tempName)
					end
				end
			end
		end

		--Set New Admin-Check Timer
		Var.AdminTimer = cCurSec() + (Admin.Timer * 60) --Converted to Minutes (x60))
	end

	--Based upon the referenced file (Top of this script)
	dofile(MainDirectory .. DebugFile)
	DebugLogging(Header, Body, Log)

	--Flush Var.LogUnk list
	while #Var.LogUnk ~= 0 do
		table.remove(Var.LogUnk)
	end

	return
end