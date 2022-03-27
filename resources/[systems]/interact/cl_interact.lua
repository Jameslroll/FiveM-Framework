Interaction = {
	entities = {},
	gridCache = {},
	grids = {},
	index = 1,
	interactables = {},
	models = {},
	options = {},
	optionsCache = {},
}

function Interaction:AddOption(id, type, entity)
	if not id then return end

	-- Get the interaction.
	local interactable = self.interactables[id]
	if not interactable then return end

	-- Conditions.
	local isVisible, canUse = interactable:UpdateConditions()
	if not isVisible then
		return
	end

	-- Embedded options.
	if interactable.embedded then
		for _, embed in ipairs(interactable.embedded) do
			self:AddOption(embed.id, type)
		end
		return
	end

	-- Check it's already an option.
	if self.options[id] then
		return
	end

	-- Send to NUI.
	SendNUIMessage({
		method = "addInteraction",
		data = {
			id = id,
			text = interactable.overrideText or interactable.text,
			index = (self.index or 1) - 1,
		},
	})

	-- Update caches.
	self.optionsCache[id] = {
		type = type,
		entity = entity,
	}

	table.insert(self.options, id)
end

function Interaction:RemoveOption(id)
	-- Check it exists.
	if not self.optionsCache[id] then
		return
	end

	-- Send to NUI.
	SendNUIMessage({
		method = "removeInteraction",
		data = {
			id = id,
		},
	})

	-- Update caches.
	self.optionsCache[id] = nil
	
	for k, v in ipairs(self.options) do
		if v == id then
			table.remove(self.options, k)

			if k >= #self.options and #self.options > 0 then
				self:SetOption(#self.options)
			end
			
			break
		end
	end
end

function Interaction:NextOption(direction)
	local count = #self.options
	if (count or 0) < 1 then return end
	
	-- Get the index.
	local index = (self.index or 1) + direction
	if index < 1 then
		index = count
	elseif index > count then
		index = 1
	end

	-- Set the index.
	self:SetOption(index)
end

function Interaction:SetOption(index)
	-- Cache index.
	self.index = index

	-- Send to NUI.
	SendNUIMessage({
		method = "selectInteraction",
		data = {
			index = index - 1
		}
	})
end

function Interaction:SelectOption()
	if not self.index then return end
	
	local id = self.options[self.index]
	if not id then return end

	-- Get interactable.
	local interactable = self.interactables[id]
	if not interactable then return end

	-- Check conditions.
	local isVisible, canUse = interactable:UpdateConditions()
	if not isVisible or not canUse then return end

	-- Get cache.
	local cache = self.optionsCache[id] or {}
	interactable.entity = cache.entity

	-- Trigger events.
	local eventName = "interact:on_"..(interactable.event or id)

	TriggerEvent(eventName, interactable)
	TriggerServerEvent(eventName)

	self:ClearOptions()
	self.lastInteract = GetGameTimer()
end

function Interaction:ClearOptions()
	if #self.options == 0 then return end

	self.entity = nil
	self.shapeHit = nil

	for id, cache in pairs(self.optionsCache) do
		self:RemoveOption(id)
	end
end

function Interaction:Register(data)
	if data == nil then
		error("registering interaction without data")
	elseif data.id == nil then
		error("registering interaction without id")
	end

	local interactable = self.interactables[data.id]
	if interactable ~= nil then
		self:Destroy(data.id)
	end

	interactable = Interactable:Create(data)
	self.interactables[data.id] = interactable

	self:RegisterModel(data)
	self:RegisterShape(data)
	self:RegisterEntity(data)

	if data.embedded ~= nil then
		for _, embed in ipairs(data.embedded) do
			embed.parent = data.id
			embed.event = embed.event or data.event

			self:Register(embed)
		end
	end
end

function Interaction:Destroy(id)
	local interactable = self.interactables[id]
	if interactable == nil then return end

	self:RegisterModel(interactable, true)
	self:RegisterShape(interactable, true)
	self:RegisterEntity(interactable, true)

	if interactable.embedded ~= nil then
		for _, embed in ipairs(interactable.embedded) do
			self:Destroy(embed.id)
		end
	end

	self.interactables[id] = nil
end

function Interaction:RegisterModel(data, clear)
	if data.model == nil then return end

	-- Convert to hash.
	if type(data.model) == "string" then
		data.model = GetHashKey(data.model)
	end

	-- Get the cache.
	local models = self.models[data.model]
	if clear then
		if models then
			models[data.id] = nil
			local isEmpty = true
			for k, v in pairs(models) do
				isEmpty = false
				break
			end
			if isEmpty then
				self.models[data.model] = nil
			end
		end
		return
	elseif not self.models[data.model] then
		models = {}
		self.models[data.model] = models
	end

	-- Cache the model.
	models[data.id] = true
end

function Interaction:RegisterShape(data, clear)
	if data.radius == nil then return end

	-- Get the grid.
	local gridIndex = Grids:GetGrid(data.coords, Config.GridSize)
	local grid = self.grids[gridIndex]
	if clear then
		if grid then
			grid[data.id] = nil
			local isEmpty = true
			for k, v in pairs(grid) do
				isEmpty = false
				break
			end
			if isEmpty then
				self.grids[gridIndex] = nil
			end
		end
		return
	elseif not grid then
		grid = {}
		self.grids[gridIndex] = grid
	end

	-- Cache the shape.
	grid[data.id] = true
end

function Interaction:RegisterEntity(data, clear)
	if data.entity == nil then return end

	-- Get the cache.
	local entities = self.entities[data.entity]
	if clear then
		if entities then
			entities[data.id] = nil
			local isEmpty = true
			for k, v in pairs(entities) do
				isEmpty = false
				break
			end
			if isEmpty then
				self.entities[data.entity] = nil
			end
		end
		return
	elseif not entities then
		entities = {}
		self.entities[data.entity] = entities
	end
	
	-- Cache the entity.
	entities[data.id] = true
end

function Interaction:Update()
	-- Cooldowns.
	if GetGameTimer() - (self.lastInteract or 0) < Config.Cooldown then
		return
	end

	-- Get ped.
	local ped = PlayerPedId()
	
	-- Closing.
	if IsPauseMenuActive() or IsPedRagdoll(ped) or GetGameTimer() - (self.lastSuppress or 0) < 500 then
		self:ClearOptions()
		return
	end

	-- Ped stuff.
	local coords = GetEntityCoords(ped)
	local isInVehicle = IsPedInAnyVehicle(ped)
	local isSwimming = IsPedSwimming(ped)
	local isUnderwater = IsPedSwimmingUnderWater(ped)

	-- Raycast.
	local retval, didHit, hitCoords, surfaceNormal, materialHash, entity = Raycast(-1)
	local isEntity = didHit and GetEntityType(entity) ~= 0
	local isNearby = false
	local modelCache, entityCache, model

	if isEntity then
		local distance = Config.MaxDistance
		
		model = GetEntityModel(entity)

		modelCache = self.models[model]
		entityCache = self.entities[entity]

		if modelCache then
			for id, _ in pairs(modelCache) do
				local interactable = self.interactables[id]
				if interactable and interactable.distance then
					distance = math.max(distance, interactable.distance)
				end
			end
		end

		if entityCache then
			for id, _ in pairs(entityCache) do
				local interactable = self.interactables[id]
				if interactable and interactable.distance then
					distance = math.max(distance, interactable.distance)
				end
			end
		end

		isNearby = #(coords - hitCoords) < distance
	end
	
	if not isNearby then
		entity = nil
	end

	local options = {}

	if self.entity ~= entity then
		self.entity = entity

		for id, cache in pairs(self.optionsCache) do
			if cache.type == "entity" then
				self:RemoveOption(id)
			end
		end

		if entity then
			-- Model based.
			if modelCache then
				for option, _ in pairs(modelCache) do
					table.insert(options, {
						id = option,
						type = "entity",
						entity = entity,
					})
				end
			end

			-- Entity based.
			if entityCache then
				for option, _ in pairs(entityCache) do
					table.insert(options, {
						id = option,
						type = "entity",
						entity = entity,
					})
				end
			end
		end
	end

	-- Shapes.
	local shapeHit = nil

	for _, id in pairs(self.gridCache) do
		local interactable = self.interactables[id]
		if interactable then
			local size = interactable.radius
			if #(coords - interactable.coords) < Config.MaxDistance + size then
				local didHit, sphereHit = false, nil
				if interactable.radius then
					didHit, sphereHit = IntersectSphere(CamCoords, CamForward, interactable.coords, interactable.radius)
				end
				if didHit ~= 0 then
					local _retval, _didHit, _hitCoords, _surfaceNormal, _materialHash, _entity = Raycast(1)
					if #(sphereHit - CamCoords) < #(_hitCoords - CamCoords) then
						shapeHit = id
						break
					end
				end
			end
		end
	end

	if self.shapeHit ~= shapeHit then
		self.shapeHit = shapeHit

		for id, cache in pairs(self.optionsCache) do
			if cache.type == "shape" then
				self:RemoveOption(id)
			end
		end

		if shapeHit then
			table.insert(options, {
				id = shapeHit,
				type = "shape",
			})
		end
	end

	-- Add options.
	if #options > 0 then
		self.index = math.min(self.index, #options)

		table.sort(options, function(a, b)
			return a.id < b.id
		end)

		for k, option in ipairs(options) do
			self:AddOption(option.id, option.type, option.entity)
		end
	end
end

function Interaction:UpdateGrids()
	self.gridCache = {}

	local grids = Grids:GetNearbyGrids(CamCoords, Config.GridSize)
	for _, gridIndex in ipairs(grids) do
		local grid = self.grids[gridIndex]
		if grid then
			for id, info in pairs(grid) do
				table.insert(self.gridCache, id)
			end
		end
	end
end

--[[ Exports ]]--
exports("Register", function(data)
	data.resource = GetInvokingResource()

	Interaction:Register(data)
end)

exports("Destroy", function(data)
	Interaction:Destroy(data)
end)

exports("Set", function(id, key, value)
	local interactable = Interaction.interactables[id]
	if not interactable then return end

	interactable[key] = value
end)

exports("ClearOptions", function(entity)
	if entity and Interaction.entity ~= entity then
		return
	end

	Interaction:ClearOptions()
end)

--[[ NUI Callbacks ]]--
RegisterNUICallback("ready", function(data, cb)
	cb(true)
	
	Interaction.ready = true
end)

--[[ Events ]]--
AddEventHandler("interact:suppress", function()
	Interaction.lastSuppress = GetGameTimer()
end)

AddEventHandler("onResourceStop", function(resourceName)
	for id, interactable in pairs(Interaction.interactables) do
		if interactable.resource == resourceName then
			Interaction:Destroy(id)
		end
	end
end)

--[[ Threads ]]--
Citizen.CreateThread(function()
	while true do
		Interaction:Update()

		Citizen.Wait(0)
	end
end)

Citizen.CreateThread(function()
	while true do
		Interaction:UpdateGrids()

		Citizen.Wait(1000)
	end
end)

--[[ Commands ]]--
RegisterKeyMapping("+roleplay_interact", "Interact", "MOUSE_BUTTON", "MOUSE_MIDDLE")
RegisterCommand("+roleplay_interact", function(source, args, command)
	Interaction:SelectOption()
end, true)

RegisterKeyMapping("+roleplay_interactup", "Interact - Previous", "MOUSE_WHEEL", "IOM_WHEEL_UP")
RegisterCommand("+roleplay_interactup", function(source, args, command)
	Interaction:NextOption(-1)
end, true)

RegisterKeyMapping("+roleplay_interactdown", "Interact - Next", "MOUSE_WHEEL", "IOM_WHEEL_DOWN")
RegisterCommand("+roleplay_interactdown", function(source, args, command)
	Interaction:NextOption(1)
end, true)

RegisterCommand("interact:debug", function(source, args, command)
	for k, v in pairs(Interaction) do
		if type(v) == "table" then
			Citizen.Trace("\n"..k.."\n")
			for _k, _v in pairs(v) do
				Citizen.Trace(json.encode(_v).."\n")
			end
		end
	end
end, true)