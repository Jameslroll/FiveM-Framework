Players = {
	viewers = {},
}

function Players:GetPayloadSingle(source)
	return {
		serverId = source,
		userId = exports.user:Get(source, "id"),
		characterName = exports.character:GetName(source) or "LOADING",
		steamName = GetPlayerName(source),
	}
end

function Players:GetPayloadAll()
	local payload = {}

	for source in GetActivePlayers() do
		payload[#payload + 1] = self:GetPayloadSingle(source)
	end

	return payload
end

function Players:UpdateAll()

end

--[[ Events: Net ]]--
RegisterNetEvent(Admin.event.."requestPlayers", function(value)
	local source = source
	
	if value and not exports.user:IsMod(source) then return end

	Players.viewers[source] = value or nil

	if value then
		TriggerClientEvent(Admin.event.."receivePlayers", source, Players:GetPayloadAll())
	end
end)