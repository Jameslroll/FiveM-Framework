Config.Filters.Convenience = {
	item = {
		-- Food.
		["Choco Rings"] = true,
		["Corn Dog"] = true,
		["Crackles O Dawn"] = true,
		["Cup Noodles"] = true,
		["Ego Chaser"] = true,
		["Fat Chips"] = true,
		["Meteorite Bar"] = true,
		["Peanuts"] = true,
		["Ps & Qs"] = true,
		["Rails"] = true,
		["Release Gum"] = true,
		["Scooby Snacks"] = true,

		-- Drink.
		["Coffee"] = true,
		["E Cola"] = true,
		["Junk Energy Drink"] = true,
		["Milk"] = true,
		["O Rang O Tang"] = true,
		["Sprunk"] = true,
		["Water"] = true,

		-- Ingredients.
		["Baking Soda"] = true,
		["Eggs"] = true,

		-- Other.
		["Tenga"] = true,
	},
}

RegisterShop("HARMONY_247", {
	Name = "Harmony 24/7",
	Clerks = {
		{
			coords = vector4(549.2772, 2669.603, 42.15648, 91.24641),
		},
	},
	Storage = {
		Coords = vector3(546.5003, 2662.695, 41.83086),
		Radius = 1.0,
		Filters = Config.Filters.Convenience,
	},
	Containers = {
		{ text = "Counter", radius = 0.2, coords = vector3(548.6461, 2669.562, 42.2) },
	},
})