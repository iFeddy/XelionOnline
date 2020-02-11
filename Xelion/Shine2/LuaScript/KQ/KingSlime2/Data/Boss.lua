--------------------------------------------------------------------------------
--                           King Slime Boss Data                             --
--------------------------------------------------------------------------------

KingSlimeChat =
{
	ScriptFileName = MsgScriptFileDefault,

	WarningDialog =
	{
		{ Index = "KingSlime0" },
		{ Index = "KingSlime1" },
	},

	SummonMobShout 	= {	Index = "KingSlimeSummon" },
	DeathShout 		= { Index = "KingSlimeDead" },
}


KingSlimeSummon =
{
	FirstSummon =
	{
		HP_Rate = 800,
		SummonMobs =
		{
			"KQ2_Slime", "KQ2_Slime", "KQ2_Slime",
		},
	},

	SecondSummon =
	{
		HP_Rate = 600,
		SummonMobs =
		{
			"KQ2_FireSlime", "KQ2_FireSlime", "KQ2_FireSlime",
		},
	},

	ThirdSummon =
	{
		HP_Rate = 400,
		SummonMobs =
		{
			"KQ2_IronSlime", "KQ2_IronSlime", "KQ2_IronSlime", "KQ2_IronSlime",
		},
	},

	LastSummon =
	{
		HP_Rate = 200,
		SummonMobs =
		{
			"KQ2_QueenSlime",
			"KQ2_PrinceSlime", "KQ2_PrinceSlime",
		},
	},
}
