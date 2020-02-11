--[[
Created by Myth ~
	Revision 1 : Basic Structure - 20-12-2012
		- Usage of External Modules
		- Spawn / Death Control
		- Table Control
		- Infection Control
		- Debugging Features
	Revision 2 : Debugging and More - 27-02-2013
		- Debugging Features
		- Map-Name Control
		- Admin Control
	Revision 3 : Map-Swap and Clean - 09-06-2013
		- Swapped to KDSpring
		- Cleaned code just a little
	Revision 4 : Structure Improvement - 10-06-2013
		- Adjusted the base-structure
		- Adjusted the logging and announcement system
		- Cleaner code
]]
----------------------------------------------------------------------------------------------
require( "admin" )									--Admin List
require( "common" )									--Common Entry / Instance / Field Variables
require( "debug" )									--Debugging Functions / Features
require( "maps" )									--Map Names
require( "Map/Infect_KDSpring/Infect_Data" )		--External Script Data
----------------------------------------------------------------------------------------------
-- To do list:																				--
--	*Create the base-structure again with the flow of the script 							--
--	*Give each section appropriate names / finish all variables / use timers etc			--
--	Create the starting infection and maintaining the infection until the end 				--
--	Add relics or some equal object which will spawn at various locations on the map 		--
----------------------------------------------------------------------------------------------

------------------------------------------------------------------
--	Directory Listings for External Modules						--
------------------------------------------------------------------

MainDirectory = 'C:/Server/Villain/World00_Villain/9Data/Hero/LuaScript/'

DebugFile 	= 'debug.lua'
MapFile 	= 'maps.lua'
AdminFile 	= 'admin.lua'

------------------------------------------------------------------
--	This file MUST be referenced properly, otherwise errors		--
--	will occur. Please be sure it's referenced correctly and 	--
--	that the x_Log.txt file is produced or has been appended.	--
--											Edited : 17-02-2013	--
------------------------------------------------------------------
---------------------- 	  Log Variables    -----------------------
------------------------------------------------------------------

FileInfo = {}
FileInfo.FileName		= 'Infect_KDSpring'			--File Name
FileInfo.MapName		= 'KDSpring'				--Map Name (InxName)

FileInfo.Require = {}
FileInfo.Require[1]		= 'Infect_Data.lua'		--External File for Data

LogParam = {}
LogParam.Enabled		= true				--Write Log for file
LogParam.HeaderWrite	= false				--Write with Header
LogParam.BodyWrite		= true				--Write with Body 	/ Not used currently
LogParam.SaveExtra		= false				--Save extra variables/paramaters or information
LogParam.Chunk			= 'Unknown'			--Name of the chunk/section for logging
LogParam.Split			= false				--Split (Write with Split)

------------------------------------------------------------------
----------------------- Dynamic Variables  -----------------------
------------------------------------------------------------------

function StartUp(StartUpRun)
cExecCheck( "StartUp_Infection" )

	if StartUpRun == false then
		
		Infect = {}						--Infect Main List (For all Infection-Variables)
		Infect.MinPlayer		= 2 	--Minimum Players for Infection
		Infect.Duration			= 60	--Duration of Infection (In Minutes)
		Infect.SpreadDuration	= nil 	--Current Timer on Infection
		Infect.Difficulty		= 1 	--Starting Difficulty (1 = Easy - Less Mobs / 2 = Medium - More Mobs / 3 = Hard - Even More Mobs)
		Infect.MaxSpawn			= 5		--Maximum Mobs per Spawn (Based on difficulty - 5 = Easy / 10 = Medium / 15 = Hard)

		Infect.Enabled			= false	--Infection Spreading (True/False)
		Infect.Expire 			= false --Infection Expiry (True/Fase) - If an expiry has been triggered
		Infect.ExpirePause		= 10 	--Infection Expiry Pause Timer (In seconds) before forced-Warp

		Infect.PlayerIdle 		= false --Infection-Spread Idle (True/False for whether Infection is Idle)
		Infect.PlayerIdleTime	= 0 	--Infection-Spread Idle (Infection Enabled but Timeout Timer)
		Infect.PlayerIdleDuration = 5	--Time allowed to be Idle (Converted to Minutes)

		Infect.RndPick			= nil	--Random Player Number (From Main PlayerList)
		Infect.FirstBlood		= nil	--Name of First Infected (Using Infect.RndPick)
		
		Infect.WarpHide			= false --WarpGate Hide (Map is Full)
		Infect.EntryGate = cMobRegen_XY( EntryGate.Location, EntryGate.GateIndex, EntryGate.x, EntryGate.y, EntryGate.dir )

		if Infect.EntryGate ~= nil then
			--cSetAIScript( "ID/Infect_KDSpring/Infect", Infect.EntryGate )
			cAIScriptFunc( Infect.EntryGate, "Entrance", "DummyFunc" )
			cAIScriptFunc( Infect.EntryGate, "NPCClick", "EntryGateClick" )
		end

		Timer = {}						--Time List (For all Timers)
		Timer[1] = 0 					--Timer for Idle-Announce (Fill with AnnounceInfo)
		Timer[2] = 0 					--Timer for Prepare-Announce (Fill with PrepareInfo)
		Timer[3] = 0 					--Timer for Infection-Idle-Announce (Fill with IdleInfo)


		Timer[6] = 0 					--Timer for Expiry (pause before warp)
		Timer[7] = 0 					--Temp timer for List-Logging

		List = {}						--Main List for Sub-Lists
		List.PlayerList = {}			--PlayerList (Updated via Local)
		List.SurvivorList = {}			--SurvivorList (Updated via Syncing / Comparison between Infected)
		List.InfectedList = {}			--InfectedList (Added to upon Infection)
		--These three tables need to be synced on each script run-through

		StartUpRun = true
	end

	return
end

------------------------------------------------------------------
------------------------------------------------------------------

function Main( Field )
cExecCheck( 'InfectionMain' )
	
	Var = InstanceField[Field]

	if Var == nil then

		InstanceField[Field] = {}
		Var = InstanceField[Field]

		local StartUpRun = false
		StartUp(StartUpRun)
		
		Var.MapIndex = Field
		Var.WarpMap = Field

		Var.AdminTimer = 0 		--Timer for each Admin-Check
		Var.ActiveAdmin = {}	--Default Empty for AdminList
		Var.LogUnk = {} 		--List for logging random variables (Is reset in Debug script)

		Var.StepFunc = RoutineControl

---->	Used for Map-Name Fetch	<---------------------
		dofile(MainDirectory .. MapFile)
		Var.MapName = MapNameReturn(Var)
------------------------------------------------------

---->	Used for WarpMap-Name Fetch	<-----------------
		dofile(MainDirectory .. MapFile)
		Var.WarpMapName = WarpNameReturn(Var)
------------------------------------------------------

---->	Used for Logging	<-------------------------
		local LType = 1
		LogControl(Var, Infect, Timer, List, LType)
------------------------------------------------------

	end

	Var.StepFunc(Var, Infect, List, Timer)
end

function RoutineControl(Var, Infect, List, Timer)
cExecCheck( "RoutineControl" )

	Infection_ListControl(Var, Infect, List, Timer)

	--Not Enough Players / Infection not Enabled
	if Infect.Enabled == false and #List.PlayerList < Infect.MinPlayer and Infect.Expire == false then
		Infection_Idle(Var, Infect, List, Timer)
	end

	--Enough Players / Infection not Enabled
	if Infect.Enabled == false and #List.PlayerList >= Infect.MinPlayer and Infect.Expire == false then
		Infection_Begin(Var, Infect, List, Timer)
	end

	--Infection is Enabled / Control Infection
	if Infect.Enabled == true and Infect.Expire == false then
		Infection_Control(Var, Infect, List, Timer)
	end

	--Infection is going to Expire
	if Infect.Enabled == true and Infect.Expire == true then
		if Timer[6] <= cCurSec() then
			--Initiate Expire
			Infection_Expire(Var, Infect, List, Timer)
		end
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
		LogControl(Var, Infect, Timer, List, LType)
------------------------------------------------------
	end
end

------------------------------------------------------------------
-----------------------  Infection : Main  -----------------------
------------------------------------------------------------------

function Infection_Idle(Var, Infect, List, Timer)
cExecCheck( 'Infection_Idle' )

	if Infect.Enabled == true then
		return 	--If Timer is still not up or Infection Enabled / Return back to main
	end

	if Timer[1] <= cCurSec() then
		--Announce for Missing Players
		local AData = {} 	--Announce-Data
		--There are %s Players in %s, need %s more Players to begin.
		AData.Type = 'Infection_PCount'		--Type (Referenced in ScriptMsg.shn)
		AData.Var = {}

		--Check player count
		if #List.PlayerList > 1 then
			AData.Var[1] = #List.PlayerList .. " players"
		else
			AData.Var[1] = #List.PlayerList .. " player"
		end
		AData.Var[2] = Var.MapName
		AData.Var[3] = (Infect.MinPlayer - #List.PlayerList)
	
		AnnounceControl(Var, Infect, List, Timer, AData)

		Timer[1] = cCurSec() + 30 	--Every 30 Seconds / Announce

---->	Used for Logging	<-------------------------
		local LType = 2
		LogControl(Var, Infect, List, Timer, LType)
------------------------------------------------------
	end
end

function Infection_Begin(Var, Infect, List, Timer)
cExecCheck( 'Infection_Begin' )

	if Infect.Enabled == false then
		if Timer[2] <= cCurSec() then
			--Announce Infection start					
			local AData = {} 	--Announce-Data
			--There is %s in %s, about to start Infection.
			AData.Type = 'Infection_WaitInfect'		--Type (Referenced in ScriptMsg.shn)
			AData.Var = {}
	
			--Check player count
			if #List.PlayerList > 1 then
				AData.Var[1] = #List.PlayerList .. ' players'
			else
				AData.Var[1] = #List.PlayerList .. ' player'
			end
			AData.Var[2] = Var.MapName
		
			AnnounceControl(Var, Infect, List, Timer, AData)
	
			Timer[2] = cCurSec() + 30 	--Every 30 Seconds / Announce
	
-------->	Used for Logging	<-------------------------
			local LType = 4
			LogControl(Var, Infect, List, Timer, LType)
----------------------------------------------------------
		end

		--Hide WarpGate and set blocked
		if Infect.WarpHide == false then
			cAIScriptFunc( Infect.EntryGate, "Entrance", "DummyFunc" )
			cAIScriptFunc( Infect.EntryGate, "NPCClick", "EntryDenied" )

			Infect.WarpHide = true
		end
		--Begin spawn for infection and set initial variables
	end
end

function Infection_Control(Var, Infect, List, Timer)
cExecCheck( 'Infection_Control' )

	if Infect.Enabled == true then
		--Control/Check the current Infection
		Infection_Check(Var, Infect, List, Timer)
	end

	return
end

function Infection_Check(Var, Infect, List, Timer)
cExecCheck( 'Infection_Check' )

	if Infect.Enabled == true then
		if #List.PlayerList < Infect.MinPlayer then --<= (Infect.MinPlayer / 4) then
			if Infect.PlayerIdle == false then
				--Turn on player-idle time (Expire by timer)
				Infect.PlayerIdleTime = cCurSec() + (Infect.PlayerIdleDuration * 60)

				--Announce the lower-Player Count			
				local AData = {} 	--Announce-Data
				--%s
				AData.Type = 'Infection_Misc'		--Type (Referenced in ScriptMsg.shn)
				AData.Var = {}
		
				AData.Var[1] = "The player count has dropped."
			
				AnnounceControl(Var, Infect, List, Timer, AData)

				--Turn on player-idle and set timer
				Infect.PlayerIdle = true
				Timer[3] = cCurSec() + 30
			end 
		end

		--If expired (player(s) failed to log back in)
		if Infect.PlayerIdleTime <= cCurSec() and Infect.PlayerIdle == true then
			--Idle Time Expired
			Infection_Expire(Var, Infect, List, Timer)

			if Infect.Expire == true then
				--Announce the Infection-Expire
				local AData = {} 	--Announce-Data
				--Time is about to expire, prepare to warp to %s.
				AData.Type = 'Infection_NoTime'		--Type (Referenced in ScriptMsg.shn)
				AData.Var = {}
				AData.Var[1] = Var.WarpMap
				
				AnnounceControl(Var, Infect, List, Timer, AData)
			end
		end

		--If recovered (player(s) have logged back in)
		if #List.PlayerList >= Infect.MinPlayer and Infect.PlayerIdle == true then -->= (Infect.MinPlayer / 4) and Infect.PlayerIdle == true then
			--Turn off player-idle (Expire by timer)
			Infect.Expire = false
			Infect.PlayerIdle = false
			Infect.PlayerIdleTime = 0
		end

		--Current status of infection-idle
		if Timer[3] <= cCurSec() and Infect.Expire == true then
			--Announce information regarding player count
			local AData = {} 	--Announce-Data
			--%s
			AData.Type = 'Infection_Misc'		--Type (Referenced in ScriptMsg.shn)
			AData.Var = {}
			AData.Var[1] = "There are currently " .. #List.PlayerList .. " on the map."
			
			AnnounceControl(Var, Infect, List, Timer, AData)

			--Add 60 seconds to current timer to initiate another announcement
			Timer[3] = cCurSec() + 60
		end
	end
end

function Infection_Expire(Var, Infect, List, Timer)
cExecCheck( 'Infection_Expire' )

	if Infect.Enabled == true and Infect.Expire == false then
		--Set the timer expired and set expiry
		Infect.Expire = true
		Timer[6] = cCurSec() + Infect.ExpirePause
	end

	if Infect.Expire == true then
		if Timer[6] <= cCurSec() then
			--Reset variables and warp everyone out / expire the infection
			Infection_Reset(Var, Infect, List, Timer)
		end
	end

	return
end

------------------------------------------------------------------
----------------------- Infection : Reset  -----------------------
------------------------------------------------------------------

function Infection_Reset(Var, Infect, List, Timer)
cExecCheck( 'Infection_Reset' )

	--Check if Expire is still true (should be)
	if Infect.Expire == true then
		--Reset each variable that needs to be re-used for another infection
		--Reset fututre variables
		--Warp players out of the map

		--Reset timers
		for k, v in ipairs(Timer) do
			v = 0
		end

		--Reset infection
		Infect.Enabled 			= false 		--Reset Infection
		Infect.Expire 			= false 		--Reset Expire
		Infect.WarpHide 		= false 		--Reset Warp visibility
		Infect.SpreadDuration 	= nil 			--Reset Infection-duration
		Infect.Difficulty 		= 1 			--Reset Difficulty
		Infect.MaxSpawn 		= 5 			--Reset max-spawns
		Infect.PlayerIdle 		= false 		--Reset Player-Idle status
		Infect.PlayerIdleTime 	= 0 			--Reset Player-Idle Time
		Infect.RndPick 			= nil 			--Reset random-Infected player
		Infect.FirstBlood 		= nil 			--Reset first-infected
	end
end

------------------------------------------------------------------
--------------------- Infection : Spawn Control ------------------
------------------------------------------------------------------

------------------------------------------------------------------
------------------- Infection : Table Control  -------------------
------------------------------------------------------------------

function Infection_ListControl(Var, Infect, List, Timer)
cExecCheck( 'Infection_ListControl' )

	List.PlayerList = { cGetPlayerList( Var.MapIndex ) }

	--Clear Survivor Table to Resync
	for k, v in ipairs(List.SurvivorList) do
		table.remove(List.SurvivorList)
	end

	--Control Lists / Infected and Survivor to match PlayerList on each round
	for k, v in ipairs(List.PlayerList) do
		local tempName = cGetPlayerName( v )

		for ke, val in ipairs(List.SurvivorList) do
			for key, value in ipairs(List.InfectedList) do
				if val ~= value then
					table.insert(List.SurvivorList, tempName)
				end
			end
		end
	end

	if Timer[7] <= cCurSec() then
---->	Used for Logging	<-------------------------
		local LType = 3
		LogControl(Var, Infect, List, Timer, LType)
------------------------------------------------------
		Timer[7] = cCurSec() + 15
	end

	return
end

------------------------------------------------------------------
-------------------- Infection : Announce Control ----------------
------------------------------------------------------------------

function AnnounceControl(Var, Infect, List, Timer, AData)
cExecCheck( 'AnnounceControl' )

	if #AData.Var == 1 then
		--Announce using 1 Extra Strings
		cScriptMessage(Var.MapIndex, AData.Type, AData.Var[1])
	end
	
	if #AData.Var == 2 then
		--Announce using 2 Extra Strings
		cScriptMessage(Var.MapIndex, AData.Type, AData.Var[1], AData.Var[2])
	end

	if #AData.Var == 3 then
		--Announce using 3 Extra Strings
		cScriptMessage(Var.MapIndex, AData.Type, AData.Var[1], AData.Var[2], AData.Var[3])
	end

	if #AData.Var == 4 then
		--Announce using 4 Extra Strings
		cScriptMessage(Var.MapIndex, AData.Type, AData.Var[1], AData.Var[2], AData.Var[3], AData.Var[4])
	end

	if #AData.Var == 5 then
		--Announce using 5 Extra Strings
		cScriptMessage(Var.MapIndex, AData.Type, AData.Var[1], AData.Var[2], AData.Var[3], AData.Var[4], AData.Var[5])
	end

--[[
Infection_PCount						There is %s in %s, need %s more player(s) to begin.
Infection_SCount						There is %s Survivor(s) in %s.
Infection_ZCount						There is %s Zombie(s) in %s.
Infection_NoTime						Time is about to expire, prepare to warp to %s.
Infection_WaitInfect					There is %s in %s, about to start Infection.
Infection_FirstBlood					%s has been Infected.
Infection_SurvivorList					Survivors: %s, %s, %s, %s, %s
Infection_TotalCount					There is %s in %s.
Infection_Misc							%s
]]

	--Announce type
	Var.AType = AData.Type

---->	Used for Logging	<-------------------------
		local LType = 10
		LogControl(Var, Infect, List, Timer, LType)
------------------------------------------------------
	return
end

------------------------------------------------------------------
----------------------- 	Gate Control	  --------------------
------------------------------------------------------------------

function DummyFunc( Handle, MapIndex )
	cExecCheck( "DummyFunc" )
end

function EntryGateClick( NPCHandle, PlyHandle, RegistNumber )
cExecCheck( "EntryGateClick" )

	cServerMenu( PlyHandle, NPCHandle, EntryGate.Title .. Var.MapName .. '?', EntryGate.Yes, "LinkToInfection", EntryGate.No,  "DummyFunc")
end

function EntryDenied( NPCHandle, PlyHandle, RegistNumber )
cExecCheck( "EntryDenied" )
	
	cServerMenu( PlyHandle, NPCHandle, EntryGate.Blocked .. (Infect.SpreadDuration / 60) .. ' minutes.', EntryGate.Accept .. #List.PlayerList, "DummyFunc")
end

function LinkToInfection( NPCHandle, PlyHandle, RegistNumber )
cExecCheck( "LinkToInfection" )

	cLinkTo( PlyHandle, "KDSpring", 3532, 2941 )
end

------------------------------------------------------------------
----------------------- 		Log Control	  --------------------
------------------------------------------------------------------

function LogControl(Var, Infect, List, Timer, LType)
cExecCheck( 'LogControl' )

	--Header Variables to parse to DebugLogging
	local Header = FileInfo

	--Log Paramaters to parse to DebugLogging
	local Log = LogParam

	--Body Variables to parse to DebugLogging
	local Body = {}

	--Startup (InfectionMain)
	if LType == 1 then
		--Log Variables
		Log.HeaderWrite = true
		Log.Split = true
		Log.Chunk = 'Main - Infection'

		--Body Variables
		Body[1] = Var.MapIndex
		Body[2] = MainDirectory
		Body[3] = 'Infection Start - Map Name: ' .. Var.MapName .. ' | WarpMap Name: ' .. Var.WarpMapName
		Body[4] = 'Minimum Players Needed: ' .. Infect.MinPlayer
		Body[5] = 'Current Time: ' .. cCurSec()
		Body[6] = 'Gate Location: ' .. EntryGate.Location .. ' | Gate Index: ' .. EntryGate.GateIndex .. ' | Location X: ' .. EntryGate.x .. ' | Location Y: ' .. EntryGate.y
	
		--For each Required-File / Write
		for k, v in ipairs(FileInfo.Require) do
			table.insert(Body, v)
		end
	end

	--
	if LType == 2 then
		--Log Variables
		Log.Chunk = 'Infection_Idle - Announce'
		
		--Body Variables
		Body[1] = 'PlayerCount: ' .. #List.PlayerList
		Body[2] = 'Timer for NeedPlayerAnnounce: ' .. Timer[1]
		Body[3] = 'Players Needed: ' .. Infect.MinPlayer - #List.PlayerList
		
		--Log Every Players Name
		if #List.PlayerList > 0 then
			local tempString = ''
			for k, v in ipairs(List.PlayerList) do
				local tempName = cGetPlayerName( v )
				tempString = tempString .. ' ' .. tempName
			end
			table.insert(Body, 'Current Players: ' .. tempString)
		end
	end

	--
	if LType == 3 then
		--Log Variables
		Log.Chunk = 'Infection_ListControl - Table Re-Sync'

		--Body Variables
		Body[1] = 'PlayerCount: ' .. #List.PlayerList
		Body[2] = 'SurvivorCount: ' .. #List.SurvivorList
		Body[3] = 'InfectedCount: ' .. #List.InfectedList

		--Log Survivor Names
		if #List.SurvivorList > 0 then
			local tempString = ''
			for k, v in ipairs(List.SurvivorList) do
				for ke, val in ipairs(List.PlayerList) do
					if v == val then
						local tempName = cGetPlayerName( val )
						tempString = tempString .. ' ' .. tempName
					end
				end
			end
			table.insert(Body, tempString)
		end
		
		--Log Infected Names
		if #List.InfectedList > 0 then
			local tempString = ''
			for k, v in ipairs(List.InfectedList) do
				for ke, val in ipairs(List.PlayerList) do
					if v == val then
						local tempName = cGetPlayerName( val )
						tempString = tempString .. ' ' .. tempName
					end
				end
			end
			table.insert(Body, tempString)
		end
	end

	--
	if LType == 4 then	
		--Log Variables
		Log.Chunk = 'Infection_Begin - Announce'

		--Body Variables
		Body[1] = 'PlayerCount: ' .. #List.PlayerList
		Body[2] = 'Timer for InfectionStartAnnounce: ' .. Timer[2]

		--Log Every Players Name
		if #List.PlayerList > 0 then
			local tempString = ''
			for k, v in ipairs(List.PlayerList) do
				local tempName = cGetPlayerName( v )
				tempString = tempString  .. ' ' .. tempName
			end
			table.insert(Body, 'Current Players: ' .. tempString)
		end
	end

	--
	if LType == 5 then

	end

	--
	if LType == 6 then

	end

	--
	if LType == 7 then

	end

	--
	if LType == 8 then

	end

	--
	if LType == 9 then

	end

	--
	if LType == 10 then
		--Log Variables
		Log.Chunk = 'AnnounceControl - Announce'

		--Body Variables
		Body[1] = 'AnnounceType: ' .. Var.AType
		Body[2] = 'Current Time: ' .. cCurSec()
	end

	--
	if LType == 'AdminLog' then
		--Log Variables
		Log.Chunk = 'AdminControl - Current Admin Variables'

		--Body Variables
		Body[1] = 'Current Admin-Timer: ' .. Var.AdminTimer
		Body[2] = 'Current Admin Count: ' .. #Var.ActiveAdmin

		--For each in ActiveAdmin List
		if #Var.ActiveAdmin > 0 then
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