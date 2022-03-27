Preview = {
	slots = {},
}

function Preview:IsVisible(ped)
	ped = ped or self.ped

	return IsEntityVisible(ped) and IsEntityVisibleToScript(ped) and not IsPlayerSwitchInProgress()
end

function Preview:LoadContainer(container)
	-- Clear props.
	self:ClearAll()

	-- Update cache.
	self.containerId = container.id
	self.ped = PlayerPedId()
	self.visible = self:IsVisible(ped)

	-- Update slots.
	for slotId, slot in pairs(container.slots) do
		local item = exports.inventory:GetItem(slot.item_id) or {}
		if item.usable == "Weapon" then
			self:UpdateSlot(tonumber(slotId), slot.id, item)
		end
	end
end

function Preview:UpdateSlot(slot, id, item)
	-- Check input.
	if id and State.currentId == id then return end

	-- Get preview.
	local preview = self.slots[slot]
	if preview ~= nil then
		-- Check duplicate.
		if item and preview.id == id then
			return
		end
		
		-- Remove preview.
		self:Delete(preview.object)
		self.slots[slot] = nil
	end

	-- Check item.
	if item then
		-- Create entity.
		preview = self:Create(id, item)
		if not preview then return end
	
		self.slots[slot] = preview
	end
	
	-- Update objects.
	self:UpdateObjects()
end

function Preview:Create(id, item)
	-- Get item.
	if type(item) ~= "table" or not item.weapon or not item.name then return end
	
	-- Get settings.
	local isWeaponTable = type(item.weapon) == "table"
	local weapon = isWeaponTable and item.weapon.hash or item.weapon
	if not weapon then
		error("missing weapon for item: "..tostring(item and item.name))
	end

	local group = GetWeapontypeGroup(weapon)
	local groupSettings = Config.Groups[group] or {}
	local preview = isWeaponTable and item.weapon.preview or groupSettings.Preview
	local rotationOffset = vector3(0.0, 0.0, 0.0)

	if type(preview) == "table" then
		rotationOffset = preview[2] or rotationOffset
		preview = preview[1]
	end
	
	if preview == nil then return end
	
	local settings = Config.Previews[preview]
	if settings == nil then return end
	
	-- Get ped.
	local ped = PlayerPedId()
	local coords = GetEntityCoords(ped)
	
	-- Check visibile.
	local entity
	if self.visible then
		-- Get model.
		local model = GetWeapontypeModel(weapon)

		-- Request model.
		while IsModelValid(model) and not HasModelLoaded(model) do
			RequestModel(model)
			Citizen.Wait(0)
		end

		-- Play sound.
		self:PlaySound()

		-- Create object.
		entity = CreateObject(model, coords.x, coords.y, coords.z, true, false, false)

		SetEntityCollision(entity, false, false)
		SetModelAsNoLongerNeeded(model)
	end

	-- Cache settings.
	local bone = settings.Bone
	local offset = settings.Offset
	local rotation = settings.Rotation + rotationOffset

	-- Set random rotation.
	if settings.Random then
		rotation = rotation + vector3(
			GetRandomFloatInRange(settings.Random.Min.x, settings.Random.Max.x),
			GetRandomFloatInRange(settings.Random.Min.y, settings.Random.Max.y),
			GetRandomFloatInRange(settings.Random.Min.z, settings.Random.Max.z)
		)
	end

	-- Immediately attach.
	if entity then
		AttachEntityToEntity(
			entity,
			ped,
			GetPedBoneIndex(ped, bone),
			offset.x, offset.y, offset.z,
			rotation.x, rotation.y, rotation.z,
			false,
			false,
			true,
			true,
			0,
			true
		)
	end

	-- Create preview.
	self.lastInsertIndex = (self.lastInsertIndex or 0) + 1
	
	local preview = {
		bone = bone,
		id = id,
		item = item.id,
		key = self.lastInsertIndex,
		object = entity,
		offset = offset,
		preview = preview,
		rotation = rotation,
	}

	return preview
end

function Preview:UpdateObjects()
	local slots = {}
	for id, slot in pairs(self.slots) do
		slots[#slots + 1] = slot
	end

	table.sort(slots, function(a, b)
		return (a.key or 0) < (b.key or 0)
	end)
	
	local ped = PlayerPedId()
	local counts = {}

	for _, entity in ipairs(slots) do
		local offset = entity.offset
		local rotation = entity.rotation
		local count = counts[entity.preview] or 0
		local settings = Config.Previews[entity.preview]

		if settings.Stack then
			offset = offset + settings.Stack * count
		end

		AttachEntityToEntity(
			entity.object,
			ped,
			GetPedBoneIndex(ped, entity.bone),
			offset.x, offset.y, offset.z,
			rotation.x, rotation.y, rotation.z,
			false,
			false,
			true,
			true,
			0,
			true
		)

		counts[entity.preview] = count + 1
	end
end

function Preview:PlaySound()
	if GetGameTimer() - (self.lastSound or 0) < 1000 then return end

	PlaySoundFrontend(-1, "PICK_UP_WEAPON", "HUD_FRONTEND_CUSTOM_SOUNDSET")
	self.lastSound = GetGameTimer()
end

function Preview:Delete(entity)
	Citizen.CreateThread(function()
		while DoesEntityExist(entity) do
			NetworkRequestControlOfEntity(entity)
			DeleteEntity(entity)

			Citizen.Wait(50)
		end
	end)
end

function Preview:ClearSlot(id)
	local slot = self.slots[id]
	if slot == nil then return end

	self:Delete(slot.object)
	self.slots[id] = nil
	self:UpdateObjects()
end

function Preview:ClearAll(objectOnly)
	for id, slot in pairs(self.slots) do
		self:Delete(slot.object)
	end
	if not objectOnly then
		self.slots = {}
	end
end

function Preview:UpdatePed()
	local ped = PlayerPedId()
	local visible = self:IsVisible(ped)

	if self.ped ~= ped or self.visible ~= visible then
		self:ClearAll(true)
		self.ped = ped
		self.visible = visible
	end
end

function Preview:CheckObjects()
	if not self.visible then
		return
	end

	local didUpdate = false
	for id, slot in pairs(self.slots) do
		if not DoesEntityExist(slot.object or 0) then
			local preview = self:Create(slot.id, exports.inventory:GetItem(slot.item))
			if preview ~= nil then
				self.slots[id] = preview
				didUpdate = true
			end
		end
	end
	if didUpdate then
		self:UpdateObjects()
	end
end

--[[ Threads ]]--
-- Citizen.CreateThread(function()
-- 	while true do
-- 		Preview:CheckObjects()
-- 		Citizen.Wait(2000)
-- 	end
-- end)

-- Citizen.CreateThread(function()
-- 	while true do
-- 		Preview:UpdatePed()
-- 		Citizen.Wait(200)
-- 	end
-- end)

--[[ Events ]]--
AddEventHandler("inventory:", function()
	
end)

-- AddEventHandler("inventory:onContainerCreate", function(container)
-- 	if container.isSelf then
-- 		Preview:LoadContainer(container)
-- 	end
-- end)

-- AddEventHandler("inventory:updateSlot", function(containerId, slotId, slot, item)
-- 	if containerId ~= Preview.containerId or (slot and State.currentSlot and slot.slot_id == State.currentSlot.slot_id) then return end

-- 	Preview:UpdateSlot(slotId, slot and slot.id, item)
-- end)

-- AddEventHandler("weapons:start", function()
-- 	-- Get container.
-- 	local container = exports.inventory:GetPlayerContainer()
-- 	if container == nil then return end
	
-- 	-- Update container.
-- 	Preview:LoadContainer(container)
-- end)

AddEventHandler("weapons:stop", function()
	for id, slot in pairs(Preview.slots) do
		if DoesEntityExist(slot.object) then
			DeleteEntity(slot.object)
		end
	end
end)

AddEventHandler("character:switch", function()
	Preview:ClearAll()
end)