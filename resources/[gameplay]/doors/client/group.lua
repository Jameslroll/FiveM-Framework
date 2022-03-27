function Group:Create(data)
	if not data.id then
		error("creating group without id")
	end

	data = setmetatable(data, Group)
	data.doors = {}
	data.cached = {}
	data.ignore = {}

	if data.overrides then
		for _, override in ipairs(data.overrides) do
			if override.ignore then
				data.ignore[#data.ignore + 1] = override.coords
			end
		end
	end

	Main.groups[data.id] = data
end

function Group:Activate()
	if Main.debug then
		self.debugText = exports.interact:AddText({
			id = "doorGroup-"..self.id,
			coords = self.coords,
			text = "Group: "..(self.name or self).."<br>Radius: "..(self.radius or 0).."<br>Factions: "..json.encode(self.factions).."<br>Locked: "..tostring(self.locked),
		})
	end
end

function Group:Deactivate()
	for entity, door in pairs(self.doors) do
		door:Destroy()
	end

	if self.debugText then
		exports.interact:RemoveText(self.debugText)
		self.debugText = nil
	end
end

function Group:Update()
	-- Register doors from cache.
	for entity, info in pairs(Main.doors) do
		if info and not self.doors[entity] then
			if self:ShouldIgnore(info.coords) then
				Main.doors[entity] = false
			elseif #(info.coords - self.coords) < self.radius then
				self:AddDoor(entity, self:GetCachedState(info.coords, true), info)
			end
		end
	end
end

function Group:AddDoor(entity, ...)
	self.doors[entity] = Door:Create(self, entity, ...)
end

function Group:RemoveDoor(entity)
	local door = self.doors[entity]
	if door then
		door:Destroy()
	end
end

function Group:FindDoor(coords, tolerance, check)
	for entity, door in pairs(self.doors) do
		if #(door.coords - coords) < (tolerance or 0.1) and (type(check) ~= "function" or check(entity, door)) then
			return door
		end
	end
end

function Group:Cache(coords, state)
	for k, info in ipairs(self.cached) do
		if #(coords - info.coords) < 0.1 then
			info.state = state
			return
		end
	end

	table.insert(self.cached, {
		coords = coords,
		state = state,
	})

	Debug("caching state", #self.cached, coords, state)
end

-- function Group:Uncache(coords)
-- 	for k, info in ipairs(self.cached) do
-- 		if #(coords - info.coords) < 0.1 then
-- 			table.remove(self.cached, k)

-- 			Debug("uncaching state", k, coords)

-- 			return
-- 		end
-- 	end
-- end

function Group:GetCachedState(coords, remove)
	for k, info in ipairs(self.cached) do
		if #(coords - info.coords) < 0.1 then
			if remove then
				table.remove(self.cached, k)
			end

			return info.state
		end
	end
end

function Group:ShouldIgnore(coords)
	for _, _coords in ipairs(self.ignore) do
		if #(coords - _coords) < 0.1 then
			return true
		end
	end
	return false
end