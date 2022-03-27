Overlays = {
	Head = {
		Makeup = {
			{ index = 4, name = "Makeup" },
			{ index = 5, name = "Blush" },
			{ index = 8, name = "Lipstick" },
		},
		Hair = {
			{ index = 1, name = "Facial Hair" },
			{ index = 2, name = "Eyebrows" },
			{ index = 10, name = "Chest Hair", target = "chest" },
		},
		Other = {
			{ index = 0, name = "Blemishes" },
			{ index = 3, name = "Ageing" },
			{ index = 6, name = "Complexion" },
			{ index = 7, name = "Sun Damage" },
			{ index = 9, name = "Moles/Freckles" },
			{ index = 11, name = "Body Blemishes" },
		},
	},
	Zones = {
		["ZONE_HEAD"] = { index = 1, name = "Head", target = "head" },
		["ZONE_TORSO"] = { index = 2, name = "Torso", target = "chest" },
		["ZONE_LEFT_ARM"] = { index = 3, name = "Left Arm", target = "larm" },
		["ZONE_RIGHT_ARM"] = { index = 4, name = "Right Arm", target = "rarm" },
		["ZONE_LEFT_LEG"] = { index = 5, name = "Left Leg", target = "lleg" },
		["ZONE_RIGHT_LEG"] = { index = 6, name = "Right Leg", target = "rleg" },
	},
	Tattoos = {
		[`mpairraces_overlays`] = {
			{
				name = "Turbulence",
				male = `MP_Airraces_Tattoo_000_M`,
				female = `MP_Airraces_Tattoo_000_F`,
				zone = "ZONE_TORSO"
			},
			{
				name = "Pilot Skull",
				male = `MP_Airraces_Tattoo_001_M`,
				female = `MP_Airraces_Tattoo_001_F`,
				zone = "ZONE_TORSO"
			},
			{
				name = "Winged Bombshell",
				male = `MP_Airraces_Tattoo_002_M`,
				female = `MP_Airraces_Tattoo_002_F`,
				zone = "ZONE_TORSO"
			},
			{
				name = "Toxic Trails",
				male = `MP_Airraces_Tattoo_003_M`,
				female = `MP_Airraces_Tattoo_003_F`,
				zone = "ZONE_LEFT_ARM"
			},
			{
				name = "Balloon Pioneer",
				male = `MP_Airraces_Tattoo_004_M`,
				female = `MP_Airraces_Tattoo_004_F`,
				zone = "ZONE_TORSO"
			},
			{
				name = "Parachute Belle",
				male = `MP_Airraces_Tattoo_005_M`,
				female = `MP_Airraces_Tattoo_005_F`,
				zone = "ZONE_TORSO"
			},
			{
				name = "Bombs Away",
				male = `MP_Airraces_Tattoo_006_M`,
				female = `MP_Airraces_Tattoo_006_F`,
				zone = "ZONE_TORSO"
			},
			{
				name = "Eagle Eyes",
				male = `MP_Airraces_Tattoo_007_M`,
				female = `MP_Airraces_Tattoo_007_F`,
				zone = "ZONE_TORSO"
			}
		},
		[`mpbeach_overlays`] = {
			{
				name = "Ship Arms",
				male = `MP_Bea_M_Back_000`,
				female = ``,
				zone = "ZONE_TORSO"
			},
			{
				name = "Tribal Hammerhead",
				male = `MP_Bea_M_Chest_000`,
				female = ``,
				zone = "ZONE_TORSO"
			},
			{
				name = "Tribal Shark",
				male = `MP_Bea_M_Chest_001`,
				female = ``,
				zone = "ZONE_TORSO"
			},
			{
				name = "Pirate Skull",
				male = `MP_Bea_M_Head_000`,
				female = ``,
				zone = "ZONE_HEAD"
			},
			{
				name = "Surf LS",
				male = `MP_Bea_M_Head_001`,
				female = ``,
				zone = "ZONE_HEAD"
			},
			{
				name = "Shark",
				male = `MP_Bea_M_Head_002`,
				female = ``,
				zone = "ZONE_HEAD"
			},
			{
				name = "Tribal Star",
				male = `MP_Bea_M_Lleg_000`,
				female = ``,
				zone = "ZONE_LEFT_LEG"
			},
			{
				name = "Tribal Tiki Tower",
				male = `MP_Bea_M_Rleg_000`,
				female = ``,
				zone = "ZONE_RIGHT_LEG"
			},
			{
				name = "Tribal Sun",
				male = `MP_Bea_M_RArm_000`,
				female = ``,
				zone = "ZONE_RIGHT_ARM"
			},
			{
				name = "Tiki Tower",
				male = `MP_Bea_M_LArm_000`,
				female = ``,
				zone = "ZONE_LEFT_ARM"
			},
			{
				name = "Mermaid L.S.",
				male = `MP_Bea_M_LArm_001`,
				female = ``,
				zone = "ZONE_LEFT_ARM"
			},
			{
				name = "Little Fish",
				male = `MP_Bea_M_Neck_000`,
				female = ``,
				zone = "ZONE_HEAD"
			},
			{
				name = "Surfs Up",
				male = `MP_Bea_M_Neck_001`,
				female = ``,
				zone = "ZONE_HEAD"
			},
			{
				name = "Vespucci Beauty",
				male = `MP_Bea_M_RArm_001`,
				female = ``,
				zone = "ZONE_RIGHT_ARM"
			},
			{
				name = "Swordfish",
				male = `MP_Bea_M_Stom_000`,
				female = ``,
				zone = "ZONE_TORSO"
			},
			{
				name = "Wheel",
				male = `MP_Bea_M_Stom_001`,
				female = ``,
				zone = "ZONE_TORSO"
			},
			{
				name = "Rock Solid",
				male = ``,
				female = `MP_Bea_F_Back_000`,
				zone = "ZONE_TORSO"
			},
			{
				name = "Hibiscus Flower Duo",
				male = ``,
				female = `MP_Bea_F_Back_001`,
				zone = "ZONE_TORSO"
			},
			{
				name = "Shrimp",
				male = ``,
				female = `MP_Bea_F_Back_002`,
				zone = "ZONE_TORSO"
			},
			{
				name = "Anchor",
				male = ``,
				female = `MP_Bea_F_Chest_000`,
				zone = "ZONE_TORSO"
			},
			{
				name = "Anchor",
				male = ``,
				female = `MP_Bea_F_Chest_001`,
				zone = "ZONE_TORSO"
			},
			{
				name = "Los Santos Wreath",
				male = ``,
				female = `MP_Bea_F_Chest_002`,
				zone = "ZONE_TORSO"
			},
			{
				name = "Love Dagger",
				male = ``,
				female = `MP_Bea_F_RSide_000`,
				zone = "ZONE_TORSO"
			},
			{
				name = "School of Fish",
				male = ``,
				female = `MP_Bea_F_RLeg_000`,
				zone = "ZONE_RIGHT_LEG"
			},
			{
				name = "Tribal Fish",
				male = ``,
				female = `MP_Bea_F_RArm_001`,
				zone = "ZONE_RIGHT_ARM"
			},
			{
				name = "Tribal Butterfly",
				male = ``,
				female = `MP_Bea_F_Neck_000`,
				zone = "ZONE_HEAD"
			},
			{
				name = "Sea Horses",
				male = ``,
				female = `MP_Bea_F_Should_000`,
				zone = "ZONE_TORSO"
			},
			{
				name = "Catfish",
				male = ``,
				female = `MP_Bea_F_Should_001`,
				zone = "ZONE_TORSO"
			},
			{
				name = "Swallow",
				male = ``,
				female = `MP_Bea_F_Stom_000`,
				zone = "ZONE_TORSO"
			},
			{
				name = "Hibiscus Flower",
				male = ``,
				female = `MP_Bea_F_Stom_001`,
				zone = "ZONE_TORSO"
			},
			{
				name = "Dolphin",
				male = ``,
				female = `MP_Bea_F_Stom_002`,
				zone = "ZONE_TORSO"
			},
			{
				name = "Tribal Flower",
				male = ``,
				female = `MP_Bea_F_LArm_000`,
				zone = "ZONE_LEFT_ARM"
			},
			{
				name = "Parrot",
				male = ``,
				female = `MP_Bea_F_LArm_001`,
				zone = "ZONE_LEFT_ARM"
			}
		},
		[`mpbiker_overlays`] = {
			{
				name = "Demon Rider",
				male = `MP_MP_Biker_Tat_000_M`,
				female = `MP_MP_Biker_Tat_000_F`,
				zone = "ZONE_TORSO"
			},
			{
				name = "Both Barrels",
				male = `MP_MP_Biker_Tat_001_M`,
				female = `MP_MP_Biker_Tat_001_F`,
				zone = "ZONE_TORSO"
			},
			{
				name = "Rose Tribute",
				male = `MP_MP_Biker_Tat_002_M`,
				female = `MP_MP_Biker_Tat_002_F`,
				zone = "ZONE_LEFT_LEG"
			},
			{
				name = "Web Rider",
				male = `MP_MP_Biker_Tat_003_M`,
				female = `MP_MP_Biker_Tat_003_F`,
				zone = "ZONE_TORSO"
			},
			{
				name = "Dragon's Fury",
				male = `MP_MP_Biker_Tat_004_M`,
				female = `MP_MP_Biker_Tat_004_F`,
				zone = "ZONE_RIGHT_LEG"
			},
			{
				name = "Made In America",
				male = `MP_MP_Biker_Tat_005_M`,
				female = `MP_MP_Biker_Tat_005_F`,
				zone = "ZONE_TORSO"
			},
			{
				name = "Chopper Freedom",
				male = `MP_MP_Biker_Tat_006_M`,
				female = `MP_MP_Biker_Tat_006_F`,
				zone = "ZONE_TORSO"
			},
			{
				name = "Swooping Eagle",
				male = `MP_MP_Biker_Tat_007_M`,
				female = `MP_MP_Biker_Tat_007_F`,
				zone = "ZONE_RIGHT_ARM"
			},
			{
				name = "Freedom Wheels",
				male = `MP_MP_Biker_Tat_008_M`,
				female = `MP_MP_Biker_Tat_008_F`,
				zone = "ZONE_TORSO"
			},
			{
				name = "Morbid Arachnid",
				male = `MP_MP_Biker_Tat_009_M`,
				female = `MP_MP_Biker_Tat_009_F`,
				zone = "ZONE_HEAD"
			},
			{
				name = "Skull Of Taurus",
				male = `MP_MP_Biker_Tat_010_M`,
				female = `MP_MP_Biker_Tat_010_F`,
				zone = "ZONE_TORSO"
			},
			{
				name = "R.I.P. My Brothers",
				male = `MP_MP_Biker_Tat_011_M`,
				female = `MP_MP_Biker_Tat_011_F`,
				zone = "ZONE_TORSO"
			},
			{
				name = "Urban Stunter",
				male = `MP_MP_Biker_Tat_012_M`,
				female = `MP_MP_Biker_Tat_012_F`,
				zone = "ZONE_LEFT_ARM"
			},
			{
				name = "Demon Crossbones",
				male = `MP_MP_Biker_Tat_013_M`,
				female = `MP_MP_Biker_Tat_013_F`,
				zone = "ZONE_TORSO"
			},
			{
				name = "Lady Mortality",
				male = `MP_MP_Biker_Tat_014_M`,
				female = `MP_MP_Biker_Tat_014_F`,
				zone = "ZONE_RIGHT_ARM"
			},
			{
				name = "Ride or Die",
				male = `MP_MP_Biker_Tat_015_M`,
				female = `MP_MP_Biker_Tat_015_F`,
				zone = "ZONE_LEFT_LEG"
			},
			{
				name = "Macabre Tree",
				male = `MP_MP_Biker_Tat_016_M`,
				female = `MP_MP_Biker_Tat_016_F`,
				zone = "ZONE_LEFT_ARM"
			},
			{
				name = "Clawed Beast",
				male = `MP_MP_Biker_Tat_017_M`,
				female = `MP_MP_Biker_Tat_017_F`,
				zone = "ZONE_TORSO"
			},
			{
				name = "Skeletal Chopper",
				male = `MP_MP_Biker_Tat_018_M`,
				female = `MP_MP_Biker_Tat_018_F`,
				zone = "ZONE_TORSO"
			},
			{
				name = "Gruesome Talons",
				male = `MP_MP_Biker_Tat_019_M`,
				female = `MP_MP_Biker_Tat_019_F`,
				zone = "ZONE_TORSO"
			},
			{
				name = "Cranial Rose",
				male = `MP_MP_Biker_Tat_020_M`,
				female = `MP_MP_Biker_Tat_020_F`,
				zone = "ZONE_LEFT_ARM"
			},
			{
				name = "Flaming Reaper",
				male = `MP_MP_Biker_Tat_021_M`,
				female = `MP_MP_Biker_Tat_021_F`,
				zone = "ZONE_TORSO"
			},
			{
				name = "Western Insignia",
				male = `MP_MP_Biker_Tat_022_M`,
				female = `MP_MP_Biker_Tat_022_F`,
				zone = "ZONE_RIGHT_LEG"
			},
			{
				name = "Western MC",
				male = `MP_MP_Biker_Tat_023_M`,
				female = `MP_MP_Biker_Tat_023_F`,
				zone = "ZONE_TORSO"
			},
			{
				name = "Live to Ride",
				male = `MP_MP_Biker_Tat_024_M`,
				female = `MP_MP_Biker_Tat_024_F`,
				zone = "ZONE_LEFT_ARM"
			},
			{
				name = "Good Luck",
				male = `MP_MP_Biker_Tat_025_M`,
				female = `MP_MP_Biker_Tat_025_F`,
				zone = "ZONE_LEFT_ARM"
			},
			{
				name = "American Dream",
				male = `MP_MP_Biker_Tat_026_M`,
				female = `MP_MP_Biker_Tat_026_F`,
				zone = "ZONE_TORSO"
			},
			{
				name = "Bad Luck",
				male = `MP_MP_Biker_Tat_027_M`,
				female = `MP_MP_Biker_Tat_027_F`,
				zone = "ZONE_LEFT_LEG"
			},
			{
				name = "Dusk Rider",
				male = `MP_MP_Biker_Tat_028_M`,
				female = `MP_MP_Biker_Tat_028_F`,
				zone = "ZONE_RIGHT_LEG"
			},
			{
				name = "Bone Wrench",
				male = `MP_MP_Biker_Tat_029_M`,
				female = `MP_MP_Biker_Tat_029_F`,
				zone = "ZONE_TORSO"
			},
			{
				name = "Brothers For Life",
				male = `MP_MP_Biker_Tat_030_M`,
				female = `MP_MP_Biker_Tat_030_F`,
				zone = "ZONE_TORSO"
			},
			{
				name = "Gear Head",
				male = `MP_MP_Biker_Tat_031_M`,
				female = `MP_MP_Biker_Tat_031_F`,
				zone = "ZONE_TORSO"
			},
			{
				name = "Western Eagle",
				male = `MP_MP_Biker_Tat_032_M`,
				female = `MP_MP_Biker_Tat_032_F`,
				zone = "ZONE_TORSO"
			},
			{
				name = "Eagle Emblem",
				male = `MP_MP_Biker_Tat_033_M`,
				female = `MP_MP_Biker_Tat_033_F`,
				zone = "ZONE_RIGHT_ARM"
			},
			{
				name = "Brotherhood of Bikes",
				male = `MP_MP_Biker_Tat_034_M`,
				female = `MP_MP_Biker_Tat_034_F`,
				zone = "ZONE_TORSO"
			},
			{
				name = "Chain Fist",
				male = `MP_MP_Biker_Tat_035_M`,
				female = `MP_MP_Biker_Tat_035_F`,
				zone = "ZONE_LEFT_ARM"
			},
			{
				name = "Engulfed Skull",
				male = `MP_MP_Biker_Tat_036_M`,
				female = `MP_MP_Biker_Tat_036_F`,
				zone = "ZONE_LEFT_LEG"
			},
			{
				name = "Scorched Soul",
				male = `MP_MP_Biker_Tat_037_M`,
				female = `MP_MP_Biker_Tat_037_F`,
				zone = "ZONE_LEFT_LEG"
			},
			{
				name = "FTW",
				male = `MP_MP_Biker_Tat_038_M`,
				female = `MP_MP_Biker_Tat_038_F`,
				zone = "ZONE_HEAD"
			},
			{
				name = "Gas Guzzler",
				male = `MP_MP_Biker_Tat_039_M`,
				female = `MP_MP_Biker_Tat_039_F`,
				zone = "ZONE_TORSO"
			},
			{
				name = "American Made",
				male = `MP_MP_Biker_Tat_040_M`,
				female = `MP_MP_Biker_Tat_040_F`,
				zone = "ZONE_RIGHT_LEG"
			},
			{
				name = "No Regrets",
				male = `MP_MP_Biker_Tat_041_M`,
				female = `MP_MP_Biker_Tat_041_F`,
				zone = "ZONE_TORSO"
			},
			{
				name = "Grim Rider",
				male = `MP_MP_Biker_Tat_042_M`,
				female = `MP_MP_Biker_Tat_042_F`,
				zone = "ZONE_RIGHT_ARM"
			},
			{
				name = "Ride Forever",
				male = `MP_MP_Biker_Tat_043_M`,
				female = `MP_MP_Biker_Tat_043_F`,
				zone = "ZONE_TORSO"
			},
			{
				name = "Ride Free",
				male = `MP_MP_Biker_Tat_044_M`,
				female = `MP_MP_Biker_Tat_044_F`,
				zone = "ZONE_LEFT_LEG"
			},
			{
				name = "Ride Hard Die Fast",
				male = `MP_MP_Biker_Tat_045_M`,
				female = `MP_MP_Biker_Tat_045_F`,
				zone = "ZONE_LEFT_ARM"
			},
			{
				name = "Skull Chain",
				male = `MP_MP_Biker_Tat_046_M`,
				female = `MP_MP_Biker_Tat_046_F`,
				zone = "ZONE_RIGHT_ARM"
			},
			{
				name = "Snake Bike",
				male = `MP_MP_Biker_Tat_047_M`,
				female = `MP_MP_Biker_Tat_047_F`,
				zone = "ZONE_RIGHT_ARM"
			},
			{
				name = "STFU",
				male = `MP_MP_Biker_Tat_048_M`,
				female = `MP_MP_Biker_Tat_048_F`,
				zone = "ZONE_RIGHT_LEG"
			},
			{
				name = "These Colors Don't Run",
				male = `MP_MP_Biker_Tat_049_M`,
				female = `MP_MP_Biker_Tat_049_F`,
				zone = "ZONE_RIGHT_ARM"
			},
			{
				name = "Unforgiven",
				male = `MP_MP_Biker_Tat_050_M`,
				female = `MP_MP_Biker_Tat_050_F`,
				zone = "ZONE_TORSO"
			},
			{
				name = "Western Stylized",
				male = `MP_MP_Biker_Tat_051_M`,
				female = `MP_MP_Biker_Tat_051_F`,
				zone = "ZONE_HEAD"
			},
			{
				name = "Biker Mount",
				male = `MP_MP_Biker_Tat_052_M`,
				female = `MP_MP_Biker_Tat_052_F`,
				zone = "ZONE_TORSO"
			},
			{
				name = "Muffler Helmet",
				male = `MP_MP_Biker_Tat_053_M`,
				female = `MP_MP_Biker_Tat_053_F`,
				zone = "ZONE_LEFT_ARM"
			},
			{
				name = "Mum",
				male = `MP_MP_Biker_Tat_054_M`,
				female = `MP_MP_Biker_Tat_054_F`,
				zone = "ZONE_RIGHT_ARM"
			},
			{
				name = "Poison Scorpion",
				male = `MP_MP_Biker_Tat_055_M`,
				female = `MP_MP_Biker_Tat_055_F`,
				zone = "ZONE_LEFT_ARM"
			},
			{
				name = "Bone Cruiser",
				male = `MP_MP_Biker_Tat_056_M`,
				female = `MP_MP_Biker_Tat_056_F`,
				zone = "ZONE_LEFT_LEG"
			},
			{
				name = "Laughing Skull",
				male = `MP_MP_Biker_Tat_057_M`,
				female = `MP_MP_Biker_Tat_057_F`,
				zone = "ZONE_LEFT_LEG"
			},
			{
				name = "Reaper Vulture",
				male = `MP_MP_Biker_Tat_058_M`,
				female = `MP_MP_Biker_Tat_058_F`,
				zone = "ZONE_TORSO"
			},
			{
				name = "Faggio",
				male = `MP_MP_Biker_Tat_059_M`,
				female = `MP_MP_Biker_Tat_059_F`,
				zone = "ZONE_TORSO"
			},
			{
				name = "We Are The Mods!",
				male = `MP_MP_Biker_Tat_060_M`,
				female = `MP_MP_Biker_Tat_060_F`,
				zone = "ZONE_TORSO"
			}
		},
		[`mpbusiness_overlays`] = {
			{
				name = "Cash is King",
				male = `MP_Buis_M_Neck_000`,
				female = ``,
				zone = "ZONE_HEAD"
			},
			{
				name = "Bold Dollar Sign",
				male = `MP_Buis_M_Neck_001`,
				female = ``,
				zone = "ZONE_HEAD"
			},
			{
				name = "Script Dollar Sign",
				male = `MP_Buis_M_Neck_002`,
				female = ``,
				zone = "ZONE_HEAD"
			},
			{
				name = "$100",
				male = `MP_Buis_M_Neck_003`,
				female = ``,
				zone = "ZONE_HEAD"
			},
			{
				name = "$100 Bill",
				male = `MP_Buis_M_LeftArm_000`,
				female = ``,
				zone = "ZONE_LEFT_ARM"
			},
			{
				name = "All-Seeing Eye",
				male = `MP_Buis_M_LeftArm_001`,
				female = ``,
				zone = "ZONE_LEFT_ARM"
			},
			{
				name = "Dollar Skull",
				male = `MP_Buis_M_RightArm_000`,
				female = ``,
				zone = "ZONE_RIGHT_ARM"
			},
			{
				name = "Green",
				male = `MP_Buis_M_RightArm_001`,
				female = ``,
				zone = "ZONE_RIGHT_ARM"
			},
			{
				name = "Refined Hustler",
				male = `MP_Buis_M_Stomach_000`,
				female = ``,
				zone = "ZONE_TORSO"
			},
			{
				name = "Rich",
				male = `MP_Buis_M_Chest_000`,
				female = ``,
				zone = "ZONE_TORSO"
			},
			{
				name = "$$$",
				male = `MP_Buis_M_Chest_001`,
				female = ``,
				zone = "ZONE_TORSO"
			},
			{
				name = "Makin' Paper",
				male = `MP_Buis_M_Back_000`,
				female = ``,
				zone = "ZONE_TORSO"
			},
			{
				name = "High Roller",
				male = ``,
				female = `MP_Buis_F_Chest_000`,
				zone = "ZONE_TORSO"
			},
			{
				name = "Makin' Money",
				male = ``,
				female = `MP_Buis_F_Chest_001`,
				zone = "ZONE_TORSO"
			},
			{
				name = "Love Money",
				male = ``,
				female = `MP_Buis_F_Chest_002`,
				zone = "ZONE_TORSO"
			},
			{
				name = "Diamond Back",
				male = ``,
				female = `MP_Buis_F_Stom_000`,
				zone = "ZONE_TORSO"
			},
			{
				name = "Santo Capra Logo",
				male = ``,
				female = `MP_Buis_F_Stom_001`,
				zone = "ZONE_TORSO"
			},
			{
				name = "Money Bag",
				male = ``,
				female = `MP_Buis_F_Stom_002`,
				zone = "ZONE_TORSO"
			},
			{
				name = "Respect",
				male = ``,
				female = `MP_Buis_F_Back_000`,
				zone = "ZONE_TORSO"
			},
			{
				name = "Gold Digger",
				male = ``,
				female = `MP_Buis_F_Back_001`,
				zone = "ZONE_TORSO"
			},
			{
				name = "Val-de-Grace Logo",
				male = ``,
				female = `MP_Buis_F_Neck_000`,
				zone = "ZONE_HEAD"
			},
			{
				name = "Money Rose",
				male = ``,
				female = `MP_Buis_F_Neck_001`,
				zone = "ZONE_HEAD"
			},
			{
				name = "Dollar Sign",
				male = ``,
				female = `MP_Buis_F_RArm_000`,
				zone = "ZONE_RIGHT_ARM"
			},
			{
				name = "Greed is Good",
				male = ``,
				female = `MP_Buis_F_LArm_000`,
				zone = "ZONE_LEFT_ARM"
			},
			{
				name = "Single",
				male = ``,
				female = `MP_Buis_F_LLeg_000`,
				zone = "ZONE_LEFT_LEG"
			},
			{
				name = "Diamond Crown",
				male = ``,
				female = `MP_Buis_F_RLeg_000`,
				zone = "ZONE_RIGHT_LEG"
			}
		},
		[`mpchristmas2017_overlays`] = {
			{
				name = "Thor & Goblin",
				male = `MP_Christmas2017_Tattoo_000_M`,
				female = `MP_Christmas2017_Tattoo_000_F`,
				zone = "ZONE_TORSO"
			},
			{
				name = "Viking Warrior",
				male = `MP_Christmas2017_Tattoo_001_M`,
				female = `MP_Christmas2017_Tattoo_001_F`,
				zone = "ZONE_LEFT_ARM"
			},
			{
				name = "Kabuto",
				male = `MP_Christmas2017_Tattoo_002_M`,
				female = `MP_Christmas2017_Tattoo_002_F`,
				zone = "ZONE_TORSO"
			},
			{
				name = "Native Warrior",
				male = `MP_Christmas2017_Tattoo_003_M`,
				female = `MP_Christmas2017_Tattoo_003_F`,
				zone = "ZONE_TORSO"
			},
			{
				name = "Tiger & Mask",
				male = `MP_Christmas2017_Tattoo_004_M`,
				female = `MP_Christmas2017_Tattoo_004_F`,
				zone = "ZONE_LEFT_ARM"
			},
			{
				name = "Ghost Dragon",
				male = `MP_Christmas2017_Tattoo_005_M`,
				female = `MP_Christmas2017_Tattoo_005_F`,
				zone = "ZONE_TORSO"
			},
			{
				name = "Medusa",
				male = `MP_Christmas2017_Tattoo_006_M`,
				female = `MP_Christmas2017_Tattoo_006_F`,
				zone = "ZONE_RIGHT_ARM"
			},
			{
				name = "Spartan Combat",
				male = `MP_Christmas2017_Tattoo_007_M`,
				female = `MP_Christmas2017_Tattoo_007_F`,
				zone = "ZONE_LEFT_ARM"
			},
			{
				name = "Spartan Warrior",
				male = `MP_Christmas2017_Tattoo_008_M`,
				female = `MP_Christmas2017_Tattoo_008_F`,
				zone = "ZONE_TORSO"
			},
			{
				name = "Norse Rune",
				male = `MP_Christmas2017_Tattoo_009_M`,
				female = `MP_Christmas2017_Tattoo_009_F`,
				zone = "ZONE_TORSO"
			},
			{
				name = "Spartan Shield",
				male = `MP_Christmas2017_Tattoo_010_M`,
				female = `MP_Christmas2017_Tattoo_010_F`,
				zone = "ZONE_TORSO"
			},
			{
				name = "Weathered Skull",
				male = `MP_Christmas2017_Tattoo_011_M`,
				female = `MP_Christmas2017_Tattoo_011_F`,
				zone = "ZONE_TORSO"
			},
			{
				name = "Tiger Headdress",
				male = `MP_Christmas2017_Tattoo_012_M`,
				female = `MP_Christmas2017_Tattoo_012_F`,
				zone = "ZONE_RIGHT_ARM"
			},
			{
				name = "Katana",
				male = `MP_Christmas2017_Tattoo_013_M`,
				female = `MP_Christmas2017_Tattoo_013_F`,
				zone = "ZONE_LEFT_ARM"
			},
			{
				name = "Celtic Band",
				male = `MP_Christmas2017_Tattoo_014_M`,
				female = `MP_Christmas2017_Tattoo_014_F`,
				zone = "ZONE_RIGHT_ARM"
			},
			{
				name = "Samurai Combat",
				male = `MP_Christmas2017_Tattoo_015_M`,
				female = `MP_Christmas2017_Tattoo_015_F`,
				zone = "ZONE_TORSO"
			},
			{
				name = "Odin & Raven",
				male = `MP_Christmas2017_Tattoo_016_M`,
				female = `MP_Christmas2017_Tattoo_016_F`,
				zone = "ZONE_TORSO"
			},
			{
				name = "Feather Sleeve",
				male = `MP_Christmas2017_Tattoo_017_M`,
				female = `MP_Christmas2017_Tattoo_017_F`,
				zone = "ZONE_RIGHT_ARM"
			},
			{
				name = "Muscle Tear",
				male = `MP_Christmas2017_Tattoo_018_M`,
				female = `MP_Christmas2017_Tattoo_018_F`,
				zone = "ZONE_RIGHT_ARM"
			},
			{
				name = "Strike Force",
				male = `MP_Christmas2017_Tattoo_019_M`,
				female = `MP_Christmas2017_Tattoo_019_F`,
				zone = "ZONE_TORSO"
			},
			{
				name = "Medusa's Gaze",
				male = `MP_Christmas2017_Tattoo_020_M`,
				female = `MP_Christmas2017_Tattoo_020_F`,
				zone = "ZONE_TORSO"
			},
			{
				name = "Spartan & Lion",
				male = `MP_Christmas2017_Tattoo_021_M`,
				female = `MP_Christmas2017_Tattoo_021_F`,
				zone = "ZONE_TORSO"
			},
			{
				name = "Spartan & Horse",
				male = `MP_Christmas2017_Tattoo_022_M`,
				female = `MP_Christmas2017_Tattoo_022_F`,
				zone = "ZONE_TORSO"
			},
			{
				name = "Samurai Tallship",
				male = `MP_Christmas2017_Tattoo_023_M`,
				female = `MP_Christmas2017_Tattoo_023_F`,
				zone = "ZONE_RIGHT_ARM"
			},
			{
				name = "Dragon Slayer",
				male = `MP_Christmas2017_Tattoo_024_M`,
				female = `MP_Christmas2017_Tattoo_024_F`,
				zone = "ZONE_TORSO"
			},
			{
				name = "Winged Serpent",
				male = `MP_Christmas2017_Tattoo_025_M`,
				female = `MP_Christmas2017_Tattoo_025_F`,
				zone = "ZONE_LEFT_ARM"
			},
			{
				name = "Spartan Skull",
				male = `MP_Christmas2017_Tattoo_026_M`,
				female = `MP_Christmas2017_Tattoo_026_F`,
				zone = "ZONE_TORSO"
			},
			{
				name = "Molon Labe",
				male = `MP_Christmas2017_Tattoo_027_M`,
				female = `MP_Christmas2017_Tattoo_027_F`,
				zone = "ZONE_TORSO"
			},
			{
				name = "Spartan Mural",
				male = `MP_Christmas2017_Tattoo_028_M`,
				female = `MP_Christmas2017_Tattoo_028_F`,
				zone = "ZONE_RIGHT_ARM"
			},
			{
				name = "Cerberus",
				male = `MP_Christmas2017_Tattoo_029_M`,
				female = `MP_Christmas2017_Tattoo_029_F`,
				zone = "ZONE_LEFT_ARM"
			}
		},
		[`mpchristmas2018_overlays`] = {
			{
				name = "???",
				male = `MP_Christmas2018_Tat_000_M`,
				female = `MP_Christmas2018_Tat_000_F`,
				zone = "ZONE_TORSO"
			}
		},
		[`mpchristmas2_overlays`] = {
			{
				name = "Skull Rider",
				male = `MP_Xmas2_M_Tat_000`,
				female = `MP_Xmas2_F_Tat_000`,
				zone = "ZONE_LEFT_ARM"
			},
			{
				name = "Spider Outline",
				male = `MP_Xmas2_M_Tat_001`,
				female = `MP_Xmas2_F_Tat_001`,
				zone = "ZONE_LEFT_LEG"
			},
			{
				name = "Spider Color",
				male = `MP_Xmas2_M_Tat_002`,
				female = `MP_Xmas2_F_Tat_002`,
				zone = "ZONE_LEFT_LEG"
			},
			{
				name = "Snake Outline",
				male = `MP_Xmas2_M_Tat_003`,
				female = `MP_Xmas2_F_Tat_003`,
				zone = "ZONE_RIGHT_ARM"
			},
			{
				name = "Snake Shaded",
				male = `MP_Xmas2_M_Tat_004`,
				female = `MP_Xmas2_F_Tat_004`,
				zone = "ZONE_RIGHT_ARM"
			},
			{
				name = "Carp Outline",
				male = `MP_Xmas2_M_Tat_005`,
				female = `MP_Xmas2_F_Tat_005`,
				zone = "ZONE_TORSO"
			},
			{
				name = "Carp Shaded",
				male = `MP_Xmas2_M_Tat_006`,
				female = `MP_Xmas2_F_Tat_006`,
				zone = "ZONE_TORSO"
			},
			{
				name = "Los Muertos",
				male = `MP_Xmas2_M_Tat_007`,
				female = `MP_Xmas2_F_Tat_007`,
				zone = "ZONE_HEAD"
			},
			{
				name = "Death Before Dishonor",
				male = `MP_Xmas2_M_Tat_008`,
				female = `MP_Xmas2_F_Tat_008`,
				zone = "ZONE_RIGHT_ARM"
			},
			{
				name = "Time To Die",
				male = `MP_Xmas2_M_Tat_009`,
				female = `MP_Xmas2_F_Tat_009`,
				zone = "ZONE_TORSO"
			},
			{
				name = "Electric Snake",
				male = `MP_Xmas2_M_Tat_010`,
				female = `MP_Xmas2_F_Tat_010`,
				zone = "ZONE_LEFT_ARM"
			},
			{
				name = "Roaring Tiger",
				male = `MP_Xmas2_M_Tat_011`,
				female = `MP_Xmas2_F_Tat_011`,
				zone = "ZONE_TORSO"
			},
			{
				name = "8 Ball Skull",
				male = `MP_Xmas2_M_Tat_012`,
				female = `MP_Xmas2_F_Tat_012`,
				zone = "ZONE_LEFT_ARM"
			},
			{
				name = "Lizard",
				male = `MP_Xmas2_M_Tat_013`,
				female = `MP_Xmas2_F_Tat_013`,
				zone = "ZONE_TORSO"
			},
			{
				name = "Floral Dagger",
				male = `MP_Xmas2_M_Tat_014`,
				female = `MP_Xmas2_F_Tat_014`,
				zone = "ZONE_RIGHT_LEG"
			},
			{
				name = "Japanese Warrior",
				male = `MP_Xmas2_M_Tat_015`,
				female = `MP_Xmas2_F_Tat_015`,
				zone = "ZONE_TORSO"
			},
			{
				name = "Loose Lips Outline",
				male = `MP_Xmas2_M_Tat_016`,
				female = `MP_Xmas2_F_Tat_016`,
				zone = "ZONE_TORSO"
			},
			{
				name = "Loose Lips Color",
				male = `MP_Xmas2_M_Tat_017`,
				female = `MP_Xmas2_F_Tat_017`,
				zone = "ZONE_TORSO"
			},
			{
				name = "Royal Dagger Outline",
				male = `MP_Xmas2_M_Tat_018`,
				female = `MP_Xmas2_F_Tat_018`,
				zone = "ZONE_TORSO"
			},
			{
				name = "Royal Dagger Color",
				male = `MP_Xmas2_M_Tat_019`,
				female = `MP_Xmas2_F_Tat_019`,
				zone = "ZONE_TORSO"
			},
			{
				name = "Time's Up Outline",
				male = `MP_Xmas2_M_Tat_020`,
				female = `MP_Xmas2_F_Tat_020`,
				zone = "ZONE_LEFT_ARM"
			},
			{
				name = "Time's Up Color",
				male = `MP_Xmas2_M_Tat_021`,
				female = `MP_Xmas2_F_Tat_021`,
				zone = "ZONE_LEFT_ARM"
			},
			{
				name = "You're Next Outline",
				male = `MP_Xmas2_M_Tat_022`,
				female = `MP_Xmas2_F_Tat_022`,
				zone = "ZONE_RIGHT_ARM"
			},
			{
				name = "You're Next Color",
				male = `MP_Xmas2_M_Tat_023`,
				female = `MP_Xmas2_F_Tat_023`,
				zone = "ZONE_RIGHT_ARM"
			},
			{
				name = "Snake Head Outline",
				male = `MP_Xmas2_M_Tat_024`,
				female = `MP_Xmas2_F_Tat_024`,
				zone = "ZONE_HEAD"
			},
			{
				name = "Snake Head Color",
				male = `MP_Xmas2_M_Tat_025`,
				female = `MP_Xmas2_F_Tat_025`,
				zone = "ZONE_HEAD"
			},
			{
				name = "Fuck Luck Outline",
				male = `MP_Xmas2_M_Tat_026`,
				female = `MP_Xmas2_F_Tat_026`,
				zone = "ZONE_RIGHT_ARM"
			},
			{
				name = "Fuck Luck Color",
				male = `MP_Xmas2_M_Tat_027`,
				female = `MP_Xmas2_F_Tat_027`,
				zone = "ZONE_RIGHT_ARM"
			},
			{
				name = "Executioner",
				male = `MP_Xmas2_M_Tat_028`,
				female = `MP_Xmas2_F_Tat_028`,
				zone = "ZONE_TORSO"
			},
			{
				name = "Beautiful Death",
				male = `MP_Xmas2_M_Tat_029`,
				female = `MP_Xmas2_F_Tat_029`,
				zone = "ZONE_HEAD"
			}
		},
		[`mpgunrunning_overlays`] = {
			{
				name = "Bullet Proof",
				male = `MP_Gunrunning_Tattoo_000_M`,
				female = `MP_Gunrunning_Tattoo_000_F`,
				zone = "ZONE_TORSO"
			},
			{
				name = "Crossed Weapons",
				male = `MP_Gunrunning_Tattoo_001_M`,
				female = `MP_Gunrunning_Tattoo_001_F`,
				zone = "ZONE_TORSO"
			},
			{
				name = "Grenade",
				male = `MP_Gunrunning_Tattoo_002_M`,
				female = `MP_Gunrunning_Tattoo_002_F`,
				zone = "ZONE_RIGHT_ARM"
			},
			{
				name = "Lock & Load",
				male = `MP_Gunrunning_Tattoo_003_M`,
				female = `MP_Gunrunning_Tattoo_003_F`,
				zone = "ZONE_HEAD"
			},
			{
				name = "Sidearm",
				male = `MP_Gunrunning_Tattoo_004_M`,
				female = `MP_Gunrunning_Tattoo_004_F`,
				zone = "ZONE_LEFT_ARM"
			},
			{
				name = "Patriot Skull",
				male = `MP_Gunrunning_Tattoo_005_M`,
				female = `MP_Gunrunning_Tattoo_005_F`,
				zone = "ZONE_LEFT_LEG"
			},
			{
				name = "Combat Skull",
				male = `MP_Gunrunning_Tattoo_006_M`,
				female = `MP_Gunrunning_Tattoo_006_F`,
				zone = "ZONE_RIGHT_LEG"
			},
			{
				name = "Stylized Tiger",
				male = `MP_Gunrunning_Tattoo_007_M`,
				female = `MP_Gunrunning_Tattoo_007_F`,
				zone = "ZONE_LEFT_LEG"
			},
			{
				name = "Bandolier",
				male = `MP_Gunrunning_Tattoo_008_M`,
				female = `MP_Gunrunning_Tattoo_008_F`,
				zone = "ZONE_LEFT_ARM"
			},
			{
				name = "Butterfly Knife",
				male = `MP_Gunrunning_Tattoo_009_M`,
				female = `MP_Gunrunning_Tattoo_009_F`,
				zone = "ZONE_TORSO"
			},
			{
				name = "Cash Money",
				male = `MP_Gunrunning_Tattoo_010_M`,
				female = `MP_Gunrunning_Tattoo_010_F`,
				zone = "ZONE_TORSO"
			},
			{
				name = "Death Skull",
				male = `MP_Gunrunning_Tattoo_011_M`,
				female = `MP_Gunrunning_Tattoo_011_F`,
				zone = "ZONE_LEFT_LEG"
			},
			{
				name = "Dollar Daggers",
				male = `MP_Gunrunning_Tattoo_012_M`,
				female = `MP_Gunrunning_Tattoo_012_F`,
				zone = "ZONE_TORSO"
			},
			{
				name = "Wolf Insignia",
				male = `MP_Gunrunning_Tattoo_013_M`,
				female = `MP_Gunrunning_Tattoo_013_F`,
				zone = "ZONE_TORSO"
			},
			{
				name = "Backstabber",
				male = `MP_Gunrunning_Tattoo_014_M`,
				female = `MP_Gunrunning_Tattoo_014_F`,
				zone = "ZONE_TORSO"
			},
			{
				name = "Spiked Skull",
				male = `MP_Gunrunning_Tattoo_015_M`,
				female = `MP_Gunrunning_Tattoo_015_F`,
				zone = "ZONE_LEFT_ARM"
			},
			{
				name = "Blood Money",
				male = `MP_Gunrunning_Tattoo_016_M`,
				female = `MP_Gunrunning_Tattoo_016_F`,
				zone = "ZONE_LEFT_ARM"
			},
			{
				name = "Dog Tags",
				male = `MP_Gunrunning_Tattoo_017_M`,
				female = `MP_Gunrunning_Tattoo_017_F`,
				zone = "ZONE_TORSO"
			},
			{
				name = "Dual Wield Skull",
				male = `MP_Gunrunning_Tattoo_018_M`,
				female = `MP_Gunrunning_Tattoo_018_F`,
				zone = "ZONE_TORSO"
			},
			{
				name = "Pistol Wings",
				male = `MP_Gunrunning_Tattoo_019_M`,
				female = `MP_Gunrunning_Tattoo_019_F`,
				zone = "ZONE_TORSO"
			},
			{
				name = "Crowned Weapons",
				male = `MP_Gunrunning_Tattoo_020_M`,
				female = `MP_Gunrunning_Tattoo_020_F`,
				zone = "ZONE_TORSO"
			},
			{
				name = "Have a Nice Day",
				male = `MP_Gunrunning_Tattoo_021_M`,
				female = `MP_Gunrunning_Tattoo_021_F`,
				zone = "ZONE_RIGHT_ARM"
			},
			{
				name = "Explosive Heart",
				male = `MP_Gunrunning_Tattoo_022_M`,
				female = `MP_Gunrunning_Tattoo_022_F`,
				zone = "ZONE_TORSO"
			},
			{
				name = "Rose Revolver",
				male = `MP_Gunrunning_Tattoo_023_M`,
				female = `MP_Gunrunning_Tattoo_023_F`,
				zone = "ZONE_LEFT_LEG"
			},
			{
				name = "Combat Reaper",
				male = `MP_Gunrunning_Tattoo_024_M`,
				female = `MP_Gunrunning_Tattoo_024_F`,
				zone = "ZONE_RIGHT_ARM"
			},
			{
				name = "Praying Skull",
				male = `MP_Gunrunning_Tattoo_025_M`,
				female = `MP_Gunrunning_Tattoo_025_F`,
				zone = "ZONE_LEFT_ARM"
			},
			{
				name = "Restless Skull",
				male = `MP_Gunrunning_Tattoo_026_M`,
				female = `MP_Gunrunning_Tattoo_026_F`,
				zone = "ZONE_RIGHT_LEG"
			},
			{
				name = "Serpent Revolver",
				male = `MP_Gunrunning_Tattoo_027_M`,
				female = `MP_Gunrunning_Tattoo_027_F`,
				zone = "ZONE_LEFT_ARM"
			},
			{
				name = "Micro SMG Chain",
				male = `MP_Gunrunning_Tattoo_028_M`,
				female = `MP_Gunrunning_Tattoo_028_F`,
				zone = "ZONE_TORSO"
			},
			{
				name = "Win Some Lose Some",
				male = `MP_Gunrunning_Tattoo_029_M`,
				female = `MP_Gunrunning_Tattoo_029_F`,
				zone = "ZONE_TORSO"
			},
			{
				name = "Pistol Ace",
				male = `MP_Gunrunning_Tattoo_030_M`,
				female = `MP_Gunrunning_Tattoo_030_F`,
				zone = "ZONE_RIGHT_LEG"
			}
		},
		[`mpheist3_overlays`] = {
			{
				name = "Five Stars",
				male = `mpHeist3_Tat_000_M`,
				female = `mpHeist3_Tat_000_F`,
				zone = "ZONE_HEAD"
			},
			{
				name = "Ace of Spades",
				male = `mpHeist3_Tat_001_M`,
				female = `mpHeist3_Tat_001_F`,
				zone = "ZONE_HEAD"
			},
			{
				name = "Animal",
				male = `mpHeist3_Tat_002_M`,
				female = `mpHeist3_Tat_002_F`,
				zone = "ZONE_HEAD"
			},
			{
				name = "Assault Rifle",
				male = `mpHeist3_Tat_003_M`,
				female = `mpHeist3_Tat_003_F`,
				zone = "ZONE_HEAD"
			},
			{
				name = "Bandage",
				male = `mpHeist3_Tat_004_M`,
				female = `mpHeist3_Tat_004_F`,
				zone = "ZONE_HEAD"
			},
			{
				name = "Spades",
				male = `mpHeist3_Tat_005_M`,
				female = `mpHeist3_Tat_005_F`,
				zone = "ZONE_HEAD"
			},
			{
				name = "Crowned",
				male = `mpHeist3_Tat_006_M`,
				female = `mpHeist3_Tat_006_F`,
				zone = "ZONE_HEAD"
			},
			{
				name = "Two Horns",
				male = `mpHeist3_Tat_007_M`,
				female = `mpHeist3_Tat_007_F`,
				zone = "ZONE_HEAD"
			},
			{
				name = "Ice Cream",
				male = `mpHeist3_Tat_008_M`,
				female = `mpHeist3_Tat_008_F`,
				zone = "ZONE_HEAD"
			},
			{
				name = "Knifed",
				male = `mpHeist3_Tat_009_M`,
				female = `mpHeist3_Tat_009_F`,
				zone = "ZONE_HEAD"
			},
			{
				name = "Green Leaf",
				male = `mpHeist3_Tat_010_M`,
				female = `mpHeist3_Tat_010_F`,
				zone = "ZONE_HEAD"
			},
			{
				name = "Lipstick Kiss",
				male = `mpHeist3_Tat_011_M`,
				female = `mpHeist3_Tat_011_F`,
				zone = "ZONE_HEAD"
			},
			{
				name = "Razor Pop",
				male = `mpHeist3_Tat_012_M`,
				female = `mpHeist3_Tat_012_F`,
				zone = "ZONE_HEAD"
			},
			{
				name = "LS Star",
				male = `mpHeist3_Tat_013_M`,
				female = `mpHeist3_Tat_013_F`,
				zone = "ZONE_HEAD"
			},
			{
				name = "LS Wings",
				male = `mpHeist3_Tat_014_M`,
				female = `mpHeist3_Tat_014_F`,
				zone = "ZONE_HEAD"
			},
			{
				name = "On/Off",
				male = `mpHeist3_Tat_015_M`,
				female = `mpHeist3_Tat_015_F`,
				zone = "ZONE_HEAD"
			},
			{
				name = "Sleepy",
				male = `mpHeist3_Tat_016_M`,
				female = `mpHeist3_Tat_016_F`,
				zone = "ZONE_HEAD"
			},
			{
				name = "Space Monkey",
				male = `mpHeist3_Tat_017_M`,
				female = `mpHeist3_Tat_017_F`,
				zone = "ZONE_HEAD"
			},
			{
				name = "Stitches",
				male = `mpHeist3_Tat_018_M`,
				female = `mpHeist3_Tat_018_F`,
				zone = "ZONE_HEAD"
			},
			{
				name = "Teddy Bear",
				male = `mpHeist3_Tat_019_M`,
				female = `mpHeist3_Tat_019_F`,
				zone = "ZONE_HEAD"
			},
			{
				name = "UFO",
				male = `mpHeist3_Tat_020_M`,
				female = `mpHeist3_Tat_020_F`,
				zone = "ZONE_HEAD"
			},
			{
				name = "Wanted",
				male = `mpHeist3_Tat_021_M`,
				female = `mpHeist3_Tat_021_F`,
				zone = "ZONE_HEAD"
			},
			{
				name = "Thog's Sword",
				male = `mpHeist3_Tat_022_M`,
				female = `mpHeist3_Tat_022_F`,
				zone = "ZONE_HEAD"
			},
			{
				name = "Bigfoot",
				male = `mpHeist3_Tat_023_M`,
				female = `mpHeist3_Tat_023_F`,
				zone = "ZONE_TORSO"
			},
			{
				name = "Mount Chiliad",
				male = `mpHeist3_Tat_024_M`,
				female = `mpHeist3_Tat_024_F`,
				zone = "ZONE_TORSO"
			},
			{
				name = "Davis",
				male = `mpHeist3_Tat_025_M`,
				female = `mpHeist3_Tat_025_F`,
				zone = "ZONE_TORSO"
			},
			{
				name = "Dignity",
				male = `mpHeist3_Tat_026_M`,
				female = `mpHeist3_Tat_026_F`,
				zone = "ZONE_TORSO"
			},
			{
				name = "Epsilon",
				male = `mpHeist3_Tat_027_M`,
				female = `mpHeist3_Tat_027_F`,
				zone = "ZONE_TORSO"
			},
			{
				name = "Bananas Gone Bad",
				male = `mpHeist3_Tat_028_M`,
				female = `mpHeist3_Tat_028_F`,
				zone = "ZONE_TORSO"
			},
			{
				name = "Fatal Incursion",
				male = `mpHeist3_Tat_029_M`,
				female = `mpHeist3_Tat_029_F`,
				zone = "ZONE_TORSO"
			},
			{
				name = "Howitzer",
				male = `mpHeist3_Tat_030_M`,
				female = `mpHeist3_Tat_030_F`,
				zone = "ZONE_TORSO"
			},
			{
				name = "Kifflom",
				male = `mpHeist3_Tat_031_M`,
				female = `mpHeist3_Tat_031_F`,
				zone = "ZONE_RIGHT_LEG"
			},
			{
				name = "Love Fist",
				male = `mpHeist3_Tat_032_M`,
				female = `mpHeist3_Tat_032_F`,
				zone = "ZONE_LEFT_LEG"
			},
			{
				name = "LS City",
				male = `mpHeist3_Tat_033_M`,
				female = `mpHeist3_Tat_033_F`,
				zone = "ZONE_TORSO"
			},
			{
				name = "LS Monogram",
				male = `mpHeist3_Tat_034_M`,
				female = `mpHeist3_Tat_034_F`,
				zone = "ZONE_RIGHT_ARM"
			},
			{
				name = "LS Panic",
				male = `mpHeist3_Tat_035_M`,
				female = `mpHeist3_Tat_035_F`,
				zone = "ZONE_TORSO"
			},
			{
				name = "LS Shield",
				male = `mpHeist3_Tat_036_M`,
				female = `mpHeist3_Tat_036_F`,
				zone = "ZONE_TORSO"
			},
			{
				name = "Ladybug",
				male = `mpHeist3_Tat_037_M`,
				female = `mpHeist3_Tat_037_F`,
				zone = "ZONE_TORSO"
			},
			{
				name = "Robot Bubblegum",
				male = `mpHeist3_Tat_038_M`,
				female = `mpHeist3_Tat_038_F`,
				zone = "ZONE_TORSO"
			},
			{
				name = "Space Rangers",
				male = `mpHeist3_Tat_039_M`,
				female = `mpHeist3_Tat_039_F`,
				zone = "ZONE_TORSO"
			},
			{
				name = "Tiger Heart",
				male = `mpHeist3_Tat_040_M`,
				female = `mpHeist3_Tat_040_F`,
				zone = "ZONE_LEFT_ARM"
			},
			{
				name = "Mighty Thog",
				male = `mpHeist3_Tat_041_M`,
				female = `mpHeist3_Tat_041_F`,
				zone = "ZONE_LEFT_ARM"
			},
			{
				name = "Hearts",
				male = `mpHeist3_Tat_042_M`,
				female = `mpHeist3_Tat_042_F`,
				zone = "ZONE_HEAD"
			},
			{
				name = "Diamonds",
				male = `mpHeist3_Tat_043_M`,
				female = `mpHeist3_Tat_043_F`,
				zone = "ZONE_HEAD"
			},
			{
				name = "Clubs",
				male = `mpHeist3_Tat_044_M`,
				female = `mpHeist3_Tat_044_F`,
				zone = "ZONE_HEAD"
			}
		},
		[`mphipster_overlays`] = {
			{
				name = "Crossed Arrows",
				male = `FM_Hip_M_Tat_000`,
				female = `FM_Hip_F_Tat_000`,
				zone = "ZONE_TORSO"
			},
			{
				name = "Single Arrow",
				male = `FM_Hip_M_Tat_001`,
				female = `FM_Hip_F_Tat_001`,
				zone = "ZONE_RIGHT_ARM"
			},
			{
				name = "Chemistry",
				male = `FM_Hip_M_Tat_002`,
				female = `FM_Hip_F_Tat_002`,
				zone = "ZONE_TORSO"
			},
			{
				name = "Diamond Sparkle",
				male = `FM_Hip_M_Tat_003`,
				female = `FM_Hip_F_Tat_003`,
				zone = "ZONE_LEFT_ARM"
			},
			{
				name = "Bone",
				male = `FM_Hip_M_Tat_004`,
				female = `FM_Hip_F_Tat_004`,
				zone = "ZONE_RIGHT_ARM"
			},
			{
				name = "Beautiful Eye",
				male = `FM_Hip_M_Tat_005`,
				female = `FM_Hip_F_Tat_005`,
				zone = "ZONE_HEAD"
			},
			{
				name = "Feather Birds",
				male = `FM_Hip_M_Tat_006`,
				female = `FM_Hip_F_Tat_006`,
				zone = "ZONE_TORSO"
			},
			{
				name = "Bricks",
				male = `FM_Hip_M_Tat_007`,
				female = `FM_Hip_F_Tat_007`,
				zone = "ZONE_LEFT_ARM"
			},
			{
				name = "Cube",
				male = `FM_Hip_M_Tat_008`,
				female = `FM_Hip_F_Tat_008`,
				zone = "ZONE_RIGHT_ARM"
			},
			{
				name = "Squares",
				male = `FM_Hip_M_Tat_009`,
				female = `FM_Hip_F_Tat_009`,
				zone = "ZONE_LEFT_LEG"
			},
			{
				name = "Horseshoe",
				male = `FM_Hip_M_Tat_010`,
				female = `FM_Hip_F_Tat_010`,
				zone = "ZONE_RIGHT_ARM"
			},
			{
				name = "Infinity",
				male = `FM_Hip_M_Tat_011`,
				female = `FM_Hip_F_Tat_011`,
				zone = "ZONE_TORSO"
			},
			{
				name = "Antlers",
				male = `FM_Hip_M_Tat_012`,
				female = `FM_Hip_F_Tat_012`,
				zone = "ZONE_TORSO"
			},
			{
				name = "Boombox",
				male = `FM_Hip_M_Tat_013`,
				female = `FM_Hip_F_Tat_013`,
				zone = "ZONE_TORSO"
			},
			{
				name = "Spray Can",
				male = `FM_Hip_M_Tat_014`,
				female = `FM_Hip_F_Tat_014`,
				zone = "ZONE_RIGHT_ARM"
			},
			{
				name = "Mustache",
				male = `FM_Hip_M_Tat_015`,
				female = `FM_Hip_F_Tat_015`,
				zone = "ZONE_LEFT_ARM"
			},
			{
				name = "Lightning Bolt",
				male = `FM_Hip_M_Tat_016`,
				female = `FM_Hip_F_Tat_016`,
				zone = "ZONE_LEFT_ARM"
			},
			{
				name = "Eye Triangle",
				male = `FM_Hip_M_Tat_017`,
				female = `FM_Hip_F_Tat_017`,
				zone = "ZONE_RIGHT_ARM"
			},
			{
				name = "Origami",
				male = `FM_Hip_M_Tat_018`,
				female = `FM_Hip_F_Tat_018`,
				zone = "ZONE_RIGHT_ARM"
			},
			{
				name = "Charm",
				male = `FM_Hip_M_Tat_019`,
				female = `FM_Hip_F_Tat_019`,
				zone = "ZONE_LEFT_LEG"
			},
			{
				name = "Geo Pattern",
				male = `FM_Hip_M_Tat_020`,
				female = `FM_Hip_F_Tat_020`,
				zone = "ZONE_RIGHT_ARM"
			},
			{
				name = "Geo Fox",
				male = `FM_Hip_M_Tat_021`,
				female = `FM_Hip_F_Tat_021`,
				zone = "ZONE_HEAD"
			},
			{
				name = "Pencil",
				male = `FM_Hip_M_Tat_022`,
				female = `FM_Hip_F_Tat_022`,
				zone = "ZONE_RIGHT_ARM"
			},
			{
				name = "Smiley",
				male = `FM_Hip_M_Tat_023`,
				female = `FM_Hip_F_Tat_023`,
				zone = "ZONE_RIGHT_ARM"
			},
			{
				name = "Pyramid",
				male = `FM_Hip_M_Tat_024`,
				female = `FM_Hip_F_Tat_024`,
				zone = "ZONE_TORSO"
			},
			{
				name = "Watch Your Step",
				male = `FM_Hip_M_Tat_025`,
				female = `FM_Hip_F_Tat_025`,
				zone = "ZONE_TORSO"
			},
			{
				name = "Pizza",
				male = `FM_Hip_M_Tat_026`,
				female = `FM_Hip_F_Tat_026`,
				zone = "ZONE_LEFT_ARM"
			},
			{
				name = "Padlock",
				male = `FM_Hip_M_Tat_027`,
				female = `FM_Hip_F_Tat_027`,
				zone = "ZONE_LEFT_ARM"
			},
			{
				name = "Thorny Rose",
				male = `FM_Hip_M_Tat_028`,
				female = `FM_Hip_F_Tat_028`,
				zone = "ZONE_LEFT_ARM"
			},
			{
				name = "Sad",
				male = `FM_Hip_M_Tat_029`,
				female = `FM_Hip_F_Tat_029`,
				zone = "ZONE_TORSO"
			},
			{
				name = "Shark Fin",
				male = `FM_Hip_M_Tat_030`,
				female = `FM_Hip_F_Tat_030`,
				zone = "ZONE_TORSO"
			},
			{
				name = "Skateboard",
				male = `FM_Hip_M_Tat_031`,
				female = `FM_Hip_F_Tat_031`,
				zone = "ZONE_TORSO"
			},
			{
				name = "Paper Plane",
				male = `FM_Hip_M_Tat_032`,
				female = `FM_Hip_F_Tat_032`,
				zone = "ZONE_TORSO"
			},
			{
				name = "Stag",
				male = `FM_Hip_M_Tat_033`,
				female = `FM_Hip_F_Tat_033`,
				zone = "ZONE_TORSO"
			},
			{
				name = "Stop",
				male = `FM_Hip_M_Tat_034`,
				female = `FM_Hip_F_Tat_034`,
				zone = "ZONE_LEFT_ARM"
			},
			{
				name = "Sewn Heart",
				male = `FM_Hip_M_Tat_035`,
				female = `FM_Hip_F_Tat_035`,
				zone = "ZONE_TORSO"
			},
			{
				name = "Shapes",
				male = `FM_Hip_M_Tat_036`,
				female = `FM_Hip_F_Tat_036`,
				zone = "ZONE_RIGHT_ARM"
			},
			{
				name = "Sunrise",
				male = `FM_Hip_M_Tat_037`,
				female = `FM_Hip_F_Tat_037`,
				zone = "ZONE_LEFT_ARM"
			},
			{
				name = "Grub",
				male = `FM_Hip_M_Tat_038`,
				female = `FM_Hip_F_Tat_038`,
				zone = "ZONE_RIGHT_LEG"
			},
			{
				name = "Sleeve",
				male = `FM_Hip_M_Tat_039`,
				female = `FM_Hip_F_Tat_039`,
				zone = "ZONE_LEFT_ARM"
			},
			{
				name = "Black Anchor",
				male = `FM_Hip_M_Tat_040`,
				female = `FM_Hip_F_Tat_040`,
				zone = "ZONE_LEFT_LEG"
			},
			{
				name = "Tooth",
				male = `FM_Hip_M_Tat_041`,
				female = `FM_Hip_F_Tat_041`,
				zone = "ZONE_TORSO"
			},
			{
				name = "Sparkplug",
				male = `FM_Hip_M_Tat_042`,
				female = `FM_Hip_F_Tat_042`,
				zone = "ZONE_RIGHT_LEG"
			},
			{
				name = "Triangle White",
				male = `FM_Hip_M_Tat_043`,
				female = `FM_Hip_F_Tat_043`,
				zone = "ZONE_LEFT_ARM"
			},
			{
				name = "Triangle Black",
				male = `FM_Hip_M_Tat_044`,
				female = `FM_Hip_F_Tat_044`,
				zone = "ZONE_RIGHT_ARM"
			},
			{
				name = "Mesh Band",
				male = `FM_Hip_M_Tat_045`,
				female = `FM_Hip_F_Tat_045`,
				zone = "ZONE_RIGHT_ARM"
			},
			{
				name = "Triangles",
				male = `FM_Hip_M_Tat_046`,
				female = `FM_Hip_F_Tat_046`,
				zone = "ZONE_TORSO"
			},
			{
				name = "Cassette",
				male = `FM_Hip_M_Tat_047`,
				female = `FM_Hip_F_Tat_047`,
				zone = "ZONE_TORSO"
			},
			{
				name = "Peace",
				male = `FM_Hip_M_Tat_048`,
				female = `FM_Hip_F_Tat_048`,
				zone = "ZONE_LEFT_ARM"
			}
		},
		[`mpimportexport_overlays`] = {
			{
				name = "Block Back",
				male = `MP_MP_ImportExport_Tat_000_M`,
				female = `MP_MP_ImportExport_Tat_000_F`,
				zone = "ZONE_TORSO"
			},
			{
				name = "Power Plant",
				male = `MP_MP_ImportExport_Tat_001_M`,
				female = `MP_MP_ImportExport_Tat_001_F`,
				zone = "ZONE_TORSO"
			},
			{
				name = "Tuned to Death",
				male = `MP_MP_ImportExport_Tat_002_M`,
				female = `MP_MP_ImportExport_Tat_002_F`,
				zone = "ZONE_TORSO"
			},
			{
				name = "Mechanical Sleeve",
				male = `MP_MP_ImportExport_Tat_003_M`,
				female = `MP_MP_ImportExport_Tat_003_F`,
				zone = "ZONE_RIGHT_ARM"
			},
			{
				name = "Piston Sleeve",
				male = `MP_MP_ImportExport_Tat_004_M`,
				female = `MP_MP_ImportExport_Tat_004_F`,
				zone = "ZONE_LEFT_ARM"
			},
			{
				name = "Dialed In",
				male = `MP_MP_ImportExport_Tat_005_M`,
				female = `MP_MP_ImportExport_Tat_005_F`,
				zone = "ZONE_RIGHT_ARM"
			},
			{
				name = "Engulfed Block",
				male = `MP_MP_ImportExport_Tat_006_M`,
				female = `MP_MP_ImportExport_Tat_006_F`,
				zone = "ZONE_RIGHT_ARM"
			},
			{
				name = "Drive Forever",
				male = `MP_MP_ImportExport_Tat_007_M`,
				female = `MP_MP_ImportExport_Tat_007_F`,
				zone = "ZONE_RIGHT_ARM"
			},
			{
				name = "Scarlett",
				male = `MP_MP_ImportExport_Tat_008_M`,
				female = `MP_MP_ImportExport_Tat_008_F`,
				zone = "ZONE_LEFT_ARM"
			},
			{
				name = "Serpents of Destruction",
				male = `MP_MP_ImportExport_Tat_009_M`,
				female = `MP_MP_ImportExport_Tat_009_F`,
				zone = "ZONE_TORSO"
			},
			{
				name = "Take the Wheel",
				male = `MP_MP_ImportExport_Tat_010_M`,
				female = `MP_MP_ImportExport_Tat_010_F`,
				zone = "ZONE_TORSO"
			},
			{
				name = "Talk Shit Get Hit",
				male = `MP_MP_ImportExport_Tat_011_M`,
				female = `MP_MP_ImportExport_Tat_011_F`,
				zone = "ZONE_TORSO"
			}
		},
		[`mplowrider2_overlays`] = {
			{
				name = "SA Assault",
				male = `MP_LR_Tat_000_M`,
				female = `MP_LR_Tat_000_F`,
				zone = "ZONE_TORSO"
			},
			{
				name = "Lady Vamp",
				male = `MP_LR_Tat_003_M`,
				female = `MP_LR_Tat_003_F`,
				zone = "ZONE_RIGHT_ARM"
			},
			{
				name = "Love Hustle",
				male = `MP_LR_Tat_006_M`,
				female = `MP_LR_Tat_006_F`,
				zone = "ZONE_LEFT_ARM"
			},
			{
				name = "Love the Game",
				male = `MP_LR_Tat_008_M`,
				female = `MP_LR_Tat_008_F`,
				zone = "ZONE_TORSO"
			},
			{
				name = "Lady Liberty",
				male = `MP_LR_Tat_011_M`,
				female = `MP_LR_Tat_011_F`,
				zone = "ZONE_TORSO"
			},
			{
				name = "Royal Kiss",
				male = `MP_LR_Tat_012_M`,
				female = `MP_LR_Tat_012_F`,
				zone = "ZONE_TORSO"
			},
			{
				name = "Two Face",
				male = `MP_LR_Tat_016_M`,
				female = `MP_LR_Tat_016_F`,
				zone = "ZONE_TORSO"
			},
			{
				name = "Skeleton Party",
				male = `MP_LR_Tat_018_M`,
				female = `MP_LR_Tat_018_F`,
				zone = "ZONE_LEFT_ARM"
			},
			{
				name = "Death Behind",
				male = `MP_LR_Tat_019_M`,
				female = `MP_LR_Tat_019_F`,
				zone = "ZONE_TORSO"
			},
			{
				name = "My Crazy Life",
				male = `MP_LR_Tat_022_M`,
				female = `MP_LR_Tat_022_F`,
				zone = "ZONE_LEFT_ARM"
			},
			{
				name = "Loving Los Muertos",
				male = `MP_LR_Tat_028_M`,
				female = `MP_LR_Tat_028_F`,
				zone = "ZONE_RIGHT_ARM"
			},
			{
				name = "Death Us Do Part",
				male = `MP_LR_Tat_029_M`,
				female = `MP_LR_Tat_029_F`,
				zone = "ZONE_LEFT_LEG"
			},
			{
				name = "San Andreas Prayer",
				male = `MP_LR_Tat_030_M`,
				female = `MP_LR_Tat_030_F`,
				zone = "ZONE_RIGHT_LEG"
			},
			{
				name = "Dead Pretty",
				male = `MP_LR_Tat_031_M`,
				female = `MP_LR_Tat_031_F`,
				zone = "ZONE_TORSO"
			},
			{
				name = "Reign Over",
				male = `MP_LR_Tat_032_M`,
				female = `MP_LR_Tat_032_F`,
				zone = "ZONE_TORSO"
			},
			{
				name = "Black Tears",
				male = `MP_LR_Tat_035_M`,
				female = `MP_LR_Tat_035_F`,
				zone = "ZONE_RIGHT_ARM"
			}
		},
		[`mplowrider_overlays`] = {
			{
				name = "King Fight",
				male = `MP_LR_Tat_001_M`,
				female = `MP_LR_Tat_001_F`,
				zone = "ZONE_TORSO"
			},
			{
				name = "Holy Mary",
				male = `MP_LR_Tat_002_M`,
				female = `MP_LR_Tat_002_F`,
				zone = "ZONE_TORSO"
			},
			{
				name = "Gun Mic",
				male = `MP_LR_Tat_004_M`,
				female = `MP_LR_Tat_004_F`,
				zone = "ZONE_TORSO"
			},
			{
				name = "No Evil",
				male = `MP_LR_Tat_005_M`,
				female = `MP_LR_Tat_005_F`,
				zone = "ZONE_LEFT_ARM"
			},
			{
				name = "LS Serpent",
				male = `MP_LR_Tat_007_M`,
				female = `MP_LR_Tat_007_F`,
				zone = "ZONE_LEFT_LEG"
			},
			{
				name = "Amazon",
				male = `MP_LR_Tat_009_M`,
				female = `MP_LR_Tat_009_F`,
				zone = "ZONE_TORSO"
			},
			{
				name = "Bad Angel",
				male = `MP_LR_Tat_010_M`,
				female = `MP_LR_Tat_010_F`,
				zone = "ZONE_TORSO"
			},
			{
				name = "Love Gamble",
				male = `MP_LR_Tat_013_M`,
				female = `MP_LR_Tat_013_F`,
				zone = "ZONE_TORSO"
			},
			{
				name = "Love is Blind",
				male = `MP_LR_Tat_014_M`,
				female = `MP_LR_Tat_014_F`,
				zone = "ZONE_TORSO"
			},
			{
				name = "Seductress",
				male = `MP_LR_Tat_015_M`,
				female = `MP_LR_Tat_015_F`,
				zone = "ZONE_RIGHT_ARM"
			},
			{
				name = "Ink Me",
				male = `MP_LR_Tat_017_M`,
				female = `MP_LR_Tat_017_F`,
				zone = "ZONE_RIGHT_LEG"
			},
			{
				name = "Presidents",
				male = `MP_LR_Tat_020_M`,
				female = `MP_LR_Tat_020_F`,
				zone = "ZONE_LEFT_LEG"
			},
			{
				name = "Sad Angel",
				male = `MP_LR_Tat_021_M`,
				female = `MP_LR_Tat_021_F`,
				zone = "ZONE_TORSO"
			},
			{
				name = "Dance of Hearts",
				male = `MP_LR_Tat_023_M`,
				female = `MP_LR_Tat_023_F`,
				zone = "ZONE_RIGHT_LEG"
			},
			{
				name = "Royal Takeover",
				male = `MP_LR_Tat_026_M`,
				female = `MP_LR_Tat_026_F`,
				zone = "ZONE_TORSO"
			},
			{
				name = "Los Santos Life",
				male = `MP_LR_Tat_027_M`,
				female = `MP_LR_Tat_027_F`,
				zone = "ZONE_LEFT_ARM"
			},
			{
				name = "City Sorrow",
				male = `MP_LR_Tat_033_M`,
				female = `MP_LR_Tat_033_F`,
				zone = "ZONE_LEFT_ARM"
			}
		},
		[`mpluxe2_overlays`] = {
			{
				name = "The Howler",
				male = `MP_LUXE_TAT_002_M`,
				female = `MP_LUXE_TAT_002_F`,
				zone = "ZONE_TORSO"
			},
			{
				name = "Fatal Dagger",
				male = `MP_LUXE_TAT_005_M`,
				female = `MP_LUXE_TAT_005_F`,
				zone = "ZONE_LEFT_ARM"
			},
			{
				name = "Intrometric",
				male = `MP_LUXE_TAT_010_M`,
				female = `MP_LUXE_TAT_010_F`,
				zone = "ZONE_RIGHT_ARM"
			},
			{
				name = "Cross of Roses",
				male = `MP_LUXE_TAT_011_M`,
				female = `MP_LUXE_TAT_011_F`,
				zone = "ZONE_LEFT_LEG"
			},
			{
				name = "Geometric Galaxy",
				male = `MP_LUXE_TAT_012_M`,
				female = `MP_LUXE_TAT_012_F`,
				zone = "ZONE_TORSO"
			},
			{
				name = "Egyptian Mural",
				male = `MP_LUXE_TAT_016_M`,
				female = `MP_LUXE_TAT_016_F`,
				zone = "ZONE_LEFT_ARM"
			},
			{
				name = "Heavenly Deity",
				male = `MP_LUXE_TAT_017_M`,
				female = `MP_LUXE_TAT_017_F`,
				zone = "ZONE_RIGHT_ARM"
			},
			{
				name = "Divine Goddess",
				male = `MP_LUXE_TAT_018_M`,
				female = `MP_LUXE_TAT_018_F`,
				zone = "ZONE_LEFT_ARM"
			},
			{
				name = "Cloaked Angel",
				male = `MP_LUXE_TAT_022_M`,
				female = `MP_LUXE_TAT_022_F`,
				zone = "ZONE_TORSO"
			},
			{
				name = "Starmetric",
				male = `MP_LUXE_TAT_023_M`,
				female = `MP_LUXE_TAT_023_F`,
				zone = "ZONE_RIGHT_LEG"
			},
			{
				name = "Reaper Sway",
				male = `MP_LUXE_TAT_025_M`,
				female = `MP_LUXE_TAT_025_F`,
				zone = "ZONE_TORSO"
			},
			{
				name = "Floral Print",
				male = `MP_LUXE_TAT_026_M`,
				female = `MP_LUXE_TAT_026_F`,
				zone = "ZONE_RIGHT_ARM"
			},
			{
				name = "Cobra Dawn",
				male = `MP_LUXE_TAT_027_M`,
				female = `MP_LUXE_TAT_027_F`,
				zone = "ZONE_TORSO"
			},
			{
				name = "Python Skull",
				male = `MP_LUXE_TAT_028_M`,
				female = `MP_LUXE_TAT_028_F`,
				zone = "ZONE_LEFT_ARM"
			},
			{
				name = "Geometric Design",
				male = `MP_LUXE_TAT_029_M`,
				female = `MP_LUXE_TAT_029_F`,
				zone = "ZONE_TORSO"
			},
			{
				name = "Geometric Design",
				male = `MP_LUXE_TAT_030_M`,
				female = `MP_LUXE_TAT_030_F`,
				zone = "ZONE_RIGHT_ARM"
			},
			{
				name = "Geometric Design",
				male = `MP_LUXE_TAT_031_M`,
				female = `MP_LUXE_TAT_031_F`,
				zone = "ZONE_LEFT_ARM"
			}
		},
		[`mpluxe_overlays`] = {
			{
				name = "Serpent of Death",
				male = `MP_LUXE_TAT_000_M`,
				female = `MP_LUXE_TAT_000_F`,
				zone = "ZONE_LEFT_LEG"
			},
			{
				name = "Elaborate Los Muertos",
				male = `MP_LUXE_TAT_001_M`,
				female = `MP_LUXE_TAT_001_F`,
				zone = "ZONE_RIGHT_LEG"
			},
			{
				name = "Abstract Skull",
				male = `MP_LUXE_TAT_003_M`,
				female = `MP_LUXE_TAT_003_F`,
				zone = "ZONE_TORSO"
			},
			{
				name = "Floral Raven",
				male = `MP_LUXE_TAT_004_M`,
				female = `MP_LUXE_TAT_004_F`,
				zone = "ZONE_RIGHT_ARM"
			},
			{
				name = "Adorned Wolf",
				male = `MP_LUXE_TAT_006_M`,
				female = `MP_LUXE_TAT_006_F`,
				zone = "ZONE_TORSO"
			},
			{
				name = "Eye of the Griffin",
				male = `MP_LUXE_TAT_007_M`,
				female = `MP_LUXE_TAT_007_F`,
				zone = "ZONE_TORSO"
			},
			{
				name = "Flying Eye",
				male = `MP_LUXE_TAT_008_M`,
				female = `MP_LUXE_TAT_008_F`,
				zone = "ZONE_TORSO"
			},
			{
				name = "Floral Symmetry",
				male = `MP_LUXE_TAT_009_M`,
				female = `MP_LUXE_TAT_009_F`,
				zone = "ZONE_LEFT_ARM"
			},
			{
				name = "Mermaid Harpist",
				male = `MP_LUXE_TAT_013_M`,
				female = `MP_LUXE_TAT_013_F`,
				zone = "ZONE_RIGHT_ARM"
			},
			{
				name = "Ancient Queen",
				male = `MP_LUXE_TAT_014_M`,
				female = `MP_LUXE_TAT_014_F`,
				zone = "ZONE_TORSO"
			},
			{
				name = "Smoking Sisters",
				male = `MP_LUXE_TAT_015_M`,
				female = `MP_LUXE_TAT_015_F`,
				zone = "ZONE_TORSO"
			},
			{
				name = "Geisha Bloom",
				male = `MP_LUXE_TAT_019_M`,
				female = `MP_LUXE_TAT_019_F`,
				zone = "ZONE_RIGHT_ARM"
			},
			{
				name = "Archangel & Mary",
				male = `MP_LUXE_TAT_020_M`,
				female = `MP_LUXE_TAT_020_F`,
				zone = "ZONE_LEFT_ARM"
			},
			{
				name = "Gabriel",
				male = `MP_LUXE_TAT_021_M`,
				female = `MP_LUXE_TAT_021_F`,
				zone = "ZONE_LEFT_ARM"
			},
			{
				name = "Feather Mural",
				male = `MP_LUXE_TAT_024_M`,
				female = `MP_LUXE_TAT_024_F`,
				zone = "ZONE_TORSO"
			}
		},
		[`mpsmuggler_overlays`] = {
			{
				name = "Bless The Dead",
				male = `MP_Smuggler_Tattoo_000_M`,
				female = `MP_Smuggler_Tattoo_000_F`,
				zone = "ZONE_TORSO"
			},
			{
				name = "Crackshot",
				male = `MP_Smuggler_Tattoo_001_M`,
				female = `MP_Smuggler_Tattoo_001_F`,
				zone = "ZONE_RIGHT_ARM"
			},
			{
				name = "Dead Lies",
				male = `MP_Smuggler_Tattoo_002_M`,
				female = `MP_Smuggler_Tattoo_002_F`,
				zone = "ZONE_TORSO"
			},
			{
				name = "Give Nothing Back",
				male = `MP_Smuggler_Tattoo_003_M`,
				female = `MP_Smuggler_Tattoo_003_F`,
				zone = "ZONE_TORSO"
			},
			{
				name = "Honor",
				male = `MP_Smuggler_Tattoo_004_M`,
				female = `MP_Smuggler_Tattoo_004_F`,
				zone = "ZONE_LEFT_ARM"
			},
			{
				name = "Mutiny",
				male = `MP_Smuggler_Tattoo_005_M`,
				female = `MP_Smuggler_Tattoo_005_F`,
				zone = "ZONE_RIGHT_ARM"
			},
			{
				name = "Never Surrender",
				male = `MP_Smuggler_Tattoo_006_M`,
				female = `MP_Smuggler_Tattoo_006_F`,
				zone = "ZONE_TORSO"
			},
			{
				name = "No Honor",
				male = `MP_Smuggler_Tattoo_007_M`,
				female = `MP_Smuggler_Tattoo_007_F`,
				zone = "ZONE_TORSO"
			},
			{
				name = "Horrors Of The Deep",
				male = `MP_Smuggler_Tattoo_008_M`,
				female = `MP_Smuggler_Tattoo_008_F`,
				zone = "ZONE_LEFT_ARM"
			},
			{
				name = "Tall Ship Conflict",
				male = `MP_Smuggler_Tattoo_009_M`,
				female = `MP_Smuggler_Tattoo_009_F`,
				zone = "ZONE_TORSO"
			},
			{
				name = "See You In Hell",
				male = `MP_Smuggler_Tattoo_010_M`,
				female = `MP_Smuggler_Tattoo_010_F`,
				zone = "ZONE_TORSO"
			},
			{
				name = "Sinner",
				male = `MP_Smuggler_Tattoo_011_M`,
				female = `MP_Smuggler_Tattoo_011_F`,
				zone = "ZONE_HEAD"
			},
			{
				name = "Thief",
				male = `MP_Smuggler_Tattoo_012_M`,
				female = `MP_Smuggler_Tattoo_012_F`,
				zone = "ZONE_HEAD"
			},
			{
				name = "Torn Wings",
				male = `MP_Smuggler_Tattoo_013_M`,
				female = `MP_Smuggler_Tattoo_013_F`,
				zone = "ZONE_TORSO"
			},
			{
				name = "Mermaid's Curse",
				male = `MP_Smuggler_Tattoo_014_M`,
				female = `MP_Smuggler_Tattoo_014_F`,
				zone = "ZONE_LEFT_ARM"
			},
			{
				name = "Jolly Roger",
				male = `MP_Smuggler_Tattoo_015_M`,
				female = `MP_Smuggler_Tattoo_015_F`,
				zone = "ZONE_TORSO"
			},
			{
				name = "Skull Compass",
				male = `MP_Smuggler_Tattoo_016_M`,
				female = `MP_Smuggler_Tattoo_016_F`,
				zone = "ZONE_TORSO"
			},
			{
				name = "Framed Tall Ship",
				male = `MP_Smuggler_Tattoo_017_M`,
				female = `MP_Smuggler_Tattoo_017_F`,
				zone = "ZONE_TORSO"
			},
			{
				name = "Finders Keepers",
				male = `MP_Smuggler_Tattoo_018_M`,
				female = `MP_Smuggler_Tattoo_018_F`,
				zone = "ZONE_TORSO"
			},
			{
				name = "Lost At Sea",
				male = `MP_Smuggler_Tattoo_019_M`,
				female = `MP_Smuggler_Tattoo_019_F`,
				zone = "ZONE_TORSO"
			},
			{
				name = "Homeward Bound",
				male = `MP_Smuggler_Tattoo_020_M`,
				female = `MP_Smuggler_Tattoo_020_F`,
				zone = "ZONE_RIGHT_LEG"
			},
			{
				name = "Dead Tales",
				male = `MP_Smuggler_Tattoo_021_M`,
				female = `MP_Smuggler_Tattoo_021_F`,
				zone = "ZONE_TORSO"
			},
			{
				name = "X Marks The Spot",
				male = `MP_Smuggler_Tattoo_022_M`,
				female = `MP_Smuggler_Tattoo_022_F`,
				zone = "ZONE_TORSO"
			},
			{
				name = "Stylized Kraken",
				male = `MP_Smuggler_Tattoo_023_M`,
				female = `MP_Smuggler_Tattoo_023_F`,
				zone = "ZONE_RIGHT_ARM"
			},
			{
				name = "Pirate Captain",
				male = `MP_Smuggler_Tattoo_024_M`,
				female = `MP_Smuggler_Tattoo_024_F`,
				zone = "ZONE_TORSO"
			},
			{
				name = "Claimed By The Beast",
				male = `MP_Smuggler_Tattoo_025_M`,
				female = `MP_Smuggler_Tattoo_025_F`,
				zone = "ZONE_TORSO"
			}
		},
		[`mpstunt_overlays`] = {
			{
				name = "Stunt Skull",
				male = `MP_MP_Stunt_Tat_000_M`,
				female = `MP_MP_Stunt_Tat_000_F`,
				zone = "ZONE_HEAD"
			},
			{
				name = "8 Eyed Skull",
				male = `MP_MP_Stunt_tat_001_M`,
				female = `MP_MP_Stunt_tat_001_F`,
				zone = "ZONE_LEFT_ARM"
			},
			{
				name = "Big Cat",
				male = `MP_MP_Stunt_tat_002_M`,
				female = `MP_MP_Stunt_tat_002_F`,
				zone = "ZONE_LEFT_ARM"
			},
			{
				name = "Poison Wrench",
				male = `MP_MP_Stunt_tat_003_M`,
				female = `MP_MP_Stunt_tat_003_F`,
				zone = "ZONE_RIGHT_ARM"
			},
			{
				name = "Scorpion",
				male = `MP_MP_Stunt_tat_004_M`,
				female = `MP_MP_Stunt_tat_004_F`,
				zone = "ZONE_HEAD"
			},
			{
				name = "Demon Spark Plug",
				male = `MP_MP_Stunt_tat_005_M`,
				female = `MP_MP_Stunt_tat_005_F`,
				zone = "ZONE_RIGHT_LEG"
			},
			{
				name = "Toxic Spider",
				male = `MP_MP_Stunt_tat_006_M`,
				female = `MP_MP_Stunt_tat_006_F`,
				zone = "ZONE_HEAD"
			},
			{
				name = "Dagger Devil",
				male = `MP_MP_Stunt_tat_007_M`,
				female = `MP_MP_Stunt_tat_007_F`,
				zone = "ZONE_LEFT_LEG"
			},
			{
				name = "Moonlight Ride",
				male = `MP_MP_Stunt_tat_008_M`,
				female = `MP_MP_Stunt_tat_008_F`,
				zone = "ZONE_LEFT_ARM"
			},
			{
				name = "Arachnid of Death",
				male = `MP_MP_Stunt_tat_009_M`,
				female = `MP_MP_Stunt_tat_009_F`,
				zone = "ZONE_RIGHT_ARM"
			},
			{
				name = "Grave Vulture",
				male = `MP_MP_Stunt_tat_010_M`,
				female = `MP_MP_Stunt_tat_010_F`,
				zone = "ZONE_RIGHT_ARM"
			},
			{
				name = "Wheels of Death",
				male = `MP_MP_Stunt_tat_011_M`,
				female = `MP_MP_Stunt_tat_011_F`,
				zone = "ZONE_TORSO"
			},
			{
				name = "Punk Biker",
				male = `MP_MP_Stunt_tat_012_M`,
				female = `MP_MP_Stunt_tat_012_F`,
				zone = "ZONE_TORSO"
			},
			{
				name = "Dirt Track Hero",
				male = `MP_MP_Stunt_tat_013_M`,
				female = `MP_MP_Stunt_tat_013_F`,
				zone = "ZONE_LEFT_LEG"
			},
			{
				name = "Bat Cat of Spades",
				male = `MP_MP_Stunt_tat_014_M`,
				female = `MP_MP_Stunt_tat_014_F`,
				zone = "ZONE_TORSO"
			},
			{
				name = "Praying Gloves",
				male = `MP_MP_Stunt_tat_015_M`,
				female = `MP_MP_Stunt_tat_015_F`,
				zone = "ZONE_RIGHT_LEG"
			},
			{
				name = "Coffin Racer",
				male = `MP_MP_Stunt_tat_016_M`,
				female = `MP_MP_Stunt_tat_016_F`,
				zone = "ZONE_RIGHT_ARM"
			},
			{
				name = "Bat Wheel",
				male = `MP_MP_Stunt_tat_017_M`,
				female = `MP_MP_Stunt_tat_017_F`,
				zone = "ZONE_HEAD"
			},
			{
				name = "Vintage Bully",
				male = `MP_MP_Stunt_tat_018_M`,
				female = `MP_MP_Stunt_tat_018_F`,
				zone = "ZONE_TORSO"
			},
			{
				name = "Engine Heart",
				male = `MP_MP_Stunt_tat_019_M`,
				female = `MP_MP_Stunt_tat_019_F`,
				zone = "ZONE_TORSO"
			},
			{
				name = "Piston Angel",
				male = `MP_MP_Stunt_tat_020_M`,
				female = `MP_MP_Stunt_tat_020_F`,
				zone = "ZONE_RIGHT_LEG"
			},
			{
				name = "Golden Cobra",
				male = `MP_MP_Stunt_tat_021_M`,
				female = `MP_MP_Stunt_tat_021_F`,
				zone = "ZONE_LEFT_LEG"
			},
			{
				name = "Piston Head",
				male = `MP_MP_Stunt_tat_022_M`,
				female = `MP_MP_Stunt_tat_022_F`,
				zone = "ZONE_LEFT_ARM"
			},
			{
				name = "Tanked",
				male = `MP_MP_Stunt_tat_023_M`,
				female = `MP_MP_Stunt_tat_023_F`,
				zone = "ZONE_LEFT_ARM"
			},
			{
				name = "Road Kill",
				male = `MP_MP_Stunt_tat_024_M`,
				female = `MP_MP_Stunt_tat_024_F`,
				zone = "ZONE_TORSO"
			},
			{
				name = "Speed Freak",
				male = `MP_MP_Stunt_tat_025_M`,
				female = `MP_MP_Stunt_tat_025_F`,
				zone = "ZONE_RIGHT_LEG"
			},
			{
				name = "Winged Wheel",
				male = `MP_MP_Stunt_tat_026_M`,
				female = `MP_MP_Stunt_tat_026_F`,
				zone = "ZONE_TORSO"
			},
			{
				name = "Punk Road Hog",
				male = `MP_MP_Stunt_tat_027_M`,
				female = `MP_MP_Stunt_tat_027_F`,
				zone = "ZONE_TORSO"
			},
			{
				name = "Quad Goblin",
				male = `MP_MP_Stunt_tat_028_M`,
				female = `MP_MP_Stunt_tat_028_F`,
				zone = "ZONE_LEFT_LEG"
			},
			{
				name = "Majestic Finish",
				male = `MP_MP_Stunt_tat_029_M`,
				female = `MP_MP_Stunt_tat_029_F`,
				zone = "ZONE_TORSO"
			},
			{
				name = "Man's Ruin",
				male = `MP_MP_Stunt_tat_030_M`,
				female = `MP_MP_Stunt_tat_030_F`,
				zone = "ZONE_TORSO"
			},
			{
				name = "Stunt Jesus",
				male = `MP_MP_Stunt_tat_031_M`,
				female = `MP_MP_Stunt_tat_031_F`,
				zone = "ZONE_LEFT_LEG"
			},
			{
				name = "Wheelie Mouse",
				male = `MP_MP_Stunt_tat_032_M`,
				female = `MP_MP_Stunt_tat_032_F`,
				zone = "ZONE_RIGHT_LEG"
			},
			{
				name = "Sugar Skull Trucker",
				male = `MP_MP_Stunt_tat_033_M`,
				female = `MP_MP_Stunt_tat_033_F`,
				zone = "ZONE_TORSO"
			},
			{
				name = "Feather Road Kill",
				male = `MP_MP_Stunt_tat_034_M`,
				female = `MP_MP_Stunt_tat_034_F`,
				zone = "ZONE_TORSO"
			},
			{
				name = "Stuntman's End",
				male = `MP_MP_Stunt_tat_035_M`,
				female = `MP_MP_Stunt_tat_035_F`,
				zone = "ZONE_LEFT_ARM"
			},
			{
				name = "Biker Stallion",
				male = `MP_MP_Stunt_tat_036_M`,
				female = `MP_MP_Stunt_tat_036_F`,
				zone = "ZONE_RIGHT_ARM"
			},
			{
				name = "Big Grills",
				male = `MP_MP_Stunt_tat_037_M`,
				female = `MP_MP_Stunt_tat_037_F`,
				zone = "ZONE_TORSO"
			},
			{
				name = "One Down Five Up",
				male = `MP_MP_Stunt_tat_038_M`,
				female = `MP_MP_Stunt_tat_038_F`,
				zone = "ZONE_RIGHT_ARM"
			},
			{
				name = "Kaboom",
				male = `MP_MP_Stunt_tat_039_M`,
				female = `MP_MP_Stunt_tat_039_F`,
				zone = "ZONE_LEFT_ARM"
			},
			{
				name = "Monkey Chopper",
				male = `MP_MP_Stunt_tat_040_M`,
				female = `MP_MP_Stunt_tat_040_F`,
				zone = "ZONE_TORSO"
			},
			{
				name = "Brapp",
				male = `MP_MP_Stunt_tat_041_M`,
				female = `MP_MP_Stunt_tat_041_F`,
				zone = "ZONE_TORSO"
			},
			{
				name = "Flaming Quad",
				male = `MP_MP_Stunt_tat_042_M`,
				female = `MP_MP_Stunt_tat_042_F`,
				zone = "ZONE_HEAD"
			},
			{
				name = "Engine Arm",
				male = `MP_MP_Stunt_tat_043_M`,
				female = `MP_MP_Stunt_tat_043_F`,
				zone = "ZONE_LEFT_ARM"
			},
			{
				name = "Ram Skull",
				male = `MP_MP_Stunt_tat_044_M`,
				female = `MP_MP_Stunt_tat_044_F`,
				zone = "ZONE_TORSO"
			},
			{
				name = "Severed Hand",
				male = `MP_MP_Stunt_tat_045_M`,
				female = `MP_MP_Stunt_tat_045_F`,
				zone = "ZONE_RIGHT_LEG"
			},
			{
				name = "Full Throttle",
				male = `MP_MP_Stunt_tat_046_M`,
				female = `MP_MP_Stunt_tat_046_F`,
				zone = "ZONE_TORSO"
			},
			{
				name = "Brake Knife",
				male = `MP_MP_Stunt_tat_047_M`,
				female = `MP_MP_Stunt_tat_047_F`,
				zone = "ZONE_RIGHT_LEG"
			},
			{
				name = "Racing Doll",
				male = `MP_MP_Stunt_tat_048_M`,
				female = `MP_MP_Stunt_tat_048_F`,
				zone = "ZONE_TORSO"
			},
			{
				name = "Seductive Mechanic",
				male = `MP_MP_Stunt_tat_049_M`,
				female = `MP_MP_Stunt_tat_049_F`,
				zone = "ZONE_RIGHT_ARM"
			}
		},
		[`mpvinewood_overlays`] = {
			{
				name = "In the Pocket",
				male = `MP_Vinewood_Tat_000_M`,
				female = `MP_Vinewood_Tat_000_F`,
				zone = "ZONE_TORSO"
			},
			{
				name = "Jackpot",
				male = `MP_Vinewood_Tat_001_M`,
				female = `MP_Vinewood_Tat_001_F`,
				zone = "ZONE_TORSO"
			},
			{
				name = "Suits",
				male = `MP_Vinewood_Tat_002_M`,
				female = `MP_Vinewood_Tat_002_F`,
				zone = "ZONE_LEFT_ARM"
			},
			{
				name = "Royal Flush",
				male = `MP_Vinewood_Tat_003_M`,
				female = `MP_Vinewood_Tat_003_F`,
				zone = "ZONE_TORSO"
			},
			{
				name = "Lady Luck",
				male = `MP_Vinewood_Tat_004_M`,
				female = `MP_Vinewood_Tat_004_F`,
				zone = "ZONE_RIGHT_ARM"
			},
			{
				name = "Get Lucky",
				male = `MP_Vinewood_Tat_005_M`,
				female = `MP_Vinewood_Tat_005_F`,
				zone = "ZONE_LEFT_ARM"
			},
			{
				name = "Wheel of Suits",
				male = `MP_Vinewood_Tat_006_M`,
				female = `MP_Vinewood_Tat_006_F`,
				zone = "ZONE_TORSO"
			},
			{
				name = "777",
				male = `MP_Vinewood_Tat_007_M`,
				female = `MP_Vinewood_Tat_007_F`,
				zone = "ZONE_TORSO"
			},
			{
				name = "Snake Eyes",
				male = `MP_Vinewood_Tat_008_M`,
				female = `MP_Vinewood_Tat_008_F`,
				zone = "ZONE_TORSO"
			},
			{
				name = "Till Death Do Us Part",
				male = `MP_Vinewood_Tat_009_M`,
				female = `MP_Vinewood_Tat_009_F`,
				zone = "ZONE_TORSO"
			},
			{
				name = "Photo Finish",
				male = `MP_Vinewood_Tat_010_M`,
				female = `MP_Vinewood_Tat_010_F`,
				zone = "ZONE_TORSO"
			},
			{
				name = "Life's a Gamble",
				male = `MP_Vinewood_Tat_011_M`,
				female = `MP_Vinewood_Tat_011_F`,
				zone = "ZONE_TORSO"
			},
			{
				name = "Skull of Suits",
				male = `MP_Vinewood_Tat_012_M`,
				female = `MP_Vinewood_Tat_012_F`,
				zone = "ZONE_TORSO"
			},
			{
				name = "One-armed Bandit",
				male = `MP_Vinewood_Tat_013_M`,
				female = `MP_Vinewood_Tat_013_F`,
				zone = "ZONE_LEFT_LEG"
			},
			{
				name = "Vice",
				male = `MP_Vinewood_Tat_014_M`,
				female = `MP_Vinewood_Tat_014_F`,
				zone = "ZONE_LEFT_ARM"
			},
			{
				name = "The Jolly Joker",
				male = `MP_Vinewood_Tat_015_M`,
				female = `MP_Vinewood_Tat_015_F`,
				zone = "ZONE_TORSO"
			},
			{
				name = "Rose & Aces",
				male = `MP_Vinewood_Tat_016_M`,
				female = `MP_Vinewood_Tat_016_F`,
				zone = "ZONE_TORSO"
			},
			{
				name = "Roll the Dice",
				male = `MP_Vinewood_Tat_017_M`,
				female = `MP_Vinewood_Tat_017_F`,
				zone = "ZONE_TORSO"
			},
			{
				name = "The Gambler's Life",
				male = `MP_Vinewood_Tat_018_M`,
				female = `MP_Vinewood_Tat_018_F`,
				zone = "ZONE_RIGHT_ARM"
			},
			{
				name = "Can't Win Them All",
				male = `MP_Vinewood_Tat_019_M`,
				female = `MP_Vinewood_Tat_019_F`,
				zone = "ZONE_LEFT_ARM"
			},
			{
				name = "Cash is King",
				male = `MP_Vinewood_Tat_020_M`,
				female = `MP_Vinewood_Tat_020_F`,
				zone = "ZONE_RIGHT_LEG"
			},
			{
				name = "Show Your Hand",
				male = `MP_Vinewood_Tat_021_M`,
				female = `MP_Vinewood_Tat_021_F`,
				zone = "ZONE_TORSO"
			},
			{
				name = "Blood Money",
				male = `MP_Vinewood_Tat_022_M`,
				female = `MP_Vinewood_Tat_022_F`,
				zone = "ZONE_TORSO"
			},
			{
				name = "Lucky 7s",
				male = `MP_Vinewood_Tat_023_M`,
				female = `MP_Vinewood_Tat_023_F`,
				zone = "ZONE_TORSO"
			},
			{
				name = "Cash Mouth",
				male = `MP_Vinewood_Tat_024_M`,
				female = `MP_Vinewood_Tat_024_F`,
				zone = "ZONE_TORSO"
			},
			{
				name = "Queen of Roses",
				male = `MP_Vinewood_Tat_025_M`,
				female = `MP_Vinewood_Tat_025_F`,
				zone = "ZONE_RIGHT_ARM"
			},
			{
				name = "Banknote Rose",
				male = `MP_Vinewood_Tat_026_M`,
				female = `MP_Vinewood_Tat_026_F`,
				zone = "ZONE_LEFT_ARM"
			},
			{
				name = "8-Ball Rose",
				male = `MP_Vinewood_Tat_027_M`,
				female = `MP_Vinewood_Tat_027_F`,
				zone = "ZONE_LEFT_LEG"
			},
			{
				name = "Skull & Aces",
				male = `MP_Vinewood_Tat_028_M`,
				female = `MP_Vinewood_Tat_028_F`,
				zone = "ZONE_RIGHT_ARM"
			},
			{
				name = "The Table",
				male = `MP_Vinewood_Tat_029_M`,
				female = `MP_Vinewood_Tat_029_F`,
				zone = "ZONE_TORSO"
			},
			{
				name = "The Royals",
				male = `MP_Vinewood_Tat_030_M`,
				female = `MP_Vinewood_Tat_030_F`,
				zone = "ZONE_TORSO"
			},
			{
				name = "Gambling Royalty",
				male = `MP_Vinewood_Tat_031_M`,
				female = `MP_Vinewood_Tat_031_F`,
				zone = "ZONE_TORSO"
			},
			{
				name = "Play Your Ace",
				male = `MP_Vinewood_Tat_032_M`,
				female = `MP_Vinewood_Tat_032_F`,
				zone = "ZONE_TORSO"
			}
		},
		[`multiplayer_overlays`] = {
			{
				name = "Skull",
				male = `FM_Tat_Award_M_000`,
				female = `FM_Tat_Award_F_000`,
				zone = "ZONE_HEAD"
			},
			{
				name = "Burning Heart",
				male = `FM_Tat_Award_M_001`,
				female = `FM_Tat_Award_F_001`,
				zone = "ZONE_LEFT_ARM"
			},
			{
				name = "Grim Reaper Smoking Gun",
				male = `FM_Tat_Award_M_002`,
				female = `FM_Tat_Award_F_002`,
				zone = "ZONE_RIGHT_ARM"
			},
			{
				name = "Blackjack",
				male = `FM_Tat_Award_M_003`,
				female = `FM_Tat_Award_F_003`,
				zone = "ZONE_TORSO"
			},
			{
				name = "Hustler",
				male = `FM_Tat_Award_M_004`,
				female = `FM_Tat_Award_F_004`,
				zone = "ZONE_TORSO"
			},
			{
				name = "Angel",
				male = `FM_Tat_Award_M_005`,
				female = `FM_Tat_Award_F_005`,
				zone = "ZONE_TORSO"
			},
			{
				name = "Skull and Sword",
				male = `FM_Tat_Award_M_006`,
				female = `FM_Tat_Award_F_006`,
				zone = "ZONE_RIGHT_LEG"
			},
			{
				name = "Racing Blonde",
				male = `FM_Tat_Award_M_007`,
				female = `FM_Tat_Award_F_007`,
				zone = "ZONE_LEFT_ARM"
			},
			{
				name = "Los Santos Customs",
				male = `FM_Tat_Award_M_008`,
				female = `FM_Tat_Award_F_008`,
				zone = "ZONE_TORSO"
			},
			{
				name = "Dragon and Dagger",
				male = `FM_Tat_Award_M_009`,
				female = `FM_Tat_Award_F_009`,
				zone = "ZONE_LEFT_LEG"
			},
			{
				name = "Ride or Die",
				male = `FM_Tat_Award_M_010`,
				female = `FM_Tat_Award_F_010`,
				zone = "ZONE_RIGHT_ARM"
			},
			{
				name = "Blank Scroll",
				male = `FM_Tat_Award_M_011`,
				female = `FM_Tat_Award_F_011`,
				zone = "ZONE_TORSO"
			},
			{
				name = "Embellished Scroll",
				male = `FM_Tat_Award_M_012`,
				female = `FM_Tat_Award_F_012`,
				zone = "ZONE_TORSO"
			},
			{
				name = "Seven Deadly Sins",
				male = `FM_Tat_Award_M_013`,
				female = `FM_Tat_Award_F_013`,
				zone = "ZONE_TORSO"
			},
			{
				name = "Trust No One",
				male = `FM_Tat_Award_M_014`,
				female = `FM_Tat_Award_F_014`,
				zone = "ZONE_TORSO"
			},
			{
				name = "Racing Brunette",
				male = `FM_Tat_Award_M_015`,
				female = `FM_Tat_Award_F_015`,
				zone = "ZONE_LEFT_ARM"
			},
			{
				name = "Clown",
				male = `FM_Tat_Award_M_016`,
				female = `FM_Tat_Award_F_016`,
				zone = "ZONE_TORSO"
			},
			{
				name = "Clown and Gun",
				male = `FM_Tat_Award_M_017`,
				female = `FM_Tat_Award_F_017`,
				zone = "ZONE_TORSO"
			},
			{
				name = "Clown Dual Wield",
				male = `FM_Tat_Award_M_018`,
				female = `FM_Tat_Award_F_018`,
				zone = "ZONE_TORSO"
			},
			{
				name = "Clown Dual Wield Dollars",
				male = `FM_Tat_Award_M_019`,
				female = `FM_Tat_Award_F_019`,
				zone = "ZONE_TORSO"
			},
			{
				name = "Brotherhood",
				male = `FM_Tat_M_000`,
				female = `FM_Tat_F_000`,
				zone = "ZONE_RIGHT_ARM"
			},
			{
				name = "Dragons",
				male = `FM_Tat_M_001`,
				female = `FM_Tat_F_001`,
				zone = "ZONE_RIGHT_ARM"
			},
			{
				name = "Melting Skull",
				male = `FM_Tat_M_002`,
				female = `FM_Tat_F_002`,
				zone = "ZONE_LEFT_LEG"
			},
			{
				name = "Dragons and Skull",
				male = `FM_Tat_M_003`,
				female = `FM_Tat_F_003`,
				zone = "ZONE_RIGHT_ARM"
			},
			{
				name = "Faith",
				male = `FM_Tat_M_004`,
				female = `FM_Tat_F_004`,
				zone = "ZONE_TORSO"
			},
			{
				name = "Serpents",
				male = `FM_Tat_M_005`,
				female = `FM_Tat_F_005`,
				zone = "ZONE_LEFT_ARM"
			},
			{
				name = "Oriental Mural",
				male = `FM_Tat_M_006`,
				female = `FM_Tat_F_006`,
				zone = "ZONE_LEFT_ARM"
			},
			{
				name = "The Warrior",
				male = `FM_Tat_M_007`,
				female = `FM_Tat_F_007`,
				zone = "ZONE_RIGHT_LEG"
			},
			{
				name = "Dragon Mural",
				male = `FM_Tat_M_008`,
				female = `FM_Tat_F_008`,
				zone = "ZONE_LEFT_LEG"
			},
			{
				name = "Skull on the Cross",
				male = `FM_Tat_M_009`,
				female = `FM_Tat_F_009`,
				zone = "ZONE_TORSO"
			},
			{
				name = "LS Flames",
				male = `FM_Tat_M_010`,
				female = `FM_Tat_F_010`,
				zone = "ZONE_TORSO"
			},
			{
				name = "LS Script",
				male = `FM_Tat_M_011`,
				female = `FM_Tat_F_011`,
				zone = "ZONE_TORSO"
			},
			{
				name = "Los Santos Bills",
				male = `FM_Tat_M_012`,
				female = `FM_Tat_F_012`,
				zone = "ZONE_TORSO"
			},
			{
				name = "Eagle and Serpent",
				male = `FM_Tat_M_013`,
				female = `FM_Tat_F_013`,
				zone = "ZONE_TORSO"
			},
			{
				name = "Flower Mural",
				male = `FM_Tat_M_014`,
				female = `FM_Tat_F_014`,
				zone = "ZONE_RIGHT_ARM"
			},
			{
				name = "Zodiac Skull",
				male = `FM_Tat_M_015`,
				female = `FM_Tat_F_015`,
				zone = "ZONE_LEFT_ARM"
			},
			{
				name = "Evil Clown",
				male = `FM_Tat_M_016`,
				female = `FM_Tat_F_016`,
				zone = "ZONE_TORSO"
			},
			{
				name = "Tribal",
				male = `FM_Tat_M_017`,
				female = `FM_Tat_F_017`,
				zone = "ZONE_RIGHT_LEG"
			},
			{
				name = "Serpent Skull",
				male = `FM_Tat_M_018`,
				female = `FM_Tat_F_018`,
				zone = "ZONE_RIGHT_ARM"
			},
			{
				name = "The Wages of Sin",
				male = `FM_Tat_M_019`,
				female = `FM_Tat_F_019`,
				zone = "ZONE_TORSO"
			},
			{
				name = "Dragon",
				male = `FM_Tat_M_020`,
				female = `FM_Tat_F_020`,
				zone = "ZONE_TORSO"
			},
			{
				name = "Serpent Skull",
				male = `FM_Tat_M_021`,
				female = `FM_Tat_F_021`,
				zone = "ZONE_LEFT_LEG"
			},
			{
				name = "Fiery Dragon",
				male = `FM_Tat_M_022`,
				female = `FM_Tat_F_022`,
				zone = "ZONE_RIGHT_LEG"
			},
			{
				name = "Hottie",
				male = `FM_Tat_M_023`,
				female = `FM_Tat_F_023`,
				zone = "ZONE_LEFT_LEG"
			},
			{
				name = "Flaming Cross",
				male = `FM_Tat_M_024`,
				female = `FM_Tat_F_024`,
				zone = "ZONE_TORSO"
			},
			{
				name = "LS Bold",
				male = `FM_Tat_M_025`,
				female = `FM_Tat_F_025`,
				zone = "ZONE_TORSO"
			},
			{
				name = "Smoking Dagger",
				male = `FM_Tat_M_026`,
				female = `FM_Tat_F_026`,
				zone = "ZONE_LEFT_LEG"
			},
			{
				name = "Virgin Mary",
				male = `FM_Tat_M_027`,
				female = `FM_Tat_F_027`,
				zone = "ZONE_RIGHT_ARM"
			},
			{
				name = "Mermaid",
				male = `FM_Tat_M_028`,
				female = `FM_Tat_F_028`,
				zone = "ZONE_RIGHT_ARM"
			},
			{
				name = "Trinity Knot",
				male = `FM_Tat_M_029`,
				female = `FM_Tat_F_029`,
				zone = "ZONE_TORSO"
			},
			{
				name = "Lucky Celtic Dogs",
				male = `FM_Tat_M_030`,
				female = `FM_Tat_F_030`,
				zone = "ZONE_TORSO"
			},
			{
				name = "Lady M",
				male = `FM_Tat_M_031`,
				female = `FM_Tat_F_031`,
				zone = "ZONE_LEFT_ARM"
			},
			{
				name = "Faith",
				male = `FM_Tat_M_032`,
				female = `FM_Tat_F_032`,
				zone = "ZONE_LEFT_LEG"
			},
			{
				name = "Chinese Dragon",
				male = `FM_Tat_M_033`,
				female = `FM_Tat_F_033`,
				zone = "ZONE_LEFT_LEG"
			},
			{
				name = "Flaming Shamrock",
				male = `FM_Tat_M_034`,
				female = `FM_Tat_F_034`,
				zone = "ZONE_TORSO"
			},
			{
				name = "Dragon",
				male = `FM_Tat_M_035`,
				female = `FM_Tat_F_035`,
				zone = "ZONE_LEFT_LEG"
			},
			{
				name = "Way of the Gun",
				male = `FM_Tat_M_036`,
				female = `FM_Tat_F_036`,
				zone = "ZONE_TORSO"
			},
			{
				name = "Grim Reaper",
				male = `FM_Tat_M_037`,
				female = `FM_Tat_F_037`,
				zone = "ZONE_LEFT_LEG"
			},
			{
				name = "Dagger",
				male = `FM_Tat_M_038`,
				female = `FM_Tat_F_038`,
				zone = "ZONE_RIGHT_ARM"
			},
			{
				name = "Broken Skull",
				male = `FM_Tat_M_039`,
				female = `FM_Tat_F_039`,
				zone = "ZONE_RIGHT_LEG"
			},
			{
				name = "Flaming Skull",
				male = `FM_Tat_M_040`,
				female = `FM_Tat_F_040`,
				zone = "ZONE_RIGHT_LEG"
			},
			{
				name = "Dope Skull",
				male = `FM_Tat_M_041`,
				female = `FM_Tat_F_041`,
				zone = "ZONE_LEFT_ARM"
			},
			{
				name = "Flaming Scorpion",
				male = `FM_Tat_M_042`,
				female = `FM_Tat_F_042`,
				zone = "ZONE_RIGHT_LEG"
			},
			{
				name = "Indian Ram",
				male = `FM_Tat_M_043`,
				female = `FM_Tat_F_043`,
				zone = "ZONE_RIGHT_LEG"
			},
			{
				name = "Stone Cross",
				male = `FM_Tat_M_044`,
				female = `FM_Tat_F_044`,
				zone = "ZONE_TORSO"
			},
			{
				name = "Skulls and Rose",
				male = `FM_Tat_M_045`,
				female = `FM_Tat_F_045`,
				zone = "ZONE_TORSO"
			},
			{
				name = "Lion",
				male = `FM_Tat_M_047`,
				female = `FM_Tat_F_047`,
				zone = "ZONE_RIGHT_ARM"
			}
		}
	},
}