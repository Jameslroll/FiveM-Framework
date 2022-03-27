Group = {}
Group.__index = Group

--[[ Functions: Group ]]--
function Group:Create(data)
	-- Cache players.
	local entities = data.entities

	-- Defaults.
	data.entities = {}
	data.active = {}
	
	-- Create the group.
	local group = setmetatable(data, Group)

	-- Instance entities.
	if entities then
		for _, _data in pairs(entities) do
			group:AddEntity(_data)
		end
	end

	return group
end

function Group:UpdateAll(coords)
	self.active = {}

	for netId, coords in pairs(coords) do
		-- Convert the net id.
		netId = tonumber(netId)

		-- Get entity.
		local entity = NetworkDoesNetworkIdExist(netId) and NetworkGetEntityFromNetworkId(netId) or 0

		-- Get data.
		local data = self.entities[netId]
		if not data then goto skipEntity end

		-- Cache active entities.
		if DoesEntityExist(entity) then
			self.active[netId] = true
		end

		-- Create or update blip.
		local blip = data.blip
		if blip and DoesBlipExist(blip) then
			SetBlipCoords(blip, coords.x, coords.y, coords.z)
		else
			blip = AddBlipForCoord(coords.x, coords.y, coords.z)

			self:UpdateBlip(blip, data)

			data.blip = blip
		end

		SetBlipRotation(blip, math.floor(coords.w))

		-- Skip entities.
		::skipEntity::
	end
end

function Group:UpdateActive()
	for netId, _ in pairs(self.active) do
		-- Get data.
		local data = self.entities[netId]
		if not data then goto skipEntity end
		
		local blip = data.blip
		if not blip or not DoesBlipExist(blip) then goto skipEntity end

		-- Get entity.
		local entity = NetworkDoesNetworkIdExist(netId) and NetworkGetEntityFromNetworkId(netId)
		if not netId or not DoesEntityExist(entity) then goto skipEntity end

		-- Update blip.
		local coords = GetEntityCoords(entity)
		local heading = GetEntityHeading(entity)

		SetBlipCoords(blip, coords)
		SetBlipRotation(blip, math.floor(heading))

		-- Skip entities.
		::skipEntity::
	end
end

function Group:AddEntity(data)
	local netId = data.netId
	local cachedData = self.entities[netId]

	-- Data is already cached.
	if cachedData then
		-- Update blip.
		local blip = cachedData.blip
		if blip and DoesBlipExist(blip) then
			self:UpdateBlip(blip, data)
			data.blip = cachedData.blip
		end
	end

	-- Cache data.
	self.entities[netId] = data

	return true
end

function Group:RemoveEntity(netId)
	local data = self.entities[netId]
	if not data then
		return false
	end

	-- Remove blip.
	local blip = data.blip
	if blip and DoesBlipExist(blip) then
		RemoveBlip(blip)
		data.blip = nil
	end

	-- Uncache entity.
	self.entities[netId] = nil

	return true
end

function Group:UpdateBlip(blip, data)
	local isPed = data.type == 1

	-- Entity types.
	local typeInfo = Config.Types[data.type or 1]
	if typeInfo then
		SetBlipInfo(blip, typeInfo)
	end

	-- State types.
	local stateInfo = self.info and self.info.states[data.type or 1]
	if stateInfo then
		stateInfo = stateInfo[data.state or "default"]
		if stateInfo then
			SetBlipInfo(blip, stateInfo)
		end
	end

	-- General blip info.
	SetBlipScale(blip, 0.8)
	SetBlipAsShortRange(blip, true)
	SetBlipDisplay(blip, 6)
	SetBlipCategory(blip, isPed and 7 or 1)
	SetBlipHiddenOnLegend(blip, not isPed)
	ShowHeadingIndicatorOnBlip(blip, isPed)

	if isPed then
		SetBlipPriority(blip, 255)
	end
	
	-- Blip labels.
	if data.text then
		BeginTextCommandSetBlipName("STRING")
		AddTextComponentSubstringPlayerName(data.text)
		EndTextCommandSetBlipName(blip)
	end
end