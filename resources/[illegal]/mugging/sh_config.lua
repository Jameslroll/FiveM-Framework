Config = {
	StopDistance = 15.0, -- How close to put hands up and face player.
	RobDistance = 3.0, -- How close to rob, they will also stop looking at the player.
	MinDot = -0.1, -- The dot product (from 0-1, where 1 is facing, and 0 is perpendicular) required to be facing.
	IngoreChance = 0.05,--0.05, -- Chance (per ped) that they will completely ignore the player.
	HostileChance = 0.1,--0.2, -- Chance (per ped) that they will attack the player.
	FleeMult = 0.2,--0.25, -- Chance (per second) multiplied by confidence that they will flee while no gun is pointed.
	ConfidenceRate = 0.05, -- Confidence (per second) gained or lost while at gun point.
	MaxSpeed = 8.9, -- How fast (meters per second) they can be going before just driving away.
	DeleteChance = 0.02,
	Weapon = GetHashKey("WEAPON_PISTOL"), -- Which weapon they get when hostile.
	Cash = {
		Min = 1,
		Max = 20
	},
	Items = {
		{ name = "Wallet", chance = 0.05 },
		{ name = "Tenga", chance = 0.1 },
	},
	Anims = {
		HandsUp = {
			Dict = "missfra1mcs_2_crew_react",
			Name = "handsup_standing_base",
			Flag = 1,
		},
		Dances = {
			{
				Dict = "anim@amb@nightclub@mini@dance@dance_solo@male@var_a@",
				Name = "low_center",
				Flag = 1,
			},
			{
				Dict = "anim@amb@nightclub@mini@dance@dance_solo@female@var_b@",
				Name = "low_center_down",
				Flag = 1,
			},
			{
				Dict = "anim@amb@casino@mini@dance@dance_solo@female@var_b@",
				Name = "high_center",
				Flag = 1,
			},
			{
				Dict = "move_clown@p_m_two_idles@",
				Name = "fidget_short_dance",
				Flag = 1,
			},
			{
				Dict = "anim@amb@nightclub@mini@dance@dance_solo@female@var_b@",
				Name = "high_center",
				Flag = 1,
			},
			{
				Dict = "anim@amb@nightclub@mini@dance@dance_solo@female@var_b@",
				Name = "low_center",
				Flag = 1,
			},
		},
		Knees = {
			Dict = "missprologueig_1",
			Name = "idle_loop_malehostage01",
			Flag = 1,
		},
		Give = {
			Dict = "mp_common",
			Name = "givetake1_a",
			Flag = 0,
		}
	},
	Actions = {
		{
			action = "Rob",
			text = "\"Empty your pockets.\"",
		},
		{
			action = "Flee",
			text = "\"Get out of here!\"",
		},
		{
			action = "Follow",
			text = "\"Follow me.\"",
		},
		{
			action = "Stay",
			text = "\"Don't move.\"",
		},
		{
			action = "Knees",
			text = "\"On your knees.\"",
		},
		{
			action = "Dance",
			text = "\"Dance.\"",
		},
	},
}