Config = {
	GridSize = 2,
	DoorRadius = 2.0,
	GarageRadisu = 3.0,
	Types = {
		["motel"] = {
		},
		["apartment"] = {
		},
		["house"] = {
		},
		["mansion"] = {
		},
		["warehouse_sm"] = {
		},
		["warehouse_md"] = {
		},
		["warehouse_lg"] = {
		},
		["warehouse_xl"] = {
		},
	},
	Shells = {
		["motel"] = {
			Name = "Motel",
			Model = `motelshell`,
			Entry = vector4(4.4, 1.2, 0.5, 90.0),
		},
		["apartment"] = {
			Name = "Apartment",
			Model = `apartmentshell`,
			Entry = vector4(6.14452028274536, 0.51251339912414, 1.0273895263672, 1.14755201339721),
		},
		["house_l"] = {
			Name = "Low-end House",
			Model = `houselshell`,
			Entry = vector4(-2.19454479217529, 8.66103172302246, 8.69442844390869, 184.3791046142578),
		},
		["shop"] = {
			Name = "Shop",
			Model = `shopshell`,
			Entry = vector4(1.41482126712799, -14.02155303955078, 1.14791870117188, 0.40985843539237),
		},
		["trailer"] = {
			Name = "Trailer",
			Model = `trailershell`,
			Entry = vector4(1.2672529220581, 4.69660949707031, 2.04898071289065, 181.34971618652344),
		},
	},
	Models = {
		`apartmentshell`,
		`houselshell`,
		`motelshell`,
		`shopshell`,
		`trailershell`,
	},
}