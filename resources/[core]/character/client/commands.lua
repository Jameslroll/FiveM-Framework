exports.chat:RegisterCommand("a:switch", function(source, args, command)
	Main:SelectCharacter()
end, {
	description = "Return to the character selection menu.",
}, "Mod")