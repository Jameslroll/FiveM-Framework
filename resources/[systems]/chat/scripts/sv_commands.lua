Chat:RegisterCommand("ooc", function(source, args, command)
	local message = table.concat(args, " ")
	if message == "" or message == " " then return end

	local name = ("(%s:%s) %s"):format(source, exports.user:Get(source, "id"), tostring(GetPlayerName(source)))

	TriggerClientEvent("chat:addMessage", -1, {
		text = message,
		title = name,
		class = exports.user:IsMod(source) and "rainbow" or "server",
	})
end, {
	description = "Speak to other players in the area out-of-character.",
	parameters = {
		{ name = "Message", description = "What's on your mind?" },
	},
})