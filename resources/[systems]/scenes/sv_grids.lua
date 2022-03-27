Grid = {}
Grid.__index = Grid

--[[ Functions: Grid ]]--
function Grid:Create(id)
	local grid = setmetatable({
		id = id,
		players = {},
		scenes = {},
		count = 0,
	}, Grid)

	Main.grids[id] = grid

	-- Check is instance.
	local isWorld = type(id) == "number"
	grid.isWorld = isWorld

	return grid
end

function Grid:Load(data)
	for k, info in ipairs(data) do
		local scene = Scene:Create({
			id = info.id,
			user_id = info.user_id,
			type = info.type,
			text = info.text,
			start = (info.start and info.start / 1000) or os.time(),
			lifetime = info.lifetime,
			width = info.width,
			height = info.height,
			instance = info.instance,
			coords = vector3(info.pos_x, info.pos_y, info.pos_z),
			rotation = vector3(info.rot_x, info.rot_y, info.rot_z),
		})

		self:AddScene(scene)
	end
end

function Grid:Destroy()
	Main.grids[self.id] = nil
end

function Grid:GetSiblings()
	if not self.isWorld then return {} end

	local siblings = {}

	local grids = Grids:GetNearbyGrids(self.id, Config.GridSize)
	for _, gridId in ipairs(grids) do
		if gridId ~= self.id then
			siblings[gridId] = Main.grids[gridId]
		end
	end

	return siblings
end

function Grid:HasPlayers()
	for k, v in pairs(self.players) do
		return true
	end
	return false
end

function Grid:AddPlayer(source)
	self.players[source] = true
end

function Grid:Clean()
	if self:HasPlayers() then return end
	if not self:IsEmpty() then return end

	self:Destroy()
end

function Grid:RemovePlayer(source)
	self.players[source] = nil

	self:Clean()
end

function Grid:AddScene(scene)
	local id = tostring(scene.id)
	if not self.scenes[id] then
		self.count = self.count + 1
	end

	self.scenes[id] = scene

	return scene
end

function Grid:RemoveScene(id)
	id = tostring(id)

	if not self.scenes[id] then return end

	self.scenes[id] = nil
	self.count = self.count - 1

	self:Clean()
end

function Grid:IsEmpty()
	for k, v in pairs(self.scenes) do
		return false
	end
	return true
end

function Grid:InformAll(message, ...)
	for source, _ in pairs(self.players) do
		TriggerClientEvent(Main.event..message, source, ...)
	end
end

function Grid:InformNearby(message, ...)
	if self.isWorld then
		local nearbyGrids = Grids:GetNearbyGrids(self.id, Config.GridSize)
		for _, nearbyGridId in ipairs(nearbyGrids) do
			local nearbyGrid = Main.grids[nearbyGridId]
			if nearbyGrid ~= nil then
				nearbyGrid:InformAll(message, ...)
			end
		end
	else
		self:InformAll(message, ...)
	end
end