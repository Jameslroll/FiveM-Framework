Player = {}
Player.__index = Player

function Player:Create(source)
	local player = setmetatable({
		serverId = source,
		status = "",
		viewers = {},
	}, Player)

	Main.players[source] = player

	return player
end

function Player:Subscribe(source, value)
	value = value == true or nil

	local health = exports.character:Get(self.serverId, "health")
	if value and not health then return false end

	self.viewers[source] = value

	if value then
		TriggerClientEvent("health:sync", source, self.serverId, health, self.status)
	end

	return true
end

function Player:InformAll(eventName, ...)
	for viewer, _ in pairs(self.viewers) do
		TriggerClientEvent(eventName, viewer, ...)
	end
end

function Player:SetStatus(status)
	if status == self.status then
		return false
	end
	
	self.status = status

	self:InformAll("health:updateStatus", self.serverId, status)

	return true
end