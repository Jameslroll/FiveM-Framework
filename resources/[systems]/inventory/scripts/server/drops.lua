Drops = {
	grids = {},
	queue = {},
}

--[[ Functions: Drops ]]--
function Drops:SetPlayerGrid(source, id)
	-- Get player.
	local player = Inventory.players[source]
	if player == nil then
		return false, "no player"
	end

	if player.grid ~= nil then
		-- Same grid.
		if player.grid == id then
			return false, "same grid"
		end
		
		-- Clear last grid.
		local lastGrid = self.grids[player.grid]
		if lastGrid ~= nil then
			lastGrid:RemovePlayer(source)
		end
	end

	-- Set player.
	player.grid = id

	-- Set grid.
	local grid = self.grids[id]
	if grid == nil then
		grid = Grid:Create(id)
		self.grids[id] = grid
	end

	grid:AddPlayer(source)
	
	-- Inform player.
	self:Inform(source, id)

	-- Result.
	return true
end

function Drops:RegisterContainer(container)
	-- Get grid id.
	local gridId = container.instance or Grids:GetGrid(container.coords, Config.Drops.GridSize)

	-- Set container.
	container.grid = gridId
	
	-- Set grid.
	local grid = self.grids[gridId]
	if grid == nil then
		grid = Grid:Create(gridId)
		self.grids[gridId] = grid
	end

	-- Add container.
	local data = grid:AddContainer(container)

	-- Inform.
	self:InformAll(gridId, {
		add = {
			id = container.id,
			data = data,
		}
	})

	-- Result.
	return true
end

function Drops:RemoveContainer(container)
	local grid = self.grids[container.grid or false]
	if grid == nil then return end

	-- Remove container.
	grid:RemoveContainer(container.id)

	-- Inform.
	self:InformAll(container.grid, {
		remove = {
			id = container.id,
		}
	})
end

function Drops:UpdateContainer(container)
	-- For "real" drops.
	if container.type == "drop" then
		if container.grid == nil then
			Drops:RegisterContainer(container)

			return
		elseif not container.persistent and container:IsEmpty() then
			container:Destroy()
			
			return
		end
	end

	-- Get grid.
	local grid = self.grids[container.grid or false]
	if grid == nil then return end

	-- Get container.
	local key = tostring(container.id)
	if grid.containers[key] == nil then return end

	-- Get data.
	local data = self:GetData(container)
	grid.containers[key] = data

	-- Inform.
	self:InformAll(container.grid, {
		update = {
			id = container.id,
			data = data,
		}
	})
end

function Drops:UpdateQueue()
	for source, grid in pairs(self.queue) do
		self:SetPlayerGrid(source, grid)
	end
	self.queue = {}
end

function Drops:GetData(container)
	local data = {
		coords = container.coords,
		discrete = container.discrete,
		heading = container.heading,
		radius = container.radius,
		text = container.text,
		type = container.type,
	}

	if container.type == "drop" then
		data.items = container:CountItems()
	end

	return data
end

function Drops:Inform(source, id)
	local data = {}

	Debug("Grid inform: %s to %s", id, source)

	if type(id) == "number" then
		-- Grids.
		local nearbyGrids = Grids:GetNearbyGrids(id, Config.Drops.GridSize)
		for _, _id in ipairs(nearbyGrids) do
			local grid = Drops.grids[_id]
			if grid ~= nil then
				data[#data + 1] = grid.containers
			end
		end
	else
		-- Instances.
		local grid = Drops.grids[id]
		if grid ~= nil then
			data[1] = grid.containers
		end
	end

	-- Inform.
	TriggerClientEvent(EventPrefix.."updateDrops", source, { grids = data })
end

function Drops:InformAll(id, payload)
	Debug("Grid inform all: %s", id)

	if type(id) == "number" then
		-- Inform grids.
		local nearbyGrids = Grids:GetNearbyGrids(id, Config.Drops.GridSize)
		for _, _id in ipairs(nearbyGrids) do
			local grid = Drops.grids[_id]
			if grid ~= nil then
				for source, _ in pairs(grid.players) do
					TriggerClientEvent(EventPrefix.."updateDrops", source, payload)
				end
			end
		end
	else
		-- Inform instances.
		local grid = Drops.grids[id]
		if grid ~= nil then
			for source, _ in pairs(grid.players) do
				TriggerClientEvent(EventPrefix.."updateDrops", source, payload)
			end
		end
	end
end

--[[ Functions: Player ]]--

--[[ Hooks: Containers ]]--
Inventory:AddHook("registerContainer", function(container)
	if container.coords == nil or container.type ~= "drop" or container.protected then return end

	Drops:RegisterContainer(container)
end)

Inventory:AddHook("destroyContainer", function(container)
	if container.grid == nil then return end

	Drops:RemoveContainer(container)
end)

Inventory:AddHook("subscribe", function(container, player, value)
	-- Check container type.
	if container.type ~= "drop" then return end

	-- Assign player drop.
	if value then
		player.drop = container.id
	elseif player.drop == container.id then
		player.drop = nil
	end
end)

--[[ Hooks: Slots ]]--
Inventory:AddHook("moveSlot", function(sourceContainer, sourceSlot, target, quantity, source)
	-- Check movement type.
	if target ~= "drop" then return end
	
	-- Get player.
	local player = Inventory.players[source or 0]
	if player == nil then return end

	-- Get container.
	local container = nil
	if player.drop ~= nil then
		container = Inventory:GetContainer(player.drop)
	end

	-- Create container.
	if container == nil then
		-- Get coords.
		local ped = GetPlayerPed(source) or 0
		if not DoesEntityExist(ped) then
			return false, "no ped"
		end

		local coords = GetEntityCoords(ped)
		if #(coords - vector3(0.0, 0.0, 0.0)) < 1.0 then
			return false, "invalid coords"
		end

		-- Register container.
		container = Inventory:RegisterContainer({
			coords = coords,
			instance = GetResourceState("instances") == "started" and exports.instances:Get(source) or nil,
			type = "drop",
			temporary = true,
		})

		-- Subscribe player to container.
		container:Subscribe(source, true)
	end

	-- Return result.
	return {
		target = {
			container = container.id,
		}
	}
end)

Inventory:AddHook("slotMoved", function(sourceContainer, sourceSlot, targetContainer, targetSlot)
	if sourceContainer ~= nil and sourceContainer.type == "drop" then
		Drops:UpdateContainer(sourceContainer)
	end

	if targetContainer ~= nil and targetContainer.type == "drop" then
		Drops:UpdateContainer(targetContainer)
	end
end)

Inventory:AddHook("itemAdded", function(container, slot, amount)
	if container ~= nil and container.type == "drop" then
		Drops:UpdateContainer(container)
	end
end)

--[[ Hooks: Players ]]--
Inventory:AddHook("registerPlayer", function(player)
	local ped = GetPlayerPed(player.source) or 0
	if not DoesEntityExist(ped) then return end

	local coords = GetEntityCoords(ped)
	local grid = Grids:GetGrid(coords, Config.Drops.GridSize)

	Drops:SetPlayerGrid(player.source, grid)
end)

Inventory:AddHook("destroyPlayer", function(player)
	if player.grid then
		local lastGrid = Drops.grids[player.grid]
		if lastGrid ~= nil then
			lastGrid:RemovePlayer(source)
		end
	end
end)

--[[ Events: Net ]]--
RegisterNetEvent("grids:enter"..Config.Drops.GridSize, function(grid)
	local source = source
	if type(grid) ~= "number" then return end

	local player = Inventory.players[source]
	if player == nil or player.instanced then return end

	if player:GetTimeSinceLastAction() < 0.2 then
		Drops.queue[source] = grid
	else
		Drops:SetPlayerGrid(source, grid)
	end
end)

--[[ Events ]]--
AddEventHandler("instances:join", function(source, id)
	local player = Inventory.players[source]
	if player == nil then return end

	player.instanced = true
	
	Drops.queue[source] = nil
	Drops:SetPlayerGrid(source, tostring(id))
end)

AddEventHandler("instances:leave", function(source, id)
	local player = Inventory.players[source]
	if player == nil then return end

	player.instanced = nil

	local ped = GetPlayerPed(source)
	local coords = GetEntityCoords(ped)
	local grid = Grids:GetGrid(coords, Config.Drops.GridSize)

	Drops:SetPlayerGrid(source, grid)
end)

--[[ Threads ]]--
Citizen.CreateThread(function()
	while true do
		Drops:UpdateQueue()
		
		Citizen.Wait(200)
	end
end)