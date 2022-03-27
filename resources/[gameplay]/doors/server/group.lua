function Group:Create(data)
	if not data.id then
		error("creating group without id")
	end

	data = setmetatable(data, Group)
	data.players = {}
	data.doors = {}

	Main.groups[data.id] = data
end

function Group:Inform(event, ...)
	for source, _ in pairs(self.players) do
		TriggerClientEvent(event, source, self.id, ...)
	end
end

function Group:AddPlayer(source)
	self.players[source] = true

	TriggerClientEvent("doors:inform", source, self.id, self:GetPayload())

	Debug(("[%s] joined group: %s"):format(source, self.id))
end

function Group:RemovePlayer(source)
	self.players[source] = nil

	Debug(("[%s] left group: %s"):format(source, self.id))
end

function Group:GetPayload()
	local payload = {}
	for index, door in pairs(self.doors) do
		payload[index] = { door.coords, door.state }
	end
	return payload
end

function Group:SetState(coords, state)
	local doorIndex, door = self:FindDoor(coords)
	if not door then
		if #self.doors > 512 then
			local firstDoor = self.doors[1]
			firstDoor:Destroy()
		end

		doorIndex, door = Door:Create(self, coords)
	end

	if door then
		return door:SetState(state)
	else
		return false
	end
end

function Group:FindDoor(coords, tolerance)
	for index, door in ipairs(self.doors) do
		if #(door.coords - coords) < (tolerance or 0.1) then
			return index, door
		end
	end
end