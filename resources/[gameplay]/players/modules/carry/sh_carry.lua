Carry = Carry or {}

Carry.controls = {
	23,
	24,
	25,
	55,
}

Carry.modes = {
	["hold"] = {
		Name = "Hold",
		Immobile = true,
		Icon = "child_care",
		Attachment = {
			Offset = vector3(0.8, 0.4, -0.2),
			Rotation = vector3(-30.0, 90.0, 0.0),
			Bone = 57005,
		},
		Source = {
			Dict = "anim@heists@box_carry@",
			Name = "idle",
			Flag = 49,
		},
		Target = {
			Dict = "amb@world_human_bum_slumped@male@laying_on_right_side@base",
			Name = "base",
			Flag = 1,
		},
	},
	["carry"] = {
		Name = "Carry",
		Immobile = true,
		Icon = "luggage",
		Attachment = {
			Offset = vector3(-0.1, 0.05, 0.15),
			Rotation = vector3(25.0, 45.0, 180.0),
			Bone = 40269,
		},
		Source = {
			Dict = "misscarsteal4@meltdown",
			Name = "_rehearsal_camera_man",
			Flag = 49,
		},
		Target = {
			Dict = "nm",
			Name = "firemans_carry",
			Flag = 1,
		},
	},
	["piggyback"] = {
		Name = "Piggyback",
		Immobile = false,
		Icon = "savings",
		Attachment = {
			Offset = vector3(-0.1, -0.2, 0.0),
			Rotation = vector3(0.0, 90.0, 0.0),
			Bone = 39317,
		},
		Source = {
			Dict = "move_f@hiking",
			Name = "base",
			Flag = 49,
		},
		Target = {
			Dict = "amb@code_human_in_bus_passenger_idles@male@sit@idle_b",
			Name = "idle_e",
			Flag = 1,
		},
	},
}