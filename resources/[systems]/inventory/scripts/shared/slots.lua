Slot = Slot or {}
Slot.__index = Slot

--[[ Functions: Slot ]]--
function Slot:GetContainer()
	return Inventory:GetContainer(self.container_id)
end

function Slot:GetItem()
	return Inventory:GetItem(self.item_id)
end

function Slot:GetWeight()
	-- Get item.
	local item = Inventory:GetItem(self.item_id)
	if item == nil or item.weight == nil then
		return 0.0
	end

	-- Calculate weight.
	local weight = item.weight * self.quantity

	-- Nested weight.
	if item.nested ~= nil and self.GetNestedContainer ~= nil then
		local nestedContainer = self:GetNestedContainer()
		if nestedContainer ~= nil then
			weight = weight + nestedContainer:GetWeight()
		end
	end

	-- Return result.
	return weight
end

function Slot:GetField(key)
	if self.fields == nil then return end
	return self.fields[key]
end

--[[ Functions: Container ]]--
function Container:HasItem(name, minDurability)
	local item = Inventory:GetItem(name)
	if item == nil then return false end
	
	for id, slot in pairs(self.slots) do
		if slot.item_id == item.id and (not minDurability or (slot.durability or 1.0) >= minDurability) then
			return true
		end
	end
	return false
end

function Container:CountItem(name)
	local item = Inventory:GetItem(name)
	if item == nil then return 0 end

	local count = 0
	for id, slot in pairs(self.slots) do
		if slot.item_id == item.id then
			count = count + (slot.quantity or 0)
		end
	end
	return count
end

function Container:FindFirst(name, func)
	local item = Inventory:GetItem(name)
	if item == nil then return end

	local env = { container = self }
	if type(func) == "string" then
		func = load(func, nil, "t", env)
		if not func then
			error("can't load func")
		end
	end

	local foundSlot
	for id, slot in pairs(self.slots) do
		env.slot = slot
		if slot.item_id == item.id and (not foundSlot or foundSlot.slot_id > slot.slot_id) and (not func or func(self, slot)) then
			foundSlot = slot
		end
	end
	return foundSlot
end