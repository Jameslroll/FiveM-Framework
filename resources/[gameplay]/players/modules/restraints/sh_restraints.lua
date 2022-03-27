Restraints = Restraints or {}

Restraints.anims = {
	cuffing = {
		Source = { Dict = "mp_arrest_paired", Name = "cop_p2_back_right", Flag = 16, Duration = 3000 },
		Target = { Dict = "mp_arrest_paired", Name = "crook_p2_back_right", Flag = 16, Duration = 3000, Heading = 0.0, Offset = vector3(0.0, 0.7, 0.0), BlendOut = 1000.0  },
	},
	uncuffing = {
		Source = { Dict = "mp_arresting", Name = "a_uncuff", Flag = 16, Duration = 3000 },
		Target = { Dict = "mp_arresting", Name = "b_uncuff", Flag = 16, Duration = 3000, Heading = 0.0, Offset = vector3(0.0, 0.6, 0.0), BlendIn = 1000.0 },
	},
	lockpick = {
		Dict = "weapons@first_person@aim_idle@p_m_zero@melee@knife@fidgets@a",
		Name = "fidget_low_loop",
		Flag = 17,
		Duration = 9000,
	},
	cuffed = {
		Dict = "mp_arresting",
		Name = "idle",
		Flag = 49,
		Force = true,
		BlendSpeed = 1000.0,
	},
}

Restraints.items = {
	["Handcuffs"] = {
		Anim = "cuffing",
		Shared = true,
		Resist = true,
		Duration = 3000,
		Restraint = true,
		Counters = {
			["Handcuff Keys"] = true,
			["Lockpick"] = true,
		},
	},
	["Ziptie"] = {
		Anim = "cuffing",
		Shared = true,
		Resist = true,
		Duration = 3000,
		Restraint = true,
		Counters = {
			["Scissors"] = true,
		},
	},
	["Handcuff Keys"] = {
		Anim = "uncuffing",
		Shared = true,
		Duration = 3000,
	},
	["Scissors"] = {
		Anim = "uncuffing",
		Shared = true,
		Duration = 3000,
	},
	["Lockpick"] = {
		Anim = "lockpick",
		Shared = false,
		Duration = 9000,
	},
}