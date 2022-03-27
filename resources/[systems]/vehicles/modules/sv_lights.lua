local function GetVehicle(source)
	local ped = GetPlayerPed(source)
	if not ped or not DoesEntityExist(ped) then return end

	local vehicle = GetVehiclePedIsIn(ped)
	if not vehicle or not DoesEntityExist(vehicle) --[[or GetPedInVehicleSeat(vehicle, -1) ~= ped]] then return end

	return vehicle
end

local states = {
	["siren"] = true,
	["blinker"] = true,
	["horn"] = true,
}

RegisterNetEvent("vehicles:setState", function(key, state)
	local source = source

	if type(key) ~= "string" or type(state) ~= "number" or not states[key] then return end

	local vehicle = GetVehicle(source)
	if not vehicle then return end

	local entity = Entity(vehicle)
	if not entity then return end

	entity.state[key] = state
end)