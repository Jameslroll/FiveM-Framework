Drops = {
	entities = {},
	clearQueue = {},
	addQueue = {},
}

--[[ Functions: Doors ]]--
function Drops:Update()
	local ped = PlayerPedId()
	local coords = GetEntityCoords(ped)

	for id, container in pairs(Inventory.containers) do
		if container.coords ~= nil then
			local dist = #(container.coords - coords)
			if dist > Config.Drops.MaxDistance then
				container:Unsubscribe()
			end
		end
	end

	self:ProcessQueue()
end

function Drops:ProcessQueue()
	local count = 0

	for id, _ in pairs(self.clearQueue) do
		self:Remove(id)
		self.clearQueue[id] = nil

		count = count + 1
		if count > 5 then break end
	end

	for id, data in pairs(self.addQueue) do
		self:Add(id, data)
		self.addQueue[id] = nil

		count = count + 1
		if count > 5 then break end
	end
end

function Drops:QueueAdd(id, data)
	-- Remove from clear queue.
	if self.clearQueue[id] ~= nil then
		self.clearQueue[id] = nil
	end
	
	-- Check redunancies.
	if self.addQueue[id] ~= nil or self.entities[id] then return end
	
	-- Add to addition queue.
	self.addQueue[id] = data
end

function Drops:QueueRemove(id)
	-- Remove it from addition queue.
	if self.addQueue[id] ~= nil then
		self.addQueue[id] = nil
	end

	-- Check it exists.
	if self.entities[id] == nil then return end

	-- Add to clear queue.
	self.clearQueue[id] = true
end

function Drops:Add(id, data)
	Debug("Add drop: %s", id)

	if data.items ~= nil and not data.discrete then
		local count = 0
		local models = {}
		local seed = GetHashKey(id)

		for itemId, quantity in pairs(data.items) do
			local item = Inventory:GetItem(itemId)
			if item ~= nil then
				local model = item.model
				local rotation = nil
				local offset = vector3(0.0, 0.0, 0.0)
				if type(model) == "table" then
					offset = model[3] or offset
					rotation = model[2]
					model = model[1]
				end
				model = GetHashKey(model or Config.Drops.Models[item.category or "Default"] or Config.Drops.Models["Default"])

				if models[model] == nil then
					math.randomseed(seed + model)

					local radian = math.random() * 6.2832
					math.randomseed(seed + model + 52)
					
					local dist = math.random() * (data.radius or Config.Drops.Radius)
					math.randomseed(seed + model + 23)

					offset = offset + vector3(math.cos(radian) * dist, math.sin(radian) * dist, 0.0)
					local heading = math.random() * 360.0

					if rotation ~= nil then
						rotation = vector3(rotation.x, rotation.y, rotation.z + heading)
					end
					
					local entity = self:CreateEntity(id, model, data.coords, rotation or heading, offset)
					SetEntityCollision(entity, false, false)

					models[model] = true
				end
			end
		end
	else
		local settings = Config.Containers[data.type or "default"] or Config.Containers["default"]
		if settings.model ~= nil then
			self:CreateEntity(id, GetHashKey(settings.model), data.coords, data.heading)
		end
	end

	-- Register interact.
	exports.interact:Register({
		id = "drop-"..id,
		text = data.text or "Open",
		coords = data.coords,
		radius = data.radius or Config.Drops.Radius,
		event = "openContainer",
		container = id,
	})
end

function Drops:Remove(id)
	Debug("Remove drop: %s", id)

	-- Get entities.
	local entities = self.entities[id]
	if entities == nil then return end

	-- Remove entities.
	for _, entity in ipairs(entities) do
		if DoesEntityExist(entity) then
			DeleteEntity(entity)
		end
	end

	-- Uncache entity.
	self.entities[id] = nil

	-- Destroy interact.
	exports.interact:Destroy("drop-"..id)
end

function Drops:CreateEntity(id, model, coords, rotation, offset)
	-- Check model.
	if not IsModelValid(model) then
		print("invalid model for drop", model)
		return
	end

	-- Request model.
	while not HasModelLoaded(model) do
		RequestModel(model)
		Citizen.Wait(100)
	end

	-- Create entity.
	local entity = CreateObject(model, coords.x, coords.y, coords.z, false, true, false)
	SetEntityVisible(entity, false)
	SetEntityLodDist(entity, 512)
	FreezeEntityPosition(entity, true)
	SetEntityAsMissionEntity(entity)
	
	-- Cache entity.
	local entities = self.entities[id]
	if entities == nil then
		entities = {}
		self.entities[id] = entities
	end
	entities[#entities + 1] = entity
	
	-- Position/rotate on ground.
	Citizen.CreateThread(function()
		local startTime = GetGameTimer()
		local rotationType = type(rotation)
		if rotationType == "number" then
			SetEntityHeading(entity, rotation or 0.0)
			while DoesEntityExist(entity) and not PlaceObjectOnGroundProperly(entity) and GetGameTimer() - startTime < 5000 do
				Citizen.Wait(100)
			end
		elseif rotationType == "vector3" or rotationType == "vector4" then
			local hasGround, groundZ = false, coords.z
			while DoesEntityExist(entity) and GetGameTimer() - startTime < 5000 do
				hasGround, groundZ = GetGroundZFor_3dCoord(coords.x, coords.y, coords.z)
				if hasGround then
					break
				else
					Citizen.Wait(100)
				end
			end
			if DoesEntityExist(entity) then
				SetEntityCoords(entity, coords.x, coords.y, groundZ)
				SetEntityRotation(entity, rotation.x, rotation.y, rotation.z)
			end
		end

		if DoesEntityExist(entity) then
			SetEntityVisible(entity, true)

			if offset then
				SetEntityCoords(entity, GetEntityCoords(entity) + offset)
			end
		end
	end)

	-- Return.
	return entity
end

function Drops:ClearAll()
	for id, entities in pairs(self.entities) do
		self:Remove(id)
	end

	self.entities = {}
end

--[[ Hooks ]]--
-- Inventory:AddHook("registerContainer", function(container)
-- 	if container.coords then
		
-- 	end
-- end)

--[[ Events ]]--
RegisterNetEvent(EventPrefix.."updateDrops", function(data)
	if data.grids ~= nil then
		-- local startTime = GetGameTimer()
		-- Drops:ClearAll()
		local added = {}
		
		for _, grid in ipairs(data.grids) do
			for id, data in pairs(grid) do
				-- if startTime ~= Drops.lastUpdate then
				-- 	break
				-- end

				-- Drops:Add(id, data)
				Drops:QueueAdd(id, data)
				added[id] = true
			end
		end
		
		for id, entity in pairs(Drops.entities) do
			if not added[id] then
				Drops:QueueRemove(id)
			end
		end
	elseif data.add ~= nil then
		Drops:QueueAdd(data.add.id, data.add.data)
	elseif data.update ~= nil then
		Drops:Remove(data.update.id)
		Drops:Add(data.update.id, data.update.data)
	elseif data.remove ~= nil then
		Drops:Remove(data.remove.id)
	end
end)

AddEventHandler(EventPrefix.."stop", function()
	Drops:ClearAll()
end)

AddEventHandler("interact:on_openContainer", function(interactable)
	-- Get container.
	local container = interactable.container
	if not container then return end

	-- Subscribe to container.
	TriggerServerEvent(EventPrefix.."subscribe", tonumber(container) or container, true)

	-- Open inventory.
	Menu:Focus(true)
end)