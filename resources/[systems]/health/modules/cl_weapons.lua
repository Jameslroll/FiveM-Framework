--[[ Damage Types --
	0 = unknown (or incorrect weaponHash)
	1 =  no damage (flare,snowball, petrolcan)
	2 = melee
	3 = bullet
	4 = force ragdoll fall
	5 = explosive (RPG, Railgun, grenade)
	6 = fire(molotov)
	8 = fall(WEAPON_HELI_CRASH)
	10 = electric
	11 = barbed wire
	12 = extinguisher
	13 = gas
	14 = water cannon(WEAPON_HIT_BY_WATER_CANNON)
]]--

local funcs = {
	[2] = function(bone, weapon, weaponDamage) -- Melee.
		local isSharp = exports.weapons:IsWeaponSharp(weapon)
		local damageRatio = GetRandomFloatInRange(isSharp and 0.4 or 0.1, isSharp and 0.6 or 0.2)
		
		bone:TakeDamage(damageRatio, isSharp and "Stab" or "Bruising")

		local health = Main:GetHealth()
		if isSharp then
			bone:ApplyBleed(damageRatio * 1.5)
		elseif health < 0.3 and health > 0.001 and not IsPedRagdoll(Ped) then
			SetPedToRagdoll(Ped, GetRandomIntInRange(12000, 16000))
		end
	end,
	[3] = function(bone, weapon, weaponDamage) -- Bullets.
		local damageRatio = weaponDamage / 100.0
	
		bone:TakeDamage(damageRatio, "Gunshot")
		bone:ApplyBleed(damageRatio * 1.2)
	end,
	[5] = function(bone, weapon, weaponDamage) -- Explosions.
		bone:SpreadDamage(0.4, 0.3, 0.6, "3rd Degree Burn")
		bone:ApplyBleed(1.0)

		Main:AddEffect("Concussion", 1.0)
		Main:AddEffect("Blood", GetRandomFloatInRange(0.3, 0.4))
	end,
	[6] = function(bone, weapon, weaponDamage) -- Fire.
		if GetGameTimer() - (Main.lastFireDamage or 0) < 1000 then
			return
		end

		Main.lastFireDamage = GetGameTimer()

		bone = Main:GetRandomBone()
		bone:TakeDamage(GetRandomFloatInRange(0.2, 0.4), "2nd Degree Burn")
	end,
	[10] = function(bone, weapon, weaponDamage) -- Electric.
		if weapon == `WEAPON_STUNGUN` then
			bone:TakeDamage(GetRandomFloatInRange(0.1, 0.2), "1st Degree Burn")
			bone:ApplyBleed(GetRandomFloatInRange(0.1, 0.2))

			Main:AddEffect("Fatigue", GetRandomFloatInRange(0.2, 0.3))
		end
	end,
	[13] = function(bone, weapon, weaponDamage) -- Gas.
		if GetGameTimer() - (Main.lastGasDamage or 0) < 1000 then
			return
		end

		Main.lastGasDamage = GetGameTimer()

		ShakeGameplayCam("SMALL_EXPLOSION_SHAKE", GetRandomFloatInRange(0.2, 0.4))

		Main:AddEffect("Oxygen", GetRandomFloatInRange(0.2, 0.4))

		Citizen.CreateThread(function()
			local startTime = GetGameTimer()

			if not Main.offsetY then
				Main.offsetY = GetRandomFloatInRange(0.0, math.pi * 2.0)
			end

			while GetGameTimer() - startTime < 1000 do
				Main.offsetX = (Main.offsetX or 0.0) + GetRandomFloatInRange(0.0, 0.1)
				Main.offsetY = (Main.offsetY or 0.0) + GetRandomFloatInRange(0.0, 0.1)

				local x = math.cos(GetGameTimer() / 500.0 + Main.offsetX) * 0.5
				local y = math.sin(GetGameTimer() / 500.0 + Main.offsetY) * 0.5

				SetControlNormal(0, 1, x)
				SetControlNormal(0, 2, y)

				Citizen.Wait(0)
			end
		end)
	end,
}

function Main.update:Fire()
	local isOnFire = not Injury.isInjured and IsEntityOnFire(Ped)
	if self.isOnFire ~= isOnFire then
		if isOnFire then
			Config.Anims.Burning.Force = true
			self.burningEmote = exports.emotes:Play(Config.Anims.Burning)
		elseif self.burningEmote then
			exports.emotes:Stop(self.burningEmote)
			self.burningEmote = nil
		end

		self.isOnFire = isOnFire
	end
end

Main:AddListener("TakeDamage", function(weapon, boneId, data)
	if not IsWeaponValid(weapon) then return end
	
	local bone = Main:GetBone(boneId)
	if not bone then
		error(("no bone id (%s)"):format(boneId))
	elseif bone.lastWeaponDamaged == weapon and GetGameTimer() - (bone.lastDamage or 0) < 50 then
		print("damage too soon, ignoring")
		return
	end
	
	local weaponDamage = GetWeaponDamage(weapon) or 0.0
	local damageType = GetWeaponDamageType(weapon) or 0
	local func = funcs[damageType]

	print("damage type", damageType, "bone", bone and bone.Name)

	bone.lastWeaponDamaged = weapon

	if func then
		func(bone, weapon, weaponDamage)
	end
end)