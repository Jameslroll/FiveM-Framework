Main = {}

--[[ Functions ]]--
function Main:Init()
	self.grids = {}
	self.cached = {}

	for k, property in ipairs(Properties) do
		local gridId = Grids:GetGrid(property.coords, Config.GridSize)
		local grid = self.grids[gridId]
		if not grid then
			grid = {}
			self.grids[gridId] = grid
		end

		grid[#grid + 1] = k
	end

	local ped = PlayerPedId()
	local coords = GetEntityCoords(ped)

	self:UpdateGrids(nil, Grids:GetNearbyGrids(coords, Config.GridSize))
end

function Main:UpdateGrids(_, nearbyGrids)
	local temp = {}
	for _, gridId in ipairs(nearbyGrids) do
		temp[gridId] = true
		if not self.cached[gridId] then
			self.cached[gridId] = true
			self:RegisterGrid(gridId)
		end
	end

	for gridId, _ in pairs(self.cached) do
		if not temp[gridId] then
			self.cached[gridId] = nil
			self:UnregisterGrid(gridId)
		end
	end
end

function Main:RegisterGrid(gridId)
	-- local grid = self.grids[gridId]
	-- if not grid then return end

	-- for _, propertyId in ipairs(grid) do
	-- 	self:RegisterEntity(propertyId)
	-- end
end

function Main:UnregisterGrid(gridId)
	-- local grid = self.grids[gridId]
	-- if not grid then return end

	-- for _, propertyId in ipairs(grid) do
	-- 	local property = Properties[propertyId]
	-- 	exports.entities:Destroy("property-"..propertyId)
		
	-- 	if property.garage then
	-- 		exports.entities:Destroy("garage-"..propertyId)
	-- 	end
	-- end
end

function Main:RegisterEntity(propertyId)
	local property = Properties[propertyId]
	if not property then return end

	local options = {}

	exports.entities:Register({
		id = "property-"..propertyId,
		name = "Property "..propertyId,
		coords = property.coords,
		radius = 1.0,
		navigation = {
			id = "property",
			text = "Property",
			icon = "house",
			sub = {
				{
					id = "enterProperty",
					text = "Enter",
					icon = "door_front",
				},
				{
					id = "knockProperty",
					text = "Knock",
					icon = "notifications",
				},
				{
					id = "lockProperty",
					text = "Toggle Lock",
					icon = "lock",
				},
				{
					id = "examineProperty",
					text = "Examine",
					icon = "search",
				},
			},
		},
	})

	if property.garage then
		exports.entities:Register({
			id = "garage-"..propertyId,
			name = "Property "..propertyId.." Garage",
			coords = property.garage,
			radius = 3.0,
			navigation = {
				id = "garage",
				text = "Garage",
				icon = "garage",
			},
		})
	end
end

function Main:FindNearestProperty(coords)
	if type(coords) ~= "vector3" then return end
	
	local nearestProperty, nearestDist = nil, 0.0
	for gridId, _ in pairs(self.cached) do
		local grid = self.grids[gridId]
		if grid then
			for _, propertyId in ipairs(grid) do
				local property = Properties[propertyId]
				if property and property.coords then
					local _coords = property.coords
					local propertyDist = #(vector3(_coords.x, _coords.y, _coords.z) - coords)
					if not nearestProperty or propertyDist < nearestDist then
						nearestDist = propertyDist
						nearestProperty = property
					end
				end
			end
		end
	end

	return nearestProperty, nearestDist
end

function Main:EnterShell(id, coords)
	local shell = Config.Shells[id]
	if not shell then
		error(("shell does not exist (%s)"):format(id))
	end

	if not IsModelValid(shell.Model) then
		error(("invalid model for shell (%s)"):format(id))
	end

	while not HasModelLoaded(shell.Model) do
		RequestModel(shell.Model)
		Citizen.Wait(20)
	end

	local entity = CreateObject(shell.Model, coords.x, coords.y, coords.z, false, true)

	FreezeEntityPosition(entity, true)
	SetEntityCanBeDamaged(entity, false)
	SetEntityInvincible(entity, true)
	SetEntityDynamic(entity, false)
	SetEntityHasGravity(entity, false)
	SetEntityLights(entity, false)
	
	local ped = PlayerPedId()
	local entry = vector4(coords.x, coords.y, coords.z, 0.0) + shell.Entry

	SetEntityVelocity(ped, 0.0, 0.0, 0.0)
	SetEntityCoordsNoOffset(ped, entry.x, entry.y, entry.z, true)
	SetEntityHeading(ped, entry.w)
	ClearPedTasksImmediately(ped)

	self.coords = coords
	self.shell = shell
	self.entity = entity

	exports.sync:SetNighttime(true)
	-- exports.sync:SetBlackout(true)

	exports.entities:Register({
		id = "propertyExit",
		name = "Property Exit",
		coords = entry,
		radius = 1.0,
		navigation = {
			id = "property",
			text = "Property",
			icon = "house",
			sub = {
				{
					id = "exitProperty",
					text = "Exit",
					icon = "door_front",
				},
				{
					id = "lockProperty",
					text = "Toggle Lock",
					icon = "lock",
				},
			}
		}
	})
end

function Main:Exit()
	if self.entity and DoesEntityExist(self.entity) then
		DeleteEntity(self.entity)
	end

	self.coords = nil
	self.shell = nil
	self.entity = nil

	local ped = PlayerPedId()
	local coords = self.entry
	if coords then
		SetEntityCoordsNoOffset(ped, coords.x, coords.y, coords.z, true)
		SetEntityHeading(ped, coords.w + 180.0)
	end

	exports.entities:Destroy("propertyExit")
	exports.sync:SetNighttime(false)
	-- exports.sync:SetBlackout(false)
end

function Main:Update()
	local shell = self.shell
	if not shell then return end

	local coords = self.coords and vector3(self.coords.x, self.coords.y, self.coords.z) or vector3(0.0, 0.0, 0.0)
	
	-- Update world.
	SetRainLevel(0.0)
end

function Main:AddOption(property)
	local options = {}

	options = {
		{
			id = "enterProperty",
			text = "Enter",
			icon = "door_front",
		},
		{
			id = "knockProperty",
			text = "Knock",
			icon = "notifications",
		},
		{
			id = "lockProperty",
			text = "Toggle Lock",
			icon = "lock",
		},
		{
			id = "examineProperty",
			text = "Examine",
			icon = "search",
		},
	}

	exports.interact:AddOption({
		id = "property",
		text = "Property",
		icon = "house",
		sub = options,
	})
end

Citizen.CreateThread(function()
	while true do
		Main:Update()
		Citizen.Wait(0)
	end
end)

--[[ Events ]]--
AddEventHandler("properties:clientStart", function()
	Main:Init()
	-- Main:EnterShell("test")
end)

AddEventHandler("interact:navigate", function(value)
	if not value then
		exports.interact:RemoveOption("property")
		return
	end

	local ped = PlayerPedId()
	local coords = GetEntityCoords(ped)
	local property, distance = Main:FindNearestProperty(coords)

	if property and distance < Config.DoorRadius then
		TriggerServerEvent("properties:request", property.id)
	end
end)

AddEventHandler("interact:onNavigate_enterProperty", function(option)
	local ped = PlayerPedId()
	local coords = GetEntityCoords(ped)
	local property, dist = Main:FindNearestProperty(coords)
	if not property then return end

	local shell = "motel"

	Main.entry = property.coords
	Main:EnterShell(shell, property.coords + vector4(0.0, 0.0, 200.0, 0.0))
end)

AddEventHandler("interact:onNavigate_exitProperty", function(option)
	Main:Exit()
end)

AddEventHandler("grids:enter"..Config.GridSize, function(...)
	Main:UpdateGrids(...)
end)

--[[ Events: Net ]]--
RegisterNetEvent("properties:receive", function(property)
	Main:AddOption(property)
end)

--[[ Commands ]]--
exports.chat:RegisterCommand("a:createshells", function(source, args, command)
	local ped = PlayerPedId()
	local coords = GetEntityCoords(ped)

	for k, model in ipairs(Config.Models) do
		while not HasModelLoaded(model) do
			RequestModel(model)
			Citizen.Wait(0)
		end

		coords = coords + vector3(0.0, 0.0, 20.0)

		local entity = CreateObject(model, coords.x, coords.y, coords.z, true, true)
		
		FreezeEntityPosition(entity, true)
		SetEntityCanBeDamaged(entity, false)
		SetEntityInvincible(entity, true)
		SetEntityDynamic(entity, false)
		SetEntityHasGravity(entity, false)
		SetEntityLights(entity, false)

		print(k, model)
	end
end, {
	description = "Instance all interior shells."
}, "Dev")