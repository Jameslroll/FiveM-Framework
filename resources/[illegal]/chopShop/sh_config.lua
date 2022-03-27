Config = {
	CarsPerList = { Min = 15, Max = 20 },
	ListDuration = { Min = 30, Max = 40 },
	Presence = { Min = 1, Max = 10, MaxRate = 1.5 },
	Components = {
		{ Name = "engine", Type = -1, Index = 0, Offset = vector3(0, 0, -0.5) },
		{ Name = "door_dside_f", Type = 0, Index = 0, Offset = vector3(0.5, 0.5, 0) },
		{ Name = "door_dside_r", Type = 0, Index = 2, Offset = vector3(0.5, 0.5, 0) },
		{ Name = "door_pside_f", Type = 0, Index = 1, Offset = vector3(-0.5, 0.5, 0) },
		{ Name = "door_pside_r", Type = 0, Index = 3, Offset = vector3(-0.5, 0.5, 0) },
		{ Name = "bonnet", Type = 0, Index = 4, Offset = vector3(0, -1.5, 0) },
		{ Name = "boot", Type = 0, Index = 5, Offset = vector3(0, 1.0, 0) },
		{ Name = "wheel_lf", Type = 1, Index = 0, Offset = vector3(0.5, 0, 0) },
		{ Name = "wheel_lr", Type = 1, Index = 4, Offset = vector3(0.5, 0, 0) },
		{ Name = "wheel_rf", Type = 1, Index = 1, Offset = vector3(-0.5, 0, 0) },
		{ Name = "wheel_rr", Type = 1, Index = 5, Offset = vector3(-0.5, 0, 0) },
		-- { Name = "wheel_lm1", Type = 1, Index = 0 },
		-- { Name = "wheel_lm2", Type = 1, Index = 0 },
		-- { Name = "wheel_lm3", Type = 1, Index = 0 },
		-- { Name = "wheel_rm1", Type = 1, Index = 0 },
		-- { Name = "wheel_rm2", Type = 1, Index = 0 },
		-- { Name = "wheel_rm3", Type = 1, Index = 0 },
	},
	ComponentRange = 1.5,
	Zones = {
		--[[ Chop Zones ]]--
		-- Hayes Auto.
		-- { Type = 0, Visibility = 10.0, Radius = 5.0, Chance = 100, Coords = vector3(481.17077636719, -1317.1510009766, 29.202482223511) },
		
		-- Davis Auto Repairs.
		{ Type = 0, Visibility = 10.0, Radius = 5.0, Chance = 100, Coords = vector3(158.90139770507812, -1694.040771484375, 29.44917488098145) },

		-- Boneyard.
		{ Type = 0, Visibility = 10.0, Radius = 5.0, Chance = 100, Coords = vector3(2342.3835449219, 3052.4152832031, 48.151817321777) },

		--[[ Informants ]]--
		-- Hayes Auto.
		-- { Type = 1, Visibility = 50.0, Radius = 1.5, Chance = 100, Coords = vector3(474.52053833008, -1309.7144775391, 29.206663131714), Peds = {
		-- 	{ Model = "g_m_importexport_01" },
		-- 	{ Model = "g_m_m_mexboss_02" },
		-- 	{ Model = "g_m_y_armgoon_02" },
		-- 	{ Model = "g_m_y_azteca_01" },
		-- }, Heading = 190.47058105469},

		-- Davis Auto Repairs.
		{ Type = 1, Visibility = 50.0, Radius = 1.5, Chance = 100, Coords = vector3(144.71954345703125, -1699.8651123046875, 29.29166603088379), Peds = {
			{ Model = "g_m_importexport_01" },
			{ Model = "g_m_m_mexboss_02" },
			{ Model = "g_m_y_armgoon_02" },
			{ Model = "g_m_y_azteca_01" },
		}, Heading = 6.571166515350342},

		-- La Puerta Scrap Yard.
		{ Type = 1, Visibility = 50.0, Radius = 1.5, Chance = 50, Coords = vector3(-542.38568115234, -1636.5914306641, 19.062301635742), Peds = {
			{ Model = "g_m_m_armboss_01" },
		}, Heading = 94.182029724121},
		
		-- La Puerta Garbage Disposal.
		{ Type = 1, Visibility = 50.0, Radius = 1.5, Chance = 50, Coords = vector3(-332.68402099609, -1554.4663085938, 27.718605041504), Peds = {
			{ Model = "cs_brad" },
		}, Heading = 324.99084472656},
		
		-- Boneyard.
		{ Type = 1, Visibility = 50.0, Radius = 1.5, Chance = 75, Coords = vector3(2401.2541503906, 3124.6650390625, 48.152935028076), Peds = {
			{ Model = "ig_cletus" },
		}, Heading = 204.67668151855},
		
		-- Joshua Road.
		{ Type = 1, Visibility = 50.0, Radius = 1.5, Chance = 50, Coords = vector3(183.25653076172, 2791.0148925781, 45.603225708008), Peds = {
			{ Model = "s_m_y_construct_01" },
		}, Heading = 312.94845581055},
		
		-- Senora Road Gas Station.
		{ Type = 1, Visibility = 50.0, Radius = 1.5, Chance = 50, Coords = vector3(264.29803466797, 2591.90625, 45.0563621521), Peds = {
			{ Model = "s_m_m_autoshop_02" },
		}, Heading = 164.7827911377},
	},
	Cars = {
		{ Model = "adder", BasePrice = 500, Chance = 10 },
		{ Model = "akuma", BasePrice = 150, Chance = 80 },
		{ Model = "alpha", BasePrice = 187, Chance = 30 },
		{ Model = "asea", BasePrice = 150, Chance = 50 },
		{ Model = "bagger", BasePrice = 150, Chance = 90 },
		{ Model = "banshee", BasePrice = 187, Chance = 10 },
		{ Model = "banshee2", BasePrice = 187, Chance = 10 },
		{ Model = "bati", BasePrice = 150, Chance = 30 },
		{ Model = "bifta", BasePrice = 150, Chance = 50 },
		{ Model = "bjxl", BasePrice = 150, Chance = 50 },
		{ Model = "buffalo", BasePrice = 187, Chance = 90 },
		{ Model = "bullet", BasePrice = 262, Chance = 10 },
		{ Model = "caddy", BasePrice = 150, Chance = 20 },
		{ Model = "caddy2", BasePrice = 150, Chance = 20 },
		{ Model = "coquette", BasePrice = 225, Chance = 20 },
		{ Model = "dilettante", BasePrice = 150, Chance = 50 },
		{ Model = "dubsta", BasePrice = 187, Chance = 40 },
		{ Model = "dubsta2", BasePrice = 225, Chance = 40 },
		{ Model = "enduro", BasePrice = 150, Chance = 40 },
		{ Model = "esskey", BasePrice = 150, Chance = 45 },
		{ Model = "f620", BasePrice = 150, Chance = 40 },
		{ Model = "faction", BasePrice = 150, Chance = 50 },
		{ Model = "felon", BasePrice = 150, Chance = 30 },
		{ Model = "feltzer2", BasePrice = 225, Chance = 85 },
		{ Model = "fusilade", BasePrice = 187, Chance = 20 },
		{ Model = "glendale", BasePrice = 150, Chance = 50 },
		{ Model = "granger", BasePrice = 150, Chance = 50 },
		{ Model = "habanero", BasePrice = 150, Chance = 50 },
		{ Model = "issi2", BasePrice = 150, Chance = 50 },
		{ Model = "jester", BasePrice = 225, Chance = 40 },
		{ Model = "jester2", BasePrice = 300, Chance = 40 },
		{ Model = "kalahari", BasePrice = 150, Chance = 50 },
		{ Model = "massacro", BasePrice = 225, Chance = 30 },
		{ Model = "mesa", BasePrice = 150, Chance = 45 },
		{ Model = "mesa3", BasePrice = 150, Chance = 50 },
		{ Model = "mower", BasePrice = 150, Chance = 20 },
		{ Model = "ninef", BasePrice = 225, Chance = 20 },
		{ Model = "ninef2", BasePrice = 262, Chance = 25 },
		{ Model = "oracle", BasePrice = 150, Chance = 50 },
		{ Model = "panto", BasePrice = 150, Chance = 50 },
		{ Model = "patriot", BasePrice = 150, Chance = 60 },
		{ Model = "phoenix", BasePrice = 150, Chance = 50 },
		{ Model = "premier", BasePrice = 150, Chance = 50 },
		{ Model = "rebel", BasePrice = 150, Chance = 40 },
		{ Model = "rebel2", BasePrice = 150, Chance = 50 },
		{ Model = "regina", BasePrice = 150, Chance = 50 },
		{ Model = "rentalbus", BasePrice = 150, Chance = 70 },
		{ Model = "rhapsody", BasePrice = 150, Chance = 50 },
		{ Model = "rocoto", BasePrice = 150, Chance = 50 },
		{ Model = "sabregt", BasePrice = 225, Chance = 60 },
		{ Model = "sandking", BasePrice = 150, Chance = 50 },
		{ Model = "sandking2", BasePrice = 150, Chance = 40 },
		{ Model = "schafter2", BasePrice = 225, Chance = 50 },
		{ Model = "schafter3", BasePrice = 180, Chance = 20 },
		{ Model = "schafter4", BasePrice = 180, Chance = 30 },
		{ Model = "seminole", BasePrice = 150, Chance = 35 },
		{ Model = "sentinel", BasePrice = 225, Chance = 50 },
		{ Model = "sentinel2", BasePrice = 225, Chance = 100 },
		{ Model = "sovereign", BasePrice = 150, Chance = 80 },
		{ Model = "speedo", BasePrice = 150, Chance = 70 },
		{ Model = "stretch", BasePrice = 225, Chance = 20 },
		{ Model = "sultan", BasePrice = 185, Chance = 80 },
		{ Model = "superd", BasePrice = 375, Chance = 50 },
		{ Model = "taco", BasePrice = 150, Chance = 70 },
		{ Model = "tourbus", BasePrice = 150, Chance = 70 },
		{ Model = "turismor", BasePrice = 300, Chance = 10 },
		{ Model = "voltic", BasePrice = 300, Chance = 10 },
		{ Model = "voodoo", BasePrice = 150, Chance = 60 },
		{ Model = "washington", BasePrice = 150, Chance = 70 },
		{ Model = "xls", BasePrice = 150, Chance = 45 },
		{ Model = "youga", BasePrice = 150, Chance = 60 },
		{ Model = "zentorno", BasePrice = 500, Chance = 10 },
	},
	-- The object informants hold.
	HeldObject = {
		Model = "prop_notepad_01",
		Rot = vector3(90.0, 0.0, 0.0),
		Pos = vector3(-0.1, 0.01, 0.0),
	},
	-- The animation informants perform.
	Anim = {
		Dict = "misslsdhsclipboard@idle_a",
		Name = "idle_c",
	}
}