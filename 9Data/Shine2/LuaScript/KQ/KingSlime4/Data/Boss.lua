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
			"KQ4_Slime", "KQ4_Slime", "KQ4_Slime",
		},
	},

	SecondSummon =
	{
		HP_Rate = 600,
		SummonMobs =
		{
			"KQ4_FireSlime", "KQ4_FireSlime", "KQ4_FireSlime",
		},
	},

	ThirdSummon =
	{
		HP_Rate = 400,
		SummonMobs =
		{
			"KQ4_IronSlime", "KQ4_IronSlime", "KQ4_IronSlime", "KQ4_IronSlime",
		},
	},

	LastSummon =
	{
		HP_Rate = 200,
		SummonMobs =
		{
			"KQ4_QueenSlime",
			"KQ4_PrinceSlime", "KQ4_PrinceSlime",
		},
	},
}
