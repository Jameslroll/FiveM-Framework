function Door:Create(group, coords)
	-- Get id.
	local id = (Main.lastId or 0) + 1
	Main.lastId = id

	-- Create instance.
	self = setmetatable({
		id = id,
		coords = coords,
		group = group,
	}, Door)

	-- Cache door.
	table.insert(group.doors, self)

	-- Return instance.
	return #group.doors, self
end

function Door:Destroy()
	for k, door in pairs(self.group.doors) do
		if door.id == self.id then
			table.remove(self.group.doors, k)
			break
		end
	end
end

function Door:SetState(state)
	self.state = state

	self.group:Inform("doors:toggle", self.coords, state)

	return true
end