--------------------------------------------------------------------------------
--               Promote Job2_Gamb Regen Data                                 --
--------------------------------------------------------------------------------

RegenInfo =
{
	-- npc
	NPC =
	{
		MobIndex = "Job2_JokerTm", X = 832, Y = 1018, Dir = 0, Scale = 1000,
	},


	-- 문
	Door =
	{
		{ Name = "Door1", MobIndex = "Job2_GamOb_door", DoorBlock = "Job2_Door00", X = 550, Y = 1480, Dir = 0, Scale = 1000 },
		{ Name = "Door2", MobIndex = "Job2_GamOb_door", DoorBlock = "Job2_Door00", X = 550, Y = 2214, Dir = 0, Scale = 1000 },
	},


	-- 룰렛
	Roulette =
	{
		MobIndex = "Job2_GamOb_stick-up", X = 554, Y = 551, Dir = 0, Scale = 1000,
	},


	-- 주사위
	Dice =
	{
		{ MobIndex = "Job2_GamOb_dice-01", X = 646, Y = 498, Dir = 0, Scale = 1000 },
		{ MobIndex = "Job2_GamOb_dice-02", X = 646, Y = 600, Dir = 0, Scale = 1000 },
		{ MobIndex = "Job2_GamOb_dice-03", X = 556, Y = 654, Dir = 0, Scale = 1000 },
		{ MobIndex = "Job2_GamOb_dice-04", X = 468, Y = 600, Dir = 0, Scale = 1000 },
		{ MobIndex = "Job2_GamOb_dice-05", X = 468, Y = 498, Dir = 0, Scale = 1000 },
		{ MobIndex = "Job2_GamOb_dice-06", X = 556, Y = 449, Dir = 0, Scale = 1000 },
	},

	-- 몹리젠그룹에서 설정되어있는 모든 몹 리스트
	MobList =
	{
		"Job2_CloverT", "Job2_DiaT",

	},

	-- 룰렛 맞추기 실패시, 리젠될 몹그룹( 리젠그룹 _ MobRegen/Job2_Dn01.txt)
	Mob =
	{
		{ "Job2_Dice1-1", "Job2_Dice1-2" },
		{ "Job2_Dice2-1", "Job2_Dice2-2" },
		{ "Job2_Dice3-1", "Job2_Dice3-2" },
		{ "Job2_Dice4-1", "Job2_Dice4-2" },
		{ "Job2_Dice5-1", "Job2_Dice5-2" },
		{ "Job2_Dice6-1", "Job2_Dice6-2" },
	},

	-- 보스몹 정보
	BossMob =
	{
		MobIndex = "Job2_JokerT", X = 555, Y = 2594, Dir = 273, Scale = 1000,
	},


	-- 보스몹 드랍아이템
	RewardDropItem =
	{
		Index = "Job2_STpiece3" , DropRate = 1000000,
	},
	
	ExitGate =
	{
		Index = "MapLinkGate",	x = 555,	y = 1353,	dir = 0,	scale = 1000, -- 시작지점에서 나가는 문
	},
}
