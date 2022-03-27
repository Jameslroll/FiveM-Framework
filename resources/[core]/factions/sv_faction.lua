Faction = {}
Faction.__index = Faction

function Faction:Create(name)
	if not name then
		error("creating faction without name")
	end

	self = setmetatable({
		name = name,
		groups = {},
	}, Faction)

	Main.factions[name] = self

	return self
end

function Faction:Destroy()
	Main.factions[self.name] = nil
end

function Faction:AddPlayer(source, groupName, level, fields)
	groupName = groupName or ""
	level = level or 0

	-- Get player.
	local player = Main.players[source]
	if not player then return false end

	-- Get/create group.
	local group = self.groups[groupName]
	if not group then
		group = {}
		self.groups[groupName] = group
	end

	-- Check already in group.
	if (group[source] or nil) == (level or nil) then return false end

	-- Create info.
	local info = {
		level = level,
		fields = fields or {},
	}
	
	-- Cache player.
	local playerFaction = player[self.name]
	if not playerFaction then
		playerFaction = {}
		player[self.name] = playerFaction
	end

	playerFaction[groupName] = info
	
	-- Cache group.
	group[source] = info

	return true
end

function Faction:RemovePlayer(source, groupName)
	groupName = groupName or ""

	-- Get player.
	local player = Main.players[source]
	if not player then return false end

	-- Get group.
	local group = self.groups[groupName]
	if not group then return false end

	-- Check player in group.
	if not group[source] then return false end

	-- Remove from player.
	local playerFaction = player[self.name]
	if playerFaction then
		playerFaction[groupName] = nil

		local next = next
		if next(playerFaction) == nil then
			player[self.name] = nil
		end
	end

	-- Remove from group.
	group[source] = nil

	-- Clear empty factions.
	local next = next
	if next(group) == nil then
		self.groups[groupName] = nil

		if next(self.groups) == nil then
			self:Destroy()
		end
	end

	return true
end

function Faction:UpdatePlayer(source, groupName, key, value)
	groupName = groupName or ""

	-- Get player.
	local player = Main.players[source]
	if not player then return false end

	-- Get/create group.
	local group = self.groups[groupName]
	if not group then return false end

	-- Get info.
	local info = group[source]
	if not info then return false end

	-- Convert key.
	if key ~= "level" and key ~= "fields" then
		info = info["fields"]
	end

	-- Set info.
	info[key] = value

	return true
end

function Faction:GetPlayer(source, groupName)
	groupName = groupName or ""

	-- Get player.
	local player = Main.players[source]
	if not player then return false end

	-- Get group.
	local group = self.groups[groupName]
	if not group then return false end

	return group[source]
end