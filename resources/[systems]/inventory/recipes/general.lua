RegisterRecipe({
	name = "Thermite",
	duration = 15000,
	stations = { "Workbench" },
	input = {
		{ name = "Phosphorus", quantity = 5 },
		{ name = "Scrap Aluminum", quantity = 1 },
	},
	output = {
		{ name = "Thermite", quantity = 1 },
	},
})

RegisterRecipe({
	name = "Joints",
	duration = 4000,
	stations = { "Workbench" },
	input = {
		{ name = "Weed", quantity = 1 },
		{ name = "Rolling Paper", quantity = 1 },
	},
	output = {
		{ name = "Joint", quantity = 1 },
	},
})

RegisterRecipe({
	name = "Lean",
	duration = 1500,
	stations = { "Workbench" },
	input = {
		{ name = "Sprunk", quantity = 1 },
		{ name = "Codeine", quantity = 1 },
		{ name = "Soda Cup", quantity = 1 },
	},
	output = {
		{ name = "Lean", quantity = 1 },
	},
})

-- RegisterRecipe({
-- 	name = "Sulphuric Acid",
-- 	duration = 15000,
-- 	stations = { "Workbench" },
-- 	input = {
-- 		{ name = "Car Battery", quantity = 1 },
-- 		{ name = "Compact Coal", quantity = 2 },
-- 		{ name = "Jar", quantity = 3 },
-- 		{ name = "Pliers", durability = 0.1 },
-- 	},
-- 	output = {
-- 		{ name = "Sulphuric Acid", quantity = 3 },
-- 	},
-- })

RegisterRecipe({
	name = "Compact Coal",
	duration = 2000,
	stations = { "Workbench" },
	input = {
		{ name = "Coal", quantity = 4 },
	},
	output = {
		{ name = "Compact Coal", quantity = 1 },
	},
})

RegisterRecipe({
	name = "Gun Powder",
	duration = 5000,
	stations = { "Workbench" },
	input = {
		{ name = "Plastic", quantity = 7 },
		{ name = "Coal", quantity = 2 },
		{ name = "Sulfur", quantity = 2 },
	},
	output = {
		{ name = "Gun Powder", quantity = 2 },
	},
})