--[[ Functions: Inventory ]]
function Inventory:GetPlayerContainer(idOnly)
	if idOnly then
		return self.selfContainer
	end

	return self.containers[self.selfContainer or false]
end
Inventory:Export("GetPlayerContainer")

function Inventory:UseItem(containerId, slotId)
	-- Get container.
	local container = self:GetContainer(containerId)
	if container == nil then return false end

	-- Check container.
	if not container.isSelf then return end

	-- Get slot.
	local slot = container.slots[tostring(slotId)]
	if slot == nil then return false end

	-- Cancel usage.
	if (slot.use_time or 0) > 0 then
		slot:CancelUse()
		return
	end

	-- Check cooldown.
	if self.useCooldown ~= nil and GetGameTimer() < self.useCooldown then return end
	
	-- Get item.
	local item = self:GetItem(slot.item_id or false)
	if item == nil then return false end

	-- Create callbacks.
	local useCallback = function(duration, emote)
		-- Ensure slot.
		if container.slots[tostring(slotId)] ~= slot then return end
		
		-- Clamp duration
		duration = math.max(tonumber(duration) or 0, Config.Using.Cooldown)

		-- Use slot.
		slot:Use(duration)

		-- Update cache.
		Inventory.useSlot = slot

		-- Trigger pre-event.
		TriggerEvent(EventPrefix.."useBegin", item, slot)

		-- Perform emote.
		if emote then
			Inventory.useEmote = exports.emotes:Play(emote)
		end

		-- Wait for finish.
		local startTime = GetGameTimer()
		while GetGameTimer() - startTime < duration do
			if (slot.use_time or 0) == 0 then
				return
			elseif container.slots[tostring(slotId)] ~= slot then
				slot:CancelUse()
				return
			end
			Citizen.Wait(0)
		end

		-- Trigger post-event.
		TriggerServerEvent(EventPrefix.."slotUse", containerId, slotId)
		TriggerEvent(EventPrefix.."useFinish", item, slot)

		-- Reset use time.
		slot.use_time = 0
		container:SetSlot(slot.slot_id, slot)
		Inventory.useSlot = nil

		-- Stop emote.
		if Inventory.useEmote then
			exports.emotes:Stop(Inventory.useEmote)
			Inventory.useEmote = nil
		end
	end

	-- Cooldown.
	self.useCooldown = GetGameTimer() + Config.Using.Cooldown

	-- Trigger events.
	TriggerEvent(EventPrefix.."use", item, slot, useCallback)

	return true
end

function Inventory:HasItem(...)
	local container = self:GetPlayerContainer()
	if container == nil then return false end

	return container:HasItem(...)
end
Inventory:Export("HasItem")

function Inventory:CountItem(name)
	local container = self:GetPlayerContainer()
	if container == nil then return false end

	return container:CountItem(name)
end
Inventory:Export("CountItem")

--[[ Function: Slots ]]--
function Slot:Use(duration)
	-- Get container.
	local container = self:GetContainer()
	if container == nil then return end

	-- Get item.
	local item = self:GetItem()
	if item == nil then return end

	-- Add preview.
	Menu:Commit("addPreview", {
		key = self.id,
		name = item.name,
		use_time = duration,
		change = "Use",
	})
	
	-- Update slot.
	self.use_time = duration or 0
	container:SetSlot(self.slot_id, self)

	-- Update cooldown.
	Inventory.useCooldown = GetGameTimer() + duration
end


function Slot:CancelUse()
	-- Get container.
	local container = self:GetContainer()
	if container == nil then return end

	-- Cancel preview.
	Menu:Commit("cancelUse")

	-- Trigger event.
	TriggerEvent(EventPrefix.."useCancel", self:GetItem(), self)

	-- Update cache.
	Inventory.useCooldown = GetGameTimer() + Config.Using.Cooldown
	Inventory.useSlot = nil

	-- Update slot.
	if container.slots[tostring(self.slot_id)] == self then
		self.use_time = duration or 0
		container:SetSlot(self.slot_id, self)
	end

	-- Cancel emote.
	if Inventory.useEmote then
		exports.emotes:Stop(Inventory.useEmote)
		Inventory.useEmote = nil
	end
end

--[[ Hooks ]]--
Inventory:AddHook("registerContainer", function(container)
	if container.type ~= "player" then return end

	local serverId = GetPlayerServerId(PlayerId())
	if serverId == container.owner then
		container.isSelf = true
		Inventory.selfContainer = container.id
	end
end)

--[[ NUI Callbacks ]]--
RegisterNUICallback("use", function(data, cb)
	Inventory:UseItem(data.container, data.slot)
	cb(true)
end)

--[[ Events ]]--
AddEventHandler("emotes:cancel", function(id)
	if id and Inventory.useEmote == id then
		local slot = Inventory.useSlot
		if slot then
			slot:CancelUse()
		end
	end
end)

AddEventHandler("inventory:cancel", function()
	local slot = Inventory.useSlot
	if slot then
		slot:CancelUse()
	end
end)