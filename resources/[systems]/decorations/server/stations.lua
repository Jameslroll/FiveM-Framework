--[[ Functions: Decoration ]]--
function Decoration:EnterStation(source)
	if self.player then
		return false
	end

	-- Open station.
	exports.inventory:SubscribeStation(source, self.id, true)
	
	-- Cache player.
	self:Set("player", source)
	print("entered", source)
	
	return true
end

function Decoration:ExitStation(source)
	if self.player ~= source then
		return false
	end

	-- Close station.
	exports.inventory:SubscribeStation(source, self.id, false)

	-- Uncache player.
	self:Set("player", nil)
	print("exited", source)

	return true
end

--[[ Events: Net ]]--
RegisterNetEvent(Main.event.."enterStation", function(id)
	local source = source

	local player = Main.players[source]
	if not player then return end

	local decoration = Main.decorations[id or false]
	local success = false
	if decoration and decoration:EnterStation(source) then
		player.station = decoration
		success = true
	end

	TriggerClientEvent(Main.event.."enterStation", source, id, success)
end)

RegisterNetEvent(Main.event.."exitStation", function()
	local source = source

	local player = Main.players[source]
	if player and player.station then
		player.station:ExitStation(source)
		player.station = nil
	end
end)