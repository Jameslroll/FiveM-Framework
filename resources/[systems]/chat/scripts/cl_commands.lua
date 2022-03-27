Chat:RegisterCommand("clear", function(source, args, command)
	Menu:Commit("clearMessages")
end, {
	description = "Removes all current messages from the chat.",
})

Chat:RegisterCommand("test", function(source, args, command)
	for k, v in ipairs({
		"transparent",
		"system",
		"server",
		"advert",
		"emergency",
		"nonemergency",
		"rainbow",
	}) do
		TriggerEvent("chat:addMessage", {
			text = "This is "..v.."!",
			class = v,
		})
	end

	for k, v in ipairs({
		"success",
		"error",
		"inform",
	}) do
		TriggerEvent("chat:notify", {
			text = "This is "..v.."!",
			class = v,
		})
	end
end, {
	description = "Test all the pretty colors.",
})