Config = {
	Control = 45, -- Control for broadcasting on station.
	BaseVolume = 0.4,
	Items = {
		["Satellite Radio"] = true,
	},
	Stations = {
		{
			Channel = "r99.3",
			Name = "Radio Pioneers",
			Type = "Manual",
			Center = vector3(717.9264, 2534.835, 75.01734),
			Light = vector3(720.5579, 2533.93, 74.59779),
			Control = vector3(721.5223, 2534.003, 73.47406),
			Radius = 10.0,
			Room = "studiobooth",
		},
		-- {
		-- 	Channel = "137.00",
		-- 	Name = "Dispatch",
		-- 	Type = "Manual",
		-- 	Center = vector3(444.4111, -997.6417, 34.97013),
		-- 	Light = vector3(442.4712, -997.6697, 35.80561),
		-- 	Control = vector3(440.7523, -995.8439, 35.14596),
		-- 	Radius = 10.0,
		-- 	Room = "Room17",
		-- },
	},
}