--[[
Created by Myth ~
	Revision 1 : Basic Variables - 20-12-2012
		- Mobs / Gates / Spawn-Stats and Relics
	Revision 2 : Map-Swap - 09-06-2013
		- Swapped to use KDSpring
		- Warp-Gate located in Roumen
]]
------------------------------------------------------------------
---------------------- 	Static Variables   -----------------------
------------------------------------------------------------------

Other = { WarpMap = "KDSpring", }

EntryGate	= { Location = "Rou", GateIndex = "MapLinkGate",  x =  5323, y =  4501, dir =  0, Title = "Warp to ", Yes = "Yes", No = "No", Blocked = "Please try again in ", Accept = "Players on map : ", }

SpawnStats = { Damage = 40, HP = 90, HPRegen = 10, AC = 2570, MR = 2570, Speed = 50, Exp = 1234, ItemDrop = 0, }

--Warp-from RouN - 5313 5371
--Warp-to KDSpring - 3532 2941

------------------------------------------------------------------
---------------------- 		Mob Spawns	   -----------------------
------------------------------------------------------------------

Spawn = { IndexA = "Slime", IndexB = "Honeying", IndexC = "Crab" }

Relic =
{
	{
		Common = {},
	},
	{
		Uncommon = {},
	},
		Rare = {},
	{
	},
	{
		Ultra = {},
	},
}

------------------------------------------------------------------