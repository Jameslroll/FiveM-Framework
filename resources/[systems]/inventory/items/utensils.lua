local items = {
	{
		name = "Bowl",
		weight = 0.40,
		value = 4.99,
	},
	{
		name = "Plate",
		weight = 0.40,
		value = 4.99,
	},
	{
		name = "Cook Book",
		weight = 0.90,
		value = 9.99,
	},
	{
		name = "Potato Masher",
		weight = 0.32,
		value = 8.99,
	},
	{
		name = "Strainer",
		weight = 0.45,
		value = 6.80,
	},
	{
		name = "Tongs",
		weight = 0.08,
		value = 1.70,
	},
	{
		name = "Whisk",
		weight = 0.11,
		value = 2.10,
	},
}

for _, item in ipairs(items) do
	item.category = "Utensil"
	item.stack = 1

	RegisterItem(item)
end