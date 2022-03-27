Config = {
	Item = "Fishing Rod",
	Chance = 0.6,
	Delay = { 10, 15 },
	Decay = { 0.01, 0.02 },
	Anims = {
		Idle = {
			Dict = "amb@world_human_stand_fishing@idle_a",
			Name = "idle_a",
			Flag = 17,
			BlendSpeed = 12.0,
			Props = {
				{ Model = "prop_fishing_rod_01", Bone = 60309, Offset = { 0.0, 0.0, 0.0, 0.0, 0.0, 0.0 }},
			},
		},
		Catch = {
			Dict = "anim@am_hold_up@male",
			Name = "shoplift_mid",
			Flag = 48,
		},
	},
	QuickTime = {
		goalSize = 0.15,
		speed = 0.4,
		stages = 1,
	},
	PeerBonus = {
		Count = 3,
		Chance = 0.3,
		Range = 15.0,
	},
	WeatherModifiers = {
		[`EXTRASUNNY`] = 0.0,
		[`CLEAR`] = 0.0,
		[`NEUTRAL`] = 0.0,
		[`SMOG`] = 0.0,
		[`FOGGY`] = 0.1,
		[`OVERCAST`] = 0.0,
		[`CLOUDS`] = 0.0,
		[`CLEARING`] = 0.1,
		[`RAIN`] = 0.1,
		[`THUNDER`] = -0.1,
		[`SNOW`] = 0.0,
		[`BLIZZARD`] = 0.0,
		[`SNOWLIGHT`] = 0.0,
		[`XMAS`] = 0.0,
		[`HALLOWEEN`] = -100.0,
	},
	Habitats = {
		["Shallow Sandy"] = {
			Fish = {
				["Dogfish"] = 1.0,
				["Flounder"] = 1.0,
				["Halibut"] = 1.0,
				["Queenfish"] = 1.0,
				["Ray"] = 0.5,
				["Sand Bass"] = 1.0,
				["Seaweed"] = 0.5,
			},
		},
		["Deep Sandy"] = {
			Fish = {
				["Halibut"] = 1.0,
				["Seaweed"] = 0.2,
			},
		},
		["Shallow Rocky"] = {
			Fish = {
				["Black Rockfish"] = 1.0,
				["Sheephead"] = 1.0,
				["Rockfish"] = 1.0,
				["Sculpin"] = 1.0,
				["Seaweed"] = 0.5,
			},
		},
		["Deep Rocky"] = {
			Fish = {
				["Giant Seabass"] = 1.0,
				["Lingcod"] = 1.0,
				["Rockfish"] = 1.0,
				["White Seabass"] = 1.0,
				["Seaweed"] = 0.5,
			},
		},
		["Pelagic"] = {
			Fish = {
				["Albacore"] = 1.0,
				["Amberjack"] = 1.0,
				["Barracuda"] = 1.0,
				["Bigeye Tuna"] = 1.0,
				["Blue Shark"] = 0.25,
				["Bluefin Tuna"] = 1.0,
				["Bonito"] = 1.0,
				["Chinook Salmon"] = 1.0,
				["Coho Salmon"] = 1.0,
				["Mackerel"] = 1.0,
				["Mako Shark"] = 0.25,
				["Skipjack Tuna"] = 1.0,
				["Striped Marlin"] = 1.0,
				["Swordfish"] = 0.5,
				["Thresher Shark"] = 0.25,
				["Yellowfin Tuna"] = 1.0,
			},
		},
		["Surf"] = {
			Fish = {
				["Corbina"] = 1.0,
				["Seaweed"] = 0.2,
			},
		},
		["Bay"] = {
			Fish = {
				["Leopard Shark"] = 0.25,
				["White Perch"] = 1.0,
				["Sand Bass"] = 1.0,
				["Sculpin"] = 1.0,
				["Striped Bass"] = 1.0,
				["Sturgeon"] = 1.0,
				["Walleye"] = 1.0,
				["Seaweed"] = 0.25,
			},
		},
		["Secret"] = {
			Fish = {
				["Golden Dorado"] = 1.0,
			},
		},
	},
	Zones = {
		Rocky = {
			DepthPrefix = true,
			Coords = {
				-- El Burro to Paleto.
				vector2(2008.3162841796875, -2548.353759765625),
				vector2(2542.791015625, -2135.404052734375),
				vector2(2501.565673828125, -1398.52880859375),
				vector2(2835.211669921875, -723.8081665039062),
				vector2(2915.46630859375, 256.5668029785156),
				vector2(2770.233154296875, 1035.7762451171875),
				vector2(3235.648193359375, 2153.416259765625),
				vector2(3688.052734375, 3044.283447265625),
				vector2(3865.13916015625, 3946.81884765625),
				vector2(3681.554931640625, 4647.89501953125),
				vector2(3338.22265625, 5040.5966796875),
				vector2(3371.078369140625, 5660.33935546875),
				vector2(3010.507080078125, 6336.04833984375),
				vector2(1960.2476806640625, 6699.55712890625),
				vector2(1458.5147705078125, 6625.4423828125),
				vector2(826.9076538085938, 6633.88623046875),
				vector2(401.2832336425781, 6886.13037109375),
				vector2(60.02974319458008, 7216.6953125),
				vector2(-12.20090389251709, 6998.794921875),
				-- Villa to Airport on Cayo Perrico.
				vector2(4777.623, -5181.037),
			},
		},
		Bay = {
			Coords = {
				-- Paleto to Del Perro.
				vector2(-86.96258544921875, 6765.81298828125),
				vector2(-609.4100341796875, 6256.3798828125),
				vector2(-1330.443359375, 5276.9892578125),
				vector2(-1806.8248291015625, 4804.04248046875),
				vector2(-2140.562255859375, 4593.2236328125),
				vector2(-2589.193359375, 3668.076171875),
				vector2(-2715.280517578125, 2602.468017578125),
				vector2(-3175.67724609375, 1385.7218017578125),
				vector2(-3065.343505859375, 415.5496215820313),
				vector2(-2553.833984375, -243.76385498046875),
				vector2(-2174.1640625, -464.1466674804688),
				-- Rivers.
				vector2(-953.6820678710938, 4397.78369140625),
				vector2(-645.1614379882812, 2887.942626953125),
			},
		},
		Surf = {
			Coords = {
				-- Del Perro to Airport.
				vector2(-2103.309326171875, -555.6774291992188),
				vector2(-1734.3150634765625, -1014.981689453125),
				vector2(-1421.2652587890625, -1542.1636962890625),
				vector2(-1157.71923828125, -1926.57568359375),
				vector2(-1603.194091796875, -2480.208251953125),
				-- Airport to El Burro.
				vector2(-1469.3975830078125, -3345.5849609375),
				vector2(-393.1763000488281, -2745.40966796875),
				vector2(223.28125, -3097.448974609375),
				vector2(1268.788330078125, -3090.962158203125),
				vector2(1024.0880126953125, -2652.064453125),
				vector2(1564.0172119140625, -2728.365966796875),
			},
		},
		Sandy = {
			DepthPrefix = true,
			Coords = {
				-- Land Act Reservoir.
				vector2(1791.5966796875, 7.46894645690918),
				vector2(1968.69677734375, 280.4029846191406),
				-- Vinewood Dam.
				vector2(-261.6719970703125, 834.5707397460938),
				vector2(11.97127628326416, 673.6646728515625),
				vector2(93.3871078491211, 863.7963256835938),
				-- Alamo Sea.
				vector2(2373.682861328125, 4485.93115234375),
				vector2(1825.8143310546875, 4229.42236328125),
				vector2(1067.9041748046875, 3986.1650390625),
				vector2(422.7247924804688, 3965.61181640625),
				vector2(-176.9177398681641, 4217.859375),
			},
		},
	},
}