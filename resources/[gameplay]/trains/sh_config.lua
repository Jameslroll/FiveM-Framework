Config = {
	GridSize = 4,
	MaxTrains = 12,
	MinDistance = 500.0, -- Between trains.
	MaxRetries = 8,
	Models = {
		`freight`,
		`freightcar`,
		`freightcar2`,
		`freightcont1`,
		`freightcont2`,
		`freightgrain`,
		`freighttrailer`,
		`metrotrain`,
		`tankercar`,
	},
	Fronts = {
		[`metrotrain`] = true,
		[`freight`] = true,
	},
}