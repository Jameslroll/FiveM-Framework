Main = Main or {}
Main.scenes = {}
Main.grids = {}
Main.players = {}

function Main:Init()
	-- Create table.
	exports.GHMattiMySQL:Query([[
		CREATE TABLE IF NOT EXISTS `scenes` (
			`id` INT(11) UNSIGNED NOT NULL AUTO_INCREMENT,
			`user_id` INT(11) UNSIGNED NULL DEFAULT NULL,
			`type` ENUM('Text','Image') NOT NULL DEFAULT 'Text' COLLATE 'utf8mb4_general_ci',
			`text` TEXT NOT NULL COLLATE 'utf8mb4_general_ci',
			`start` DATETIME NOT NULL DEFAULT sysdate(),
			`lifetime` TINYINT(4) UNSIGNED NOT NULL DEFAULT '24',
			`width` FLOAT UNSIGNED NOT NULL DEFAULT '0.5',
			`height` FLOAT UNSIGNED NOT NULL DEFAULT '0.5',
			`grid` INT(11) NULL DEFAULT NULL,
			`instance` TINYTEXT NULL DEFAULT NULL COLLATE 'utf8mb4_general_ci',
			`pos_x` FLOAT NOT NULL,
			`pos_y` FLOAT NOT NULL,
			`pos_z` FLOAT NOT NULL,
			`rot_x` FLOAT NOT NULL,
			`rot_y` FLOAT NOT NULL,
			`rot_z` FLOAT NOT NULL,
			PRIMARY KEY (`id`) USING BTREE,
			INDEX `scenes_target_key` (`grid`, `instance`(100)) USING BTREE,
			INDEX `scenes_user_id` (`user_id`) USING BTREE,
			CONSTRAINT `scenes_user_id` FOREIGN KEY (`user_id`) REFERENCES `users` (`id`) ON UPDATE RESTRICT ON DELETE CASCADE
		)
		COLLATE='utf8mb4_general_ci'
		ENGINE=InnoDB
		;
	]])

	-- Cache scenes.
	print("Pre-caching scene grids...")
	
	local result = exports.GHMattiMySQL:QueryResult("SELECT * FROM `scenes`")
	local gridCache = {}
	local gridCount, sceneCount = 0, 0

	for _, data in ipairs(result) do
		local grid = gridCache[data.instance or data.grid]
		if not grid then
			grid = {}
			gridCache[data.instance or data.grid] = grid
		end

		grid[#grid + 1] = data
	end

	print("Pre-cache done!")
	print("Caching scene grids...")

	for id, data in pairs(gridCache) do
		local grid = self.grids[id] or Grid:Create(id)
		grid:Load(data)

		sceneCount = sceneCount + #data
		gridCount = gridCount + 1
	end

	print(("Done loading %s scenes in %s grids!"):format(sceneCount, gridCount))

	-- Load players.
	for i = 1, GetNumPlayerIndices() do
		local player = tonumber(GetPlayerFromIndex(i - 1))
		local ped = GetPlayerPed(player)
		if ped and DoesEntityExist(ped) then
			local coords = GetEntityCoords(ped)
			Main:UpdatePlayer(player, exports.instances:GetPlayerInstance(player) or Grids:GetGrid(coords, Config.GridSize))
		end
	end
end

function Main:UpdateScenes()
	for id, scene in pairs(self.scenes) do
		if os.time() - scene.start > scene.lifetime * 3600 then
			scene:Destroy()
			Citizen.Wait(50)
		end
	end
end

function Main:UpdatePlayer(source, target)
	-- Get player.
	local player = self.players[source]
	if not player then
		player = {}
		self.players[source] = player
	end

	-- Remove from last grid.
	if player.grid then
		player.grid:RemovePlayer(source)
	end

	-- Get or create grid.
	local grid = self.grids[target]
	if not grid then
		grid = Grid:Create(target)
	end

	-- Add player to grid.
	grid:AddPlayer(source)
	player.grid = grid

	-- Load nearby grids and build payload.
	local payload = {}

	for sceneId, scene in pairs(grid.scenes) do
		table.insert(payload, scene)
	end

	if grid.isWorld then
		for _gridId, _grid in pairs(grid:GetSiblings()) do
			for sceneId, scene in pairs(_grid.scenes) do
				table.insert(payload, scene)
			end
		end
	end

	-- Send payload.
	TriggerClientEvent(self.event.."updateScenes", source, payload)
end

function Main:DestroyPlayer(source)
	self.players[source] = nil
end

function Main:PlaceScene(source, scene)
	-- Get player.
	local player = self.players[source]
	if not player or os.clock() - (player.lastPlaced or 0.0) < 3.0 then return end

	player.lastPlaced = os.clock()

	-- Get user.
	local userId = exports.user:Get(source, "id")
	if not userId then
		return false, "no user"
	end

	scene.user_id = userId

	-- Check scene.
	for k, _type in pairs(Config.Fields) do
		local v = scene[k]
		if v == nil then
			return false, k.." is nil"
		elseif type(v) ~= _type then
			return false, k.." is not type ".._type, true
		end
	end

	if not Config.Types[scene.type] then
		return false, ("'%s' is not a type"):format(scene.type), true
	elseif scene.width > 1.001 or scene.height > 1.001 or scene.width < -0.001 or scene.height < -0.001 then
		return false, ("invalid scene size (%sx%s)"):format(tostring(scene.width), tostring(scene.height)), true
	elseif scene.lifetime <= 0 or scene.lifetime > 72 then
		return false, ("lifetime not in range (%s)"):format(scene.lifetime), true
	elseif scene.text:len() > Config.MaxCharacters then
		return false, ("too many characters (%s/%s)"):format(scene.text:len(), Config.MaxCharacters)
	end

	-- Format text.
	if scene.type == "Image" then
		local host = scene.text:match("[%w%.]*%.(%w+%.%w+)")
		if not Config.Hosts[host] then
			return false, ("host '%s' is not supported"):format(host)
		end
	else
		scene.text = FormatText(scene.text)
	end

	-- Get grid/instance.
	local instance = exports.instances:GetPlayerInstance(source)
	local gridId = Grids:GetGrid(scene.coords, Config.GridSize)

	-- Check grid scene limit.
	local grid = self.grids[instance or gridId]
	if not grid then
		grid = Grid:Create(instance or gridId)
	end

	if (grid.count or 0) > Config.MaxPerGrid then
		return false, "scene limit reached in grid"
	end

	-- Take item.
	if not exports.inventory:TakeItem(source, scene.item, 1, scene.slot) then
		return false, "no item"
	end

	-- Save to database and get id.
	local id = exports.GHMattiMySQL:QueryScalar(([[
		INSERT INTO `scenes` SET
			type=@type,
			text=@text,
			user_id=@userId,
			lifetime=@lifetime,
			width=@width,
			height=@height,
			pos_x=@pos_x,
			pos_y=@pos_y,
			pos_z=@pos_z,
			rot_x=@rot_x,
			rot_y=@rot_y,
			rot_z=@rot_z,
			%s;
		SELECT LAST_INSERT_ID();
	]]):format((instance and "instance=@target") or "grid=@target"), {
		["@type"] = scene.type,
		["@text"] = scene.text,
		["@userId"] = scene.user_id,
		["@lifetime"] = scene.lifetime,
		["@width"] = scene.width,
		["@height"] = scene.height,
		["@target"] = instance or gridId,
		["@pos_x"] = scene.coords.x,
		["@pos_y"] = scene.coords.y,
		["@pos_z"] = scene.coords.z,
		["@rot_x"] = scene.rotation.x,
		["@rot_y"] = scene.rotation.y,
		["@rot_z"] = scene.rotation.z,
	})

	-- Create scene.
	local scene = Scene:Create({
		id = id,
		type = scene.type,
		text = scene.text,
		user_id = scene.user_id,
		instance = instance,
		width = scene.width,
		height = scene.height,
		coords = scene.coords,
		rotation = scene.rotation,
	})

	-- Inform grid.
	grid:InformNearby("addScene", scene)

	return true, scene
end

function Main:RemoveScenesInArea(coords, radius)
	local grids = Grids:GetNearbyGrids(coords, Config.GridSize)
	for _, gridId in ipairs(grids) do
		local grid = self.grids[gridId]
		if grid then
			for sceneId, scene in pairs(grid.scenes) do
				if #(coords - scene.coords) < radius then
					scene:Destroy()
				end
			end
		end
	end
end

--[[ Threads ]]--
Citizen.CreateThread(function()
	while true do
		Main:UpdateScenes()

		Citizen.Wait(60000)
	end
end)

--[[ Events ]]--
RegisterNetEvent(Main.event.."remove")
AddEventHandler(Main.event.."remove", function(coords, slotId)
	local source = source

	if type(coords) ~= "vector3" and type(slotId) ~= "number" then return end

	if exports.inventory:TakeItem(source, Config.Remover.Item, 1, slotId) then
		Main:RemoveScenesInArea(coords, Config.Remover.Radius)
	end
end)

RegisterNetEvent(Main.event.."place")
AddEventHandler(Main.event.."place", function(scene)
	local source = source
	local retval, result, shouldBan = Main:PlaceScene(source, scene)

	if retval then
		exports.log:Add({
			source = source,
			verb = "placed",
			noun = "scene",
			extra = ("id: %s - text: %s"):format(result.id, result.text),
			channel = "scene",
		})
	elseif shouldBan then
		exports.sv_test:Report(source, ("impossible scene placement: %s"):format(result), true)
	else
		print(("[%s] Failed to place scene: %s"):format(source, result))

		TriggerClientEvent(Main.event.."failed", source, result)
	end
end)

RegisterNetEvent("grids:enter"..Config.GridSize)
AddEventHandler("grids:enter"..Config.GridSize, function(gridId)
	local source = source
	if type(gridId) ~= "number" or exports.instances:IsInstanced(source) then return end

	Main:UpdatePlayer(source, gridId)
end)

AddEventHandler("instances:playerEntered", function(source, instance)
	local source = source

	Main:UpdatePlayer(source, instance)
end)

AddEventHandler("instances:playerExited", function(source, instance)
	local source = source
	local ped = GetPlayerPed(source)
	if ped and DoesEntityExist(ped) then
		local coords = GetEntityCoords(ped)
		Main:UpdatePlayer(source, Grids:GetGrid(coords, Config.GridSize))
	end
end)

AddEventHandler(Main.event.."start", function()
	Main:Init()
end)

AddEventHandler("playerDropped", function()
	local source = source
	Main:DestroyPlayer(source)
end)

--[[ Commands ]]--
RegisterCommand(Main.event.."debug", function(source, args, command)
	if source ~= 0 then return end

	for gridId, grid in pairs(Main.grids) do
		Citizen.Trace("Grid "..gridId..":\n")

		for id, scene in pairs(grid.scenes) do
			Citizen.Trace("\tScene "..id..": "..json.encode(scene).."\n")
		end

		for source, data in pairs(grid.players) do
			Citizen.Trace("\tPlayer "..source..": "..json.encode(data).."\n")
		end
	end
end, true)

exports.chat:RegisterCommand("a:sceneremove", function(source, args, command)
	local id = tonumber(args[1])
	local scene = Main.scenes[id or false]

	if not scene then
		TriggerClientEvent("chat:addMessage", source, "Invalid scene!")
		return
	end

	scene:Destroy()
	
	exports.log:Add({
		source = source,
		verb = "deleted",
		noun = "scene",
		extra = ("id: %s"):format(id),
		channel = "admin",
	})
end, {}, "Mod")