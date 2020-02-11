--[[
Created by Myth ~
	Revision 1 : Base - 12-07-2013
		- Basic spawn function
		- Basic mob-movement control
		- Basic timer control
	Revision 2 : Spawns and Tornados - 15-07-2013
		- Basic Tornado Control
		- Co-ordinates for paths
		- Clean code
	Revision 3 : Minions and Clean Code - 29-07-2013
		- Added Minions (And control)
		- Clean code
]]
----------------------------------------------------------------------------------------------
require( "common" )								--Common Entry / Instance / Field Variables
require( "admin" )								--Admin List
require( "maps" )								--Map Names
require( "ID/AHarp/AHarp_Data" )				--External Script Data
----------------------------------------------------------------------------------------------
-- To do list:																				--
--																							--
----------------------------------------------------------------------------------------------

------------------------------------------------------------------
--	Directory Listings for External Modules						--
------------------------------------------------------------------

MainDirectory = 'C:/Server/Villain/World00_Villain/9Data/Hero/LuaScript/'

MapFile 	= 'maps.lua'
AdminFile 	= 'admin.lua'

------------------------------------------------------------------
------------------------------------------------------------------

function Main(Field)
cExecCheck( "Main" )
	
	Var = InstanceField[Field]

	if Var == nil then

		InstanceField[Field] = {}
		Var = InstanceField[Field]
		
		Var.MapIndex 	= Field
		Var.WarpMap 	= Other.WarpMap


		Var.AHarp = {}						--Angelic Harpy List (Variables that control the instance)
		Var.AHarp.Difficulty = 1 			--Difficulty for the whole instance (1 = Easy / 2 = Medium / 3 = Hard / 4 = Insane)
		Var.AHarp.InsBoss = nil				--Main handle for boss
		Var.AHarp.InsXY =					--Location of boss
		{
			X = nil,
			Y = nil,
		} 				
		Var.AHarp.InsIdle = false 			--Whether on tornado-idle (tornados are on map but boss is also at full hp)
		Var.AHarp.HP_Minion = 950			--First HP value used (as a percentage) to do spawn (if 95% or lower) / Is set to x - 10 each time (95 - 10 / 85 - 10)
		Var.AHarp.HP_Tornado = 900 			--First HP value used (as a percentage) to do spawn (if 90% or lower) / Is set to x - 10 each time (90 - 10 / 80 - 10)
		Var.AHarp.InsTome = nil				--Invisible handle for the square radius
		Var.AHarp.HasTornado = false 		--Whether tornados are currently on map
		Var.AHarp.HasMinion = false			--Whether minions are currently on map
		
		Var.AHarp.TornadoPath = {}			--List containing the handle and pathid of each tornado (when summoned)
		Var.AHarp.MinionList = {}			--List containing the handles of all minions
	
		Var.AHarp.RespawnTime = 86400		--Seconds for 24 hours
	
		Var.AHarp.ExitGate = cMobRegen_XY( Var.MapIndex, ExitGate['GateIndex'], ExitGate['x'], ExitGate['y'], ExitGate['dir'] )
		if Var.AHarp.ExitGate ~= nil then
			cSetAIScript( "ID/AHarp/AHarp", Var.AHarp.ExitGate )
			cAIScriptFunc( Var.AHarp.ExitGate, "Entrance", "DummyFunc" )
			cAIScriptFunc( Var.AHarp.ExitGate, "NPCClick", "ExitGateClick" )
		end
	
		Var.AHarp.HP_Max = nil 				--Set the mobs maximum HP on spawn (full HP)
	
		Var.Timer = {}						--Time List (Variables for all timers)
		Var.Timer[1] = 0 					--Boss re-spawn timer
		Var.Timer[2] = 0 					--Idle-timer for tornaodo life
	
	
		Var.Timer[9] = 0 					--Assert Logging
		Var.Timer[10] = 0 					--Assert for Logging Minion-List

		Var.AdminTimer 	= 0 			--Timer for each Admin-Check
		Var.ActiveAdmin = {}			--Default Empty for AdminList

		Var.DoDura = 3600
		Var.DoTime = cCurSec() + Var.DoDura
		Var.CurTime = cCurSec()

		Var.StepFunc = RoutineControl

	end

	Var.PlayerList = { cGetPlayerList( Var.MapIndex) }

	if Var.Timer[9] < cCurSec() then
		cAssertLog("For MapID: " .. Var.MapIndex .. " - PlayerCount: " .. #Var.PlayerList)
		Var.Timer[9] = cCurSec() + 15
	end

	Var.StepFunc(Var)

end

------------------------------------------------------------------
------------------------------------------------------------------

function RoutineControl(Var)
cExecCheck( "AHarp_RoutineControl" )

	if Var == nil then
		return
	end

	--AHarp_TimeCheck(Var)

	--Initiate First Spawn
	if Var.AHarp.InsBoss == nil then
		if Var.Timer[1] < cCurSec() then
			AHarp_Spawn(Var)
		end
	end

	--BossHP Control
	if Var.AHarp.InsBoss ~= nil then
		if not cIsObjectDead(Var.AHarp.InsBoss) then
			AHarp_BossControl(Var)

			--Tornado Control
			if #Var.AHarp.TornadoPath > 0 and not cIsObjectDead(Var.AHarp.InsBoss) then
				AHarp_TornadoControl(Var)
			end

			--Minion Control
			if Var.AHarp.HasMinion ~= false and not cIsObjectDead(Var.AHarp.InsBoss) then
				AHarp_MinionControl(Var)
			end
		end

		if cIsObjectDead(Var.AHarp.InsBoss) and Var.Timer[1] < cCurSec() then
			AHarp_SpawnReset(Var)
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
	end
end

function AHarp_Spawn(Var)
cExecCheck( "AHarp_Spawn" )

	--Spawn boss
	if Var.AHarp.InsBoss == nil then
		Var.AHarp.InsBoss = cMobRegen_XY( Var.MapIndex, BossSpawn['IndexA'], BossSpawn['X'], BossSpawn['Y'], 0)

		cAssertLog("For MapID: " .. Var.MapIndex .. " - PlayerCount: " .. #Var.PlayerList .. " - BossHandle: " .. Var.AHarp.InsBoss)

		--Check if the invisible mob handle is still existing (shouldnt be)
		if Var.AHarp.InsTome ~= nil then
			cNPCVanish( Var.AHarp.InsTome )
		end
		Var.AHarp.InsTome = cMobRegen_XY( Var.MapIndex, TomeSpawn['Index'], TomeSpawn['X'], TomeSpawn['Y'], 0)

		cAssertLog("For MapID: " .. Var.MapIndex .. " - PlayerCount: " .. #Var.PlayerList .. " - TomeHandle: " .. Var.AHarp.InsTome)

		Var.AHarp.HP_Max = cObjectHP(Var.AHarp.InsBoss)
		Var.AHarp.InsXY['X'], Var.AHarp.InsXY['Y'] = cObjectLocate( Var.AHarp.InsBoss )
	end
end

function AHarp_SpawnReset(Var)
cExecCheck( "AHarp_SpawnReset" )

	cAssertLog("For MapID: " .. Var.MapIndex .. " - PlayerCount: " .. #Var.PlayerList .. " - SpawnReset")

	Var.AHarp.InsBoss = nil	
	Var.AHarp.HP_Minion = 950
	cNPCVanish(Var.AHarp.InsTome)
	Var.AHarp.InsTome = nil
	Var.AHarp.HasMinion = false

	Var.DoDura = 3600
	Var.DoTime = cCurSec() + Var.DoDura
	Var.CurTime = cCurSec() + Var.AHarp.RespawnTime

	Var.Timer[1] = cCurSec() + Var.AHarp.RespawnTime

	cTimer(Var.MapIndex, 0)

	AHarp_TornadoClear(Var)
end

function AHarp_BossControl(Var)
cExecCheck( "AHarp_BossControl" )

	--Check if still alive
	if Var.AHarp.InsBoss ~= nil then
		--MonitorHP for Tornado
		if cObjectHP(Var.AHarp.InsBoss) * 1000 < Var.AHarp.HP_Max * Var.AHarp.HP_Tornado then
			local tempPathID = math.random(0, #TornadoPath)
			local tempPosID = math.random(0, #TornadoPath[tempPathID] - 1)
			local tempTorID = math.random(0, #TornadoSpawn - 1)
			local tempHandle = cMobRegen_XY( Var.MapIndex, TornadoSpawn[tempTorID], TornadoPath[tempPathID][tempPosID]['X'], TornadoPath[tempPathID][tempPosID]['Y'], 0)

			cScriptMessage(Var.MapIndex, "AHarp_TornadoSpawn")

			cAssertLog("For MapID: " .. Var.MapIndex .. " - PlayerCount: " .. #Var.PlayerList .. " - TornadoSpawn: " .. tempHandle .. " PathID: " .. tempPathID .. " PosID: " .. tempPosID)

			table.insert(Var.AHarp.TornadoPath, { Handle = tempHandle, PathID = tempPathID, PosID = tempPosID })
			Var.AHarp.HP_Tornado = Var.AHarp.HP_Tornado - 100
			Var.AHarp.HasTornado = true
		end
	
		if cObjectHP(Var.AHarp.InsBoss) == Var.AHarp.HP_Max and Var.AHarp.HasTornado == true then
			if Var.AHarp.InsIdle == false then
				Var.AHarp.InsIdle = true
				local idleTotal = 60 --()

				cScriptMessage( Var.MapIndex, "AHarp_Inactivity", idleTotal / 1 .. " minute")

				Var.Timer[2] = cCurSec() + (idleTotal * 60)
			end
		elseif cObjectHP(Var.AHarp.InsBoss) ~= Var.AHarp.HP_Max and Var.AHarp.HasTornado == true then
			Var.AHarp.InsIdle = false

			Var.Timer[2] = cCurSec() + 3600
		end

		if Var.AHarp.InsIdle == true and not cIsObjectDead(Var.AHarp.InsBoss) and Var.AHarp.HasTornado == true then
			if Var.Timer[2] < cCurSec() then
				AHarp_TornadoClear(Var)
			end
		end

		--MonitorHP for Minion
		if cObjectHP(Var.AHarp.InsBoss) * 1000 < Var.AHarp.HP_Max * Var.AHarp.HP_Minion then
			if Var.AHarp.HP_Minion == 950 then
				AHarp_MinionSpawn(Var, 0)
			elseif Var.AHarp.HP_Minion == 850 then
				AHarp_MinionSpawn(Var, 1)
			elseif Var.AHarp.HP_Minion == 750 then
				AHarp_MinionSpawn(Var, 2)
			elseif Var.AHarp.HP_Minion == 650 then
				AHarp_MinionSpawn(Var, 3)
			elseif Var.AHarp.HP_Minion == 550 then
				AHarp_MinionSpawn(Var, 4)
			elseif Var.AHarp.HP_Minion == 450 then
				AHarp_MinionSpawn(Var, 5)
			elseif Var.AHarp.HP_Minion == 350 then
				AHarp_MinionSpawn(Var, 6)
			elseif Var.AHarp.HP_Minion == 250 then
				AHarp_MinionSpawn(Var, 7)
			elseif Var.AHarp.HP_Minion == 150 then
				AHarp_MinionSpawn(Var, 8)
			elseif Var.AHarp.HP_Minion == 50 then
				AHarp_MinionSpawn(Var, 9)
			end

			if Var.AHarp.HP_Minion > 0 then
				Var.AHarp.HP_Minion = Var.AHarp.HP_Minion - 100
			end
		end
	end
end

function AHarp_TornadoControl(Var)
cExecCheck( "AHarp_TornadoControl" )

	if #Var.AHarp.TornadoPath > 0 then
		for key, value in pairs(Var.AHarp.TornadoPath) do
			local pX, pY = cObjectLocate(value['Handle'])

			local tempPosID = value['PosID'] + 1
			if tempPosID > #TornadoPath[value['PathID']] then
				if cDistanceSquar(pX, pY, TornadoPath[value['PathID']][value['PosID']]['X'], TornadoPath[value['PathID']][value['PosID']]['Y']) < ( 25 ) then
					value['PosID'] = 0

					cRunTo( value['Handle'], TornadoPath[value['PathID']][value['PosID']]['X'], TornadoPath[value['PathID']][value['PosID']]['Y'])
				end	
			else
				if cDistanceSquar(pX, pY, TornadoPath[value['PathID']][value['PosID']]['X'], TornadoPath[value['PathID']][value['PosID']]['Y']) < ( 25 ) then
					value['PosID'] = tempPosID

					cRunTo( value['Handle'], TornadoPath[value['PathID']][value['PosID']]['X'], TornadoPath[value['PathID']][value['PosID']]['Y'])
				end	
			end
		end
	end
end

function AHarp_TornadoClear(Var)
cExecCheck( "AHarp_TornadoClear" )

	--Reset HP for first tornado spawn
	Var.AHarp.HP_Tornado = 900
	Var.AHarp.HP_Minion = 950
	Var.AHarp.HasTornado = false
	Var.AHarp.HasMinion = false

	for key, val in pairs(Var.AHarp.TornadoPath) do
		cNPCVanish(val['Handle'])
	end

	for key, val in pairs(Var.AHarp.MinionList) do
		cNPCVanish(val['Handle'])
	end

	for key, val in pairs(Var.AHarp.TornadoPath) do
		table.remove(val)
	end

	for key, val in pairs(Var.AHarp.MinionList) do
		table.remove(val)
	end

	Var.AHarp.MinionList = {}
end

function AHarp_MinionControl(Var)
cExecCheck( "AHarp_MinionControl" )

	if Var.Timer[10] < cCurSec() then
		for key, val in ipairs(Var.AHarp.MinionList) do
			cAssertLog("MinionInfo: " .. val['Handle'] .. "/" .. val['InxName'])
		end
		Var.Timer[10] = cCurSec() + 15
	end

	for key, val in ipairs(Var.AHarp.MinionList) do
		if val['Handle'] > 0 then
			if cDistanceSquar(Var.AHarp.InsBoss, val['Handle']) < 25 then
				if val['InxName'] == "AngelicMinion01" then
					cSetAbstate(Var.AHarp.InsBoss, "StaDmgUp", 1, 300000)
				elseif val['InxName'] == "AngelicMinion02" then
					cSetAbstate(Var.AHarp.InsBoss, "StaDefUp", 1, 300000)			
				elseif val['InxName'] == "AngelicMinion03" then
					local hAmount = 0.08 * Var.AHarp.HP_Max
					cHeal(Var.AHarp.InsBoss, hAmount)
				end
				
				cNPCVanish(val['Handle'])

				cScriptMessage(Var.MapIndex, "AHarp_SoulConsume", "A Minion has delivered light to Sofia!")
			
				cAssertLog("For MapID: " .. Var.MapIndex .. " - PlayerCount: " .. #Var.PlayerList .. " - ApplyBuff: " .. val['InxName'])

				val['Handle'] = -1
			end
		end
	end
end

function AHarp_MinionSpawn(Var, rCount)
cExecCheck( "AHarp_MinionSpawn" )
	
	local tempTotal = 3 + rCount
	cScriptMessage(Var.MapIndex, "AHarp_MinionSpawn", tempTotal)

	cAssertLog("For MapID: " .. Var.MapIndex .. " - PlayerCount: " .. #Var.PlayerList .. " - MinionSpawn: " .. tempTotal)

	for i = 0, 2 do
		local tempXY = math.random(0, #MinionSpawnCoord)
		local tempHandle = cMobRegen_XY(Var.MapIndex, MinionSpawn[i], MinionSpawnCoord[tempXY]['X'], MinionSpawnCoord[tempXY]['Y'], 0)
		table.insert(Var.AHarp.MinionList, {Handle = tempHandle, InxName = MinionSpawn[i]})
	end

	if rCount > 0 then
		for i = 0, rCount - 1 do
			local tempXY = math.random(0, #MinionSpawnCoord)
			local tempID = math.random(0, #MinionSpawn)
			local tempHandle = cMobRegen_XY(Var.MapIndex, MinionSpawn[tempID], MinionSpawnCoord[tempXY]['X'], MinionSpawnCoord[tempXY]['Y'], 0)
			table.insert(Var.AHarp.MinionList, {Handle = tempHandle, InxName = MinionSpawn[tempID]})
		end
	end

	local xX, xY = cObjectLocate(Var.AHarp.InsBoss)
	for key, val in pairs(Var.AHarp.MinionList) do
		if val['Handle'] > 0 then
			cRunTo( val['Handle'], xX, xY)
		end
	end

	Var.AHarp.HasMinion = true
end

function AHarp_TimeCheck(Var)
cExecCheck( "AHarp_TimeCheck" )

	--Timer control
	if Var.AHarp.InsBoss ~= nil and not cIsObjectDead(Var.AHarp.InsBoss) then
 		if Var.DoTime <= cCurSec() then
 			--End instance if needed forcibly
			cScriptMessage(Var.MapIndex, "AHarp_Timer", "Timer has ended, " .. #Var.PlayerList .. " players will be ported out.")
			cTimer(Var.MapIndex, 0)
 			if #Var.PlayerList > 0 then
 				for key, val in pairs(Var.PlayerList) do
 					cLinkTo( val, Other['WarpMap'], Other['WarpX'], Other['WarpY'] )
 				end
 				cMobSuicide( Var.MapIndex )
 			end
		elseif Var.CurTime + 1 == cCurSec() then
			if Var.DoDura > 0 then
				Var.CurTime = Var.CurTime + 1
				Var.DoDura = Var.DoDura - 1
				cTimer(Var.MapIndex, Var.DoDura)
	
				if Var.DoDura <= 10 then
					cScriptMessage(Var.MapIndex, "AHarp_Timer", Var.DoDura .. " seconds left!")
				end
			end
			if Var.DoDura == 15 then
				cScriptMessage(Var.MapIndex, "AHarp_Timer", "Time is about to run out!")
			end			
		end
	end
end

function AHarp_MinionBuff(Var, mEntry)
cExecCheck( "AHarp_MinionBuff" )

end

function AHarp_CrystalControl(Var)
cExecCheck( "AHarp_CrystalControl" )

end

------------------------------------------------------------------
----------------------- 	Gate Control	  --------------------
------------------------------------------------------------------

function DummyFunc( Handle, MapIndex )
	cExecCheck( "DummyFunc" )
end

function ExitGateClick( NPCHandle, PlyHandle, RegistNumber )
cExecCheck( "ExitGateClick" )

	cServerMenu( PlyHandle, NPCHandle, ExitGate['Title'], ExitGate['Yes'], "LinkToWarpMap", ExitGate['No'], "DummyFunc")
end

function LinkToWarpMap( NPCHandle, PlyHandle, RegistNumber )
cExecCheck( "LinkToWarpMap" )

	cLinkTo( PlyHandle, Other['WarpMap'], Other['WarpX'], Other['WarpY'] )
end