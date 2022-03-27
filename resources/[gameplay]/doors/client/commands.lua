exports.chat:RegisterCommand("doors:debug", function(source, args, rawCommand, cb)
	local value = not Config.Debug
	Config.Debug = value

	cb("inform", ("Debug mode %s!"):format(value and "enabled" or "disabled"))

	local group = Main.group
	if group then
		group:Deactivate()
		Main.group = nil
		Main.lastCoords = nil
	end
end, {
	description = "Toggle the debug mode for doors.",
}, "Dev")

exports.chat:RegisterCommand("doors:toggle", function(source, args, rawCommand, cb)
	local group = Main.group
	if not group then
		cb("error", "There are no doors nearby!")
		return
	end

	local id = tonumber(args[1])
	if not id then
		cb("error", "Invalid ID, it must be a number!")
		return
	end

	for entity, door in pairs(group.doors) do
		if door.id == id then
			door:ToggleLock()
			break
		end
	end
end, {
	description = "Toggle the lock on a door.",
	parameters = {
		{ name = "ID", description = "The local door ID, found in debug mode." },
	}
}, "Dev")