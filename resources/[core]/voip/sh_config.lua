Config = {
	CycleRanges = 3,
	ChannelHudKey = "roleplay_channel",
	VoiceTarget = 3,
	Convars = {
		["voice_useNativeAudio"] = "true",
		["voice_use2dAudio"] = "false",
		["voice_use3dAudio"] = "false",
		["voice_useSendingRangeOnly"] = "true",
	},
	Ranges = {
		[1] = {
			Proximity = 0.8,
		},
		[2] = {
			Proximity = 2.8,
		},
		[3] = {
			Proximity = 6.7,
		},
		["M"] = {
			Proximity = 18.2,
		}
	},
	Types = {
		Automatic = 1, -- Listens and sends over the channel automatically.
		Manual = 2, -- Listens and sends over the channel using filters.
		Receiver = 3, -- Listens over the channel.
	},
	Amplifiers = {
		Stages = {
			{ Coords = vector3(121.40032958984376, -1280.865478515625, 29.4804630279541), Radius = 2.0 }, -- Vanilla Unicorn.
			{ Coords = vector3(686.324951171875, 577.818603515625, 130.46127319335938), Radius = 10.0 }, -- Vinewood Bowl.
			{ Coords = vector3(205.1594696044922, 1167.18310546875, 227.00482177734375), Radius = 8.0}, --Sisyphus Theater.
			{ Coords = vector3(77.44329833984375, 3704.7197265625, 41.07716369628906), Radius = 2.5 }, -- Stab City L.
			{ Coords = vector3(80.14737701416016, 3708.42919921875, 41.07716369628906), Radius = 2.5 }, -- Stab City M.
			{ Coords = vector3(82.62446594238281, 3711.324462890625, 41.07718658447265), Radius = 2.5 }, -- Stab City R.
			{ Coords = vector3(-550.8392944335938, 281.9425048828125, 82.97657012939453), Radius = 1.5 }, -- Tequi-la-la L.
			{ Coords = vector3(-551.5172729492188, 284.0843505859375, 82.97657012939453), Radius = 1.5 }, -- Tequi-la-la M.
			{ Coords = vector3(-550.9138793945312, 286.9436950683594, 82.97657012939453), Radius = 1.5 }, -- Tequi-la-la R.
			{ Coords = vector3(-454.537841796875, 271.7487487792969, 83.62382507324219), Radius = 3.5 }, -- Comedy Club.
			{ Coords = vector3(-312.4431762695313, 6264.5966796875, 32.06183624267578), Radius = 1.5 }, -- Hen House.
			{ Coords = vector3(-1831.1636962890625, -1190.7034912109375, 19.87976264953613), Radius = 1.5 }, -- Pearls.
			{ Coords = vector3(-300.38397216796875, 197.457763671875, 100.85525512695312), Radius = 0.5 }, -- Blush Bunnies.
			{ Coords = vector3(253.56578063964844, -418.2116088867188, 47.93564987182617), Radius = 1.3 }, -- Courthouse Judge seat.
			{ Coords = vector3(255.65206909179688, -418.90777587890625, 47.71468734741211), Radius = 0.5 }, -- Courthouse The other seat valeyard wanted.
			{ Coords = vector3(-1381.7760009765625, -614.6588745117188, 31.49820518493652), Radius = 1.5 }, -- Bahama Mamas.
			{ Coords = vector3(4893.516, -4905.183, 3.486646), Radius = 2.0 }, -- Cayo Perico, Pleasure Cove.
		},
		Vehicles = {
			[`pbus2`] = { Offset = vector3(-0.58, -1.58, 2.9), Radius = 1.0 },
		},
	},
}