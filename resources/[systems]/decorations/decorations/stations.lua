Register("Workbench", {
	Placement = "Floor",
	NoCenter = true,
	Station = {
		Type = "Workbench",
		Auto = false,
		Magnet = {
			Offset = vector3(0, -1, 0),
			Heading = 0.0,
		},
		Anim = {
			In = {
				Locked = true,
				Sequence = {
					{ Dict = "anim@amb@warehouse@toolbox@", Name = "enter", Flag = 0, Locked = true },
					{ Dict = "anim@amb@warehouse@toolbox@", Name = "idle", Flag = 1, Locked = true },
				},
			},
			Out = { Dict = "anim@amb@warehouse@toolbox@", Name = "exit", Flag = 0, BlendIn = 100.0 },
		},
		Camera = {
			Offset = vector3(-1.0, -1.0, 2.0),
			Target = vector3(0.0, 0.0, 1.0),
			Fov = 60.0,
		},
	},
	Model = {
		"gr_prop_gr_bench_04b",
		"gr_prop_gr_bench_04a",
	},
})

Register("Fryer", {
	Placement = "Floor",
	NoCenter = true,
	Station = {
		Type = "Fryer",
		Auto = true,
		Magnet = {
			Offset = vector3(0, -1, 0),
			Heading = 0.0,
		},
		Anim = {
			In = {
				Locked = true,
				Sequence = {
					{ Dict = "amb@prop_human_bbq@male@enter", Name = "enter", Flag = 0, Locked = true },
					{ Dict = "amb@prop_human_bbq@male@idle_a", Name = "idle_b", Flag = 1, Locked = true },
				},
			},
			Out = { Dict = "amb@prop_human_bbq@male@exit", Name = "exit", Flag = 0, BlendIn = 100.0 },
		},
		Camera = {
			Offset = vector3(-1.0, -1.0, 2.0),
			Target = vector3(0.0, 0.0, 1.0),
			Fov = 60.0,
		},
	},
	Model = "prop_chip_fryer",
})