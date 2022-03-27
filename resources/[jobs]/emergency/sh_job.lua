PD_FLAGS = {
	[1 << 1] = { name = "FTO" },

	[1 << 10] = { name = "Helicopter" },
	[1 << 11] = { name = "Motorcycle" },
	[1 << 12] = { name = "Interceptor" },
	[1 << 13] = { name = "Marine" },
	[1 << 14] = { name = "Medical" },
}

EMS_FLAGS = {

}

exports.jobs:Register("lspd", {
	Title = "Police",
	Name = "LSPD",
	Faction = "pd",
	Group = "lspd",
	-- Description = "Known for winning situations.",
	Flags = PD_FLAGS,
	Clocks = {
		{ Coords = vector3(453.3004, -986.6588, 30.59658), Radius = 3.5 },
		{ Coords = vector3(453.5949, -980.6509, 30.57985), Radius = 3.5 },
	},
	Tracker = {
		Group = "emergency",
		State = "pd",
	},
	Ranks = {
		{ Name = "Janitor" },
		{ Name = "Receptionist" },
		{ Name = "Cadet" },
		{ Name = "Officer" },
		{ Name = "Senior Officer" },
		{
			Name = "Sergeant",
			Flags = (
				Jobs.Permissions.CAN_SET_USER_FLAGS |
				Jobs.Permissions.CAN_SET_USER_STATUS |
				Jobs.Permissions.CAN_SET_USER_OTHER
			)
		},
		{
			Name = "Lieutenant",
			Flags = (
				Jobs.Permissions.CAN_HIRE_OR_FIRE |
				Jobs.Permissions.CAN_SET_USER_FLAGS |
				Jobs.Permissions.CAN_SET_USER_STATUS |
				Jobs.Permissions.CAN_SET_USER_OTHER
			)
		},
		{
			Name = "Captain",
			Flags = (
				Jobs.Permissions.CAN_HIRE_OR_FIRE |
				Jobs.Permissions.CAN_SET_USER_FLAGS |
				Jobs.Permissions.CAN_SET_USER_STATUS |
				Jobs.Permissions.CAN_SET_USER_OTHER |
				Jobs.Permissions.CAN_SET_USER_RANK
			)
		},
		{
			Name = "Deputy Chief",
			Flags = Jobs.Permissions.ALL()
		},
		{
			Name = "Chief of Police",
			Flags = Jobs.Permissions.ALL()
		},
	},
})

exports.jobs:Register("bcso", {
	Title = "Police",
	Name = "BCSO",
	Faction = "pd",
	Group = "bcso",
	Flags = PD_FLAGS,
	Clocks = {
		{ Coords = vector3(1848.291, 3686.824, 34.27011), Radius = 2.0 },
	},
	Tracker = {
		Group = "emergency",
		State = "pd",
	},
	Ranks ={
		"Recruit",
		"Sheriff",
	},
})

exports.jobs:Register("sasp", {
	Title = "Police",
	Name = "SASP",
	Faction = "pd",
	Group = "sasp",
	Flags = PD_FLAGS,
	Clocks = {
		{ Coords = vector3(1543.839, 828.1853, 77.66039), Radius = 3.0 },
		{ Coords = vector3(1546.448, 826.5332, 77.65541), Radius = 3.0 },
	},
	Tracker = {
		Group = "emergency",
		State = "pd",
	},
})

exports.jobs:Register("paramedic", {
	Title = "EMS",
	Name = "Paramedic",
	Faction = "ems",
	Group = "paramedic",
	Flags = EMS_FLAGS,
	Clocks = {
		{ Coords = vector3(305.0252, -600.062, 43.28405), Radius = 2.0 },
	},
	Tracker = {
		Group = "emergency",
		State = "ems",
	},
	Ranks = {
		{
			Name = "EMT",
		},
		{
			Name = "Paramedic",
		},
		{
			Name = "Senior Paramedic",
		},
		{
			Name = "Advanced Paramedic",
		},
		{
			Name = "Lieutenant",
			Flags = (
				Jobs.Permissions.CAN_HIRE_OR_FIRE |
				Jobs.Permissions.CAN_SET_USER_FLAGS |
				Jobs.Permissions.CAN_SET_USER_STATUS |
				Jobs.Permissions.CAN_SET_USER_OTHER
			)
		},
		{
			Name = "Captain",
			Flags = (
				Jobs.Permissions.CAN_HIRE_OR_FIRE |
				Jobs.Permissions.CAN_SET_USER_FLAGS |
				Jobs.Permissions.CAN_SET_USER_STATUS |
				Jobs.Permissions.CAN_SET_USER_OTHER |
				Jobs.Permissions.CAN_SET_USER_RANK
			)
		},
		{
			Name = "Dead of Medicine",
			Flags = (
				Jobs.Permissions.CAN_HIRE_OR_FIRE |
				Jobs.Permissions.CAN_SET_USER_FLAGS |
				Jobs.Permissions.CAN_SET_USER_STATUS |
				Jobs.Permissions.CAN_SET_USER_OTHER |
				Jobs.Permissions.CAN_SET_USER_RANK
			)
		},
		{
			Name = "Assistant Chief",
			Flags = Jobs.Permissions.ALL()
		},
		{
			Name = "Chief",
			Flags = Jobs.Permissions.ALL()
		},
	},
})