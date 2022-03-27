Config = {
	Animations = {
		["1h"] = {
			Holster = {
				Dict = "weapons@holster_1h",
				Name = "holster",
				Flag = 48,
				BlendSpeed = 8.0,
				Rate = 0.0,
				IgnoreCancel = true,
			},
			Unholster = {
				Dict = "weapons@holster_1h",
				Name = "unholster",
				Flag = 48,
				BlendSpeed = 8.0,
				Rate = 0.0,
				IgnoreCancel = true,
			},
		},
		["2h"] = {
			Holster = {
				Dict = "anim@heists@money_grab@duffel",
				Name = "exit",
				Flag = 48,
				BlendIn = 8.0,
				BlendOut = 2.0,
				Rate = 0.3,
				Duration = 500,
				IgnoreCancel = true,
				
			},
			Unholster = {
				Dict = "anim@heists@money_grab@duffel",
				Name = "enter",
				Flag = 48,
				BlendIn = 8.0,
				BlendOut = 2.0,
				Rate = 0.0,
				Duration = 1200,
				IgnoreCancel = true,
			},
		},
	},
	Reloading = {
		Anim = {
			Dict = "anim@amb@range@load_clips@",
			Name = "idle_02_amy_skater_01",
			Flag = 48,
			BlendSpeed = 6.0,
			Duration = 3000,
		}
	},
	Previews = {
		["lback"] = {
			Bone = 0x60F0,
			Offset = vector3(0.0, -0.18, -0.1),
			Rotation = vector3(0.0, -30.0, 180.0),
			Stack = vector3(0.0, -0.03, 0.0),
			Random = {
				Min = vector3(-4.0, 0.0, -2.0),
				Max = vector3(4.0, 5.0, 2.0),
			},
		},
		["back"] = {
			Bone = 0x60F1,
			Offset = vector3(0.0, -0.14, 0.05),
			Rotation = vector3(0.0, 15.0, 0.0),
			Stack = vector3(0.0, -0.03, 0.0),
			Random = {
				Min = vector3(-6.0, 0.0, -2.0),
				Max = vector3(6.0, 35.0, 2.0),
			},
		},
		["chest"] = {
			Bone = 0x60F0,
			Offset = vector3(0.0, 0.175, 0.0),
			Rotation = vector3(180.0, 235.0, 0.0),
			Stack = vector3(0.0, 0.025, 0.0),
			Random = {
				Min = vector3(0.0, -22.5, 0.0),
				Max = vector3(0.0, 0.0, 0.0),
			},
		},
		["hip1"] = {
			Bone = 0x60F1,
			Offset = vector3(0.0, 0.04, 0.18),
			Rotation = vector3(-90.0, 0.0, 200.0),
			Stack = vector3(0.0, 0.0, 0.025),
		},
		["hip2"] = {
			Bone = 0x60F2,
			Offset = vector3(0.0, 0.15, 0.18),
			Rotation = vector3(-90.0, 0.0, 130.0),
			Stack = vector3(0.0, 0.0, 0.025),
		},
	},
	Loading = {
		Duration = 6000,
		Anim = {
			Duration = 6000,
			Dict = "anim@amb@range@load_clips@",
			Name = "idle_01_amy_skater_01",
			Flag = 48,
			-- Sequence = {
			-- 	{
			-- 		Duration = 6000,
			-- 		Dict = "anim@amb@range@load_clips@",
			-- 		Name = "idle_01_amy_skater_01",
			-- 		Flag = 48,
			-- 		Secondary = {
			-- 			Dict = "anim@amb@business@weed@weed_inspecting_lo_med_hi@",
			-- 			Name = "weed_stand_checkingleaves_kneeling_02_inspector",
			-- 			Flag = 0,
			-- 			Rate = 0.05,
			-- 		}
			-- 	},
			-- 	{
			-- 		Duration = 3000,
			-- 		Dict = "amb@medic@standing@kneel@exit",
			-- 		Name = "exit",
			-- 		Flag = 0,
			-- 	},
			-- }
		},
	},
	Groups = {
		[970310034] = {
			Name = "Assault Rifle",
			Anim = "2h",
			Preview = "back",
			Class = 3,
			Dispatch = "brandish3",
		},
		[416676503] = {
			Name = "Handguns",
			Anim = "1h",
			Class = 1,
			Dispatch = "brandish1",
		},
		[-1569042529] = {
			Name = "Heavy Weapon",
			Anim = "2h",
			Preview = "back",
			Class = 4,
			Dispatch = "brandish3",
		},
		[1159398588] = {
			Name = "Light Machine Gun",
			Anim = "2h",
			Preview = "back",
			Class = 3,
			Dispatch = "brandish3",
		},
		-- [2685387236] = {
		-- 	Name = "Melee",
		-- 	Anim = "1h",
		-- 	Class = 0,
		-- },
		[-1609580060] = {
			Name = "Small Melee",
			Anim = "1h",
			Class = 0,
		},
		[-728555052] = {
			Name = "Large Melee",
			Anim = "2h",
			Class = 0,
		},
		[4257178988] = {
			Name = "Misc",
			Anim = "1h",
			Class = 0,
		},
		[860033945] = {
			Name = "Shotgun",
			Anim = "2h",
			Preview = "back",
			Class = 2,
			Dispatch = "brandish2",
		},
		[-1212426201] = {
			Name = "Sniper",
			Anim = "2h",
			Preview = "back",
			Class = 4,
			Dispatch = "brandish3",
		},
		[-957766203] = {
			Name = "Submachine Gun",
			Anim = "2h",
			Preview = "back",
			Class = 2,
			Dispatch = "brandish2",
		},
		[1548507267] = {
			Name = "Throwable",
			Anim = "1h",
			Class = 0,
		},
	},
	Sharp = {
		[`WEAPON_BATTLEAXE`] = true,
		[`WEAPON_BOTTLE`] = true,
		[`WEAPON_DAGGER`] = true,
		[`WEAPON_HATCHET`] = true,
		[`WEAPON_KNIFE`] = true,
		[`WEAPON_MACHETE`] = true,
		[`WEAPON_SWITCHBLADE`] = true,
	},
	Recoil = {
		[`WEAPON_MINIGUN`] = 0.02,
	},
}

exports("GetWeaponGroup", function(group)
	if not group then
		group = GetWeapontypeGroup(GetSelectedPedWeapon(PlayerPedId()))
	end

	return Config.Groups[group or false]
end)

exports("IsWeaponSharp", function(weapon)
	return Config.Sharp[weapon] == true
end)