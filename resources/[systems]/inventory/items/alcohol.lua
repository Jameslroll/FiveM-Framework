local tier1 = {
	{
		name = "Beer",
		weight = 0.34,
		hunger = 0.00,
		thirst = 0.10,
		value = 1.37,
	},
	{
		name = "Tequila",
		weight = 0.75,
		hunger = 0.00,
		thirst = 0.10,
		value = 11.48,
	},
	{
		name = "Vodka",
		weight = 0.75,
		hunger = 0.00,
		thirst = 0.10,
		value = 13.98,
	},
	{
		name = "Whiskey",
		weight = 0.75,
		hunger = 0.00,
		thirst = 0.10,
		value = 16.73,
	},
	{
		name = "Wine",
		weight = 0.75,
		hunger = 0.00,
		thirst = 0.10,
		value = 2.50,
	},
}

local tier4 = {
	{
		name = "Marsala Wine",
		hunger = 0.00,
		thirst = 0.10,
	},
	{
		name = "Ale",
		hunger = 0.00,
		thirst = 0.10,
	},
	{
		name = "Barbados Rum",
		hunger = 0.00,
		thirst = 0.10,
	},
	{
		name = "Bloody Mary",
		hunger = 0.00,
		thirst = 0.10,
	},
	{
		name = "Champagne",
		hunger = 0.00,
		thirst = 0.10,
	},
	{
		name = "Cosmopolitan",
		hunger = 0.00,
		thirst = 0.10,
	},
	{
		name = "Gin & Tonic",
		hunger = 0.00,
		thirst = 0.10,
	},
	{
		name = "Highway To Hell",
		hunger = 0.00,
		thirst = 0.10,
	},
	{
		name = "Kamazie Shot",
		hunger = 0.00,
		thirst = 0.10,
	},
	{
		name = "Jolly Rancher Shot",
		hunger = 0.00,
		thirst = 0.10,
	},
	{
		name = "Mimosa",
		hunger = 0.00,
		thirst = 0.10,
	},
	{
		name = "Old Fashioned",
		hunger = 0.00,
		thirst = 0.10,
	},
	{
		name = "Pear Cider",
		hunger = 0.00,
		thirst = 0.10,
	},
	{
		name = "Porter",
		hunger = 0.00,
		thirst = 0.10,
	},
	{
		name = "Royal Flush",
		hunger = 0.00,
		thirst = 0.10,
	},
	{
		name = "Tequila Sunrise",
		hunger = 0.00,
		thirst = 0.10,
	},
	{
		name = "The Guinness",
		hunger = 0.00,
		thirst = 0.10,
	},
	{
		name = "Unicorn Kiss",
		hunger = 0.00,
		thirst = 0.10,
	},
}

local function RegisterTier(item, hunger, thirst, alcohol)
	item.category = "Alcohol"
	item.usable = "Drink"
	item.stack = item.stack or 16
	
	item.hunger = (item.hunger or 0.0) * hunger
	item.thirst = (item.thirst or 0.0) * thirst
	item.alcohol = (item.alcohol or 0.0) * alcohol
	
	if not item.decay or type(item.decay) == "number" then
		item.decay = {
			time = item.decay or 10070,
			prefix = "Spoiled",
		}
	end
	
	RegisterItem(item)
end

for _, item in ipairs(tier1) do
	RegisterTier(item, 0.05, 0.05, 0.2)
end

for _, item in ipairs(tier4) do
	RegisterTier(item, 1.0, 1.0, 1.0)
end