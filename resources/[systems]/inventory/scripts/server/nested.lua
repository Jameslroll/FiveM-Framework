--[[ Functions: Slots ]]--
function Slot:GetNestedContainer()
	local item = self:GetItem()
	if item.nested == nil then return end
	
	-- Get nested.
	local nestedContainer = nil
	if self.nested_container_id ~= nil then
		-- Get container.
		local wasCached = false
		nestedContainer, wasCached = Inventory:LoadContainer({
			id = self.nested_container_id,
		})

		-- Return cached container.
		if wasCached then
			return nestedContainer
		end
	end

	-- Create nested.
	if nestedContainer == nil then
		local container = Inventory:GetContainer(self.container_id)
		if container == nil then return end

		-- Create container.
		nestedContainer = Inventory:RegisterContainer({
			slot_id = self.id,
		})

		-- Update slot.
		self.nested_container_id = nestedContainer.id
		self:Save()

		-- Sync container.
		container:InformSlots(self.slot_id)
	end
	
	-- Set nested type.
	nestedContainer.type = item.nested
	nestedContainer.slot = self.id
	nestedContainer.slot_id = self.slot_id
	nestedContainer.parent = self.container_id

	-- Return nested.
	return nestedContainer
end

function Slot:HasNestedContainer()
	local item = self:GetItem()
	return item.nested ~= nil
end

function Slot:MoveNested(container, target)
	local nestedContainer = self:GetNestedContainer()
	if nestedContainer == nil then return end

	nestedContainer.parent = container.id
	nestedContainer.slot_id = (type(target) == "table" and target.id) or target

	-- Unsubscribe.
	for viewer, _ in pairs(nestedContainer.viewers) do
		nestedContainer:Subscribe(viewer, false)
	end

	-- Update parent.
	local parent = Inventory:GetContainer(container.id)
	if parent ~= nil then
		parent:UpdateNestedSlot()
	end
end

function Slot:CanMoveNested(sourceContainer, targetContainer)
	-- Get item and check nested.
	local item = self:GetItem()
	if item.nested == nil then return end

	-- Get settings.
	local settings = Config.Containers[item.nested]
	if not settings then
		return false, "no nested settings"
	end

	-- Check containers.
	if self.nested_container_id == targetContainer.id then
		return false, "same nested"
	end

	-- Check types.
	if sourceContainer.id ~= targetContainer.id and targetContainer:IsNested() then
		if item.nested == targetContainer.type then
			return false, "same size"
		end

		local targetSettings = Config.Containers[targetContainer.type]

		if settings.maxWeight and targetSettings.maxWeight and settings.maxWeight > targetSettings.maxWeight then
			return false, "too small"
		end
	end

	-- Check nested target.
	if targetContainer:IsNested() then
		local parent = targetContainer:GetParent()
		local weight = self:GetWeight()

		while parent ~= nil and parent:IsNested() do
			if parent.id == self.nested_container_id then
				return false, "overflow"
			elseif not parent:CanCarry(weight) then
				return false, "too heavy"
			end
			parent = parent:GetParent()
		end
	end
end

--[[ Functions: Container ]]--
function Container:GetParent()
	if self.parent == nil then return end

	return Inventory:GetContainer(self.parent)
end

function Container:IsNested()
	return self.parent ~= nil
end

function Container:UpdateNestedSlot(updated)
	-- Overflow check.
	if updated == nil then
		updated = {}
	elseif updated[self.id] then
		return
	end
	updated[self.id] = true
	
	-- Get parent.
	local parent = self:GetParent()
	if parent == nil then return end

	-- Get slot.
	local slot = parent.slots[self.slot_id]

	-- Update weight.
	if slot ~= nil then
		slot.weight = slot:GetWeight()
	end

	-- Update parent.
	parent:UpdateSnowflake()
	parent:InformSlots(self.slot_id)

	-- Recursive callback.
	if parent:IsNested() then
		parent:UpdateNestedSlot(updated)
	end
end

--[[ Hooks ]]--
Inventory:AddHook("use", function(source, item, slot)
	local nestedContainer = slot:GetNestedContainer()
	if nestedContainer == nil then return end

	nestedContainer:Subscribe(source, true)
end)

Inventory:AddHook("moveSlot", function(sourceContainer, sourceSlot, target, quantity, source)
	-- Check target.
	if type(target) ~= "table" or sourceContainer.id == target.container then return end

	-- Get target container.
	local targetContainer = Inventory:GetContainer(target.container)
	if targetContainer == nil then
		return false, "no container"
	end

	-- Check source.
	if sourceSlot.nested_container_id ~= nil then
		local result, message = sourceSlot:CanMoveNested(sourceContainer, targetContainer)
		if not result then
			return result, message
		end
	end
	
	-- Check target.
	local targetSlot = targetContainer.slots[target.slot]
	if targetSlot ~= nil and targetSlot.nested_container_id ~= nil then
		local result, message = targetSlot:CanMoveNested(targetContainer, sourceContainer)
		if not result then
			return result, message
		end
	end
end)

Inventory:AddHook("slotMoved", function(sourceContainer, sourceSlot, targetContainer, targetSlot)
	if sourceSlot.nested_container_id ~= nil then
		sourceSlot:MoveNested(targetContainer, targetSlot)
	end

	if type(targetSlot) == "table" and targetSlot.nested_container_id ~= nil then
		targetSlot:MoveNested(sourceContainer, sourceSlot)
	end

	if sourceContainer.id ~= targetContainer.id then
		if targetContainer:IsNested() then
			targetContainer:UpdateNestedSlot()
		end

		if sourceContainer:IsNested() then
			sourceContainer:UpdateNestedSlot()
		end
	end
end)

Inventory:AddHook("itemAdded", function(container, slot, quantity)
	if container:IsNested() then
		container:UpdateNestedSlot()
	end
end)