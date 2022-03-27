Main.players = {}
Main.queue = {}
Main.names = {}
Main.ids = {}

--[[ Functions ]]--
function Main:Init()
	-- Wait for inventory.
	while
		GetResourceState("inventory") ~= "started" or
		not exports.inventory:IsLoaded()
	do
		Citizen.Wait(50)
	end

	-- Cache items.
	self:CacheItems()

	-- Load tables.
	self:LoadDatabase()

	-- Load decorations.
	self:LoadDecorations()
	
	-- Load players.
	self:LoadPlayers()

	-- Cache initializaiton.
	self.init = true
end

function Main:LoadDatabase()
	WaitForTable("characters")
	WaitForTable("items")
	WaitForTable("containers")

	RunQuery("sql/decorations.sql")
end

function Main:LoadPlayers()
	for i = 1, GetNumPlayerIndices() do
		local player = tonumber(GetPlayerFromIndex(i - 1))
		local ped = GetPlayerPed(player)

		if ped and DoesEntityExist(ped) then
			local gridId = exports.instances:Get(player) or Grids:GetGrid(GetEntityCoords(ped), Config.GridSize)
			self:SetGrid(player, gridId)
		end
	end
end

function Main:ConvertData(data)
	data.coords = vector3(data.pos_x, data.pos_y, data.pos_z)
	data.rotation = vector3(data.rot_x, data.rot_y, data.rot_z)
	data.persistent = data.persistent == 1
	
	data.pos_x = nil
	data.pos_y = nil
	data.pos_z = nil
	
	data.rot_x = nil
	data.rot_y = nil
	data.rot_z = nil
end

function Main:LoadDecorations()
	local result = exports.GHMattiMySQL:QueryResult("SELECT * FROM `decorations` WHERE `instance` IS NULL AND `persistent`=0")
	for _, data in ipairs(result) do
		self:ConvertData(data)
		Decoration:Create(data)
	end
end

function Main:CacheItems()
	for name, settings in pairs(Decorations) do
		local item = exports.inventory:GetItem(name)
		if not item then
			Print("Decoration '%s' is missing an item!", name)
		end
		self.names[name] = item.id
		self.ids[item.id] = name
	end
end

function Main:Update()
	for id, decoration in pairs(self.decorations) do
		decoration:Update()
		Citizen.Wait(0)
	end
end

function Main:SetGrid(source, gridId)
	local player = self.players[source]
	if not player then
		player = {}
		self.players[source] = player
	elseif player.grid == gridId then
		return
	elseif player.grid then
		local lastGrid = self.grids[player.grid]
		if lastGrid then
			lastGrid:RemovePlayer(source)
		end
	end
	
	local grid = self.grids[gridId]
	if not grid then
		grid = Grid:Create(gridId)
	end
	
	grid:AddPlayer(source)

	player.time = os.clock()
	player.grid = gridId

	local payload = {}

	if type(grid.id) == "string" then
		payload[grid.id] = grid.decorations
	else
		local nearbyGrids = Grids:GetNearbyGrids(grid.id, Config.GridSize)
		for k, gridId in ipairs(nearbyGrids) do
			local grid = self.grids[gridId]
			if grid and grid.decorations then
				payload[grid.id] = grid.decorations
			end
		end
	end

	Debug("Sending payload to: [%s] in %s", source, grid.id)

	TriggerClientEvent(self.event.."sync", source, payload)
end

function Main:Place(source, item, variant, coords, rotation, slotId, instance, durability)
	-- Get settings.
	local settings = Decorations[item or false]
	if not settings then
		print("no settings")
		return false
	end

	-- Check input.
	if type(coords) ~= "vector3" or type(rotation) ~= "vector3" or (variant and type(variant) ~= "number") then
		print("invalid input type")
		return false
	end

	-- Source info.
	if source then
		-- Get player.
		local player = Main.players[source]
		if not player then
			player = {}
			Main.players[source] = player
		end

		-- Update cooldowns.
		if player.lastPlaced and os.clock() - player.lastPlaced < 1.0 then return false end
		player.lastPlaced = os.clock()

		-- Take item.
		local containerId = exports.inventory:GetPlayerContainer(source, true)
		if not containerId then return false end

		local slot = exports.inventory:ContainerGetSlot(containerId, tonumber(slotId))
		if not slot then return false end

		durability = slot.durability or 1.0
		if durability > 0.999 then
			durability = nil
		end

		if not exports.inventory:TakeItem(source, item, 1, slotId) then
			return false
		end
	end

	-- Get character id.
	local character = source and exports.character:Get(source, "id")
	if source and not character then return false end

	-- Create and return decoration.
	return Decoration:Create({
		item = item,
		coords = coords,
		rotation = rotation,
		variant = variant,
		durability = durability,
		instance = (source and exports.instances:Get(source)) or (not source and instance),
		character_id = character,
	})
end

function Main:Pickup(source, id)
	if type(id) ~= "number" then return false end

	local decoration = self.decorations[id]
	if not decoration or not decoration.item_id or decoration.temporary or decoration.persistent then return false end

	-- Check container.
	if decoration.container_id and not exports.inventory:ContainerIsEmpty(decoration.container_id) then
		return false, "must be empty"
	end

	-- Decay.
	local durability = (decoration.durability or 1.0) - 0.1
	if durability < 0.001 then
		decoration:Destroy()

		exports.log:Add({
			source = source,
			verb = "broke",
			noun = "decoration",
			extra = tostring(id),
		})

		return false, "it broke"
	end

	local success, reason = table.unpack(exports.inventory:GiveItem(source, {
		item = decoration.item_id,
		durability = durability,
	}))

	if success then
		decoration:Destroy()
		return true
	else
		return false, reason
	end
end

function Main:RegisterDecoration(data)
	return Decoration:Create(data)
end

function Main:LoadDecoration(data, shouldCreate)
	if data.id then
		-- Load from cache.
		local decoration = self.decorations[data.id]
		if decoration then
			for k, v in pairs(data) do
				decoration[k] = v
			end

			return decoration
		end

		-- Load from database.
		local result = exports.GHMattiMySQL:QueryResult("SELECT * FROM `decorations` WHERE `id`=@id LIMIT 1", {
			["@id"] = data.id,
		})[1]

		if result then
			self:ConvertData(result)
			
			for k, v in pairs(data) do
				result[k] = v
			end

			return Decoration:Create(result)
		else
			data.id = nil
		end
	end

	if shouldCreate then
		return Decoration:Create(data)
	end
end

--[[ Exports ]]--
exports("RegisterDecoration", function(data)
	data.resource = GetInvokingResource()

	while not Main.init do
		Citizen.Wait(50)
	end

	return Main:RegisterDecoration(data)
end)

exports("LoadDecoration", function(data, shouldCreate)
	data.resource = GetInvokingResource()

	while not Main.init do
		Citizen.Wait(50)
	end

	return Main:LoadDecoration(data, shouldCreate)
end)

--[[ Events ]]--
AddEventHandler(Main.event.."start", function()
	Main:Init()
end)

AddEventHandler("onResourceStop", function(resourceName)
	for id, decoration in pairs(Main.decorations) do
		if decoration.resource == resourceName then
			decoration:Unload()
		end
	end
end)

AddEventHandler("playerDropped", function(reason)
	local source = source

	local player = Main.players[source]
	if not player then return end
	
	local lastGrid = Main.grids[player.grid]
	if lastGrid then
		lastGrid:RemovePlayer(source)
	end

	local player = Main.players[source]
	if player and player.station then
		player.station:ExitStation(source)
	end
	
	Main.players[source] = nil
end)

AddEventHandler("inventory:loaded", function()
	-- Main:CacheItems()
end)

AddEventHandler("instances:join", function(source, id)
	Main:SetGrid(source, id)
end)

AddEventHandler("instances:leave", function(source, id)
	local ped = GetPlayerPed(source)
	local gridId = Grids:GetGrid(GetEntityCoords(ped), Config.GridSize)

	Main:SetGrid(source, gridId)
end)

--[[ Events: Net ]]--
RegisterNetEvent("grids:enter"..Config.GridSize, function(gridId)
	local source = source

	if type(gridId) ~= "number" or exports.instances:IsInstanced(source) then return end

	Main:SetGrid(source, gridId)
end)

RegisterNetEvent(Main.event.."place", function(...)
	local source = source
	local decoration = Main:Place(source, ...)

	if decoration then
		exports.log:Add({
			source = source,
			verb = "placed",
			noun = "decoration",
			extra = tostring(decoration.id),
		})
	end
end)

RegisterNetEvent(Main.event.."pickup", function(id)
	local source = source
	local retval, result = Main:Pickup(source, id)

	if retval then
		exports.log:Add({
			source = source,
			verb = "picked up",
			noun = "decoration",
			extra = tostring(id),
		})
	elseif result then
		TriggerClientEvent("chat:notify", source, {
			class = "error",
			text = "Can't pick up ("..(result or "error")..").",
		})
	end
end)

RegisterNetEvent(Main.event.."access", function(id)
	local source = source

	local decoration = Main.decorations[tonumber(id) or false]
	if not decoration then return end

	decoration:AccessContainer(source)
end)

--[[ Threads ]]--
Citizen.CreateThread(function()
	while true do
		Main:Update()
		Citizen.Wait(5000)
	end
end)

--[[ Commands ]]--
RegisterCommand("decorations:debug", function(source, args, command)
	if source ~= 0 then return end
	
	for gridId, grid in pairs(Main.grids) do
		print("Grid "..gridId)

		print("\tDecorations")

		for id, decoration in pairs(grid.decorations) do
			print("\t\t"..id, json.encode(decoration))
		end

		print("Players")
		for source, _ in pairs(grid.players) do
			print("\t\t"..source)
		end
	end
end, true)