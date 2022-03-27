Entering = {
	pressed = 0
}

--[[ Functions: Entering ]]--
function Entering:Update()
	local state = LocalPlayer.state
	
	DisableControlAction(0, 23)

	if
		DoesEntityExist(CurrentVehicle) or
		state.immobile
		-- not IsControlEnabled(0, 51) or
		-- not IsControlEnabled(0, 52)
	then
		return
	end

	if DoesEntityExist(EnteringVehicle) then
		if IsControlPressed(0, 30) or IsControlPressed(0, 31) then
			ClearPedTasks(Ped)
		else
			return
		end
	end

	if IsDisabledControlJustPressed(0, 23) then
		self.pressed = GetGameTimer()
	elseif IsDisabledControlJustReleased(0, 23) then
		local pressTime = GetGameTimer() - self.pressed
		Entering:Activate(pressTime > 500)
	end
end

function Entering:Activate(goToDriver)
	local coords = GetEntityCoords(Ped)
	local state = LocalPlayer.state

	-- Check carry.
	if state.carrying or state.carried then return end

	-- Get vehicle.
	local vehicle = GetNearestVehicle(coords, 8.0)
	if not vehicle or not DoesEntityExist(vehicle) or IsEntityAttached(vehicle) then return end

	-- Get model.
	local model = GetEntityModel(vehicle)

	-- Check stretchers.
	if Stretcher.models[model] then
		Main:InvokeListener("ActivateStretcher", vehicle)
		return
	end

	-- Check locks.
	local class = GetVehicleClass(vehicle)
	local locked = GetVehicleDoorsLockedForPlayer(vehicle, Player) == 1
	
	if locked and not Config.Locking.Blacklist[class] then
		return
	end

	-- Check driver.
	local driver = GetPedInVehicleSeat(vehicle, -1)
	local hasDriver = driver and DoesEntityExist(driver) and not IsPedDeadOrDying(driver)
	if hasDriver and not IsPedAPlayer(driver) then
		if Config.Taxis[model] then
			TaskSetBlockingOfNonTemporaryEvents(driver, true)
		else
			return
		end
	end

	-- Find seat.
	local nearestDoor, nearestDoorDist, nearestDoorCoords = GetClosestDoor(coords, vehicle, true, true)
	local seatIndex, doorDist

	if not goToDriver and nearestDoor and nearestDoorDist < 1.0 then
		seatIndex = (Doors[nearestDoor] or 0) - 1
		doorDist = nearestDoorDist
	else
		seatIndex, doorDist = (goToDriver and not hasDriver and -1) or GetClosestSeat(coords, vehicle, true) or (not hasDriver and -1)
	end

	if not seatIndex then return end

	-- Check door.
	local doorIndex = seatIndex + 1
	if state.restrained and not IsVehicleDoorOpen(vehicle, doorIndex) then
		return
	end

	-- Enter vehicle.
	SetVehicleDoorsLocked(vehicle, 0)
	TaskEnterVehicle(Ped, vehicle, -1, seatIndex, IsControlPressed(0, 21) and 2.0 or 1.0, state.restrained and 256 or 8, 0)
end

--[[ Listeners ]]--
Main:AddListener("Enter", function(vehicle)
	SetVehicleNeedsToBeHotwired(vehicle, false)
end)

Main:AddListener("Update", function()
	Entering:Update()
end)