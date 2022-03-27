Config = {
	Debug = false,
	Using = {
		Cooldown = 1000,
	},
	Toggle = {
		Anim = {
			Dict = "pickup_object",
			Name = "putdown_low",
			Flag = 48,
			BlendSpeed = 1.0,
			Duration = 1200,
		},
	},
	EnabledControls = {
		-- On foot.
		30,
		31,
		32,
		33,
		34,
		35,
		-- Vehicles.
		59,
		60,
		61,
		62,
		63,
		64,
		71,
		72,
		76,
	},
	Change = {
		{ Name = "One Hundred Dollars", Nominal = 100.0 },
		{ Name = "Fifty Dollars", Nominal = 50.0 },
		{ Name = "Twenty Dollars", Nominal = 20.0 },
		{ Name = "Ten Dollars", Nominal = 10.0 },
		{ Name = "Five Dollars", Nominal = 5.0 },
		{ Name = "One Dollar", Nominal = 1.0 },
		{ Name = "Quarter", Nominal = 0.25 },
		{ Name = "Dime", Nominal = 0.1 },
		{ Name = "Nickel", Nominal = 0.05 },
		{ Name = "Penny", Nominal = 0.01 },
	},
	Containers = {
		["default"] = {
			name = "Container",
			width = 4,
			height = 4,
			maxWeight = 20.0,
			model = "prop_mil_crate_02",
			emote = {
				Dict = "missmic3",
				Name = "newspaper_idle_outro_dave",
				Flag = 48,
				Rate = 0.2,
				Duration = 1000,
			},
		},
		["station"] = {
			width = 5,
			height = 5,
		},
		["shop"] = {
			name = "Storage",
			width = 5,
			height = 30,
			decayRate = 0.25,
		},
		["player"] = {
			name = "Player",
			width = 5,
			height = 10,
			maxWeight = 100.0,
		},
		["drop"] = {
			name = "Drop",
			width = 4,
			height = 5,
		},
		["debug"] = {
			name = "Container",
			width = 5,
			height = 20,
			model = "vw_prop_vw_pogo_gold_01a",
			user = "Mod",
		},
		["stash1"] = {
			name = "Stash",
			width = 4,
			height = 2,
			maxWeight = 10.0,
		},
		["stash2"] = {
			name = "Stash",
			width = 4,
			height = 4,
			maxWeight = 20.0,
		},
		["stash3"] = {
			name = "Stash",
			width = 4,
			height = 6,
			maxWeight = 30.0,
		},
		["stash4"] = {
			name = "Stash",
			width = 4,
			height = 8,
			maxWeight = 40.0,
		},
		["fridge1"] = {
			name = "Fridge",
			width = 4,
			height = 6,
			maxWeight = 70.0,
			decayRate = 0.25,
			filters = {
				category = {
					["Food"] = true,
					["Beverage"] = true,
					["Ingredients"] = true,
				},
			},
		},
		["fridge2"] = {
			name = "Fridge",
			width = 4,
			height = 20,
			maxWeight = 400.0,
			decayRate = 0.25,
			filters = {
				category = {
					["Food"] = true,
					["Beverage"] = true,
					["Ingredients"] = true,
				},
			},
		},
		["wallet"] = {
			name = "Wallet",
			wallet = true,
			width = 4,
			height = 3,
			filters = {
				category = {
					["Money"] = true,
				},
				item = {
					["License"] = true,
				},
			},
		},
		["duffle"] = {
			name = "Duffle Bag",
			width = 4,
			height = 3,
			maxWeight = 6.0,
			emote = {
				Dict = "anim@heists@money_grab@duffel",
				Name = "enter",
				Flag = 48,
				BlendIn = 8.0,
				BlendOut = 2.0,
				Rate = 0.0,
				Duration = 1200,
			},
		},
		["paperbag"] = {
			name = "Paper Bag",
			width = 2,
			height = 2,
			maxWeight = 2.0,
		},
		["evidencebag"] = {
			name = "Evidence Bag",
			width = 3,
			height = 9,
			maxWeight = 4.0,
		},
		["doll1"] = {
			name = "Nested Doll",
			width = 1,
			height = 1,
			maxWeight = 0.2,
		},
		["doll2"] = {
			name = "Nested Doll",
			width = 1,
			height = 1,
			maxWeight = 0.4,
		},
		["doll3"] = {
			name = "Nested Doll",
			width = 1,
			height = 1,
			maxWeight = 0.6,
		},
		["doll4"] = {
			name = "Nested Doll",
			width = 1,
			height = 1,
			maxWeight = 0.8,
		},
	},
	Binds = {
		{ key = "1" },
		{ key = "2" },
		{ key = "3" },
		{ key = "4" },
		{ key = "5" },
		{ key = "6" },
	},
	Drops = {
		GridSize = 4,
		MaxDistance = 2.0,
		Radius = 1.0,
		Models = {
			["Default"] = "hei_prop_hei_security_case",
			["Drink"] = "v_ret_gc_cup",
			["Fish"] = "prop_crate_03a",
			["Food"] = "prop_food_bag2",
			["Weapon"] = "ch_prop_ch_guncase_01a",
		},
	},
	Packs = {
		["box"] = {
			Suffix = " Box",
			Anim = {
				Dict = "missmic3",
				Name = "newspaper_idle_outro_dave",
				Flag = 48,
				Rate = 0.1,
				Duration = 2500,
			},
		},
		["booster"] = {
			Random = {
				{ name = "Card: Akashi Tomiyoko" },
				{ name = "Card: Hanaba Izuri" },
				{ name = "Card: Miyabata Hirona" },
			},
			Anim = {
				Dict = "missmic3",
				Name = "newspaper_idle_outro_dave",
				Flag = 48,
				Rate = 0.15,
				Duration = 2000,
			},
		},
	},
}