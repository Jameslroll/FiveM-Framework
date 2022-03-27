Scene = {}
Scene.__index = Scene

function Scene:Create(data)
	if not data.id then return end

	-- Create instance.
	local scene = setmetatable(data or {}, self)
	scene.start = scene.start or os.time()
	scene.lifetime = scene.lifetime or 4

	-- Cache instance.
	Main.scenes[scene.id] = scene

	-- Update position.
	if scene.coords then
		scene:UpdatePosition(scene.coords, scene.instance)
	end

	-- Return instance.
	return scene
end

function Scene:Destroy()
	local id = self.id
	local grid = self:GetGrid()

	-- Remove from grid.
	if grid then
		grid:RemoveScene(id)
		grid:InformNearby("removeScene", self.grid, id)
	end

	-- Uncache.
	Main.scenes[id] = nil

	-- Remove from database.
	exports.GHMattiMySQL:QueryAsync("DELETE FROM `scenes` WHERE id=@id", {
		["@id"] = id,
	})
end

function Scene:GetGrid()
	return self.grid and Main.grids[self.grid]
end

function Scene:UpdatePosition(coords, instance)
	-- Remove from last grid.
	local grid = self:GetGrid()
	if grid then
		grid:RemoveScene(self.id)
	end

	-- Get new grid.
	local gridId = instance or Grids:GetGrid(coords, Config.GridSize)
	if not gridId then return end

	local grid = Main.grids[gridId]
	if not grid then
		grid = Grid:Create(gridId)
	end

	-- Add scene to grid.
	grid:AddScene(self)

	-- Cache.
	self.grid = gridId
	self.coords = coords
end