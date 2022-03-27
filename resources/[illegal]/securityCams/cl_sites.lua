Site = {}
Site.__index = Site

--[[ Functions ]]--
function Site:Create(id)
	local site = setmetatable({ id = id }, Site)
	site.groups = {}
	site.hashes = {}
	
	return site
end

function Site:Activate()
	-- Settings.
	local settings = self:GetSettings()
	if settings == nil then return end

	-- Groups.
	self:RegisterGroups(settings.Groups)

	-- Activate group.
	self:SetGroup(1)
end

function Site:Deactivate()
	self:ClearDoors()
end

function Site:Update()
	-- Get settings.
	local settings = self:GetSettings()
	if settings == nil then return end

	-- Discover cameras.
	if self.lastDiscovery == nil or (GetGameTimer() - self.lastDiscovery) > 200 then
		self.lastDiscovery = GetGameTimer()
		self:Discover()
	end

	-- Group input.
	if IsDisabledControlJustPressed(0, 32) then
		self:NextGroup(-1)
	elseif IsDisabledControlJustPressed(0, 33) then
		self:NextGroup(1)
	end
	
	-- Update groups.
	if self.group ~= nil then
		self.group:Update()

		if IsDisabledControlJustPressed(0, 34) then
			self.group:NextCamera(-1)
		elseif IsDisabledControlJustPressed(0, 35) then
			self.group:NextCamera(1)
		end
	end

	-- Update doors.
	if settings.UseDoors then
		self:UpdateDoors()
	end
end

function Site:RegisterGroups(groups)
	if groups == nil then return end

	self.groups = {}
	local payload = {}
	
	for groupId, settings in ipairs(groups) do
		local group = Group:Create(self, groupId, settings)
		
		self.groups[groupId] = group
		payload[groupId] = {
			settings = settings
		}
	end

	Menu:Commit("setSite", payload)
end

function Site:Discover()
	for entity in EnumerateObjects() do
		-- Check for camera.
		if not Main:IsObjectACamera(entity) then goto skip end
		
		
		-- Get group.
		local groupId, group = self:GetGroupEntityIsIn(entity)
		if not groupId then goto skip end

		-- Get coords.
		local coords = GetEntityCoords(entity)
		local hash = GetCoordsHash(coords)

		-- Check coords hash.
		if self.hashes[hash] ~= nil then goto skip end
		
		-- Cache coords hash.
		self.hashes[hash] = entity

		-- Register object.
		group:RegisterCamera(entity)

		-- Skip region.
		::skip::
	end
end

function Site:SetGroup(index)
	if self.group ~= nil then
		self.group:Deactivate()
	end

	local group = self.groups[index]
	if group == nil then return end

	self.index = index
	self.group = group

	Citizen.CreateThread(function()
		group:Activate()
	end)
end

function Site:NextGroup(dir)
	-- Get settings.
	local settings = self:GetSettings()
	if settings == nil then return end

	-- Get index.
	local index = self.index

	-- Offset index.
	if dir > 0 then
		index = index + 1
		if index > #settings.Groups then
			index = 1
		end
	else
		index = index - 1
		if index < 1 then
			index = #settings.Groups
		end
	end

	-- Set index.
	self:SetGroup(index)
end

function Site:GetGroupEntityIsIn(entity)
	local coords = GetEntityCoords(entity)
	for groupId, group in ipairs(self.groups) do
		if
			#(coords - group.Center) < group.Radius and
			(
				group.Room == nil or
				(type(group.Room) == "table" and IsInTable(group.Room, GetRoomKeyFromEntity(entity), true)) or
				(type(group.Room) ~= "table" and GetRoomKeyFromEntity(entity) == GetHashKey(group.Room))
			)
		then
			return groupId, group
		end
	end
end

function Site:GetSettings()
	return Config.Sites[self.id]
end