State = {}

function State:Update()
	local ped = PlayerPedId()
	local player = PlayerId()

	-- Automatically unequip.
	local hasWeapon, weapon = GetCurrentPedWeapon(ped)
	if self.equipped and weapon ~= self.equipped then
		self:Remove()
	end

	-- Must be aiming to attack.
	local isAiming = IsControlPressed(0, 25)
	local invertAiming = self.equipped == `WEAPON_STICKYBOMB`
	if (not isAiming and not invertAiming) or (isAiming and invertAiming) then
		DisablePlayerFiring(player)
	end

	-- Finish reloading.
	if self.reloading and not IsPedReloading(ped) then
		self.reloading = nil
		self:UpdateAmmo()
	end

	-- Reloading.
	if not self.reloading and IsControlJustPressed(0, 45) then
		self:TryReload()
	end
end

function State:Equip(item, slot)
	-- For infinite ammo.
	self.debug = exports.inventory:HasItem("Orb of Bias")

	-- Check equipping.
	if self.equipping then return end

	-- Get weapon hash.
	local isWeaponTable = type(item.weapon) == "table"
	local weapon = isWeaponTable and item.weapon.hash or item.weapon

	-- Check equipped.
	if self.equipped and self.equipped ~= weapon then
		self:Equip(self.item)
		Citizen.Wait(1000)
	end

	-- Cache item.
	self.item = item
	
	-- Get group settings.
	local _group = GetWeapontypeGroup(weapon)
	local group = Config.Groups[_group] or {}
	self.group = group
	
	print("group", _group, json.encode(group))

	-- Check equip.
	local isEquipped = self.equipped == weapon

	-- Unequip.
	if isEquipped then
		self:Remove()
		
		slot = self.currentSlot
		self.currentSlot = nil

		if slot then
			Preview:UpdateSlot(slot.slot_id, slot.id, item)
		end
	end
	
	-- Do animation.
	local animation = Config.Animations[group.Anim or "1h"]
	local duration = 0
	
	if animation ~= nil then
		-- Find animation.
		if isEquipped then
			animation = animation.Holster
		else
			animation = animation.Unholster
		end

		-- Get duration.
		duration = animation.Duration or math.floor(GetAnimDuration(animation.Dict, animation.Name) * 1000)
	end

	Citizen.CreateThread(function()
		if animation ~= nil then
			State.equipping = true
	
			exports.emotes:Play(animation)
	
			local startTime = GetGameTimer()

			while duration ~= nil and GetGameTimer() - startTime < duration do
				DisableControlAction(0, 24)
				DisableControlAction(0, 25)
				
				Citizen.Wait(0)
			end
	
			State.equipping = false
		end
		
		-- Equip.
		if not isEquipped then
			if slot ~= nil then
				State.currentSlot = slot
				Preview:ClearSlot(tonumber(slot.slot_id), slot.id, exports.inventory:GetItem(slot.item_id))
			end
			
			State:Set(weapon)
	
			local ped = PlayerPedId()
			for componentHash, component in pairs(ComponentHashes) do
				if DoesWeaponTakeWeaponComponent(weapon, componentHash) then
					-- GiveWeaponComponentToPed(PlayerPedId(), weapon, componentHash)
					RemoveWeaponComponentFromPed(ped, weapon, componentHash)
				end
			end
		end
	end)

	return duration
end

function State:Remove(skipUpdate)
	local ped = PlayerPedId()
	SetCurrentPedWeapon(ped, `WEAPON_UNARMED`, true)
	RemoveAllPedWeapons(ped, true)

	local slot = self.currentSlot
	if slot ~= nil and not skipUpdate then
		Preview:UpdateSlot(tonumber(slot.slot_id), slot.id, exports.inventory:GetItem(slot.item_id))
	end
	
	self.item = nil
	self.group = nil
	self.currentSlot = nil
	self.equipped = nil
end

function State:Set(weapon)
	local ped = PlayerPedId()

	GiveWeaponToPed(ped, weapon, 999, true, true)

	if weapon == `GADGET_NIGHTVISION` then
		local nightvision = not GetUsingnightvision()
		if nightvision then
			SetPedPropIndex(ped, 0, 195, 0, true)
		else
			ClearPedProp(ped, 0)
		end
		SetNightvision(nightvision)
		return
	elseif weapon == `GADGET_PARACHUTE` then
		SetPedGadget(ped, weapon, true)
		return
	end

	local slot = self.currentSlot or {}

	self.equipped = weapon
	self.ammo = self.debug and 100 or (slot.fields and slot.fields[1] or 0)
	self:UpdateAmmo()
end

function State:TryReload()
	-- Get weapon.
	local weapon = self.equipped
	if not weapon then return end

	-- Get weapon item.
	local item = self.item
	if not item then return end
	
	-- Find magazine slot.
	local magazine = item.ammo.." Magazine"
	local slot = exports.inventory:ContainerFindFirst("self", magazine, "return (slot:GetField(1) or 0) > 0")
	if not slot then return end

	-- Check ammo in magazine.
	local ammo = slot.fields and slot.fields[1]
	if not ammo or ammo == 0 then return end

	-- Check weapon slot.
	if not self.currentSlot then return end

	TriggerServerEvent("weapons:loadMagazine", self.currentSlot.slot_id, slot.slot_id)
	
	-- Set ammo.
	local ped = PlayerPedId()

	SetPedAmmo(ped, weapon, 100)
	SetAmmoInClip(ped, weapon, 0)

	SetPedConfigFlag(ped, 105, true)

	self.ammo = ammo
	self.reloading = true
end

function State:UpdateAmmo()
	local weapon = self.equipped
	if not weapon or not self.group then return end

	local ped = PlayerPedId()
	local hasAmmo = self.ammo and self.ammo > 0
	local isThrowable = self.group.Name == "Throwable"

	if isThrowable then
		SetPedAmmo(ped, weapon, 1)
		return
	end

	SetWeaponsNoAutoreload(true)
	SetWeaponsNoAutoswap(true)

	SetPedAmmo(ped, weapon, hasAmmo and 99 or 0)
	SetAmmoInClip(ped, weapon, hasAmmo and 99 or 0)

	if self.hadAmmo ~= hasAmmo then
		self.hadAmmo = hasAmmo
	end

	print("ammo", self.ammo)
end

--[[ Exports ]]--
function FillJerryCan()
end
exports("FillJerryCan", FillJerryCan)

function GetCurrentSlot()
	return State.currentSlot
end
exports("GetCurrentSlot", GetCurrentSlot)

function GetCurrentWeapon()
	return State.equipped
end
exports("GetCurrentWeapon", GetCurrentWeapon)

function HasAnyWeapon()
	return State.equipped ~= nil
end
exports("HasAnyWeapon", HasAnyWeapon)

--[[ Threads ]]--
Citizen.CreateThread(function()
	while true do
		State:Update()
		Citizen.Wait(0)
	end
end)

--[[ Events ]]--
AddEventHandler("inventory:use", function(item, slot, cb)
	if item.usable == "Weapon" then
		local duration = State:Equip(item, slot)
		if not duration then return end
	
		cb(duration)
	elseif item.usable == "Magazine" then
		local err = nil
		if slot.fields and (slot.fields[1] or 0) >= (item.count or 0) then
			err = "It's already full..."
		elseif not exports.inventory:HasItem(item.ammo) then
			err = "No bullets that fit..."
		end

		if err then
			exports.chat:AddToast({
				class = "error",
				text = err,
			})

			return
		end

		exports.emotes:Play(Config.Loading.Anim)
		cb(Config.Loading.Duration)
	end
end)

AddEventHandler("inventory:useFinish", function(item, slot)
	if item.usable == "Magazine" then
		print("wow loaded")
		exports.emotes:Stop()
	end
end)

AddEventHandler("inventory:useBegin", function(item, slot)
	if item.usable == "Weapon" then return end

	State:Remove()
end)

AddEventHandler("inventory:updateSlot", function(containerId, slotId, slot, item)
	if
		(Preview ~= nil and containerId ~= Preview.containerId) or
		State.currentSlot == nil or State.currentSlot.slot_id ~= slotId or (slot ~= nil and State.currentSlot.id == slot.id)
	then
		return
	end

	State:Remove(true)
end)

AddEventHandler("disarmed", function()
	State:Remove()
end)