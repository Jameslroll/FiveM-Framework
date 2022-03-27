Main.doors = {}

function Main:Update()
	local ped = PlayerPedId()
	local coords = GetEntityCoords(ped)

	-- Update entities.
	self:UpdateEntities()

	-- Update current group.
	self:UpdateGroup(coords)

	local group = self.group
	if group then
		group:Update()
	end
end

function Main:UpdateEntities()
	-- Uncache removed doors.
	for entity, info in pairs(self.doors) do
		if not DoesEntityExist(entity) then
			self.doors[entity] = nil
		end
	end

	-- Cache doors.
	for entity in EnumerateObjects() do
		-- Check already cached.
		if self.doors[entity] ~= nil then goto skipObject end
		
		-- Get model.
		local model = GetEntityModel(entity)
		local modelInfo = Config.Doors[model]
		if not modelInfo then
			self.doors[entity] = false
			goto skipObject
		end

		-- Cache entity info.
		self.doors[entity] = {
			coords = GetEntityCoords(entity),
			rotation = GetEntityRotation(entity),
			forward = GetEntityForwardVector(entity),
			heading = GetEntityHeading(entity),
			settings = Config.Doors[model]
		}

		::skipObject::
	end
end

function Main:UpdateGroup(coords)
	-- Make sure we moved.
	if self.lastCoords and #(coords - self.lastCoords) < 3.0 then
		return
	end

	self.lastCoords = coords
	self.debug = Config.Debug
	
	-- Get nearest group.
	local nearestDist, group
	for groupId, _group in pairs(self.groups) do
		local dist = #(_group.coords - coords)
		if dist < _group.radius and (not nearestDist or dist < nearestDist) then
			group = _group
			nearestDist = dist
		end
	end

	-- Check current group.
	local lastGroup = self.group
	if group == lastGroup then
		return
	end
	
	-- Debug.
	Debug("group change", lastGroup and lastGroup.id, group and group.id)

	-- Unload the last group.
	if lastGroup then
		lastGroup:Deactivate()
	end

	-- Activate current group.
	if group then
		group:Activate()
	end

	-- Cache the group.
	self.group = group

	-- Subscribe to group.
	TriggerServerEvent("doors:subscribe", group and group.id)
end

--[[ Exports ]]--
exports("SetDoorState", function(coords, state)
	if state == nil then
		local group = Main.group
		if not group then return end

		local door = group:FindDoor(coords)
		if not door then return end

		state = not door.state
	end
	TriggerServerEvent("doors:toggle", Main.group.id, coords, state)
end)

exports("GetDoorState", function(coords)
	local group = Main.group
	if not group then return end

	local door = group:FindDoor(coords)
	if not door then return end

	return door.state
end)

exports("GetDoors", function()
	return Main.doors
end)

--[[ Threads ]]--
Citizen.CreateThread(function()
	while true do
		Main:Update()
		Citizen.Wait(200)
	end
end)

Citizen.CreateThread(function()
	while true do
		local group = Main.group
		if group then
			for entity, door in pairs(group.doors) do
				if DoesEntityExist(entity) then
					door:Update()
				else
					door:Destroy()
				end
			end
		end

		Citizen.Wait(20)
	end
end)

--[[ Events: Net ]]--
RegisterNetEvent("doors:inform", function(groupId, payload)
	local group = Main.group
	if not group or group.id ~= groupId then
		print("receiving doors for wrong group", group and group.id, groupId)
		return
	end

	print("update doors", groupId, payload)

	local cached = {}

	for k, v in ipairs(payload) do
		local coords, state = table.unpack(v)
		cached[k] = {
			coords = coords,
			state = state,
		}
	end

	group.cached = cached
end)

RegisterNetEvent("doors:toggle", function(groupId, coords, state)
	local group = Main.group
	if not group or group.id ~= groupId then
		print("toggling door for wrong group", group and group.id, groupId)
		return
	end

	local door = group:FindDoor(coords)

	if door then
		print("toggle door", coords, state)
	
		door:SetState(state)
	else
		print("toggling door that doesn't exist, so it will cache", coords, state)

		group:Cache(coords, state)
	end
end)

--[[ Events ]]--
AddEventHandler("doors:clientStart", function()
	Main:Init()
end)

AddEventHandler("doors:stop", function()
	if Main.group then
		Main.group:Deactivate()
	end
end)