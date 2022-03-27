Fob = {}
Fob.distance = 10.0
Fob.classes = {
	[18] = true, -- Emergency.
	[19] = true, -- Military.
}

function Fob:UpdateDoors()
	-- Check group.
	if not Main.group then return end

	-- Get ped.
	local ped = PlayerPedId()

	-- Check vehicle.
	local vehicle = IsPedInAnyVehicle(ped) and GetVehiclePedIsIn(ped)
	if not vehicle or GetPedInVehicleSeat(vehicle, -1) ~= ped or not self.classes[GetVehicleClass(vehicle)] then return end

	-- Find door.
	local coords = GetEntityCoords(vehicle)

	self.door = Main.group:FindDoor(coords, self.distance, function(entity, door)
		return door.settings.Fob
	end)

	return true
end

function Fob:UpdateInput()
	if not self.door then return end

	DisableControlAction(0, 73)

	if IsDisabledControlPressed(0, 73) and (not self.lastLock or GetGameTimer() - self.lastLock > 3000) then
		self.lastLock = GetGameTimer()
		self.door:ToggleLock()
	end
end

Citizen.CreateThread(function()
	while true do
		if not Fob:UpdateDoors() and Fob.door then
			Fob.door = nil
		end
	
		Citizen.Wait(1000)
	end
end)

Citizen.CreateThread(function()
	while true do
		Fob:UpdateInput()
		Citizen.Wait(0)
	end
end)