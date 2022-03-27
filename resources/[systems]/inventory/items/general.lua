RegisterItem({
	name = "Die",
	description = "Single six sided die",
	weight = 0.2,
	stack = 1,
})

RegisterItem({
	name = "Even Die",
	weight = 0.2,
	stack = 1,
})

RegisterItem({
	name = "Odd Die",
	weight = 0.2,
	stack = 1,
})

RegisterItem({
	name = "License",
	weight = 0.01,
	stack = 1,
	fields = {
		["Character"] = {
			default = 0,
			hidden = true,
		},
		["Name"] = {
			default = "John Doe",
		},
		["ID"] = {
			default = 0,
		},
	}
})

RegisterItem({
	category = "Electronics",
	name = "Mobile Phone",
	weight = 0.08,
	stack = 1,
})

RegisterItem({
	category = "Electronics",
	name = "Tablet",
	weight = 0.24,
	stack = 1,
})

RegisterItem({
	category = "Electronics",
	name = "Money Counter",
	weight = 0.08,
	stack = 1,
})

RegisterItem({
	category = "Restraint",
	name = "Ziptie",
	description = "Strong plastic fastener used for holding items together",
	weight = 0.5,
	stack = 3,
})

RegisterItem({
	category = "Restraint",
	name = "Handcuffs",
	weight = 1,
	stack = 3,
})

RegisterItem({
	category = "Evidence",
	name = "Sealed Evidence Bag",
	description = "This bag contains carefully collected evidence, sealed as to not be contaminated or tampered with",
	weight = 0.2,
	stack = 1,
	fields = {{true, "Evidence", { "None" }}, {false, "Info", {}}},
})

RegisterItem({
	category = "Evidence",
	name = "Evidence Bag",
	weight = 0.2,
	stack = 16,
	nested = "evidencebag",
})

RegisterItem({
	category = "Heist",
	name = "Drill",
	weight = 1,
	stack = 1,
})

RegisterItem({
	name = "Fake Plate",
	weight = 1,
	stack = 1,
})

RegisterItem({
	category = "Tools",
	name = "Wire Tracer",
	weight = 1,
	stack = 1,
})

RegisterItem({
	category = "Heist",
	name = "Lockpick",
	weight = 1,
	stack = 16,
})

RegisterItem({
	category = "Heist",
	name = "Duffle Bag",
	weight = 1,
	stack = 1,
	visible = 2,
	model = "prop_cs_heist_bag_02",
	nested = "duffle",
})

RegisterItem({
	category = "Heist",
	name = "Mallet",
	weight = 1.25,
	stack = 16,
})

RegisterItem({
	category = "Drug",
	name = "Cannabis",
	weight = 1,
	stack = 64,
})

RegisterItem({
	category = "Drug",
	name = "Cocaine",
	weight = 0.001,
	stack = 64,
	model = "prop_drug_package_02",
})

RegisterItem({
	name = "Solo Cup",
	description = "Disposable plastic cup. Please recycle",
	weight = 0.05,
	stack = 16,
	model = "prop_plastic_cup_02",
})

RegisterItem({
	category = "Drug",
	name = "Lean",
	weight = 1.05,
	stack = 16,
	model = "prop_plastic_cup_02",
})

RegisterItem({
	category = "Drug",
	name = "Crack Pipe",
	weight = 1,
	stack = 64,
	model = "prop_cs_crackpipe",
})

RegisterItem({
	category = "Drug",
	name = "Crack Cocaine",
	weight = 0.001,
	stack = 64,
})

RegisterItem({
	category = "Drug",
	name = "Heroin",
	weight = 0.001,
	stack = 64,
})

RegisterItem({
	category = "Drug",
	name = "Laced Heroin Syringe",
	weight = 0.01,
	stack = 64,
})

RegisterItem({
	category = "Drug",
	name = "Heroin Syringe",
	weight = 0.01,
	stack = 64,
})

RegisterItem({
	category = "Drug",
	name = "China White",
	weight = 0.001,
	stack = 64,
})

RegisterItem({
	category = "Drug",
	name = "China White Syringe",
	weight = 0.01,
	stack = 64,
})

RegisterItem({
	category = "Drug",
	name = "Fentanyl",
	weight = 0.001,
	stack = 64,
})

RegisterItem({
	category = "Drug",
	name = "Powdered Fentanyl",
	weight = 0.001,
	stack = 64,
})

RegisterItem({
	category = "Drug",
	name = "Methylfentanyl",
	weight = 0.001,
	stack = 64,
})

RegisterItem({
	category = "Drug",
	name = "Joint",
	weight = 0.0235,
	stack = 16,
	model = "p_amb_joint_01",
})

RegisterItem({
	category = "Drug",
	name = "Bong",
	weight = 0.5,
	stack = 16,
	model = "prop_bong_01",
})

RegisterItem({
	category = "Drug",
	name = "Medicinal Joint",
	weight = 0.0235,
	stack = 16,
	model = "p_amb_joint_01",
})

RegisterItem({
	category = "Drug",
	name = "Edible",
	weight = 0.01,
	stack = 16,
})

RegisterItem({
	category = "Drug",
	name = "LSD",
	weight = 1,
	stack = 64,
})

RegisterItem({
	category = "Drug",
	name = "Methamphetamine",
	weight = 1,
	stack = 64,
	model = "bkr_prop_meth_smallbag_01a",
})

RegisterItem({
	category = "Drug",
	name = "Pill Press",
	weight = 3,
	stack = 16,
})

RegisterItem({
	category = "Drug",
	name = "Ketamine Syringe",
	weight = 0.001,
	stack = 64,
})

RegisterItem({
	category = "Drug",
	name = "Cyanide",
	weight = 0.01,
	stack = 16,
})

RegisterItem({
	name = "Syringe",
	description = "Simple reciprocating pump consisting of a plunger that fits tightly within a cylindrical tube to take in and expel liquid or gas",
	weight = 0.01,
	stack = 64,
})

RegisterItem({
	category = "Drug",
	name = "Peyote",
	weight = 0.05,
	stack = 64,
})

RegisterItem({
	category = "Drug",
	name = "Peyote Chunk",
	weight = 0.001,
	stack = 64,
})

RegisterItem({
	category = "Drug",
	name = "Weed",
	description = "Psychoactive drug from the Cannabis plant used primarily for medical and recreational purposes",
	weight = 0.001,
	stack = 64,
	model = "prop_drug_package_02",
})

RegisterItem({
	category = "Drug",
	name = "Xanax",
	description = "Controlled substance used to treat anxiety and panic disorders",
	weight = 1,
	stack = 64,
})

RegisterItem({
	name = "Tenga",
	description = "Male masturbation aid",
	weight = 0.13,
	stack = 1,
	value = 9.99,
	visible = 1,
})

RegisterItem({
	name = "Max 2",
	description = "Male masturbator with vibrating capabilities",
	weight = 0.75,
	stack = 1,
	value = 99.99,
	visible = 1,
})

RegisterItem({
	name = "Domi 2",
	weight = 0.6,
	stack = 1,
	visible = 1,
})

RegisterItem({
	name = "Nora",
	weight = 0.5,
	stack = 1,
	visible = 1,
})

RegisterItem({
	name = "Water-Based Lubricant",
	description = "Specialized lubricant used during sexual acts",
	weight = 0.05,
	stack = 16,
})

RegisterItem({
	name = "Tracker",
	weight = 0.06,
	stack = 1,
})

RegisterItem({
	category = "Heist",
	name = "Green Keycard",
	weight = 0.1,
	stack = 16,
})

RegisterItem({
	name = "Fuzzy Handcuffs",
	weight = 1,
	stack = 1,
})

RegisterItem({
	name = "Juicer",
	weight = 0.2,
	stack = 1,
})

RegisterItem({
	name = "Cup",
	weight = 0.05,
	stack = 32,
})

RegisterItem({
	name = "Gunshot Residue Kit",
	weight = 1,
	stack = 1,
})

RegisterItem({
	name = "Handcuff Keys",
	weight = 0.5,
	stack = 1,
})

RegisterItem({
	category = "Ammo",
	name = "Rocket",
	weight = 1,
	stack = 1,
	usable = "Ammo",
})

RegisterItem({
	name = "Rolling Paper",
	description = "Sprinkle in some weed or tabacco, roll it up, and smoke it",
	weight = 0.02,
	stack = 64,
})

RegisterItem({
	name = "Cigarette Pack",
	weight = 0.1,
	stack = 16,
})

RegisterItem({
	name = "Cigarette",
	weight = 0.01,
	stack = 16,
})

RegisterItem({
	name = "Cigar",
	weight = 0.1,
	stack = 16,
})

RegisterItem({
	name = "Vape Pen",
	description = "Compact pen shaped vaping device used to inhale flavored liquids commonly containing nicotine",
	weight = 0.1,
	stack = 16,
})

RegisterItem({
	name = "Scissors",
	weight = 0.5,
	stack = 1,
})

RegisterItem({
	category = "Electronics",
	name = "Radio",
	description = "Device that uses radio frequency (RF) to transmit voice",
	weight = 1,
	stack = 1,
	model = "prop_cs_hand_radio",
})

RegisterItem({
	category = "Tool",
	name = "Wire Cutters",
	description = "Pliers intended for the cutting of wire",
	weight = 0.5,
	stack = 1,
})

RegisterItem({
	category = "Resource",
	name = "Solder",
	description = "Fusible metal alloy used to create a permanent bond between metal workpieces",
	weight = 0.1,
	stack = 64,
})

RegisterItem({
	category = "Tool",
	name = "Soldering Iron",
	description = "Hand tool used in soldering. It supplies heat to melt solder so that it can flow into the joint between two workpieces",
	weight = 2,
	stack = 1,
})

RegisterItem({
	category = "Tool",
	name = "Pliers",
	weight = 0.5,
	stack = 1,
})

RegisterItem({
	category = "Tool",
	name = "Screwdriver",
	weight = 0.5,
	stack = 1,
})

RegisterItem({
	category = "Tool",
	name = "Electrical Tape",
	weight = 0.2,
	stack = 1,
})

RegisterItem({
	category = "Tool",
	name = "Nail File",
	weight = 0.25,
	stack = 1,
})

RegisterItem({
	category = "Farming",
	name = "Apple Tree Seed",
	weight = 0.1,
	stack = 16,
})

RegisterItem({
	name = "Jar",
	weight = 0.05,
	stack = 16,
})

RegisterItem({
	category = "Farming",
	name = "Poppy Seed Pod",
	weight = 0.01,
	stack = 128,
})

RegisterItem({
	category = "Drug",
	name = "Raw Opium",
	weight = 0.01,
	stack = 64,
})

RegisterItem({
	name = "Badge",
	description = "Identification given to law enforcement to show proof of employment",
	weight = 0.01,
	stack = 1,
	fields = {{true, "Name", ""}, {true, "ID", 0}}
})

RegisterItem({
	name = "Soil",
	description = "Mixture of organic matter, minerals, gases, liquids, and organisms that together support life",
	weight = 0.1,
	stack = 16,
})

RegisterItem({
	category = "Heist",
	name = "Hacking Tool",
	weight = 0.2,
	stack = 16,
})

RegisterItem({
	category = "Heist",
	name = "Safe Cracking Tool",
	weight = 0.2,
	stack = 16,
})

RegisterItem({
	category = "Tools",
	name = "Fishing Rod",
	weight = 0.5,
	stack = 1,
})

RegisterItem({
	category = "Fish",
	name = "Dogfish",
	weight = 0.5,
	stack = 32,
	decay = 10080,
})

RegisterItem({
	category = "Fish",
	name = "Flounder",
	weight = 0.5,
	stack = 32,
	decay = 10080,
})

RegisterItem({
	category = "Fish",
	name = "Halibut",
	weight = 0.5,
	stack = 32,
	decay = 10080,
})

RegisterItem({
	category = "Fish",
	name = "Queenfish",
	weight = 0.5,
	stack = 32,
	decay = 10080,
})

RegisterItem({
	category = "Fish",
	name = "Ray",
	weight = 0.8,
	stack = 32,
	decay = 10080,
})

RegisterItem({
	category = "Fish",
	name = "Sand Bass",
	weight = 0.5,
	stack = 32,
	decay = 10080,
})

RegisterItem({
	category = "Fish",
	name = "Black Rockfish",
	weight = 0.5,
	stack = 32,
	decay = 10080,
})

RegisterItem({
	category = "Fish",
	name = "Sheephead",
	weight = 0.5,
	stack = 32,
	decay = 10080,
})

RegisterItem({
	category = "Fish",
	name = "Rockfish",
	weight = 0.5,
	stack = 32,
	decay = 10080,
})

RegisterItem({
	category = "Fish",
	name = "Sculpin",
	weight = 0.5,
	stack = 32,
	decay = 10080,
})

RegisterItem({
	category = "Fish",
	name = "Giant Seabass",
	weight = 0.5,
	stack = 32,
	decay = 10080,
})

RegisterItem({
	category = "Fish",
	name = "Lingcod",
	weight = 0.5,
	stack = 32,
	decay = 10080,
})

RegisterItem({
	category = "Fish",
	name = "White Seabass",
	description = "Moderately low fat fish with a mild flavor",
	weight = 0.5,
	stack = 32,
	decay = 10080,
})

RegisterItem({
	category = "Fish",
	name = "Albacore",
	description = "Also known as a Longfin Tuna and has remarkably long pectoral fins",
	weight = 0.5,
	stack = 32,
	decay = 10080,
})

RegisterItem({
	category = "Fish",
	name = "Amberjack",
	weight = 0.5,
	stack = 32,
	decay = 10080,
})

RegisterItem({
	category = "Fish",
	name = "Barracuda",
	weight = 0.5,
	stack = 32,
	decay = 10080,
})

RegisterItem({
	category = "Fish",
	name = "Bigeye Tuna",
	weight = 0.5,
	stack = 32,
	decay = 10080,
})

RegisterItem({
	category = "Fish",
	name = "Blue Shark",
	weight = 0.5,
	stack = 32,
	decay = 10080,
})

RegisterItem({
	category = "Fish",
	name = "Bluefin Tuna",
	weight = 0.5,
	stack = 32,
	decay = 10080,
})

RegisterItem({
	category = "Fish",
	name = "Bonito",
	weight = 0.5,
	stack = 32,
	decay = 10080,
})

RegisterItem({
	category = "Fish",
	name = "Chinook Salmon",
	weight = 0.5,
	stack = 32,
	decay = 10080,
})

RegisterItem({
	category = "Fish",
	name = "Coho Salmon",
	weight = 0.5,
	stack = 32,
	decay = 10080,
})

RegisterItem({
	category = "Fish",
	name = "Mackerel",
	weight = 0.5,
	stack = 32,
	decay = 10080,
})

RegisterItem({
	category = "Fish",
	name = "Mako Shark",
	weight = 1.0,
	stack = 32,
	decay = 10080,
})

RegisterItem({
	category = "Fish",
	name = "Skipjack Tuna",
	weight = 0.5,
	stack = 32,
	decay = 10080,
})

RegisterItem({
	category = "Fish",
	name = "Striped Marlin",
	weight = 0.5,
	stack = 32,
	decay = 10080,
})

RegisterItem({
	category = "Fish",
	name = "Swordfish",
	description = "Mild-tasting, white-fleshed fish with a meaty texture",
	weight = 0.5,
	stack = 32,
	decay = 10080,
})

RegisterItem({
	category = "Fish",
	name = "Thresher Shark",
	description = "Ask Donovan Ford about this shark or any sharks for more information",
	weight = 0.5,
	stack = 32,
	decay = 10080,
})

RegisterItem({
	category = "Fish",
	name = "Yellowfin Tuna",
	description = "Larger Tuna species that is great for sushi or grilling",
	weight = 0.5,
	stack = 32,
	decay = 10080,
})

RegisterItem({
	category = "Fish",
	name = "Corbina",
	weight = 0.5,
	stack = 32,
	decay = 10080,
})

RegisterItem({
	category = "Fish",
	name = "Leopard Shark",
	weight = 0.5,
	stack = 32,
	decay = 10080,
})

RegisterItem({
	category = "Fish",
	name = "White Perch",
	description = "Smaller sized fish with a strong fishy flavor",
	weight = 0.5,
	stack = 32,
	decay = 10080,
})

RegisterItem({
	category = "Fish",
	name = "Striped Bass",
	weight = 0.5,
	stack = 32,
	decay = 10080,
})

RegisterItem({
	category = "Fish",
	name = "Sturgeon",
	description = "Mild and delicatly flavored fish",
	weight = 0.5,
	stack = 32,
	decay = 10080,
})

RegisterItem({
	category = "Fish",
	name = "Walleye",
	description = "Subtle, sweet and buttery fish",
	weight = 0.5,
	stack = 32,
	decay = 10080,
})

RegisterItem({
	category = "Fish",
	name = "Golden Dorado",
	weight = 0.5,
	stack = 32,
	decay = 30240,
})

RegisterItem({
	category = "Fish",
	name = "Scallop",
	weight = 0.5,
	stack = 32,
	decay = 10080,
})

RegisterItem({
	category = "Fish",
	name = "Squid",
	description = "Firm and white with a mild, slightly sweet, almost nutty flavor",
	weight = 0.8,
	stack = 32,
	decay = 10080,
})

RegisterItem({
	category = "Fish",
	name = "Shrimp",
	weight = 0.2,
	stack = 32,
	decay = 10080,
})

RegisterItem({
	category = "Fish",
	name = "Lobster",
	weight = 0.4,
	stack = 32,
	decay = 10080,
})

RegisterItem({
	category = "Fish",
	name = "Catfish",
	weight = 0.5,
	stack = 32,
	decay = 10080,
})

RegisterItem({
	category = "Fish",
	name = "Clam",
	weight = 0.5,
	stack = 32,
})

RegisterItem({
	category = "Fish",
	name = "Crayfish",
	weight = 0.5,
	stack = 32,
	decay = 10080,
})

RegisterItem({
	category = "Fish",
	name = "Crab",
	weight = 0.4,
	stack = 32,
	decay = 10080,
})

RegisterItem({
	name = "Battery",
	description = "Has positive and negative terminal connectors",
	weight = 1,
	stack = 16,
})

RegisterItem({
	category = "Heist",
	name = "Cracked USB",
	weight = 0.25,
	stack = 16,
})

RegisterItem({
	category = "Electronics",
	name = "USB",
	weight = 0.25,
	stack = 16,
})

RegisterItem({
	name = "Metal Spring",
	weight = 0.5,
	stack = 16,
})

RegisterItem({
	category = "Tool",
	name = "Pickaxe",
	weight = 1,
	stack = 1,
})

RegisterItem({
	category = "Hunting",
	name = "Small Bones",
	weight = 1,
	stack = 16,
})

RegisterItem({
	category = "Hunting",
	name = "Large Bones",
	weight = 1,
	stack = 16,
})

RegisterItem({
	name = "Bone Meal",
	weight = 1,
	stack = 16,
})

RegisterItem({
	name = "Golden Egg",
	weight = 1,
	stack = 1,
})

RegisterItem({
	name = "Ankle Monitor",
	description = "Looks like it might fit on somebody's ankle",
	weight = 0.1,
	stack = 1,
})

RegisterItem({
	category = "Jewel",
	name = "Diamond",
	weight = 0.1,
	stack = 16,
})

RegisterItem({
	category = "Jewel",
	name = "Emerald",
	weight = 0.1,
	stack = 16,
})

RegisterItem({
	category = "Jewel",
	name = "Ruby",
	weight = 0.1,
	stack = 16,
})

RegisterItem({
	category = "Jewel",
	name = "Sapphire",
	weight = 0.1,
	stack = 16,
})

RegisterItem({
	category = "Drug",
	name = "Cocaine Paste",
	weight = 0.02,
	stack = 64,
	decay = 360,
	onbreak = {"AddItem", "ContainerId", "Cocaine", "Amount", false, "SlotId"}
})

RegisterItem({
	category = "Drug",
	name = "Coca Leaves",
	weight = 0.1,
	stack = 128,
})

RegisterItem({
	category = "Heist",
	name = "Brown Keycard",
	weight = 0.1,
	stack = 16,
})

RegisterItem({
	category = "Heist",
	name = "Red Keycard",
	weight = 0.1,
	stack = 16,
})

RegisterItem({
	category = "Heist",
	name = "Black Keycard",
	weight = 0.1,
	stack = 16,
})

RegisterItem({
	category = "Heist",
	name = "Diamond Key",
	weight = 0.1,
	stack = 16,
})

RegisterItem({
	category = "Heist",
	name = "Blue Keycard",
	weight = 0.1,
	stack = 16,
})

RegisterItem({
	category = "Heist",
	name = "Valuable Goods",
	description = "Various valuable items of high worth",
	weight = 1,
	stack = 16,
})

RegisterItem({
	name = "Paper",
	weight = 0.025,
	stack = 128,
})

RegisterItem({
	name = "Blueprint",
	weight = 0.1208,
	stack = 16,
})

RegisterItem({
	name = "Binoculars",
	weight = 0.8,
	stack = 1,
	model = "prop_binoc_01",
})

RegisterItem({
	category = "Electronics",
	name = "Camera",
	weight = 1.2,
	stack = 1,
	model = "prop_ing_camera_01",
})

RegisterItem({
	category = "Attachment",
	name = "Scope",
	description = "Weapon attachment used to magnifly and assist in visually aligning ranged weapons",
	weight = 0.2,
	stack = 8,
	usable = "Attachment",
})

RegisterItem({
	category = "Attachment",
	name = "Extended Clip",
	weight = 0.2,
	stack = 8,
	usable = "Attachment",
})

RegisterItem({
	category = "Attachment",
	name = "Suppressor",
	description = "Also known as a silencer is a muzzle device that when attached to a gun reduces acoustic intensity of the gunshots",
	weight = 0.2,
	stack = 8,
	usable = "Attachment",
})

RegisterItem({
	category = "Attachment",
	name = "Tactical Light",
	description = "Flashlight used in conjunction with a firearm to aid low-light target identification",
	weight = 0.2,
	stack = 8,
	usable = "Attachment",
})

RegisterItem({
	category = "Attachment",
	name = "Grip",
	weight = 0.2,
	stack = 8,
	usable = "Attachment",
})

RegisterItem({
	name = "Bleach",
	weight = 3.43,
	stack = 16,
})

RegisterItem({
	category = "Tool",
	name = "Tweezers",
	description = "Small tools used for picking up objects too small to be easily handled with the human fingers",
	weight = 0.009,
	stack = 1,
})

RegisterItem({
	name = "Cotton Swab",
	weight = 0.001,
	stack = 32,
})

RegisterItem({
	name = "Golden Pumpkin",
	weight = 0.5,
	stack = 1,
})

RegisterItem({
	name = "Briefcase",
	weight = 1.0,
	stack = 1,
	usable = "Weapon",
	fields = {{false, "Serial", 0}, {false, "Ammo", 0}, {false, "Attachments", {}}}
})

RegisterItem({
	name = "Metal Briefcase",
	weight = 1.0,
	stack = 1,
	usable = "Weapon",
	fields = {{false, "Serial", 0}, {false, "Ammo", 0}, {false, "Attachments", {}}}
})

RegisterItem({
	name = "Pellets",
	weight = 0.04,
	stack = 128,
})

RegisterItem({
	name = "Studio Camera",
	weight = 0.2,
	stack = 20,
	decay = 4080,
})

RegisterItem({
	name = "Microphone",
	weight = 0.2,
	stack = 20,
	decay = 4080,
})

RegisterItem({
	name = "Boom Microphone",
	weight = 0.2,
	stack = 20,
	decay = 4080,
})

RegisterItem({
	name = "Scratch Off",
	weight = 0.02,
	stack = 16,
})

RegisterItem({
	name = "Paper Bag",
	weight = 0.5,
	stack = 1,
	model = "ng_proc_food_bag01a",
	nested = "paperbag",
})

RegisterItem({
	name = "Plastic Explosive",
	weight = 3.0,
	stack = 8,
})

RegisterItem({
	name = "Detonater",
	weight = 0.3,
	stack = 1,
})

RegisterItem({
	name = "Ring of Bias",
	description = "A ring that contains the power of God",
	weight = 0.0,
	stack = 1,
	nested = "debug",
})

RegisterItem({
	name = "Orb of Bias",
	description = "An orb that contains the power of God",
	weight = 0.0,
	stack = 1,
})

RegisterItem({
	name = "Nested Doll Tiny",
	weight = 0.04,
	stack = 1,
	nested = "doll1",
})

RegisterItem({
	name = "Nested Doll Small",
	weight = 0.08,
	stack = 1,
	nested = "doll2",
})

RegisterItem({
	name = "Nested Doll Medium",
	weight = 0.12,
	stack = 1,
	nested = "doll3",
})

RegisterItem({
	name = "Nested Doll Large",
	weight = 0.16,
	stack = 1,
	nested = "doll4",
})

RegisterItem({
	name = "Satellite Radio",
	weight = 1.9,
	stack = 1,
	fields = {
		[1] = {
			name = "On",
			default = 0,
			hidden = false,
		},
		[2] = {
			name = "Channel",
			default = 1,
			hidden = false,
		},
	},
})