exports.chat:RegisterCommand("a:vehlock", function(source, args, command, cb)
	local vehicle = IsInVehicle and CurrentVehicle or NearestVehicle
	if not vehicle or not DoesEntityExist(vehicle) then return end

	if not Main:ToggleLock(true) then
		error("error", "Failed to toggle lock...")
	end
end, {
	description = "Toggle the lock on a vehicle.",
}, "Admin")