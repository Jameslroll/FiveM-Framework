RegisterShop("BURGER_SHOT", {
	Name = "Burger Shot",
	Storage = {
		Coords = vector3(-1196.097, -904.3538, 13.99892),
		Radius = 1.0,
	},
	Decorations = {
		["frier_1"] = {
			item = "Fryer",
			invisible = true,
			coords = vector3(-1201.197, -899.7913, 12.99524),
			heading = 123.7745,
		},
		["frier_2"] = {
			item = "Fryer",
			invisible = true,
			coords = vector3(-1201.669, -899.0747, 12.99524),
			heading = 123.7745,
		},
		["frier_3"] = {
			item = "Fryer",
			invisible = true,
			coords = vector3(-1202.146, -898.379, 12.99524),
			heading = 123.7745,
		},
	},
	Containers = {
		{
			text = "Tray",
			radius = 0.2,
			coords = vector3(-1195.275, -892.303, 14.04083),
		},
		{
			text = "Tray",
			radius = 0.2,
			coords = vector3(-1194.018, -894.209, 14.04083),
		},
		{
			text = "Pass-through",
			radius = 0.5,
			coords = vector3(-1196.916, -895.6237, 14.34702),
			discrete = true,
		},
		{
			text = "Pass-through",
			radius = 0.5,
			coords = vector3(-1197.684, -894.2891, 14.28494),
			discrete = true,
		},
		{
			text = "Pass-through",
			radius = 0.5,
			coords = vector3(-1198.569, -893.0552, 14.32487),
			discrete = true,
		},
		{
			text = "Window",
			radius = 0.5,
			coords = vector3(-1193.818, -906.8685, 14.10615),
			discrete = true,
		},
		{
			text = "Ingredients",
			radius = 0.6,
			coords = vector3(-1197.675, -899.3553, 14.09628),
			discrete = true,
			width = 4,
			height = 5,
			filters = {
				category = {
					["Ingredient"] = true,
				}
			},
		},
		{
			text = "Drinks",
			radius = 0.5,
			coords = vector3(-1199.055, -895.9397, 13.92456),
			discrete = true,
			width = 4,
			height = 3,
			filters = {
				category = {
					["Drink"] = true,
				}
			},
		},
		{
			text = "Drinks",
			radius = 0.5,
			coords = vector3(-1199.729, -895.0001, 13.92456),
			discrete = true,
			width = 4,
			height = 3,
			filters = {
				category = {
					["Drink"] = true,
				}
			},
		},
	},
})