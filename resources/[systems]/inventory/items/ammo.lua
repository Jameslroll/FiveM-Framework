local bullets = {
	{
		name = "9mm Parabellum",
		description = "Caliber of ammunition typically used in revolvers or pistols",
		weight = 0.0116,
	},
	{
		name = "12 Gauge",
		description = "Caliber of ammunition typically used in shotguns",
		weight = 0.0435,
	},
	{
		name = ".22 LR",
		weight = 0.0032,
	},
	{
		name = ".30-06 Springfield",
		weight = 0.0117,
	},
	{
		name = ".38 Special",
		weight = 0.0133,
	},
	{
		name = ".40 S&W",
		weight = 0.0165,
	},
	{
		name = ".45 ACP",
		weight = 0.0184,
	},
	{
		name = ".50 Action Express",
		weight = 0.019,
	},
	{
		name = ".50 BMG",
		description = "Caliber of ammunition typically used in pistols and some larger weapons",
		weight = 0.042,
	},
	{
		name = ".223 Remington",
		weight = 0.0114,
	},
	{
		name = ".300 AAC Blackout",
		weight = 0.014,
	},
	{
		name = ".308 Winchester",
		weight = 0.011,
	},
	{
		name = ".357 Magnum",
		description = "Caliber of ammunition typically used in revolvers or pistols",
		weight = 0.014,
	},
	{
		name = "5.56mm NATO",
		description = "Caliber of ammunition typically used in semi or fully automatic rifles",
		weight = 0.062,
	},
	{
		name = "7.62x39mm FMJ",
		description = "Caliber of ammunition typically used in semi or fully automatic rifles and sniper rifles",
		weight = 0.016,
	},
}

local boxes = {
	{
		name = "9mm Parabellum Box",
		weight = 0.24, -- 20 rounds.
		count = 20,
	},
	{
		name = "12 Gauge Box",
		weight = 0.54, -- 12 rounds.
		count = 12,
	},
	{
		name = ".22 LR Box",
		weight = 0.17, -- 50 rounds.
		count = 50,
	},
	{
		name = ".30-06 Springfield Box",
		weight = 0.25, -- 20 rounds.
		count = 20,
	},
	{
		name = ".38 Special Box",
		weight = 0.675, -- 50 rounds.
		count = 50,
	},
	{
		name = ".40 S&W Box",
		weight = 0.83, -- 50 rounds.
		count = 50,
	},
	{
		name = ".45 ACP Box",
		weight = 0.4, -- 20 rounds.
		count = 20,
	},
	{
		name = ".50 Action Express Box",
		weight = 0.4, -- 20 rounds.
		count = 20,
	},
	{
		name = ".50 BMG Box",
		weight = 0.5, -- 10 rounds.
		count = 10,
	},
	{
		name = ".223 Remington Box",
		weight = 0.6, -- 50 rounds.
		count = 50,
	},
	{
		name = ".300 AAC Blackout Box",
		weight = 0.3, -- 20 rounds.
		count = 20,
	},
	{
		name = ".308 Winchester Box",
		weight = 0.25, -- 20 rounds.
		count = 20,
	},
	{
		name = ".357 Magnum Box",
		weight = 0.3, -- 20 rounds.
		count = 20,
	},
	{
		name = "5.56mm NATO Box",
		weight = 1.25, -- 20 rounds.
		count = 20,
	},
	{
		name = "7.62x39mm FMJ Box",
		weight = 0.35, -- 20 rounds.
		count = 20,
	},
}

local magazines = {
	{
		name = "9mm Magazine",
		ammo = "9mm Parabellum",
		weight = 0.45,
		count = 30,
	},
	{
		name = ".22 Magazine",
		ammo = ".22 LR",
		weight = 0.164,
		count = 20,
	},
	{
		name = ".30-06 Magazine",
		ammo = ".30-06 Springfield",
		weight = 0.334,
		count = 20,
	},
	{
		name = ".38 Magazine",
		ammo = ".38 Special",
		weight = 0.366,
		count = 20,
	},
	{
		name = ".40 Magazine",
		ammo = ".40 S&W",
		weight = 0.43,
		count = 20,
	},
	{
		name = ".45 Magazine",
		ammo = ".45 ACP",
		weight = 0.468,
		count = 20,
	},
	{
		name = ".50 Magazine",
		ammo = ".50 BMG",
		weight = 0.94,
		count = 20,
	},
	{
		name = ".223 Magazine",
		ammo = ".223 Remington",
		weight = 0.328,
		count = 20,
	},
	{
		name = ".300 Magazine",
		ammo = ".300 AAC Blackout",
		weight = 0.38,
		count = 20,
	},
	{
		name = ".308 Magazine",
		ammo = ".308 Winchester",
		weight = 0.32,
		count = 20,
	},
	{
		name = ".357 Magazine",
		ammo = ".357 Magnum",
		weight = 0.38,
		count = 20,
	},
	{
		name = "5.56mm Magazine",
		ammo = "5.56mm NATO",
		weight = 1.96,
		count = 30,
	},
	{
		name = "7.62x39mm Magazine",
		ammo = "7.62x39mm FMJ",
		weight = 0.54,
		count = 30,
	},
	{
		name = "Taser Cartridge",
		description = "Replacement cartridge for a taser",
		weight = 0.02,
	},
}

for _, ammo in ipairs(bullets) do
	ammo.category = "Ammo"
	ammo.stack = 128
	ammo.usable = "Ammo"
	ammo.model = "prop_ld_ammo_pack_01"

	RegisterItem(ammo)
end

for _, ammo in ipairs(boxes) do
	ammo.category = "Ammo"
	ammo.stack = 32
	ammo.usable = "Ammo Box"
	ammo.model = "prop_ld_ammo_pack_02"
	ammo.pack = "box"

	RegisterItem(ammo)
end

for _, ammo in ipairs(magazines) do
	ammo.category = "Ammo"
	ammo.stack = 1
	ammo.usable = "Magazine"
	ammo.model = "prop_ld_ammo_pack_01"
	ammo.fields = ammo.fields or {
		[1] = {
			name = "Ammo",
			default = 0,
		}
	}

	RegisterItem(ammo)
end