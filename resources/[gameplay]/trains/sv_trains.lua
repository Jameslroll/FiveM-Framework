Main = {
	gridIndexes = {},
	grids = {},
	playerGrids = {},
	players = {},
	trainCount = 0,
	trains = {},
}

--[[ Functions ]]--
function Main:Init()
	for i = 1, GetNumPlayerIndices() do
		local source = tonumber(GetPlayerFromIndex(i - 1))
		local ped = GetPlayerPed(source)
		local coords = GetEntityCoords(ped)
		local gridIndex = Grids:GetGrid(coords, Config.GridSize)

		self.players[source] = gridIndex
		self.playerGrids[gridIndex] = (self.playerGrids[gridIndex] or 0) + 1
	end

	for trackIndex, track in pairs(Tracks) do
		for nodeIndex, node in pairs(track.Nodes) do
			local gridIndex = Grids:GetGrid(node, Config.GridSize)
			local grid = self.grids[gridIndex]
			if not grid then
				grid = {}
				self.grids[gridIndex] = grid
				table.insert(self.gridIndexes, gridIndex)
			end

			grid[#grid + 1] = vector4(node.x, node.y, node.z, trackIndex)
		end
	end
end

function Main:Update()
	for entity, _ in pairs(self.trains) do
		TriggerClientEvent(
			"trains:sync",
			-1,
			NetworkGetNetworkIdFromEntity(entity),
			GetEntityCoords(entity),
			GetEntityHeading(entity),
			GetEntityVelocity(entity)
		)

		Citizen.Wait(20)
	end
end

function Main:GetRandomNode(retries)
	if retries and retries > Config.MaxRetries then return end

	local gridIndex = self.gridIndexes[GetRandomIntInRange(1, #self.gridIndexes + 1)]
	if not gridIndex then return end

	-- Check for players.
	for _, nearbyGrid in ipairs(Grids:GetNearbyGrids(gridIndex, Config.GridSize)) do
		if self.playerGrids[nearbyGrid] then
			return self:GetRandomNode((retries or 0) + 1)
		end
	end

	-- Get node.
	local grid = self.grids[gridIndex]
	local node = grid[GetRandomIntInRange(1, #grid)]
	
	-- Check for other trains.
	local coords = vector3(node.x, node.y, node.z)
	for entity, _ in pairs(self.trains) do
		local _coords = GetEntityCoords(entity)
		local dist = #(coords - _coords)
		
		if dist < Config.MinDistance then
			return self:GetRandomNode((retries or 0) + 1)
		end
	end

	-- Return node.
	return node
end

function Main:SpawnTrain()
	-- Find node.
	local node = self:GetRandomNode()
	if not node then return end

	local coords = vector3(node.x, node.y, node.z)

	-- Find nearest player.
	local nearestPlayer, nearestDist = nil, 0.0
	for source, _ in pairs(self.players) do
		local ped = GetPlayerPed(source)
		local _coords = GetEntityCoords(ped)
		local dist = #(coords - _coords)

		if not nearestPlayer or dist < nearestDist then
			nearestPlayer = source
			nearestDist = dist
		end
	end

	-- Tell client to spawn train.
	if nearestPlayer then
		TriggerClientEvent("trains:spawn", nearestPlayer, node)
	end
end

function Main:CacheEntity(entity)
	if self.trains[entity] then
		return
	end

	self.trains[entity] = true
	self.trainCount = self.trainCount + 1
end

function Main:UncacheEntity(entity)
	if not self.trains[entity] then
		return
	end

	self.trains[entity] = nil
	self.trainCount = self.trainCount - 1

	TriggerClientEvent("trains:remove", -1, NetworkGetNetworkIdFromEntity(entity))
end

--[[ Events ]]--
AddEventHandler("trains:start", function()
	Main:Init()
end)

AddEventHandler("playerDropped", function(reason)
	local source = source

	local grid = Main.players[source]
	if grid then
		local amount = Main.playerGrids[grid]
		Main.playerGrids[grid] = amount > 1 and amount - 1 or nil
		Main.players[source] = nil
	end
end)

--[[ Events: Net ]]--
RegisterNetEvent("grids:enter"..Config.GridSize, function(gridIndex)
	local source = source
	
	if type(gridIndex) ~= "number" then return end

	local lastGrid = Main.players[source]
	if lastGrid then
		local lastAmount = Main.playerGrids[lastGrid]
		Main.playerGrids[lastGrid] = lastAmount > 1 and lastAmount - 1 or nil
	end

	Main.players[source] = gridIndex
	Main.playerGrids[gridIndex] = (Main.playerGrids[gridIndex] or 0) + 1
end)

--[[ Events ]]--
AddEventHandler("trains:stop", function()
	for _, vehicle in ipairs(GetAllVehicles()) do
		if GetVehicleType(vehicle) == "train" then
			DeleteEntity(vehicle)
		end
	end
end)

AddEventHandler("entityCreated", function(entity)
	if not entity or not DoesEntityExist(entity) then return end

	if Config.Fronts[GetEntityModel(entity)] then
		Main:CacheEntity(entity)
	end
end)

AddEventHandler("entityRemoved", function(entity)
	if not entity then return end

	if Main.trains[entity] then
		Main:UncacheEntity(entity)
	end
end)

--[[ Threads ]]--
Citizen.CreateThread(function()
	while true do
		if Main.trainCount < Config.MaxTrains then
			Main:SpawnTrain()
		end

		Citizen.Wait(1000)
	end
end)

Citizen.CreateThread(function()
	while true do
		Main:Update()
		Citizen.Wait(1000)
	end
end)