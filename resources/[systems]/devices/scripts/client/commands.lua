--[[ Keys ]]--
RegisterCommand("+roleplay_phone", function()
	if not IsControlEnabled(0, 51) then
		return
	end

	if not exports.inventory:HasItem(Config.Devices["phone"].item) then
		return
	end

	Main:Toggle("phone")
end, true)

RegisterKeyMapping("+roleplay_phone", "Phone - Toggle", "keyboard", "m")