Chat.isServer = true
Chat.commandSettings = {}

--[[ Functions ]]--
function Chat:_RegisterCommand(command)
	Chat.commandSettings[command.name] = command.settings

	RegisterCommand(command.name, InvokeCommand, false)

	TriggerClientEvent("chat:registerCommand", -1, command.name, command.settings)
end

Chat:ExportAll()

--[[ Events ]]--
RegisterNetEvent("chat:ready")
AddEventHandler("chat:ready", function()
	local source = source
	TriggerClientEvent("chat:registerCommands", source, Chat.commandSettings)
end)