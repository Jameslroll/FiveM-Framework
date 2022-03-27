local tier1 = {
	{
		name = "Choco Rings",
		weight = 0.65,
		hunger = 1.00,
		thirst = 0.00,
		value = 3.98,
	},
	{
		name = "Corn Dog",
		weight = 0.09,
		hunger = 0.50,
		thirst = 0.00,
		value = 1.98,
	},
	{
		name = "Crackles O Dawn",
		weight = 0.65,
		hunger = 1.00,
		thirst = 0.00,
		value = 3.64,
		model = "v_res_fa_cereal02",
	},
	{
		name = "Cup Noodles",
		weight = 0.54,
		hunger = 1.00,
		thirst = 0.25,
		value = 0.75,
		model = "v_ret_247_noodle1",
	},
	{
		name = "Ego Chaser",
		weight = 0.65,
		hunger = 1.00,
		thirst = 0.00,
		value = 2.48,
		model = "prop_choc_ego",
	},
	{
		name = "Fat Chips",
		weight = 0.23,
		hunger = 1.00,
		thirst = 0.00,
		value = 2.98,
		model = "ng_proc_food_chips01a",
	},
	{
		name = "Meteorite Bar",
		weight = 0.06,
		hunger = 1.00,
		thirst = 0.00,
		value = 1.85,
	},
	{
		name = "Ps & Qs",
		weight = 0.07,
		hunger = 1.00,
		thirst = 0.00,
		value = 1.47,
	},
	{
		name = "Rails",
		weight = 0.65,
		hunger = 1.00,
		thirst = 0.00,
		value = 3.98,
		model = "v_ret_247_cereal1",
	},
	{
		name = "Release Gum",
		weight = 0.05,
		hunger = 1.00,
		thirst = 0.00,
		value = 2.48,
	},
	{
		name = "Wakame",
		description = "Species of kelp used in cooking for soups, salads, and snacks, but also as a seasoning",
		weight = 0.06,
		hunger = 0.50,
		thirst = 0.00,
		value = 6.71,
	},
	{
		name = "Scooby Snacks",
		weight = 0.45,
		hunger = 1.00,
		thirst = 0.00,
		value = 3.94,
	},
	{
		name = "Peanuts",
		weight = 0.40,
		hunger = 0.20,
		thirst = -0.10,
		value = 1.98,
	},
}

local tier2 = {
	{
		name = "Prison Food",
		weight = 0.50,
		hunger = 1.00,
		thirst = 0.10,
		value = 0.00,
	},
	{
		name = "Apple",
		description = "Red fruit with a stem sticking out",
		weight = 0.20,
		hunger = 1.00,
		thirst = 0.00,
		value = 0.99,
	},
	{
		name = "Lemon",
		weight = 0.08,
		hunger = 0.10,
		thirst = 0.00,
		value = 0.53,
	},
	{
		name = "Banana",
		description = "Oddly promiscuous yellow fruit found and grown in Central America",
		weight = 0.25,
		hunger = 1.00,
		thirst = 0.00,
		value = 0.22,
		model = "v_res_tre_banana",
		offset = { 0.0, 0.0, -0.05, 0.0, 0.0, -90.0 }
	},
	{
		name = "Grapes",
		weight = 1.00,
		hunger = 1.00,
		thirst = 0.00,
		value = 2.99,
		model = "prop_grapes_01",
	},
	{
		name = "Tomato",
		description = "Round shaped fruit (yes) rich and juicy used to make savory dishes",
		weight = 0.20,
		hunger = 1.00,
		thirst = 0.00,
		value = 0.86,
	},
	{
		name = "Corn",
		weight = 0.20,
		hunger = 1.00,
		thirst = 0.00,
		value = 0.50,
	},
	{
		name = "Steak",
		weight = 0.45,
		hunger = 1.00,
		thirst = 0.00,
		value = 6.40,
	},
	{
		name = "Pork",
		weight = 0.45,
		hunger = 1.00,
		thirst = 0.00,
		value = 3.68,
	},
	{
		name = "Venison",
		description = "Rich and earthy tasting meat from the Elk or Deer species",
		weight = 0.45,
		hunger = 1.00,
		thirst = 0.00,
		value = 5.20,
	},
	{
		name = "Chicken",
		weight = 0.45,
		hunger = 1.00,
		thirst = 0.00,
		value = 1.99,
	},
	{
		name = "Squab",
		description = "Lush, rich essence, reminiscent of sautéed foie gras",
		weight = 0.45,
		hunger = 1.00,
		thirst = 0.00,
		value = 12.00,
	},
	{
		name = "Cabbage",
		weight = 0.80,
		hunger = 1.00,
		thirst = 0.20,
		value = 1.74,
	},
	{
		name = "Pumpkin",
		weight = 4.00,
		hunger = 1.00,
		thirst = 0.00,
		value = 3.63,
	},
	{
		name = "Orange",
		weight = 0.20,
		hunger = 1.00,
		thirst = 0.00,
		value = 0.71,
	},
	{
		name = "Blueberries",
		description = "Ripe, wild, and fresh berries; a purple-blue in color",
		weight = 0.30,
		hunger = 1.00,
		thirst = 0.00,
		value = 2.98,
	},
	{
		name = "Strawberry",
		description = "Bright red in color, juicy texture, and natural sweetness",
		weight = 0.07,
		hunger = 0.20,
		thirst = 0.40,
		value = 0.30,
	},
	{
		name = "Lime",
		weight = 0.09,
		hunger = 0.10,
		thirst = 0.10,
		value = 0.40,
	},
}

local tier3 = {
	{
		name = "Brownie",
		description = "Cake-style brownie, dense and moist in texture",
		weight = 0.20,
		hunger = 1.00,
		thirst = 0.00,
	},
	{
		name = "Cupcake",
		weight = 0.20,
		hunger = 1.00,
		thirst = 0.00,
	},
	{
		name = "Cookie",
		weight = 0.20,
		hunger = 1.00,
		thirst = 0.00,
	},
	{
		name = "Bread",
		weight = 0.45,
		hunger = 1.00,
		thirst = 0.00,
		model = "v_ret_247_bread1",
	},
	{
		name = "Donut",
		weight = 0.30,
		hunger = 1.00,
		thirst = 0.00,
		model = "prop_donut_01",
	},
	{
		name = "Pocket Spaghetti",
		weight = 0.60,
		hunger = 1.00,
		thirst = 0.00,
	},
	{
		name = "Sandwich",
		description = "Freshly prepared at your local 24/7... not sure how long its been in the fridge for though",
		weight = 0.22,
		hunger = 1.00,
		thirst = 0.00,
	},
	{
		name = "Cooked Rice",
		weight = 0.30,
		hunger = 1.00,
		thirst = 0.00,
	},
	{
		name = "Cooked Turkey",
		weight = 0.50,
		hunger = 1.00,
		thirst = 0.00,
	},
	{
		name = "Blueberry Muffin",
		description = "Sweet with the taste of blueberries mixed with a moist crumb",
		weight = 0.20,
		hunger = 1.00,
		thirst = 0.00,
	},
	{
		name = "Cheese Cake",
		description = "Luscious, rich and sweet dessert",
		weight = 0.30,
		hunger = 1.00,
		thirst = 0.00,
	},
	{
		name = "Grilled Cheese",
		weight = 0.20,
		hunger = 1.00,
		thirst = 0.00,
	},
	{
		name = "Peanut Butter & Jelly",
		weight = 0.20,
		hunger = 1.00,
		thirst = 0.00,
	},
	{
		name = "Pumpkin Cookie",
		weight = 0.20,
		hunger = 1.00,
		thirst = 0.00,
	},
	{
		name = "Pumpkin Muffin",
		weight = 0.20,
		hunger = 1.00,
		thirst = 0.00,
	},
	{
		name = "Vanilla Ice Cream",
		description = "Rich, sweet, creamy frozen food made from real vanilla, cream and milk product",
		weight = 0.15,
		hunger = 1.00,
		thirst = 0.00,
	},
	{
		name = "Homemade Fries",
		weight = 0.20,
		hunger = 1.00,
		thirst = 0.00,
	},
	{
		name = "Sliced Turkey",
		description = "Cooked turkey sliced and ready to enjoy",
		weight = 0.20,
		hunger = 1.00,
		thirst = 0.00,
	},
	{
		name = "Bacon",
		weight = 0.20,
		hunger = 1.00,
		thirst = 0.00,
	},
	{
		name = "Cereal Krispie",
		weight = 0.04,
		hunger = 0.20,
		thirst = 0.00,
	},
	{
		name = "Rice Krispie",
		weight = 0.05,
		hunger = 0.10,
		thirst = 0.00,
	},
	{
		name = "Spaghetti",
		weight = 0.10,
		hunger = 0.80,
		thirst = 0.00,
	},
}

local tier4 = {
	{
		name = "Everything Bagel",
		weight = 0.20,
		hunger = 1.00,
		thirst = 0.00,
		model = "p_ing_bagel_01",
	},
	{
		name = "House Salad",
		weight = 0.15,
		hunger = 1.00,
		thirst = 0.00,
	},
	{
		name = "Red Velvet Cupake",
		weight = 0.20,
		hunger = 1.00,
		thirst = 0.00,
	},
	{
		name = "Scone",
		weight = 0.20,
		hunger = 1.00,
		thirst = 0.00,
	},
	{
		name = "Chicken Caeser Salad",
		weight = 0.30,
		hunger = 1.00,
		thirst = 0.00,
	},
	{
		name = "Churro",
		weight = 0.20,
		hunger = 1.00,
		thirst = 0.00,
	},
	{
		name = "Lady Fingers",
		weight = 0.20,
		hunger = 1.00,
		thirst = 0.00,
	},
	{
		name = "Apple Pie",
		weight = 0.20,
		hunger = 1.00,
		thirst = 0.00,
	},
	{
		name = "Hot Dog",
		weight = 0.20,
		hunger = 1.00,
		thirst = 0.00,
	},
	{
		name = "Turkey BLT",
		description = "Turkey, lettuce and bacon on fresh toasted bread",
		weight = 0.30,
		hunger = 1.00,
		thirst = 0.00,
	},
	{
		name = "Baked Salmon",
		weight = 0.20,
		hunger = 1.00,
		thirst = 0.00,
	},
	{
		name = "Blackened Tuna",
		weight = 0.20,
		hunger = 1.00,
		thirst = 0.00,
	},
	{
		name = "Chicken Fingers",
		weight = 0.20,
		hunger = 1.00,
		thirst = 0.00,
	},
	{
		name = "Chicken Parm",
		weight = 0.20,
		hunger = 1.00,
		thirst = 0.00,
	},
	{
		name = "Chicken Tikka",
		weight = 0.20,
		hunger = 1.00,
		thirst = 0.00,
	},
	{
		name = "Chili Con Carne",
		weight = 0.20,
		hunger = 1.00,
		thirst = 0.00,
	},
	{
		name = "Dino Nuggies",
		weight = 0.20,
		hunger = 1.00,
		thirst = 0.00,
	},
	{
		name = "Fish n Chips",
		weight = 0.20,
		hunger = 1.00,
		thirst = 0.00,
	},
	{
		name = "Fried Calamari",
		weight = 0.20,
		hunger = 1.00,
		thirst = 0.00,
	},
	{
		name = "Lobster Bisque",
		weight = 0.20,
		hunger = 1.00,
		thirst = 0.00,
	},
	{
		name = "Onion Rings",
		weight = 0.20,
		hunger = 1.00,
		thirst = 0.00,
	},
	{
		name = "Oysters Half Shell",
		weight = 0.20,
		hunger = 1.00,
		thirst = 0.00,
	},
	{
		name = "Penne Alla Vodka",
		weight = 0.20,
		hunger = 1.00,
		thirst = 0.00,
	},
	{
		name = "Surf & Turf",
		weight = 0.20,
		hunger = 1.00,
		thirst = 0.00,
	},
	{
		name = "The Meatwich",
		weight = 0.20,
		hunger = 1.00,
		thirst = 0.00,
	},
	{
		name = "Fries",
		weight = 0.20,
		hunger = 1.00,
		thirst = 0.00,
		model = "prop_food_bs_chips",
	},
	{
		name = "Normburger",
		weight = 0.30,
		hunger = 1.00,
		thirst = 0.00,
		model = "prop_food_bs_burg1",
	},
	{
		name = "Bacon Egg Muffin",
		weight = 0.20,
		hunger = 1.00,
		thirst = 0.00,
		model = "prop_food_bs_burg1",
	},
	{
		name = "Chicken Nuggets",
		weight = 0.20,
		hunger = 1.00,
		thirst = 0.00,
	},
	{
		name = "Egg n Cheese Muffin",
		weight = 0.20,
		hunger = 1.00,
		thirst = 0.00,
		model = "prop_food_bs_burg1",
	},
	{
		name = "Hashbrown",
		weight = 0.15,
		hunger = 1.00,
		thirst = 0.00,
	},
	{
		name = "Heart Stopper",
		weight = 0.25,
		hunger = 1.00,
		thirst = 0.00,
		model = "prop_food_bs_burg3",
	},
	{
		name = "Money Shot Burger",
		weight = 0.20,
		hunger = 1.00,
		thirst = 0.00,
	},
	{
		name = "Sausage n Egg Muffin",
		weight = 0.20,
		hunger = 1.00,
		thirst = 0.00,
		model = "prop_food_bs_burg1",
	},
	{
		name = "Tendies",
		weight = 0.20,
		hunger = 1.00,
		thirst = 0.00,
	},
	{
		name = "Cannoli",
		description = "Tube-shaped pastry filled with creme",
		weight = 0.20,
		hunger = 1.00,
		thirst = 0.00,
	},
	{
		name = "Cheese Pizza Slice",
		weight = 0.30,
		hunger = 1.00,
		thirst = 0.00,
		model = "v_res_tt_pizzaplate",
	},
	{
		name = "Aubergine Dhansak",
		weight = 0.40,
		hunger = 1.00,
		thirst = 0.00,
	},
	{
		name = "Capicola",
		weight = 0.20,
		hunger = 1.00,
		thirst = 0.00,
	},
	{
		name = "Garlic Knots",
		weight = 0.20,
		hunger = 1.00,
		thirst = 0.00,
	},
	{
		name = "Italian Cutlet",
		weight = 0.20,
		hunger = 1.00,
		thirst = 0.00,
	},
	{
		name = "Spaghetti & Meatballs",
		weight = 0.20,
		hunger = 1.00,
		thirst = 0.00,
	},
	{
		name = "Tiramisu",
		description = "Coffee-flavoured Italian dessert",
		weight = 0.20,
		hunger = 1.00,
		thirst = 0.00,
	},
	{
		name = "Sushi",
		description = "Traditional Japanese dish of rice, accompanying a variety of ingredients, such as seafood, often raw, and vegetables",
		weight = 0.30,
		hunger = 1.00,
		thirst = 0.00,
	},
	{
		name = "Nigiri",
		weight = 0.20,
		hunger = 1.00,
		thirst = 0.00,
	},
	{
		name = "Maguro Nigiri",
		weight = 0.20,
		hunger = 1.00,
		thirst = 0.00,
	},
	{
		name = "Fish Taco",
		weight = 0.35,
		hunger = 1.00,
		thirst = 0.00,
	},
	{
		name = "Burrito",
		weight = 0.20,
		hunger = 1.00,
		thirst = 0.00,
	},
	{
		name = "Guacamole",
		weight = 0.20,
		hunger = 1.00,
		thirst = 0.00,
	},
	{
		name = "Hard Taco",
		description = "Traditional Mexican dish consisting of a small hand-sized corn or wheat tortilla topped with a filling",
		weight = 0.30,
		hunger = 1.00,
		thirst = 0.00,
	},
	{
		name = "Soft Taco",
		weight = 0.20,
		hunger = 1.00,
		thirst = 0.00,
	},
	{
		name = "Pico De Gallo",
		weight = 0.20,
		hunger = 1.00,
		thirst = 0.00,
	},
	{
		name = "Quesadilla",
		weight = 0.20,
		hunger = 1.00,
		thirst = 0.00,
	},
	{
		name = "Special Cookies",
		weight = 0.20,
		hunger = 1.00,
		thirst = 0.00,
	},
	{
		name = "Popcorn",
		weight = 0.30,
		hunger = 1.00,
		thirst = 0.00,
	},
	{
		name = "Jerky",
		weight = 0.20,
		hunger = 1.00,
		thirst = 0.00,
	},
	{
		name = "Pretzel",
		weight = 0.20,
		hunger = 1.00,
		thirst = 0.00,
	},
}

local function RegisterTier(item, hunger, thirst, comfort)
	item.category = "Food"
	item.usable = "Eat"
	item.stack = item.stack or 16
	
	item.hunger = (item.hunger or 0.0) * hunger
	item.thirst = (item.thirst or 0.0) * thirst
	item.comfort = (item.comfort or 1.0) * comfort

	item.model = item.model or "prop_food_burg1"
	item.offset = item.offset or { 0.0, 0.0, -0.05, 0.0, 0.0, 0.0 }
	
	if not item.decay or type(item.decay) == "number" then
		item.decay = {
			time = item.decay or 10070,
			prefix = "Spoiled",
		}
	end
	
	RegisterItem(item)
end

for _, item in ipairs(tier1) do
	RegisterTier(item, 0.05, 0.05, 0.0)
end

for _, item in ipairs(tier2) do
	RegisterTier(item, 0.2, 0.2, 0.0)
end

for _, item in ipairs(tier3) do
	RegisterTier(item, 0.5, 0.5, 0.1)
end

for _, item in ipairs(tier4) do
	RegisterTier(item, 1.0, 1.0, 0.2)
end