Group = {}
Group.__index = Group

function Group:Create(id, info)
	local group = setmetatable({
		active = true,
		id = id,
		info = info or {},
		players = {},
		entities = {},
	}, Group)

	Main.groups[id] = group

	return group
end

function Group:Destroy()
	self.active = false
	
	self:InformAll("trackers:leave")

	Main.groups[self.id] = nil
end

function Group:Update()
	local payload = {}

	for entity, data in pairs(self.entities) do
		local coords = GetEntityCoords(entity)
		local heading = GetEntityHeading(entity)

		payload[data.netId] = vector4(coords.x, coords.y, coords.z, heading)
	end

	self:InformAll("trackers:update", payload)
end

function Group:InformAll(eventName, ...)
	for player, mask in pairs(self.players) do
		if mask & 4 ~= 0 then
			TriggerClientEvent(eventName, tonumber(player), self.id, ...)
		end
	end
end

function Group:AddPlayer(source, state, mask)
	local lastMask = self.players[source]

	-- Check mask.
	mask = tonumber(mask) or 6

	-- Inform client.
	if mask & 4 ~= 0 then
		TriggerClientEvent("trackers:join", source, {
			id = self.id,
			entities = self.entities,
			info = self.info,
		})
	elseif lastMask and lastMask & 4 ~= 0 then
		TriggerClientEvent("trackers:leave", source, self.id)
	end
	
	-- Subscribe player.
	self.players[source] = mask

	-- Add player to group.
	if mask & 2 ~= 0 then
		local ped = GetPlayerPed(source)

		self:AddEntity(ped, {
			state = state,
			text = ("[%s] %s"):format(source, exports.character:GetName(source) or "Unknown"),
		})
	end

	return true
end

function Group:RemovePlayer(source)
	local mask = self.players[source]
	if mask == nil then
		return false
	end

	-- Remove entity.
	local ped = GetPlayerPed(source)

	if self.entities[ped] then
		self:RemoveEntity(ped)
	end

	-- Unsubscribe player.
	self.players[source] = nil

	-- Inform player.
	TriggerClientEvent("trackers:leave", source, self.id)

	return true
end

function Group:AddEntity(entity, data)
	-- Check entity.
	if not DoesEntityExist(entity) then
		return false
	end
	
	-- Get entity info.
	local netId = NetworkGetNetworkIdFromEntity(entity)
	local _type = GetEntityType(entity)

	-- Init data.
	if not data then
		data = {}
	end

	data.netId = netId
	data.type = _type

	-- Inform clients.
	self:InformAll("trackers:addEntity", data)
	
	-- Cache entity.
	self.entities[entity] = data

	return true
end

function Group:RemoveEntity(entity)
	local data = self.entities[entity]
	if not data then
		return false
	end

	self:InformAll("trackers:removeEntity", data.netId)
	
	self.entities[entity] = nil

	return true
end