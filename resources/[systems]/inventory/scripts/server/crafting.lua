Station = {}
Station.__index = Station

--[[ Functions: Station ]]--
function Station:Create(id, _type, isAuto)
	if not id or not _type then return end

	local station = setmetatable({
		id = id,
		type = _type,
		isAuto = isAuto,
		locked = {},
	}, Station)

	station.container = Inventory:LoadContainer({
		sid = "c"..id,
		type = "station",
		protected = true,
	}, true)

	Inventory.stations[id] = station

	return station
end

function Station:Unload()
	if self.container then
		self.container:Destroy()
	end
	
	Inventory.stations[self.id] = nil
end

function Station:Destroy()
	if self.container then
		self.container:Destroy(true)
	end
	
	self:Unload()
end

function Station:Update()
	if not self.isAuto and not self.player then return end

	local crafting = self.crafting
	if not crafting then return end

	local recipe = self.recipe
	if not recipe then return end

	local time = os.clock()
	local delta = time - (self.lastUpdate or time)

	crafting.progress = crafting.progress + math.floor(delta * 1000.0)

	if crafting.progress > recipe.duration then
		self:FinishCrafting()
	end

	self.lastUpdate = time
end

function Station:BeginCrafting(source, name)
	-- Check already crafting.
	if self.crafting and self.crafting.name ~= name then
		return false, "already crafting"
	end

	-- Check recipe.
	local recipe = Inventory.recipes[FormatName(name)]
	if not recipe then
		return false, "no recipe"
	end

	-- Get player container.
	local playerContainer = Inventory:GetPlayerContainer(source)
	if not playerContainer then
		return false, "no player container"
	end

	-- Check self container.
	local targetContainer = self.container
	if not targetContainer then
		return false, "missing storage"
	end

	-- Cache input.
	local inputCache = {}
	for k, input in ipairs(recipe.input) do
		local item = Inventory:GetItem(input.name)
		if item then
			inputCache[item.id] = input.quantity or (input.durability and -input.durability)
		end
	end

	-- Count items.
	for k, input in ipairs(recipe.input) do
		local count = playerContainer:CountItem(input.name)
		if count < (input.quantity or 1) then
			return false, "missing requirement"
		end
	end

	-- Cache lockCache.
	local lockCache = {}
	for i = 0, targetContainer:GetSize() - 1 do
		local slot = targetContainer.slots[i]
		if slot then
			lockCache[i] = slot.quantity
		end
	end

	-- Move items.
	for i = 0, playerContainer:GetSize() - 1 do
		local slot = playerContainer.slots[i]
		local cache = slot and inputCache[slot.item_id]
		if cache and cache > 0 then
			local amount = math.min(cache, slot.quantity)

			if not playerContainer:MoveSlot(slot.slot_id, { container = targetContainer.id }, amount, source) then
				return false, "failed moving"
			end

			cache = cache - amount
			inputCache[slot.item_id] = cache
		elseif cache and cache < 0.0 then
			if not slot:Decay(-cache / (slot.quantity or 1)) then
				return false, "can't decay"
			end

			inputCache[slot.item_id] = nil
		end
	end

	-- Check slots.
	for i = 0, targetContainer:GetSize() - 1 do
		local slot = targetContainer.slots[i]
		local locked = lockCache[i]
		if slot and (not locked or locked ~= slot.quantity) then
			self.locked[i] = slot.quantity
		end
	end

	-- Cache craft.
	local crafting = self.crafting or {
		progress = 0,
		quantity = 0,
		name = name,
	}

	-- Increment quantity.
	local quantity = crafting.quantity + 1
	crafting.quantity = quantity
	
	-- Initialize recipe.
	if quantity == 1 then
		self.crafting = crafting
		self.recipe = recipe
		self.lastUpdate = os.clock()
	end

	-- Inform player.
	if self.player then
		TriggerClientEvent(EventPrefix.."beginCrafting", self.player, crafting)
		self:UpdateStorage()
	end
end

function Station:FinishCrafting()
	local crafting = self.crafting
	if not crafting then return end

	local recipe = self.recipe
	if not recipe then return end

	local container = self.container
	if not container then return end

	crafting.progress = 0
	crafting.quantity = crafting.quantity - 1

	-- Take items.
	for k, input in ipairs(recipe.input) do
		if input.quantity and not container:RemoveItem(input.name, input.quantity) then
			return false, "didn't take input"
		end
	end

	-- Cache before.
	if crafting.quantity <= 0 then
		self.locked = {}
		self.crafting = nil
	else
		local before = {}
		for i = 0, container:GetSize() - 1 do
			local slot = container.slots[i]
			if not slot then
				self.locked[i] = nil
			end
		end
	end

	-- Output items.
	for k, output in ipairs(recipe.output) do
		container:AddItem(output.name, output.quantity)
	end

	if self.player then
		if crafting.quantity <= 0 then
			TriggerClientEvent(EventPrefix.."clearCrafting", self.player)
		else
			TriggerClientEvent(EventPrefix.."beginCrafting", self.player, crafting)
		end
		self:UpdateStorage()
	end
end

function Station:CancelOne(source)
	local crafting = self.crafting
	if not crafting then return end

	crafting.quantity = math.max(crafting.quantity - 1, 0)

	if crafting.quantity <= 0 then
		self.locked = {}
		self.crafting = nil
		self.progress = 0
	end

	if self.player then
		if crafting.quantity <= 0 then
			TriggerClientEvent(EventPrefix.."clearCrafting", self.player)
		else
			TriggerClientEvent(EventPrefix.."beginCrafting", self.player, crafting)
		end
		self:UpdateStorage()
	end
end

function Station:GetStorage()
	local container = self.container
	if not container then return end

	local storage = {}
	local hasItem = false

	for i = 0, container:GetSize() - 1 do
		local slot = container.slots[i]
		if slot then
			slot.locked = self.locked[i] ~= nil
			storage[tostring(i)] = slot
			hasItem = true
		end
	end

	return hasItem and storage or nil
end

function Station:UpdateStorage()
	if not self.player then return end

	TriggerClientEvent(EventPrefix.."updateStorage", self.player, self:GetStorage())
end

--[[ Functions: Inventory ]]--
function Inventory:RegisterRecipe(recipe)
	if self.initialized then
		error("NOT YET IMPLEMENTED: Registering items post initialization")
	end

	self.recipes[FormatName(recipe.name)] = recipe
end

function Inventory:RegisterStation(...)
	return Station:Create(...)
end
Inventory:Export("RegisterStation")

function Inventory:DestroyStation(id)
	local station = self.stations[id or false]
	if station then
		station:Destroy()
	end
end
Inventory:Export("DestroyStation")

function Inventory:UnloadStation(id)
	local station = self.stations[id or false]
	if station then
		station:Unload()
	end
end
Inventory:Export("UnloadStation")

function Inventory:SubscribeStation(source, id, value)
	local player = self.players[source]
	if not player then return false end
	
	local station = self.stations[id or false]
	if not station then return false end

	if (station.player and (value or station.player ~= source)) or (not station.player and not value) then
		return false
	end

	Debug("Subscribed to station: [%s] to %s (%s)", source, id, value)

	player.station = value and id or nil
	station.player = value and source or nil

	TriggerClientEvent(EventPrefix.."toggleStation", source, id, value and station.type, value and station.crafting, station:GetStorage())

	return true
end
Inventory:Export("SubscribeStation")

--[[ Events: Net ]]--
RegisterNetEvent(EventPrefix.."beginCrafting", function(name)
	local source = source

	if type(name) ~= "string" then return end

	local player = Inventory.players[source]
	if not player or player:GetTimeSinceLastAction() < 0.1 then return end

	local station = Inventory.stations[player.station or false]
	if not station then return end

	player:UpdateLastAction()
	station:BeginCrafting(source, name)
end)

RegisterNetEvent(EventPrefix.."clearCrafting", function()
	local source = source

	local player = Inventory.players[source]
	if not player or player:GetTimeSinceLastAction() < 0.1 then return end

	local station = Inventory.stations[player.station or false]
	if not station then return end

	player:UpdateLastAction()
	station:CancelOne(source)
end)

RegisterNetEvent(EventPrefix.."moveStorage", function(slotId, to)
	local source = source

	slotId = tonumber(slotId)

	if not slotId or type(to) ~= "table" then return end

	-- Get target slot.
	local targetSlotId = tonumber(to.slot)
	if not targetSlotId then return end

	-- Get player.
	local player = Inventory.players[source]
	if not player or player:GetTimeSinceLastAction() < 0.1 then return end
	
	-- Get station.
	local station = Inventory.stations[player.station or false]
	if not station then return end
	
	local container = station.container
	if not container then return end

	-- Check slot.
	if station.locked[slotId] then return end
	
	-- Check slot.
	local slot = container.slots[slotId]
	if not slot then return end

	-- Get player container.
	local playerContainer = Inventory:GetPlayerContainer(source)
	if not playerContainer then return end

	-- Check slot is empty.
	local targetSlot = playerContainer.slots[targetSlotId]
	if targetSlot and targetSlot.item_id ~= slot.item_id then return end

	-- Move slot.
	if container:MoveSlot(slotId, { container = playerContainer.id, slot = targetSlotId }, slot.quantity, source) then
		station:UpdateStorage()
	end

	-- Update player.
	player:UpdateLastAction()
end)

--[[ Threads ]]--
Citizen.CreateThread(function()
	while true do
		for id, station in pairs(Inventory.stations) do
			station:Update()
		end

		Citizen.Wait(0)
	end
end)