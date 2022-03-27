Grid = {}
Grid.__index = Grid

--[[ Functions: Grid ]]--
function Grid:Create(id)
	Debug("Create grid: %s", id)

	return setmetatable({
		id = id,
		players = {},
		containers = {},
	}, Grid)
end

function Grid:Destroy()
	Drops.grids[self.id] = nil
	
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

function Grid:AddContainer(container)
	Debug("Container added to grid: %s in %s", container.id, self.id)

	local data = Drops:GetData(container)
	
	self.containers[tostring(container.id)] = data

	return data
end

function Grid:RemoveContainer(id)
	Debug("Container removed from grid: %s in %s", id, self.id)
	
	self.containers[tostring(id)] = nil

	self:Clean()
end

function Grid:IsEmpty()
	for k, v in pairs(self.players) do
		return false
	end
	for k, v in pairs(self.containers) do
		return false
	end
	return true
end

function Grid:InformAll(payload)
	for source, _ in pairs(self.players) do
		TriggerClientEvent(EventPrefix.."updateGrid", payload)
	end
end