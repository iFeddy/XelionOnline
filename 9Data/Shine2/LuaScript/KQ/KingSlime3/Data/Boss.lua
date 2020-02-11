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
			"KQ3_Slime", "KQ3_Slime", "KQ3_Slime",
		},
	},

	SecondSummon =
	{
		HP_Rate = 600,
		SummonMobs =
		{
			"KQ3_FireSlime", "KQ3_FireSlime", "KQ3_FireSlime",
		},
	},

	ThirdSummon =
	{
		HP_Rate = 400,
		SummonMobs =
		{
			"KQ3_IronSlime", "KQ3_IronSlime", "KQ3_IronSlime", "KQ3_IronSlime",
		},
	},

	LastSummon =
	{
		HP_Rate = 200,
		SummonMobs =
		{
			"KQ3_QueenSlime",
			"KQ3_PrinceSlime", "KQ3_PrinceSlime",
		},
	},
}
