--[[
Created by Myth ~
	Revision 1 : Basic Structure - 27-02-2013
		- Spawn-Stats / Letter-Fill / Spawn-Loc / Spawn-Types
	Revision 2 : Stat-Type List - 08-04-2013
		- Spawn-Stats List (Used as reference)
]]
------------------------------------------------------------------
---------------------- 	Static Variables   -----------------------
------------------------------------------------------------------

SpawnStats = { Damage = 40, HP = 123456, HPRegen = 12345, AC = 123, MR = 123, Speed = 275, Exp = 12345, ItemDrop = 1, }

--Stat-Types
StatType = {}
StatType[1] = 'HP'
StatType[2] = 'Speed'
StatType[3] = 'HPRegen'
StatType[4] = 'AC'
StatType[5] = 'MR'
StatType[6] = 'Exp'
StatType[7] = 'ItemDrop'

------------------------------------------------------------------
---------------------- 	Mob Spawn Location -----------------------
------------------------------------------------------------------

--Letter Fill (For Location-Use)
LFill = {}
LFill[1] = 'A'
LFill[2] = 'B'
LFill[3] = 'C'
LFill[4] = 'D'
LFill[5] = 'E'
LFill[6] = 'F'
LFill[7] = 'G'
LFill[8] = 'H'
LFill[9] = 'I'
LFill[10] = 'J'

--Will be filled with variant spawn-locations (Requres Letter Fill)
SpawnLoc = {}				--Location Main
SpawnLoc.IndexA = {} 		--Location A
SpawnLoc.IndexA.x = 7597
SpawnLoc.IndexA.y = 5641

SpawnLoc.IndexB = {}		--Location B
SpawnLoc.IndexB.x = 8428
SpawnLoc.IndexB.y = 8215

SpawnLoc.IndexC = {}		--Location C
SpawnLoc.IndexC.x = 1467
SpawnLoc.IndexC.y = 10671

SpawnLoc.IndexD = {}		--Location D
SpawnLoc.IndexD.x = 9904
SpawnLoc.IndexD.y = 10686

SpawnLoc.IndexE = {}		--Location E
SpawnLoc.IndexE.x = 5658
SpawnLoc.IndexE.y = 6791

SpawnLoc.IndexF = {}		--Location F
SpawnLoc.IndexF.x = 4866
SpawnLoc.IndexF.y = 4470

SpawnLoc.IndexG = {}		--Location G
SpawnLoc.IndexG.x = 5658
SpawnLoc.IndexG.y = 2028

SpawnLoc.IndexH = {}		--Location H
SpawnLoc.IndexH.x = 1538
SpawnLoc.IndexH.y = 1680

SpawnLoc.IndexI = {}		--Location I
SpawnLoc.IndexI.x = 8045
SpawnLoc.IndexI.y = 3223

SpawnLoc.IndexJ = {}		--Location J
SpawnLoc.IndexJ.x = 6400
SpawnLoc.IndexJ.y = 4477

------------------------------------------------------------------
---------------------- 		Mob Spawns	   -----------------------
------------------------------------------------------------------

--Spawn / IndexName
Spawn = {}
Spawn[1] = 'MegaSlime'
Spawn[2] = 'MegaHoneying'
Spawn[3] = 'MegaMushRoom'
Spawn[4] = 'MegaBlueCrab'
Spawn[5] = 'MegaImp'
Spawn[6] = 'MegaPhino'
Spawn[7] = 'MegaKebing'
Spawn[8] = 'MegaBoogy'
Spawn[9] = 'MegaOgre'
Spawn[10] = 'MegaTorturer'

--Type / Name
Type = {}
Type[1] = 'Mega Slime'
Type[2] = 'Mega Honeying'
Type[3] = 'Mega Mushroom'
Type[4] = 'Mega Blue Crab'
Type[5] = 'Mega Imp'
Type[6] = 'Mega Phino'
Type[7] = 'Mega Kebing'
Type[8] = 'Mega Boogy'
Type[9] = 'Mega Ogre'
Type[10] = 'Mega Torturer'

------------------------------------------------------------------