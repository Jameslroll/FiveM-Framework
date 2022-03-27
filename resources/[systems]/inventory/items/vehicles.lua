local parts = {
	{
		name = "Shocks",
		weight = 9.77,
	},
	{
		name = "Brakes",
		weight = 2.63,
	},
	{
		name = "Tire",
		weight = 7.2,
		model = { "prop_wheel_tyre", vector3(-90.0, 0.0, 0.0), vector3(0.0, 0.0, 0.15) },
	},
	{
		name = "Car Battery",
		weight = 19.4,
		model = "prop_battery_02",
	},
	{
		name = "Axle",
		weight = 17.9,
	},
	{
		name = "Fuel Tank",
		weight = 9.97,
	},
	{
		name = "Radiator",
		weight = 9.5,
	},
	{
		name = "Alternator",
		weight = 6.66,
	},
	{
		name = "Transmission",
		weight = 22.2,
	},
	{
		name = "Muffler",
		weight = 8.16,
	},
	{
		name = "Fuel Injector",
		weight = 1.4,
	},
	{
		name = "Repair Kit",
		description = "A set of tools to patch up your engine",
		weight = 1.2,
		model = "v_ind_cs_toolbox4",
		repair = "Engine",
		speed = 1.0,
	},
}

for _, part in pairs(parts) do
	part.category = "Vehicle Repair"
	part.stack = 1
	part.decay = {
		prefix = "Salvaged",
	}

	RegisterItem(part)
end

local items = {
	{
		name = "Vehicle Key",
		weight = 0.11,
		fields = {
			[1] = {
				name = "VIN",
				default = "",
				hidden = false,
			},
		},
		model = "p_car_keys_01",
	},
	{
		name = "Car Jack",
		weight = 9.09,
	},
	{
		name = "NoZ",
		weight = 1.6,
	},
	{
		name = "Tuner Chip",
		weight = 0.8,
	},
	{
		name = "Paint Can",
		weight = 0.62,
		description = "(Somehow) filled with various colors to paint with",
	},
	{
		name = "Light Kit",
		weight = 1.21,
		description = "A series of lights compatible with vehicles"
	},
	{
		name = "Mod Kit",
		weight = 1.42,
		description = "A set of tools useful for modding out vehicles"
	},
	{
		name = "Body Repair Kit",
		weight = 9.24,
		description = "Combination of hydraulics and gauges for removing dents"
	},
	{
		name = "Rag",
		weight = 0.04,
		description = "Clean washcloth rag, at least for now"
	},
	{
		name = "Wheel",
		weight = 11.9,
		model = { "prop_wheel_01", vector3(-90.0, 0.0, 0.0), vector3(0.0, 0.0, 0.13) },
		decay = {
			prefix = "Damaged",
		}
	},
}

for _, item in pairs(items) do
	item.category = "Vehicle"
	item.stack = item.stack or 1

	RegisterItem(item)
end