--[[ Functions: Container ]]--
function Container:Create(data)
	return setmetatable(data, Container)
end

function Container:Destroy()
	-- Debug.
	Debug("Destroy container: %s", self.id)

	-- Update NUI.
	Menu:Commit("removeContainer", self.id)

	-- Uncache container.
	Inventory.containers[self.id] = nil
end

function Container:Unsubscribe()
	self:Destroy()
	TriggerServerEvent(EventPrefix.."subscribe", self.id, false)
end

function Container:GetCoords()
	if self.coords then
		return self.coords
	end

	if self.owner then
		local player = GetPlayerFromServerId(self.owner)
		local ped = player and NetworkIsPlayerActive(player) and GetPlayerPed(player)
		if ped and DoesEntityExist(ped) then
			return GetEntityCoords(ped) - vector3(0.0, 0.0, 1.0)
		end
	end
end

--[[ Functions: Inventory ]]--
function Inventory:RegisterContainer(data)
	-- Check input.
	if not data.id then return end

	-- Debug.
	Debug("Register container: %s", json.encode(data))

	-- Load slots.
	local slots = {}
	for k, v in pairs(data.slots) do
		slots[tostring(k)] = Slot:Create(v)
	end
	data.slots = slots

	-- Create container.
	local container = Container:Create(data)

	-- Setup container.
	if container.type then
		local typeSettings = Config.Containers[container.type]
		if typeSettings then
			for key, value in pairs(typeSettings) do
				container[key] = container[key] or value
			end
		end
	elseif container.settings then
		for key, value in pairs(container.settings) do
			container[key] = container[key] or value
		end
	end

	-- Hooks.
	self:InvokeHook("registerContainer", container)

	-- Cache container.
	self.containers[container.id] = container

	-- Send to NUI.
	Menu:Commit("addContainer", container)

	-- Trigger event.
	TriggerEvent(EventPrefix.."onContainerCreate", container)
end
Inventory:Export("RegisterContainer")

function Inventory:UpdateContainer(id, data)
	-- Check input.
	if id == nil or data == nil then return end
	
	-- Debug.
	Debug("Update container: %s (%s)", id, json.encode(data))

	-- Get container.
	local container = self.containers[id]
	if container == nil then
		Debug("Cannot update non-existent container: %s", id)
		return
	end

	-- Update container.
	local slots = {}

	if data.slot then
		local info = data.slot.info

		if container.isSelf then
			local oldSlot = container.slots[tostring(data.slot.id)]
			local change = ((info and info.quantity) or 0) - ((oldSlot and oldSlot.quantity) or 0)
			
			if change ~= 0 then
				local item = Inventory:GetItem((info and info.item_id) or (oldSlot and oldSlot.item_id))

				Menu:Commit("addPreview", {
					key = data.slot.id,
					name = item.name,
					change = change,
				})
			end
		end
		
		container:SetSlot(data.slot.id, info)
		slots[1] = data.slot.id
	elseif data.slots then
		for k, _data in pairs(data.slots) do
			container:SetSlot(_data.id, _data.info)
			slots[k] = _data.id
		end
	end

	TriggerEvent(EventPrefix.."onContainerUpdate", container, table.unpack(slots))
end
Inventory:Export("UpdateContainer")

--[[ Events ]]--
RegisterNetEvent(EventPrefix.."sync", function(data)
	if data.slots == nil then
		local container = Inventory:GetContainer(data.id)
		if container then
			container:Destroy()
		end

		return
	end

	Inventory:RegisterContainer(data)
end)

RegisterNetEvent(EventPrefix.."inform", function(id, data)
	Inventory:UpdateContainer(id, data)
end)

--[[ NUI Callbacks ]]--
RegisterNUICallback("subscribe", function(data, cb)
	local container = Inventory.containers[data.container or false] or {}
	if container.isSelf then
		Menu:Focus(false)
		cb(false)
		return
	end

	TriggerServerEvent(EventPrefix.."subscribe", data.container, data.value)

	cb(true)
end)

RegisterNUICallback("updateFocus", function(data, cb)
	Inventory.primaryFocus = tonumber(data.primary) or data.primary
	Inventory.secondaryFocus = tonumber(data.secondary) or data.secondary

	cb(true)
end)