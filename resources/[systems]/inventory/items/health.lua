--[[ Armor ]]--
RegisterItem({
	category = "Armor",
	name = "Body Armor",
	weight = 2.7,
	stack = 3,
	armor = 1 << 1,
})

RegisterItem({
	category = "Armor",
	name = "Heavy Armor",
	weight = 6.0,
	stack = 1,
	armor = (1 << 2) | (1 << 1),
})

RegisterItem({
	category = "Armor",
	name = "Ballistic Helmet",
	weight = 1.9,
	stack = 1,
	armor = 1 << 3,
})

--[[ Diving ]]--
RegisterItem({
	category = "Diving",
	name = "Rebreather",
	description = "Short term device used for breathing underwater",
	weight = 1.1,
	stack = 16,
})

RegisterItem({
	category = "Diving",
	name = "Scuba Gear",
	description = "Everything you need to explore the coral reef",
	weight = 8.5,
	stack = 16,
})

--[[ Healing ]]--
local items = {
	{
		name = "Medical Bag",
		weight = 2.1,
		stack = 1,
	},
	{
		name = "IFAK",
		weight = 1.2,
		stack = 1,
	},
	{
		name = "Gauze",
		weight = 0.1,
		stack = 16,
	},
	{
		name = "Bandage",
		weight = 0.1,
		stack = 16,
	},
	{
		name = "IV Bag",
		weight = 0.19,
		stack = 16,
	},
	{
		name = "Saline",
		weight = 0.21,
		stack = 16,
	},
	{
		name = "Hydrocodone",
		weight = 1,
		stack = 8,
		model = "ng_proc_drug01a002",
	},
	{
		name = "Oxycodone",
		weight = 0.01,
		stack = 8,
		model = "ng_proc_drug01a002",
	},
	{
		name = "Morphine",
		weight = 0.01,
		stack = 8,
	},
}

for _, item in ipairs(items) do
	item.category = "Medical"

	RegisterItem(item)
end