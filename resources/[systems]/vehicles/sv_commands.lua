--[[ Functions ]]--
local function setVehicleRotation(source, x, y)
	-- Get ped.
	local ped = GetPlayerPed(source)
	if not DoesEntityExist(ped or 0) then
		return false
	end

	-- Get vehicle.
	local vehicle = GetVehiclePedIsIn(ped)
	if not vehicle then
		return false
	end

	-- Flip vehicle.
	local heading = GetEntityHeading(vehicle)
	SetEntityRotation(vehicle, x, y, heading)
end

--[[ Commands ]]--
exports.chat:RegisterCommand("a:vehspawn", function(source, args, command, cb)
	local model = args[1]
	if not model then
		cb("error", "Invalid model!")
		return
	end

	-- Get ped.
	local ped = GetPlayerPed(source)
	local coords = GetEntityCoords(ped)
	
	-- Delete old vehicle.
	local currentVehicle = GetVehiclePedIsIn(ped)
	if currentVehicle and DoesEntityExist(currentVehicle) then
		DeleteEntity(currentVehicle)
	end

	-- Create new vehicle.
	local hash = GetHashKey(model)
	local heading = GetEntityHeading(ped)
	local vehicle = Main:Spawn(hash, coords, heading, {
		key = true,
	})

	-- Put ped into vehicle.
	SetPedIntoVehicle(ped, vehicle, -1)

	-- Log it.
	exports.log:Add({
		source = source,
		verb = "spawned",
		noun = "vehicle",
		extra = model,
		channel = "admin",
	})
end, {
	description = "Spawn a vehicle.",
	parameters = {
		{ name = "Model", description = "The vehicle model to spawn." },
	}
}, "Mod")

exports.chat:RegisterCommand("a:fix", function(source, args, command, cb)
	-- Get ped.
	local ped = GetPlayerPed(source)
	if not DoesEntityExist(ped or 0) then return end

	-- Get vehicle.
	local vehicle = GetVehiclePedIsIn(ped)
	if not vehicle then
		cb("error", "Must be in a vehicle!")
		return
	end

	-- Tell owner to fix.
	local owner = NetworkGetEntityOwner(vehicle)

	TriggerClientEvent("vehicles:fix", owner)

	-- Log it.
	exports.log:Add({
		source = source,
		verb = "fixed",
		noun = "vehicle",
		channel = "admin",
	})
end, {
	description = "Completely fix your vehicle.",
}, "Admin")

exports.chat:RegisterCommand("a:flip", function(source, args, command, cb)
	if setVehicleRotation(source, 0.0, 180.0) then
		exports.log:Add({
			source = source,
			verb = "flipped",
			noun = "vehicle",
			channel = "admin",
		})
	else
		cb("error", "Must be in a vehicle!")
	end
end, {
	description = "Flip... your vehicle? Yes! Not unflip.",
}, "Mod")

exports.chat:RegisterCommand("a:unflip", function(source, args, command, cb)
	if setVehicleRotation(source, 0.0, 0.0) then
		exports.log:Add({
			source = source,
			verb = "unflipped",
			noun = "vehicle",
			channel = "admin",
		})
	else
		cb("error", "Must be in a vehicle!")
	end
end, {
	description = "Unflip your vehicle if you're upside down.",
}, "Mod")

exports.chat:RegisterCommand("a:vehkey", function(source, args, command, cb)
	-- Get target.
	local target = tonumber(args[1]) or source
	local ped = GetPlayerPed(target)
	if not ped or not DoesEntityExist(ped) then
		cb("error", "Invalid target!")
		return
	end

	-- Get vehicle.
	local vehicle = GetVehiclePedIsIn(ped)
	if not vehicle or not DoesEntityExist(vehicle) then
		cb("error", "Must be in a vehicle!")
		return
	end

	-- Give key and log it.
	if Main:GiveKey(target, NetworkGetNetworkIdFromEntity(vehicle)) then
		exports.log:Add({
			source = source,
			target = target,
			verb = "gave",
			noun = "vehicle key",
			channel = "admin",
		})
	end
end, {
	description = "Give a key to a vehicle.",
	parameters = {
		{ name = "Target", description = "Who to give the key to (default = you)." },
	}
}, "Admin")

exports.chat:RegisterCommand("a:vehdamage", function(source, args, command, cb)
	-- Get target.
	local target = tonumber(args[3]) or source
	local ped = GetPlayerPed(target)
	if not ped or not DoesEntityExist(ped) then
		cb("error", "Invalid target!")
		return
	end
	
	-- Get vehicle.
	local entity = GetVehiclePedIsIn(ped)
	if not entity or not DoesEntityExist(entity) then
		cb("error", "Must be in a vehicle!")
		return
	end

	-- Get cached vehicle.
	local vehicle = Main.vehicles[NetworkGetNetworkIdFromEntity(entity) or false]
	if not vehicle then
		cb("error", "Vehicle (cache) does not exist!")
		return
	end

	-- Get damage.
	local damage = tonumber(args[2])
	if not damage then
		cb("error", "Damage must be a number!")
		return
	end

	-- Find part.
	local setName = (args[1] or ""):lower()
	local setCount = 0
	local damages = vehicle.info.damage or {}

	for partId, part in pairs(Main.parts) do
		if part.Name then
			if setName == "*" or part.Name:lower():gsub("%s+", ""):find(setName) then
				setCount = setCount + 1
				damages[partId] = damage
			end
		end
	end

	if setCount <= 0 then
		cb("error", "Parts not found!")
		return
	end

	-- Update vehicle.
	vehicle:Set("damage", damages)

	-- Message client.
	cb("success", ("%s part(s) set to %.0f%% matching filter '%s'!"):format(setCount, damage * 100.0, setName))

	-- Log it.
	exports.log:Add({
		source = source,
		target = target,
		verb = "set",
		noun = "vehicle damage",
		extra = ("filter: %s - damage: %.2f"):format(setName, damage),
		channel = "admin",
	})
end, {
	description = "Set the damage of a specific part.",
	parameters = {
		{ name = "Part", description = "Name of the part to set." },
		{ name = "Damage", description = "Health of the part to set." },
		{ name = "Target", description = "Who's vehicle to set (default = yours)." },
	}
}, "Dev")