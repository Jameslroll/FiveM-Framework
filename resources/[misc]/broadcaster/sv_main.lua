Main = {
	event = GetCurrentResourceName()..":",
	players = {},
	channels = {},
	calls = {},
}

--[[ Functions ]]--
function Main:Init()
	for k, station in ipairs(Config.Stations) do
		self.channels[station.Channel] = station
	end
end

function Main:JoinCall(source, target)
	local sourceStation = self.players[source]
	local targetStation = self.players[target]

	if not sourceStation and not targetStation then return end
	if sourceStation and targetStation then return end

	if sourceStation then
		TriggerClientEvent(Main.event.."toggleListener", target, false)
		Citizen.Wait(0)
		TriggerClientEvent("voip:joinChannel", target, sourceStation.Channel, "Automatic", "phone", Config.BaseVolume)
		self.calls[target] = sourceStation.Channel
	elseif targetStation then
		TriggerClientEvent(Main.event.."toggleListener", source, false)
		TriggerClientEvent("voip:joinChannel", source, targetStation.Channel, "Automatic", "phone", Config.BaseVolume)
		Citizen.Wait(0)
		self.calls[source] = targetStation.Channel
	end
end

function Main:EndCall(source, target)
	local sourceChannel = self.calls[source]
	local targetChannel = not sourceChannel and self.calls[target]

	if sourceChannel then
		TriggerClientEvent("voip:leaveChannel", source, sourceChannel)
	elseif targetChannel then
		TriggerClientEvent("voip:leaveChannel", target, targetChannel)
	end
end

--[[ Events ]]--
AddEventHandler(Main.event.."start", function()
	Main:Init()
end)

AddEventHandler("phone:joinCall", function(source, target)
	Main:JoinCall(source, target)
end)

AddEventHandler("phone:endCall", function(source, target)
	Main:EndCall(source, target)
end)

AddEventHandler("voip:addToChannel", function(source, id, _type)
	local station = _type ~= 3 and Main.channels[id]
	print(station)
	if station then
		Main.players[source] = station
	end
end)

AddEventHandler("voip:removeFromChannel", function(source, id)
	if Main.channels[id] then
		Main.players[source] = nil
	end
end)

AddEventHandler("playerDropped", function(reason)
	local source = source

	Main.players[source] = nil
	Main.calls[source] = nil
end)

--[[ Events: Net ]]--
RegisterNetEvent(Main.event.."toggle", function(stationId)
	local source = source

	local station = Config.Stations[stationId]
	if not station then
		return
	end

	local id = "broadcaster"..stationId
	local state = not GlobalState[id]
	GlobalState[id] = state

	exports.log:Add({
		source = source,
		verb = state and "enabled" or "disabled",
		noun = "broadcast",
	})
end)

RegisterNetEvent("broadcaster:setState", function(slotId, key, value)
	local source = source

	-- TODO: update item.
end)