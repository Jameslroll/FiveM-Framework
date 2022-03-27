Grid = {}
Grid.__index = Grid

--[[ Functions: Grid ]]--
function Grid:Create(id)
	Debug("Create grid: %s", id)

	-- Create grid.
	local grid = setmetatable({
		id = id,
		players = {},
		decorations = {},
	}, Grid)

	-- Caceh grid.
	Main.grids[id] = grid

	-- Load instances.
	if type(id) == "string" then
		local result = exports.GHMattiMySQL:QueryResult("SELECT * FROM `decorations` WHERE `instance`=@instance", {
			["@instance"] = id,
		})

		for _, data in ipairs(result) do
			Main:ConvertData(data)
			Decoration:Create(data)
		end
	end

	-- Return grid.
	return grid
end

function Grid:Destroy()
	for id, decoration in pairs(self.decorations) do
		decoration:Unload()
	end

	Main.grids[self.id] = nil
	
	Debug("Destroy grid: %s", self.id)
end

function Grid:Clean()
	if self:IsEmpty() then
		self:Destroy()
	end
end

function Grid:AddPlayer(source)
	Debug("Player added to grid: [%s] in %s", source, self.id)

	self.players[source] = true
end

function Grid:RemovePlayer(source)
	Debug("Player removed from grid: [%s] in %s", source, self.id)
	
	self.players[source] = nil

	self:Clean()
end

function Grid:AddDecoration(decoration)
	Debug("Decoration added to grid: %s in %s", decoration.id, self.id)

	self.decorations[tostring(decoration.id)] = decoration

	self:InformNearby("add", decoration)
end

function Grid:RemoveDecoration(id)
	Debug("Decoration removed from grid: %s in %s", id, self.id)
	
	self.decorations[tostring(id)] = nil

	self:InformNearby("remove", id)

	self:Clean()
end

function Grid:IsEmpty()
	for k, v in pairs(self.players) do
		return false
	end
	if type(self.id) ~= "string" then
		for k, v in pairs(self.decorations) do
			return false
		end
	end
	return true
end

function Grid:InformNearby(...)
	if type(self.id) == "string" then
		self:InformAll(...)
	else
		local nearbyGrids = Grids:GetNearbyGrids(self.id, Config.GridSize)
		for _, gridId in ipairs(nearbyGrids) do
			local grid = Main.grids[gridId]
			if grid then
				grid:InformAll(...)
			end
		end
	end
end

function Grid:InformAll(event, ...)
	for source, _ in pairs(self.players) do
		TriggerClientEvent(Main.event..event, source, ...)
	end
end