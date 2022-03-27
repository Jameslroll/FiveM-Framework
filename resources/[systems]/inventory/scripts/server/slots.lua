--[[ Functions: Slot ]]--
function Slot:Create(id)
	if id == nil then
		if self.lastId == nil then
			id = exports.GHMattiMySQL:QueryScalar(Server.Queries.GetSlotId, {
				["@table"] = Server.Tables.Slots,
				["@schema"] = GetConvar("mysql_schema", ""),
			}) or 1
		else
			id = self.lastId + 1
		end

		self.lastId = id
	end

	Debug("Create slot: %s", id)

	return setmetatable({ id = id }, Slot)
end

function Slot:Destroy(skipInform)
	exports.GHMattiMySQL:QueryAsync(("DELETE FROM %s WHERE id=@id"):format(Server.Tables.Slots), {
		["@id"] = self.id
	})

	-- Get container.
	local container = Inventory:GetContainer(self.container_id)
	if container == nil then
		return false, "invalid container"
	end

	-- Clear slot.
	container.slots[self.slot_id] = nil
	
	-- Snowflakes.
	container:UpdateSnowflake()

	-- Inform players.
	if not skipInform then
		container:InformSlots(self.slot_id)
	end

	return true
end

function Slot:Subtract(quantity)
	local container = self:GetContainer()
	if container == nil then
		return false, "no container"
	end

	-- Subtract quantity.
	self.quantity = self.quantity - quantity

	-- Destroy.
	if self.quantity <= 0 then
		self:Destroy()
		return true
	end

	-- Save slot.
	self:Save()

	-- Snowflakes.
	container:UpdateSnowflake()

	-- Inform players.
	container:InformSlots(self.slot_id)

	return true
end

function Slot:Split(targetContainer, targetSlotId, quantity)
	if quantity >= self.quantity then
		return false
	end

	-- Get item.
	local item = self:GetItem()
	if item == nil then return false end
	
	-- Check weights.
	if self.container_id ~= targetContainer.id and item.weight ~= nil and not targetContainer:CanCarry(item.weight * quantity) then
		return false
	end

	-- Update quantity.
	self.quantity = self.quantity - quantity

	-- Create target slot.
	local slot = targetContainer:SetSlot(targetSlotId, {
		container_id = targetContainer.id,
		item_id = self.item_id,
		slot_id = targetSlotId,
		quantity = quantity,
		durability = self.durability,
	})

	-- Save.
	slot:Save()

	-- Return result.
	return true
end

function Slot:SetInfo(info)
	-- Set info.
	for _, property in ipairs(Server.Slots.Properties) do
		self[property] = info[property]
	end
end

function Slot:SetField(key, value)
	-- Get container.
	local container = Inventory:GetContainer(self.container_id)
	if container == nil then
		return false, "invalid container"
	end

	-- Update fields.
	if self.fields == nil then
		self.fields = {}
	end
	self.fields[key] = value
	
	-- Snowflakes.
	container:UpdateSnowflake()

	-- Inform players.
	if not skipInform then
		container:InformSlots(self.slot_id)
	end

	-- Save slot.
	self:Save()

	return true
end

function Slot:Save(setLastUpdate)
	-- Get container.
	local containerId = self.container_id
	local container = Inventory:GetContainer(containerId)
	if container == nil then return end

	if container.temporary then
		self.container_id = nil
	end

	-- Get query.
	local setters, values = GetQuerySetters(Server.Slots.Properties, self)

	-- Last update.
	if setLastUpdate then
		setters = setters..", `last_update`=CURRENT_TIMESTAMP()"
		self.last_update = os.time() * 1000
	end

	-- Restore container.
	if container.temporary then
		self.container_id = containerId
	end

	-- Nothing is set.
	if setters == "" then return end

	-- Set id.
	setters = "id=@id, "..setters
	values["@id"] = self.id

	-- Run query.
	exports.GHMattiMySQL:QueryAsync(Server.Queries.UpdateSlot:format(Server.Tables.Slots, setters, setters), values)
end

--[[ Functions: Container ]]--
function Container:LoadSlots()
	self.slots = {}

	-- Get settings.
	local settings = self:GetSettings() or {}

	-- Get slots for container.
	local result = exports.GHMattiMySQL:QueryResult(("SELECT * FROM `%s` WHERE container_id=@container_id"):format(Server.Tables.Slots), {
		["@container_id"] = self.id
	})

	for _, info in ipairs(result) do
		local item = Inventory:GetItem(info.item_id)
		if item == nil then goto skipSlot end

		-- Load properties.
		local _info = { id = info.id }
		for _, property in ipairs(Server.Slots.Properties) do
			local value = info[property]
			if property == "fields" then
				value = json.decode(value)
			end
			_info[property] = value
		end

		-- Create slot.
		local slot = self:SetSlot(info.slot_id, _info)
		slot.last_update = info.last_update
		slot:UpdateDecay(settings.decayRate)

		-- Load nested containers.
		local nestedContainer = slot:GetNestedContainer()
		if nestedContainer ~= nil then
			slot.weight = slot:GetWeight()
		end

		::skipSlot::
	end
end

function Container:SetSlot(id, info)
	-- Get slot.
	local slot = self.slots[id]
	if slot == nil then
		slot = Slot:Create(info.id)
		self.slots[id] = slot
	end

	-- Set slot.
	info.container_id = self.id
	info.slot_id = id

	slot:SetInfo(info)

	-- Return slot.
	return slot
end

function Container:GetSlot(id)
	return self.slots[id]
end

function Container:CalculateSlots(item, quantity, offset)
	local settings = self:GetSettings()
	if not settings then return false end

	local maxWeight = settings.maxWeight
	local weight = self:GetWeight()
	local counts = {}

	for slotId = offset or 0, self:GetSize() - 1 do
		local slot = self.slots[slotId]
		local amount = 0

		if slot and slot.item_id == item.id then
			amount = item.stack and math.min(item.stack - slot.quantity, quantity) or quantity
		elseif not slot then
			amount = item.stack and math.min(quantity, item.stack) or quantity
		end

		if amount > 0 then
			weight = weight + (item.weight and item.weight * amount or 0.0)
			counts[slotId] = amount

			quantity = quantity - amount
		end

		if maxWeight and weight >= maxWeight then
			return false, "too heavy"
		end

		if quantity <= 0 then
			return counts
		end
	end

	return false, "full"
end

function Container:AddItem(data, ...)
	if type(data) == "table" then
		data.quantity = data.quantity or 1
	else
		local quantity, fields, slot = ...
		data = {
			item = data,
			quantity = quantity or 1,
			fields = fields or nil,
			slot = slot or nil,
		}
	end

	-- Get settings.
	local size = self:GetSize()

	-- Set slot id.
	data.slot = math.min(data.slot or 0, size - 1)

	-- Set item id.
	if type(data.item) == "number" then
		data.item_id = data.item
		data.item = nil
	elseif type(data.item) == "string" then
		data.item_id = Inventory:GetItemId(data.item)
		data.item = nil
	else
		return false, "no item"
	end

	-- Get item.
	local item = Inventory:GetItem(data.item_id or "")
	if item == nil then
		return false, "invalid item"
	end

	-- Check can fit.
	local counts, result = self:CalculateSlots(item, data.quantity, data.slot)
	if not counts then
		return false, result
	end

	local slots = {}
	for slotId, count in pairs(counts) do
		local slot = self.slots[slotId]

		-- Update slot.
		if slot and slot.item_id ~= item.id then
			goto skipSlot
		elseif slot then
			-- Set quantity.
			slot.quantity = slot.quantity + count
		else
			-- Update data.
			data.quantity = count

			-- Create slot.
			slot = self:SetSlot(slotId, data)
	
			-- Set fields.
			if item.fields ~= nil then
				slot.fields = {}
				for key, field in pairs(item.fields) do
					slot.fields[key] = (data.fields ~= nil and data.fields[key]) or field.default
				end
			end
		end
	
		-- Save slot.
		slot:Save()
	
		-- Inform viewers.
		self:InformSlots(slotId)

		-- Hooks.
		Inventory:InvokeHook("itemAdded", self, slot, count)
		
		::skipSlot::
	end

	-- Update snowflake.
	self:UpdateSnowflake()

	-- Return result.
	return true
end

function Container:RemoveItem(data, quantity, slotId)
	local item = Inventory:GetItem(data)
	if item == nil then return false end

	quantity = quantity or 1

	local slot = self.slots[slotId]
	if slot and slot.item_id == item.id then
		local remove = math.min(quantity, slot.quantity)

		slot:Subtract(remove)
		quantity = quantity - remove

		if quantity <= 0 then
			return true, quantity
		end
	end

	for id, slot in pairs(self.slots) do
		if slot.item_id == item.id then
			local remove = math.min(quantity, slot.quantity)

			slot:Subtract(remove)
			quantity = quantity - remove

			if quantity <= 0 then
				break
			end
		end
	end
	return true, quantity
end

function Container:MergeSlots(sourceSlot, targetSlot, targetContainer, quantity)
	-- Compare items.
	if sourceSlot.item_id ~= targetSlot.item_id then
		return false
	end

	-- Get item.
	local item = sourceSlot:GetItem()
	if item == nil then
		return false
	end

	-- Clamp quantity.
	if item.stack ~= nil then
		quantity = quantity - math.max(0, targetSlot.quantity + quantity - item.stack)
	end

	-- Check quantity.
	if quantity == 0 then
		return false
	end

	-- Check weights.
	if self.id ~= targetContainer.id and item.weight ~= nil and not targetContainer:CanCarry(item.weight * quantity) then
		return false
	end

	-- Merge durability.
	if targetSlot.durability or sourceSlot.durability then
		targetSlot.durability = ((sourceSlot.durability or 1.0) * quantity + (targetSlot.durability or 1.0) * targetSlot.quantity) / (targetSlot.quantity + quantity)
	end
	
	-- Set quantities.
	targetSlot.quantity = targetSlot.quantity + quantity
	sourceSlot.quantity = sourceSlot.quantity - quantity

	-- Save/destroy sourceSlot.
	if sourceSlot.quantity <= 0 then
		sourceSlot:Destroy(true)
	else
		sourceSlot:Save()
	end
	
	-- Save target slot.
	targetSlot:Save()

	-- Return success.
	return true
end

function Container:SwapSlots(sourceSlot, targetSlot, targetContainer)
	-- Set target.
	local isTargetEmpty = type(targetSlot) == "number"
	local targetSlotId

	-- Check containers.
	if self.id ~= targetContainer.id and (
		not targetContainer:CanCarry(sourceSlot:GetWeight()) or (not isTargetEmpty and not self:CanCarry(targetSlot:GetWeight()))
	) then
		return false, "too heavy"
	end

	-- Swap.
	if isTargetEmpty then
		-- Cache target slot.
		targetSlotId = targetSlot
		targetSlot = nil

		if targetSlotId == nil then
			return false, "invalid target slot"
		end
	else
		-- Cache target slot.
		targetSlotId = targetSlot.slot_id

		-- Swap target with self.
		targetSlot.slot_id = sourceSlot.slot_id
		targetSlot.container_id = sourceSlot.container_id
		targetSlot:Save()
	end
	
	-- Swap self with target.
	local sourceSlotId = sourceSlot.slot_id

	sourceSlot.slot_id = targetSlotId
	sourceSlot.container_id = targetContainer.id
	sourceSlot:Save()

	-- Update containers.
	self.slots[sourceSlotId] = targetSlot
	targetContainer.slots[targetSlotId] = sourceSlot

	-- Return success.
	return true
end

function Container:MoveSlot(id, target, quantity, source)
	if self.id == target.container and id == target.slot then
		return false, "same slot"
	end

	-- Get slots.
	local sourceSlot = self.slots[id]
	if sourceSlot == nil then
		return false, "empty source slot"
	end

	-- Get items.
	local sourceItem = sourceSlot:GetItem()
	if not sourceItem then
		return false, "no source item"
	end

	-- Clamp quantity.
	quantity = math.min(math.max(quantity, 1), sourceSlot.quantity or 1)

	-- Hooks.
	local result, message = Inventory:InvokeHook("moveSlot", self, sourceSlot, target, quantity, source)
	if result == false then
		return result, message
	elseif result == true then
		return true
	elseif type(result) == "table" then
		id = result.id or id
		target = result.target or target
		quantity = result.quantity or quantity
	end
	
	-- Check target.
	if type(target) ~= "table" then
		return false, "invalid target"
	end

	-- Get containers.
	local sourceContainer = sourceSlot:GetContainer()
	if sourceContainer == nil then
		return false, "invalid source container"
	end

	local targetContainer = Inventory:GetContainer(target.container)
	if targetContainer == nil then
		return false, "invalid target container"
	end

	-- Check target slot.
	if target.slot == nil then
		local emptySlot, sameSlot = targetContainer:GetFirstEmptySlot(sourceSlot)
		target.slot = sameSlot or emptySlot
	elseif type(target.slot) ~= "number" then
		return false, "invalid slot"
	end

	local size = targetContainer:GetSize()
	if not target.slot or target.slot >= size then
		return false, "out of bounds"
	end

	-- Get target slot.
	local targetSlot = targetContainer.slots[target.slot]
	local targetItem = targetSlot and targetSlot:GetItem()

	-- Check filters.
	if not targetContainer:CheckFilter(sourceItem) then
		return false, "target container filtered"
	elseif targetItem and not sourceContainer:CheckFilter(targetItem) then
		return false, "source container filtered"
	end

	-- Try to move.
	local didMove, result = (
		(targetSlot == nil and sourceSlot:Split(targetContainer, target.slot, quantity)) or
		(targetSlot ~= nil and self:MergeSlots(sourceSlot, targetSlot, targetContainer, quantity)) or
		self:SwapSlots(sourceSlot, targetSlot or target.slot, targetContainer)
	)

	-- Result.
	if didMove then
		-- Snowflakes.
		self:UpdateSnowflake()
		
		-- Inform viewers.
		if self.id == targetContainer.id then
			self:InformSlots(id, target.slot)
		else
			self:InformSlots(id)
			targetContainer:UpdateSnowflake()
			targetContainer:InformSlots(target.slot)
		end

		-- Hooks.
		Inventory:InvokeHook("slotMoved", self, sourceSlot, targetContainer, targetSlot or target.slot)

		-- Events.
		TriggerEvent("inventory:slotMoved", self.id, sourceSlot, targetContainer.id, targetSlot or target.slot)

		return true
	else
		return false, result or "didn't move"
	end
end

function Container:InformSlots(slotA, slotB)
	if slotB == nil then
		self:InformAll({
			slot = {
				id = slotA,
				info = self.slots[slotA],
			}
		})
	else
		self:InformAll({
			slots = {
				{
					id = slotA,
					info = self.slots[slotA],
				},
				{
					id = slotB,
					info = self.slots[slotB],
				}
			}
		})
	end
end

function Container:GetFirstEmptySlot(sourceSlot)
	-- Snowflakes.
	if self:CompareSnowflake(self.emptySnowflake) then
		return self.firstEmpty, self.sameSlot
	end

	-- Get item.
	local item = nil
	if sourceSlot ~= nil then
		item = sourceSlot:GetItem() or {}
	end

	-- Get size.
	local size = self:GetSize()

	-- Get slot.
	local emptySlot = false
	local sameSlot = false

	for i = 0, size - 1 do
		local slot = self.slots[i]

		if slot == nil and not emptySlot then
			emptySlot = i
		elseif
			slot ~= nil and
			sourceSlot ~= nil and
			item.stack ~= nil and
			slot.item_id == sourceSlot.item_id and
			slot.quantity < item.stack
		then
			sameSlot = i
		end

		if emptySlot and (sameSlot or sourceSlot == nil) then
			break
		end
	end

	-- Update snowflake.
	self.emptySnowflake = self.snowflake
	self.firstEmpty = emptySlot
	self.sameSlot = sameSlot

	return emptySlot, sameSlot
end

function Container:CountSlots()
	-- Snowflakes.
	if self:CompareSnowflake(self.countSnowflake) then
		return self.fullCount, self.emptyCount
	end
	
	-- Get size.
	local size = self:GetSize()
	local fullCount, emptyCount = 0, 0
	
	-- Get slot.
	for i = 0, size - 1 do
		local slot = self.slots[i]
		if slot == nil then
			emptyCount = emptyCount + 1
		else
			fullCount = fullCount + 1
		end
	end

	-- Update snowflake.
	self.countSnowflake = self.snowflake
	self.fullCount = fullCount
	self.emptyCount = emptyCount

	return fullCount, emptyCount
end

function Container:CountItems()
	local items = {}
	for id, slot in pairs(self.slots) do
		local count = items[slot.item_id]
		items[slot.item_id] = (items[slot.item_id] or 0) + (slot.quantity or 0)
	end
	return items
end

function Container:IsEmpty()
	for id, slot in pairs(self.slots) do
		return false
	end
	return true
end

function Container:Empty()
	for id, slot in pairs(self.slots) do
		slot:Destroy()
	end
end

--[[ Hooks ]]--
Inventory:AddHook("init", function()
	exports.GHMattiMySQL:QueryAsync(("DELETE FROM %s WHERE container_id IS NULL"):format(Server.Tables.Slots))
end)

--[[ Events ]]--
RegisterNetEvent(EventPrefix.."moveSlot", function(data)
	local source = source

	-- Check input.
	if type(data) ~= "table" or type(data.from) ~= "table" then return end

	-- Get and check player.
	local player = Inventory.players[source]
	if player == nil or player:GetTimeSinceLastAction() < 0.2 then return end

	player:UpdateLastAction()
	
	-- Get container.
	local container = Inventory:GetContainer(data.from.container)
	if container == nil then return end
	
	-- Move slot.
	local result, message = container:MoveSlot(data.from.slot, data.to, tonumber(data.quantity), source)
	if not result then
		Debug("[%s] can't move slot: %s (%s)", source, message, json.encode(data))
	end
end)