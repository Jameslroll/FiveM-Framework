Shooting = {}

--[[ Functions: Shooting ]]--
function Shooting:UpdateShooting(weapon)
	local ped = PlayerPedId()

	if not IsPedShooting(ped) and not weapon then return false end

	if not weapon then
		local hasWeapon, _weapon = GetCurrentPedWeapon(ped)
		weapon = _weapon
	end

	if not weapon or weapon == `WEAPON_UNARMED` then return false end
	
	-- Update recoil.
	self:UpdateRecoil()

	-- Update cache.
	self.lastShot = GetGameTimer()
	self.shotTime = (self.shotTime or 0) + 200

	-- Update ammo.
	State.ammo = State.debug and 100 or math.max((State.ammo or 0) - 1, 0)
	State:UpdateAmmo()

	return true
end

function Shooting:UpdateHit(weapon)
	local ped = PlayerPedId()

	-- Check last shot.
	if not self.lastShot or self.lastShot == self.lastSync then return false end

	-- Update weapon.
	if not weapon then
		local hasWeapon, _weapon = GetCurrentPedWeapon(ped)
		weapon = _weapon
	end

	if not weapon or weapon == `WEAPON_UNARMED` then return false end

	-- Get shooting/coords.
	local coords = GetFinalRenderedCamCoord()
	local didHit, hitCoords = GetPedLastWeaponImpactCoord(ped)
	didHit = didHit == 1

	-- Wait for hits.
	if not didHit and GetGameTimer() - self.lastShot < 400 then
		return false
	end
	
	-- Trigger events.
	local slot = State.currentSlot
	
	TriggerEvent("shoot", didHit, coords, hitCoords, entity, hasWeapon and weapon)
	TriggerServerEvent("shoot", didHit, coords, hitCoords, entity ~= 0 and NetworkGetEntityIsNetworked(entity) and NetworkGetNetworkIdFromEntity(entity), hasWeapon and weapon, slot and slot.slot_id)

	-- Cache time.
	self.lastSync = self.lastShot
end

function Shooting:UpdateRecoil()
	local ped = PlayerPedId()
	local coords = GetEntityCoords(ped)
	local inVehicle = IsPedInAnyVehicle(ped)
	local ratio = math.min(self.shotTime / 1000, 1.0)
	local offset = 0.0
	
	if IsPedSprinting(ped) or IsPedRunning(ped) then
		offset = 1.0
	elseif IsPedWalking(ped) then
		offset = 0.5
	end

	local hasWeapon, weapon = GetCurrentPedWeapon(ped)
	local strength = (GetRandomFloatInRange(1.0, 2.0) + ratio * 1.5 + offset * 1.5) * (Config.Recoil[weapon] or 1.0)
	local horizontal = 0.2
	local recoil = GetRandomFloatInRange(0.0, 1.0)
	local cameraDistance = #(GetGameplayCamCoord() - coords)

	cameraDistance = cameraDistance < 5.3 and 1.5 or cameraDistance < 8.0 and 4.0 or 7.0
	recoil = (inVehicle and recoil * cameraDistance or recoil * 0.8) * strength

	local pitch = GetGameplayCamRelativePitch()
	local heading = GetGameplayCamRelativeHeading()
	local direction = GetRandomIntInRange(0, 2) * 2.0 - 1.0

	SetGameplayCamRelativeHeading(heading + recoil * direction * horizontal)
	SetGameplayCamRelativePitch(pitch + recoil, 0.8)
end

function Shooting:Update()
	local ped = PlayerPedId()

	local delta = self.lastUpdate and (GetGameTimer() - self.lastUpdate) or 0
	local force = false
	local isBomb = GetIsTaskActive(ped, 432)

	if isBomb and not self.isBombing then
		self.isBombing = true
	elseif not isBomb and self.isBombing then
		force = `WEAPON_STICKYBOMB`
		self.isBombing = nil
	end

	if not self:UpdateShooting(force) then
		if IsPedReloading(ped) then
			self.shotTime = 0.0
		else
			self.shotTime = self.shotTime and math.max(self.shotTime - delta * 2.0, 0) or 0
		end
	end

	self:UpdateHit(force)

	self.lastUpdate = GetGameTimer()
end

--[[ Threads ]]--
Citizen.CreateThread(function()
	while true do
		Shooting:Update()

		Citizen.Wait(0)
	end
end)