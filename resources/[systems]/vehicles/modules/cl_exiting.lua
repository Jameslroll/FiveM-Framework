Exiting = {}

--[[ Functions: Exiting ]]--
function Exiting:Update()
	local state = LocalPlayer.state
	
	DisableControlAction(0, 75)

	if
		not DoesEntityExist(CurrentVehicle) or
		state.immobile
	then
		return
	end

	if IsDisabledControlJustReleased(0, 23) then
		Exiting:Activate()
	end
end

function Exiting:Activate()
	local vehicle = CurrentVehicle
	if not vehicle then return end

	local ped = PlayerPedId()
	local state = LocalPlayer.state

	-- Check door.
	local doorIndex = (FindSeatPedIsIn(ped) or 0) + 1
	if state.restrained and not IsVehicleDoorOpen(vehicle, doorIndex) then
		return
	end
	
	-- Check locks.
	local class = GetVehicleClass(vehicle)
	local locked = GetVehicleDoorsLockedForPlayer(vehicle, Player) == 1
	
	if locked and not Config.Locking.Blacklist[class] then
		TriggerServerEvent("playSound3D", "carlocked")
		return
	end

	-- Enter vehicle.
	TaskLeaveVehicle(ped, vehicle, (((Class == 15 or Class == 16) and Speed < 0.1) and 0) or state.restrained and 256 or 4160)
end

--[[ Listeners ]]--
Main:AddListener("Update", function()
	Exiting:Update()
end)