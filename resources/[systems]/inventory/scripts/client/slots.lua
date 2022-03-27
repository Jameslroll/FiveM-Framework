--[[ Functions: Slots ]]--
function Slot:Create(data)
	data.use_time = data.use_time or 0

	return setmetatable(data, Slot)
end

--[[ Functions: Container ]]--
function Container:SetSlot(id, info)
	id = tostring(id)

	local slot = self.slots[id]

	-- Create slot.
	if info ~= nil then
		info = Slot:Create(info)
	end

	-- Set info.
	self.slots[id] = info
	
	-- Commit to menu.
	Menu:Commit("setSlot", {
		container = self.id,
		slot = id,
		info = info,
	})
	
	-- Trigger event.
	local item = (info ~= nil and info:GetItem())
	TriggerEvent(EventPrefix.."updateSlot", self.id, tonumber(id), info, item)
end

function Container:MoveSlot(from, to, quantity)
	-- Quick sending.
	if to == "send" then
		local primaryFocus = Inventory:GetContainer(Inventory.primaryFocus)
		local secondaryFocus = Inventory:GetContainer(Inventory.secondaryFocus)
		local target = (secondaryFocus == nil and primaryFocus ~= nil and Inventory:GetPlayerContainer()) or secondaryFocus
	
		if target ~= nil and (from == nil or from.container ~= target.id) then
			to = {
				container = target.id
			}
		else
			to = "drop"
		end
	end

	-- Get slot.
	local sourceSlot = self.slots[tostring(from.slot)]
	if sourceSlot == nil then
		return false, "no source slot"
	end

	-- Get item.
	local sourceItem = sourceSlot:GetItem()
	if sourceItem == nil then
		return false, "no item in source slot"
	end

	-- Hooks.
	local result, message = Inventory:InvokeHook("moveSlot", self, sourceItem, sourceSlot, to, quantity)
	if result == false then
		return result, message
	elseif result == true then
		return true
	elseif type(result) == "table" then
		from = result.from
		target = result.target or target
		quantity = result.quantity or quantity
	end

	-- Trigger server event.
	TriggerServerEvent(EventPrefix.."moveSlot", {
		from = from,
		to = to,
		quantity = quantity,
	})

	-- Return success.
	return true
end

-- Inventory:AddHook("moveSlot", function(container, sourceItem, sourceSlot, target, quantity)
	
-- end)

--[[ NUI Events ]]--
RegisterNUICallback("moveSlot", function(data, cb)
	local container = Inventory:GetContainer(data.from.container)
	if container == nil then return end

	local result, message = container:MoveSlot(data.from, data.to, data.quantity)
	if not result then
		Print("Couldn't move slot: %s -> %s x%s (%s)", json.encode(data.from), json.encode(data.to), data.quantity, message or "unknown reason")
	end

	cb(true)
end)