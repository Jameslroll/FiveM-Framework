Config = {
	Melee = {
		Cooldown = 500,
	},
	DispatchServices = {
		[1] = false, -- PoliceAutomobile
		[2] = false, -- PoliceHelicopter
		[3] = false, -- FireDepartment
		[4] = false, -- SwatAutomobile
		[5] = false, -- AmbulanceDepartment
		[6] = false, -- PoliceRiders
		[7] = false, -- PoliceVehicleRequest
		[8] = false, -- PoliceRoadBlock
		[9] = false, -- PoliceAutomobileWaitPulledOver
		[10] = false, -- PoliceAutomobileWaitCruising
		[11] = false, -- Gangs
		[12] = false, -- SwatHelicopter
		[13] = false, -- PoliceBoat
		[14] = false, -- ArmyVehicle
	},
	Flags = {
		[2] = true, -- CPED_CONFIG_FLAG_NoCriticalHits
		[35] = false, -- CPED_CONFIG_FLAG_UseHelmet
		[184] = true, -- CPED_CONFIG_FLAG_PreventAutoShuffleToDriversSeat
		[429] = true, -- CPED_CONFIG_FLAG_DisableStartEngine
		[434] = true, -- CPED_CONFIG_FLAG_DisableHomingMissileLockon
		[438] = true, -- CPED_CONFIG_FLAG_DisableHelmetArmor
	},
	UnarmedDisabled = {
		140,
		141,
		142,
		257,
		263,
		264,
	},
	SuppressedModels = {
		`adder`,
		`blimp`,
		`blimp2`,
		`fbi`,
		`fbi2`,
		`firetruk`,
		`jet`,
		`lazer`,
		`lazer`,
		`pbus`,
		`police`,
		`police2`,
		`police3`,
		`police4`,
		`policeb`,
		`policet`,
		`rhino`,
		`rhino`,
		`riot`,
		`titan`,
		`zentorno`,
	},
	DisabledGroups = {
		"BLIMP",
		"DEALERSHIP",
	},
	DisabledTypes = {
		"WORLD_HUMAN_COP_IDLES",
		"WORLD_VEHICLE_MILITARY_PLANES_BIG",
		"WORLD_VEHICLE_MILITARY_PLANES_SMALL",
		"WORLD_VEHICLE_POLICE_BIKE",
		"WORLD_VEHICLE_POLICE_CAR",
		"WORLD_VEHICLE_POLICE_NEXT_TO_CAR",
		"PROP_HUMAN_ATM",
		"PROP_HUMAN_BBQ",
		"CODE_HUMAN_MEDIC_KNEEL",
		"CODE_HUMAN_MEDIC_TEND_TO_DEAD",
		"CODE_HUMAN_MEDIC_TIME_OF_DEATH",
		"CODE_HUMAN_POLICE_CROWD_CONTROL",
		"CODE_HUMAN_POLICE_INVESTIGATE",
	},
}