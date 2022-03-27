Decoration = {}
Decoration.__index = Decoration

function Decoration:Create(data)
	-- Get item.
	if type(data.item) == "string" then
		local itemId = Main.names[data.item]
		if not itemId then return false end
		
		data.item_id = itemId
	elseif data.item_id then
		local itemName = Main.ids[data.item_id]
		if not itemName then return false end

		data.item = itemName
	end

	-- Get settings.
	local settings = Decorations[data.item] or data.settings or {}

	-- Create containers.
	local container
	if settings.Container and not data.temporary then
		container = exports.inventory:LoadContainer({
			id = data.container_id,
			type = settings.Container.Type or "default",
			coords = data.coords,
			protected = true,
		}, true)

		data.container_id = container.id
	end

	-- Load or insert.
	if data.temporary then
		local id = (Main.lastId or 0) + 1
		Main.lastId = id

		data.id = -id
	elseif not data.id then
		local setters = "pos_x=@pos_x,pos_y=@pos_y,pos_z=@pos_z,rot_x=@rot_x,rot_y=@rot_y,rot_z=@rot_z"
		local values = {
			["@pos_x"] = data.coords.x,
			["@pos_y"] = data.coords.y,
			["@pos_z"] = data.coords.z,
			["@rot_x"] = data.rotation and data.rotation.x or 0.0,
			["@rot_y"] = data.rotation and data.rotation.y or 0.0,
			["@rot_z"] = data.rotation and data.rotation.z or data.heading or 0.0,
		}

		for key, _ in pairs(Server.Properties) do
			local value = data[key]
			if value then
				if setters ~= "" then
					setters = setters..","
				end
				setters = setters..key.."=@"..key
				values["@"..key] = value
			end
		end

		data.id = exports.GHMattiMySQL:QueryScalar(([[
			INSERT INTO `decorations` SET %s;
			SELECT LAST_INSERT_ID();
		]]):format(setters), values)

		data.start_time = os.time() * 1000
	end

	-- Create stations.
	if settings.Station then
		exports.inventory:RegisterStation(data.id, settings.Station.Type, settings.Station.Auto)
		data.station = true
	end

	-- Create decoration.
	local decoration = setmetatable(data, Decoration)

	-- Update grid.
	decoration:UpdateGrid()

	-- Cache decoration.
	Main.decorations[decoration.id] = decoration

	-- Save container.
	if container and decoration.container_id ~= container.id then
		decoration:Set("container_id", container.id)
	end

	return decoration
end

function Decoration:Destroy()
	-- Remove from grid.
	local grid = self:GetGrid()
	if grid then
		grid:RemoveDecoration(self.id)
	end

	-- Uncache decoration.
	Main.decorations[self.id] = nil

	-- Remove from database.
	if not self.temporary then
		exports.GHMattiMySQL:QueryAsync("DELETE FROM `decorations` WHERE id=@id", {
			["@id"] = self.id
		})
	end

	-- Remove container.
	if self.container_id then
		exports.inventory:ContainerDestroy(self.container_id, true)
	end

	-- Destroy station.
	if self.station then
		exports.inventory:DestroyStation(self.id)
	end
end

function Decoration:Unload()
	Main.decorations[self.id] = nil

	-- Unload container (not destroy).
	if self.station then
		exports.inventory:UnloadStation(self.id)
	end

	-- Destroy container (not delete).
	if self.container_id then
		exports.inventory:ContainerDestroy(self.container_id)
	end
end

function Decoration:Update()
	if not self.start_time then
		return
	end

	-- Get settings.
	local settings = self:GetSettings()
	if not settings or settings.NoDecay then return end
	
	-- Get age (in hours).
	local age = (os.time() * 1000 - self.start_time) / 3600000
	
	-- Check decay.
	local isOutside = self.instance == nil
	if isOutside and age > (settings.Decay or 24.0) then
		self:Destroy()
	end
end

function Decoration:Set(key, value)
	-- Save properties.
	if not self.temporary and Server.Properties[key] then
		exports.GHMattiMySQL:QueryAsync(("UPDATE `decorations` SET %s=@%s WHERE `id`=%s"):format(key, key, self.id), {
			["@"..key] = value,
		})
	end

	-- Set value.
	self[key] = value

	-- Inform users.
	local grid = self:GetGrid()
	if grid then
		grid:InformNearby("updateDecoration", self.id, key, value)
	end
end

function Decoration:GetSettings()
	return Decorations[self.item or false]
end

function Decoration:UpdateGrid()
	local lastGrid = self:GetGrid()
	if lastGrid then
		lastGrid:RemoveDecoration(self.id)
	end

	self.grid = Grids:GetGrid(self.coords, Config.GridSize)
	
	local grid = self:GetGrid()
	if not grid then
		grid = Grid:Create(self.instance or self.grid)
	end
	
	grid:AddDecoration(self)
end

function Decoration:GetGrid()
	if not self.grid then return end
	return Main.grids[self.instance or self.grid]
end

function Decoration:AccessContainer(source)
	local containerId = self.container_id
	if not containerId then return end

	exports.inventory:ContainerSubscribe(containerId, source, true)

	TriggerClientEvent("inventory:toggle", source, true)
end