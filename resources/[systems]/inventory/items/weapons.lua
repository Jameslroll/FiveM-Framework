local melee = {
	{
		name = "Antique Cavalry Dagger",
		weapon = `WEAPON_DAGGER`,
		weight = 2,
		model = "w_me_dagger",
	},
	{
		name = "Baseball Bat",
		weapon = {
			hash = `WEAPON_BAT`,
			preview = { "back", vector3(0, 90, 0) },
		},
		weight = 1,
		model = "w_me_bat",
	},
	{
		name = "Battle Axe",
		weapon = {
			hash = `WEAPON_BATTLEAXE`,
			preview = "hip2",
		},
		weight = 2,
		model = "w_me_battleaxe",
	},
	{
		name = "Broken Bottle",
		weapon = `WEAPON_BOTTLE`,
		weight = 0.5,
		model = { "w_me_bottle", vector3(-90.0, 0.0, 0.0), vector3(0.0, 0.0, 0.03) },
	},
	{
		name = "Crowbar",
		weapon = `WEAPON_CROWBAR`,
		weight = 0.6,
		model = "w_me_crowbar",
	},
	{
		name = "Hammer",
		weapon = `WEAPON_HAMMER`,
		weight = 0.45,
		model = "w_me_hammer",
	},
	{
		name = "Hatchet",
		weapon = `WEAPON_HATCHET`,
		weight = 0.6,
		model = "w_me_hatchet",
	},
	{
		name = "Flashlight",
		weapon = `WEAPON_FLASHLIGHT`,
		weight = 1,
		model = "w_me_flashlight",
	},
	{
		name = "Golf Club",
		weapon = {
			hash = `WEAPON_GOLFCLUB`,
			preview = { "back", vector3(0, 90, 0) },
		},
		weight = 0.3,
		model = "w_me_gclub",
	},
	{
		name = "Knife",
		weapon = `WEAPON_KNIFE`,
		weight = 1.5,
		model = { "w_me_knife_01", vector3(-90.0, 0.0, 0.0), vector3(0.0, 0.0, 0.03) },
	},
	{
		name = "Knuckle Dusters",
		weapon = `WEAPON_KNUCKLE`,
		weight = 0.1,
		model = "w_me_knuckle",
	},
	{
		name = "Machete",
		weapon = {
			hash = `WEAPON_MACHETE`,
			preview = "hip2",
		},
		weight = 1.1,
		model = { "w_me_machette_lr", vector3(-90.0, 0.0, 0.0), vector3(0.0, 0.0, 0.03) },
	},
	{
		name = "Nightstick",
		weapon = `WEAPON_NIGHTSTICK`,
		weight = 0.5,
		model = "w_me_nightstick",
	},
	{
		name = "Pipe Wrench",
		weapon = {
			hash = `WEAPON_WRENCH`,
			preview = { "back", vector3(0, 90, 0) },
		},
		weight = 8,
		model = "w_me_wrench",
	},
	{
		name = "Switchblade",
		weapon = `WEAPON_SWITCHBLADE`,
		description = "Type of knife with a folding or sliding blade",
		weight = 0.6,
	},
	{
		name = "Pool Cue",
		weapon = {
			hash = `WEAPON_POOLCUE`,
			preview = { "back", vector3(0, 90, 0) },
		},
		weight = 0.6,
		model = { "w_me_poolcue", vector3(-90.0, 0.0, 0.0), vector3(0.0, 0.0, 0.03) },
	},
}

local throwables = {
	{
		name = "Snowball",
		weapon = `WEAPON_SNOWBALL`,
		description = "Spherical object made from snow, usually created by scooping snow with the hands, and pressing the snow together ",
		ammo = "9mm",
		weight = 0.1,
		stack = 16,
	},
	{
		name = "Ball",
		weapon = `WEAPON_BALL`,
		description = "Commonly used in the sport known as Baseball",
		weight = 0.15,
	},
	{
		name = "Flare",
		weapon = `WEAPON_FLARE`,
		weight = 0.25,
	},
	{
		name = "Grenade",
		weapon = `WEAPON_GRENADE`,
		weight = 0.5,
		model = "w_ex_grenadefrag",
	},
	{
		name = "Molotov Cocktail",
		weapon = `WEAPON_MOLOTOV`,
		weight = 0.5,
	},
	{
		name = "Pipe Bomb",
		weapon = `WEAPON_PIPEBOMB`,
		weight = 0.5,
	},
	{
		name = "Sticky Bomb",
		weapon = `WEAPON_STICKYBOMB`,
		description = "Explosive device that rely on some sort of adhesive to remain on the target",
		weight = 0.5,
	},
	{
		name = "Tear Gas",
		weapon = `WEAPON_SMOKEGRENADE`,
		description = "Chemical weapon that stimulates the nerves of the lacrimal gland in the eye to produce tears",
		weight = 0.5,
		model = "w_ex_grenadesmoke",
	},
}

local guns = {
	{
		name = "Stun Gun",
		weapon = `WEAPON_STUNGUN`,
		description = "Delivers an electric shock aimed at temporarily disrupting muscle functions and/or inflicting pain without usually causing significant injury",
		ammo = "Taser",
		weight = 0.2,
	},
	{
		name = "Assault Rifle Mk II",
		weapon = `WEAPON_ASSAULTRIFLE_MK2`,
		ammo = "7.62x39mm",
		weight = 3.3,
	},
	{
		name = "Assault Shotgun",
		weapon = `WEAPON_ASSAULTSHOTGUN`,
		ammo = "12ga",
		weight = 3.1,
	},
	{
		name = "Assault SMG",
		weapon = `WEAPON_ASSAULTSMG`,
		ammo = "9mm",
		weight = 1.4,
	},
	{
		name = "Bullpup Rifle",
		weapon = `WEAPON_BULLPUPRIFLE`,
		ammo = "5.56mm",
		weight = 3.25,
	},
	{
		name = "Bullpup Rifle Mk II",
		weapon = `WEAPON_BULLPUPRIFLE_MK2`,
		ammo = "5.56mm",
		weight = 3.8,
	},
	{
		name = "Bullpup Shotgun",
		weapon = `WEAPON_BULLPUPSHOTGUN`,
		ammo = "12ga",
		weight = 3.1,
	},
	{
		name = "Carbine Rifle Mk II",
		weapon = `WEAPON_CARBINERIFLE_MK2`,
		ammo = "5.56mm",
		weight = 2.75,
	},
	{
		name = "Combat PDW",
		weapon = `WEAPON_COMBATPDW`,
		ammo = "9mm",
		weight = 2.7,
	},
	{
		name = "Double Action Revolver",
		weapon = `WEAPON_DOUBLEACTION`,
		ammo = ".38",
		weight = 1,
	},
	{
		name = "Double Barrel Shotgun",
		weapon = `WEAPON_DBSHOTGUN`,
		ammo = "12ga",
		weight = 1.5,
	},
	{
		name = "Flare Gun",
		weapon = `WEAPON_FLAREGUN`,
		ammo = "flare",
		weight = 0.5,
	},
	{
		name = "Gusenberg Sweeper",
		weapon = `WEAPON_GUSENBERG`,
		ammo = "9mm",
		weight = 4.5,
	},
	{
		name = "Heavy Revolver",
		weapon = `WEAPON_REVOLVER`,
		ammo = ".223",
		weight = 2,
	},
	{
		name = "Heavy Revolver Mk II",
		weapon = `WEAPON_REVOLVER_MK2`,
		ammo = ".223",
		weight = 2.2,
	},
	{
		name = "Heavy Sniper",
		weapon = `WEAPON_HEAVYSNIPER`,
		ammo = ".50",
		weight = 13.5,
		model = { "w_sr_heavysniper", vector3(90.0, 0.0, 0.0) },
	},
	{
		name = "Machine Pistol",
		weapon = {
			hash = `WEAPON_MACHINEPISTOL`,
			preview = "hip1",
		},
		ammo = "9mm",
		weight = 1.2,
	},
	{
		name = "Marksman Rifle",
		weapon = `WEAPON_MARKSMANRIFLE`,
		ammo = "7.62x39mm",
		weight = 7.5,
	},
	{
		name = "Marksman Rifle Mk II",
		weapon = `WEAPON_MARKSMANRIFLE_MK2`,
		ammo = "7.62x39mm",
		weight = 7.2,
	},
	{
		name = "Micro SMG",
		weapon = {
			hash = `WEAPON_MICROSMG`,
			preview = "chest",
		},
		ammo = "9mm",
		weight = 3.5,
		model = { "w_sb_microsmg", vector3(90.0, 0.0, 0.0) },
	},
	{
		name = "Musket",
		weapon = `WEAPON_MUSKET`,
		ammo = ".40",
		weight = 4,
	},
	{
		name = "Pistol Mk II",
		weapon = `WEAPON_PISTOL_MK2`,
		ammo = ".45",
		weight = 1,
	},
	{
		name = "Pistol 50",
		weapon = `WEAPON_PISTOL50`,
		ammo = ".50",
		weight = 2,
	},
	{
		name = "Beanbag Shotgun",
		weapon = `WEAPON_PUMPSHOTGUN`,
		ammo = "12ga",
		weight = 2.5,
	},
	{
		name = "Pump Shotgun",
		weapon = `WEAPON_PUMPSHOTGUN_MK2`,
		ammo = "12ga",
		weight = 3.5,
	},
	{
		name = "Sawed-Off Shotgun",
		weapon = `WEAPON_SAWNOFFSHOTGUN`,
		ammo = "12ga",
		weight = 1.5,
	},
	{
		name = "SMG Mk II",
		weapon = `WEAPON_SMG_MK2`,
		ammo = "9mm",
		weight = 2,
	},
	{
		name = "SNS Pistol Mk II",
		weapon = `WEAPON_SNSPISTOL_MK2`,
		ammo = "9mm",
		weight = 0.5,
	},
	{
		name = "Special Carbine",
		weapon = `WEAPON_SPECIALCARBINE`,
		ammo = "5.56mm",
		weight = 3.7,
		model = { "w_ar_specialcarbine", vector3(90.0, 0.0, 0.0) },
	},
	{
		name = "Special Carbine Mk II",
		weapon = `WEAPON_SPECIALCARBINE_MK2`,
		ammo = "5.56mm",
		weight = 3.3,
	},
	{
		name = "Sweeper Shotgun",
		weapon = `WEAPON_AUTOSHOTGUN`,
		ammo = "12ga",
		weight = 4.5,
	},
	{
		name = "Vintage Pistol",
		weapon = `WEAPON_VINTAGEPISTOL`,
		ammo = "9mm",
		weight = 0.6,
	},
	{
		name = "Combat Shotgun",
		weapon = `WEAPON_COMBATSHOTGUN`,
		ammo = "12ga",
		weight = 0.6,
	},
	{
		name = "Minigun",
		weapon = {
			hash = `WEAPON_MINIGUN`,
			preview = "lback",
		},
		ammo = "7.62mm",
		weight = 19,
		model = "w_mg_minigun",
	},
	{
		name = "RPG",
		weapon = `WEAPON_RPG`,
		ammo = "rocket",
		weight = 2,
	},
	-- Custom weapons.
	{
		name = "G17",
		weapon = `WEAPON_COMBATPISTOL`,
		ammo = "9mm",
		weight = 0.6,
		model = { "w_pi_combatpistol", vector3(90.0, 0.0, 0.0) },
	},
	{
		name = "AK-74U",
		weapon = `WEAPON_COMPACTRIFLE`,
		ammo = "7.62x39mm",
		weight = 3.5,
		model = { "w_ar_assaultrifle_smg", vector3(90.0, 0.0, 0.0) },
	},
	{
		name = "M9",
		weapon = `WEAPON_PISTOL`,
		ammo = "9mm",
		weight = 1,
		model = { "w_pi_pistol", vector3(90.0, 0.0, 0.0) },
	},
	{
		name = "M249",
		weapon = `WEAPON_COMBATMG`,
		ammo = "5.56mm",
		weight = 8.2,
		model = { "w_mg_combatmg", vector3(90.0, 0.0, 0.0) },
	},
	{
		name = "M700",
		weapon = `WEAPON_SNIPERRIFLE`,
		ammo = ".50",
		weight = 6.5,
		model = { "w_sr_sniperrifle", vector3(90.0, 0.0, 0.0) },
	},
	{
		name = "M1911",
		weapon = `WEAPON_HEAVYPISTOL`,
		ammo = "9mm",
		weight = 1.1,
		model = { "w_pi_heavypistol", vector3(90.0, 0.0, 0.0) },
	},
	{
		name = "MP5A3",
		weapon = `WEAPON_SMG`,
		ammo = "9mm",
		weight = 3,
		model = { "w_sb_smg", vector3(90.0, 0.0, 0.0) },
	},
	{
		name = "PKM",
		weapon = `WEAPON_MG`,
		ammo = "7.62x39mm",
		weight = 7.5,
		model = { "w_mg_mg", vector3(90.0, 0.0, 0.0) },
	},
	{
		name = "PM",
		weapon = `WEAPON_SNSPISTOL`,
		ammo = "9mm",
		weight = 0.75,
		model = { "w_pi_sns_pistol", vector3(90.0, 0.0, 0.0) },
	},
	{
		name = "Saiga 12g",
		weapon = `WEAPON_HEAVYSHOTGUN`,
		ammo = "12ga",
		weight = 7.7,
		model = { "w_sg_heavyshotgun", vector3(90.0, 0.0, 0.0) },
	},
	{
		name = "Skorpion",
		weapon = {
			hash = `WEAPON_MINISMG`,
			preview = "hip1",
		},
		ammo = "9mm",
		weight = 1.5,
		model = { "w_sb_minismg", vector3(90.0, 0.0, 0.0) },
	},
	{
		name = "TAR-21",
		weapon = `WEAPON_ADVANCEDRIFLE`,
		ammo = "5.56mm",
		weight = 3.6,
		model = { "w_ar_advancedrifle", vector3(90.0, 0.0, 0.0) },
	},
	{
		name = "G18C",
		weapon = `WEAPON_APPISTOL`,
		ammo = "9mm",
		weight = 1,
		model = { "w_pi_appistol", vector3(90.0, 0.0, 0.0) },
	},
	{
		name = "AK-47",
		weapon = `WEAPON_ASSAULTRIFLE`,
		ammo = "7.62x39mm",
		weight = 3.5,
		model = { "w_ar_assaultrifle", vector3(90.0, 0.0, 0.0) },
	},
	{
		name = "M4A1",
		weapon = `WEAPON_CARBINERIFLE`,
		ammo = "5.56mm",
		weight = 3,
		model = { "w_ar_carbinerifle", vector3(90.0, 0.0, 0.0) },
	},
	-- Addon weapons.
	{
		name = "AK-12",
		weapon = `WEAPON_AK12`,
		ammo = "7.62x39mm",
		weight = 3.3,
		model = { "w_ar_ak12", vector3(90.0, 0.0, 0.0) },
	},
	{
		name = "Galil",
		weapon = ``,
		ammo = "7.62x39mm",
		weight = 3.95,
		model = { "w_ar_galil", vector3(90.0, 0.0, 0.0) },
	},
	{
		name = "AR-15",
		weapon = `WEAPON_GALIL`,
		ammo = "5.56mm",
		weight = 3.0,
		model = { "w_ar_fbiarb", vector3(90.0, 0.0, 0.0) },
	},
	{
		name = "P226",
		weapon = `WEAPON_P226`,
		ammo = "9mm",
		weight = 3.0,
		model = { "w_pi_p226", vector3(90.0, 0.0, 0.0) },
	},
	{
		name = "RPK",
		weapon = `WEAPON_RPK`,
		ammo = "7.62x39mm",
		weight = 3.0,
		model = { "w_ar_rpk", vector3(90.0, 0.0, 0.0) },
	},
	{
		name = "SIG516",
		weapon = `WEAPON_SIG516`,
		ammo = "5.56mm",
		weight = 3.0,
		model = { "w_ar_sig516", vector3(90.0, 0.0, 0.0) },
	},
}

local other = {
	{
		name = "Jerry Can",
		weapon = `WEAPON_PETROLCAN`,
		weight = 4.5,
		model = "w_am_jerrycan",
	},
	{
		name = "Fire Extinguisher",
		weapon = `WEAPON_FIREEXTINGUISHER`,
		weight = 5.0,
	},
	{
		name = "Parachute",
		weapon = `GADGET_PARACHUTE`,
		weight = 5,
	},
	{
		name = "Night Vision",
		weapon = `GADGET_NIGHTVISION`,
		weight = 3,
	},
}

for _, weapon in ipairs(melee) do
	weapon.category = "Melee"
	weapon.usable = "Weapon"
	weapon.stack = 1
	weapon.visible = weapon.visible or 1

	RegisterItem(weapon)
end

for _, weapon in ipairs(throwables) do
	weapon.category = "Throwable"
	weapon.usable = "Weapon"
	weapon.stack = weapon.stack or 1
	weapon.visible = weapon.visible or 1

	RegisterItem(weapon)
end

for _, weapon in ipairs(guns) do
	weapon.category = "Gun"
	weapon.usable = "Weapon"
	weapon.stack = 1
	weapon.visible = weapon.visible or 1

	weapon.fields = {
		[1] = {
			name = "Ammo",
			default = -1,
		},
		[2] = {
			default = nil,
			hidden = true,
		}
	}

	RegisterItem(weapon)
end

for _, weapon in ipairs(other) do
	weapon.usable = "Weapon"
	weapon.stack = 1
	weapon.visible = weapon.visible or 1

	RegisterItem(weapon)
end