Main.vehicles = {}
Main.vinCache = {}

--[[ Functions: Main ]]--
function Main:Init()
	self:CacheParts(Config.Parts)
end

function Main:CacheParts(parts)
	self.parts = {}
	for k, part in ipairs(parts) do
		local bone = part.Bone or -1
		if type(bone) == "table" then
			for _k, _bone in ipairs(bone) do
				self:CacheBone(part, _bone)
			end
		else
			self:CacheBone(part, bone)
		end
	end
end

function Main:CacheBone(part, bone)
	if part.Name then
		local id = GetHashKey(part.Name.."_"..bone)
		self.parts[id] = part
	end
	if part.Parts then
		for k, _part in ipairs(part.Parts) do
			self:CacheBone(_part, bone)
		end
	end
end

function Main:Spawn(model, coords, heading, info)
	local entity = CreateVehicle(model, coords.x, coords.y, coords.z, heading, true, true)
	
	if info then
		while not DoesEntityExist(entity) do
			Citizen.Wait(0)
		end

		local netId = NetworkGetNetworkIdFromEntity(entity)
		local vehicle = Vehicle:Create(netId, info)
	end

	return entity
end

function Main:Enter(source, netId)
	local vehicle = self.vehicles[netId]
	if not vehicle then
		vehicle = Vehicle:Create(netId)
	end

	vehicle:Subscribe(source, true)

	exports.log:Add({
		source = source,
		verb = "entered",
		noun = "vehicle",
		extra = vehicle:Get("vin"),
	})
end

function Main:GetUniqueVin()
	local vin

	while true do
		vin = GetRandomText(17, UpperCase, Numbers)

		if not self.vinCache[vin] then
			break
		else
			Citizen.Wait(0)
		end
	end

	self.vinCache[vin] = true

	return vin
end

--[[ Events ]]--
AddEventHandler("vehicles:start", function()
	Main:Init()
end)

AddEventHandler("entityCreated", function(entity)
	if not entity or not DoesEntityExist(entity) then return end

	-- Do something with vehicle when created?
end)

AddEventHandler("entityRemoved", function(entity)
	if not entity then return end
	
	local netId = NetworkGetNetworkIdFromEntity(entity)
	local vehicle = Main.vehicles[netId or false]
	if vehicle then
		vehicle:Destroy()
	end
end)

--[[ Events: Net ]]--
RegisterNetEvent("vehicles:enter", function(netId)
	local source = source

	-- Check input.
	if type(netId) ~= "number" then return end

	-- Check cooldown.
	if not PlayerUtil:CheckCooldown(source, 1.0) then return end
		
	PlayerUtil:UpdateCooldown(source)
	Main:Enter(source, netId)
end)

RegisterNetEvent("vehicles:subscribe", function(netId, value)
	local source = source
	value = value == true

	if type(netId) ~= "number" then return end
	
	local vehicle = Main.vehicles[netId]
	if not vehicle then
		vehicle = Vehicle:Create(netId)
		if not vehicle then return end
	end

	vehicle:Subscribe(source, value)
end)

RegisterNetEvent("vehicles:toggleDoor", function(netId, door, state)
	local source = source

	-- Check input.
	if type(netId) ~= "number" or type(door) ~= "number" or type(state) ~= "boolean" then return end
	
	-- Check cooldown.
	if not PlayerUtil:CheckCooldown(source, 1.0, true) then return end

	-- Check vehicle.
	local entity = NetworkGetEntityFromNetworkId(netId)
	if not entity or not DoesEntityExist(entity) then return end

	local target = NetworkGetEntityOwner(entity)
	if not target then return end

	exports.log:Add({
		source = source,
		verb = state and "closed" or "opened",
		noun = "vehicle door",
	})

	TriggerClientEvent("vehicles:toggleDoor", target, netId, door, state)
end)