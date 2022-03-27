--[[ Events: Net ]]--
RegisterNetEvent(Admin.event.."requestPlayer", function(serverId)
	local source = source

	if not exports.user:IsMod(source) then return end

	data = {
		name = exports.character:GetName(serverId),
	}

	TriggerClientEvent(Admin.event.."receivePlayer", source, serverId, data)
end)

RegisterNetEvent(Admin.event.."invokeHook", function(_type, message, ...)
	local source = source
	
	if not exports.user:IsMod(source) then return end

	Admin:InvokeHook(_type, message, source, ...)
end)

--[[ Hooks ]]--
Admin.streaming = {}
Admin:AddHook("toggle", "streamerMode", function(source, value)
	Admin.streaming[source] = value
end)