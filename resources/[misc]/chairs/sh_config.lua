Models = {
	[`vw_prop_casino_chair_01a`] = {
		Slots = {
			Offset = vector3(0.0, -0.15, 0.75),
			Rotation = vector3(0.0, 0.0, 0.0),
		},
	},
	[`vw_prop_casino_slot_01a`] = { Slots = { Offset = vector3(0.0, -0.9, 0.73) } },
	[`vw_prop_casino_slot_02a`] = { Slots = { Offset = vector3(0.0, -0.9, 0.73) } },
	[`vw_prop_casino_slot_03a`] = { Slots = { Offset = vector3(0.0, -0.9, 0.73) } },
	[`vw_prop_casino_slot_04a`] = { Slots = { Offset = vector3(0.0, -0.9, 0.73) } },
	[`vw_prop_casino_slot_05a`] = { Slots = { Offset = vector3(0.0, -0.9, 0.73) } },
	[`vw_prop_casino_slot_06a`] = { Slots = { Offset = vector3(0.0, -0.9, 0.73) } },
	[`vw_prop_casino_slot_07a`] = { Slots = { Offset = vector3(0.0, -0.9, 0.73) } },
	[`vw_prop_casino_slot_08a`] = { Slots = { Offset = vector3(0.0, -0.9, 0.73) } },

	--[[ Chairs ]]--
	[`v_club_stagechair`] = { Chair = { Offset = vector3(0.0, -0.02, 0.49), Rotation = vector3(0.0, 0.0, 180.0), Exit = vector3(0.0, 0.5, 0.0) } },
	[`v_corp_offchair`] = { Chair = { Offset = vector3(0.0, 0.08, 0.49), Rotation = vector3(0.0, 0.0, 180.0), Exit = vector3(0.0, 0.5, 0.0) } },
	[`bkr_prop_clubhouse_chair_03`] = { Chair = { Offset = vector3(0.0, 0.08, 0.49), Rotation = vector3(0.0, 0.0, 180.0), Exit = vector3(0.0, 0.5, 0.0) } },
	[`prop_cs_office_chair`] = { Chair = { Offset = vector3(0.0, 0.08, 0.49), Rotation = vector3(0.0, 0.0, 180.0), Exit = vector3(0.0, 0.5, 0.0) } },
	[`ba_prop_battle_club_chair_01`] = { Chair = { Offset = vector3(0.0, 0.08, -0.12), Rotation = vector3(0.0, 0.0, 180.0), Exit = vector3(0.0, 0.5, 0.0) } },

	--[[ Stools ]]--
	[`v_ret_gc_chair01`] = { Stool = { Offset = vector3(0.0, 0.0, 0.7), Rotation = vector3(0.0, 0.0, 235.0), Exit = vector3(0.0, 0.5, 0.0) } },

	-- [``] = { Chair = { Offset = vector3(0.0, 0.0, 0.0) } },

	-- Hospital.
	[`v_med_bed1`] = {
		Chair = {
			Offset = vector3(-0.15, 0.0, 1.35),
			Rotation = vector3(0.0, 0.0, 180.0),
			Exit = vector3(1.0, 0.0, 0.0),
			Anim = { Dict = "rcm_barry3", Name = "barry_3_sit_loop" },
			Camera = {
				Offset = vector3(0.0, -2.5, 2.0),
				Target = vector3(0.0, 0.0, 0.5),
			},
		},
		Medical = {
			Offset = vector3(-0.1, 0.0, 1.35),
			Rotation = vector3(0.0, 0.0, 180.0),
			Exit = vector3(1.0, 0.0, 0.0),
			Camera = {
				Offset = vector3(0.0, -2.5, 2.0),
				Target = vector3(0.0, 0.0, 0.5),
			}
		},
	},
	[`v_med_cor_medstool`] = {
		Stool = { Offset = vector3(0.0, 0.13, 1.0), Rotation = vector3(0.0, 0.0, 0.0) },
	},
	[-1519439119] = { -- Surgery bed.
		Medical = { Offset = vector3(0.0, 0.1, 2.0), Rotation = vector3(0.0, 0.0, 180.0), Camera = { Offset = vector3(-1.0, -2.0, 2.0), Target = vector3(0.0, 0.0, 1.0) } },
	},
	[-289946279] = { -- MRI/X-ray beds.
		Medical = { Offset = vector3(0.0, 0.1, 2.0), Rotation = vector3(0.0, 0.0, 180.0), Camera = { Offset = vector3(-1.0, -2.0, 2.0), Target = vector3(0.0, 0.0, 1.0) } },
	},
}

Bases = {
	Chair = {
		Anim = { Dict = "amb@prop_human_seat_chair@male@generic@idle_a", Name = "idle_a" },
	},
	Stool = {
		Anim = { Dict = "anim_casino_a@amb@casino@games@spectate@slots@ped_male@sit_withdrink@01a@idles", Name = "idle_a" },
	},
	Slots = {
		Anim = { Dict = "anim_casino_a@amb@casino@games@slots@male", Name = "base_idle_b" },
	},
	Bed = {
		Text = "Lie",
		Anim = { Dict = "savecountryside@", Name = "t_sleep_loop_countryside" },
	},
	Medical = {
		Text = "Lie",
		Anim = { Dict = "missfbi1", Name = "cpr_pumpchest_idle" },
	},
}