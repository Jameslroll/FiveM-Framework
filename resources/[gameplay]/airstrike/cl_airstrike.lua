Blacklist = {}
Vehicle = 0
Pilot = 0

Citizen.CreateThread(function()
	for _, model in ipairs(Config.Blacklist) do
		Blacklist[GetHashKey(model)] = true
	end

	while true do
		while not DoesEntityExist(PlayerPedId() or 0) do
			Citizen.Wait(100)
		end

		if IsInStrikeZone() then
			local ped = PlayerPedId()
			Strike(GetEntityCoords(ped), ped)
		end

		Citizen.Wait(15000)
	end
end)

function Strike(coords, ped)
	-- Request the vehicle model.
	local model = GetHashKey(Config.Vehicle.Model)
	while not HasModelLoaded(model) do
		RequestModel(model)
		Citizen.Wait(20)
	end

	-- Request the pilot model.
	local pilotModel = GetHashKey(Config.Vehicle.Pilot)
	while not HasModelLoaded(pilotModel) do
		RequestModel(pilotModel)
		Citizen.Wait(20)
	end
	
	-- Cache the times.
	local startTime = GetGameTimer()
	local lastUpdate = startTime

	-- Do some math.
	local rad = GetRandomFloatInRange(-3.14, 3.14)
	local direction = vector3(math.cos(rad), math.sin(rad), 0.0)
	local vehicleCoords = coords + vector3(-direction.x * Config.Vehicle.Range, -direction.y * Config.Vehicle.Range, Config.Vehicle.Height)
	local heading = rad * 57.2958 - 90

	-- Create the entities.
	Vehicle = CreateVehicle(model, vehicleCoords.x, vehicleCoords.y, vehicleCoords.z, heading, false, true)
	Pilot = CreatePed(4, pilotModel, vehicleCoords.x, vehicleCoords.y, vehicleCoords.z, heading, false, true)

	-- Put the pilot into the vehicle.
	SetPedIntoVehicle(Pilot, Vehicle, -1)

	-- Set the vehicle stuff.
	ControlLandingGear(Vehicle, 3)
	SetVehicleEngineOn(Vehicle, true, true, false)
	SetEntityVelocity(Vehicle, direction.x * Config.Vehicle.Speed, direction.y * Config.Vehicle.Speed, 0.0)

	-- Update the vehicle.
	while DoesEntityExist(Vehicle) do
		if not NetworkHasControlOfEntity(Vehicle) then
			NetworkRequestControlOfEntity(Vehicle)
			Citizen.Wait(50)
		end
		
		local delta = (GetGameTimer() - lastUpdate) / 1000.0
		lastUpdate = GetGameTimer()
		
		local coords = coords
		local vehicle = 0
		if ped then
			if not IsInStrikeZone() then
				break
			end

			coords = GetEntityCoords(ped)

			if IsPedInAnyHeli(ped) or IsPedInAnyPlane(ped) then
				vehicle = GetVehiclePedIsIn(ped)
			end
		else
			ped = 0
		end

		TaskPlaneMission(Pilot, Vehicle, vehicle, ped, coords.x, coords.y, coords.z, 6, 0, 0, heading, 2000.0, 400.0)
		
		-- Citizen.CreateThread(function()
		-- 	for i = 1, 100 do
		-- 		DrawLine(vehicleCoords.x, vehicleCoords.y, vehicleCoords.z, coords.x, coords.y, coords.z, 255, 0, 0, 255)
		-- 		Citizen.Wait(20)
		-- 	end
		-- end)

		Citizen.Wait(1000)
	end

	Citizen.Wait(5000)

	-- Remove the pilot.
	if DoesEntityExist(Pilot) then
		DeleteEntity(Pilot)
		Pilot = 0
	end
	
	-- Remove the vehicle.
	if DoesEntityExist(Vehicle) then
		DeleteEntity(Vehicle)
		Vehicle = 0
	end
end

function IsInStrikeZone()
	local ped = PlayerPedId()
	local coords = GetEntityCoords(ped)

	-- Check alive.
	if GetResourceState("health") == "started" and exports.health:IsPedDead(ped) then
		return false
	end

	-- Check factions.
	if GetResourceState("jobs") == "started" and exports.character:Get("id") then
		if exports.jobs:IsInEmergency() then
			return false
		end
	end

	-- Check vehicle.
	local vehicle = GetVehiclePedIsIn(ped, false) or 0

	if DoesEntityExist(vehicle) and Blacklist[GetEntityModel(vehicle)] then
		return true
	end

	-- Check zones.
	local currentZone = GetNameOfZone(coords.x, coords.y, coords.z)

	for _, zone in ipairs(Config.Zones) do
		if zone.Name and zone.Name == currentZone then
			return true
		end
	end

	return false
end

AddEventHandler("airstrike:stop", function()
	if DoesEntityExist(Vehicle) then
		DeleteEntity(Vehicle)
	end

	if DoesEntityExist(Pilot) then
		DeleteEntity(Pilot)
	end
end)