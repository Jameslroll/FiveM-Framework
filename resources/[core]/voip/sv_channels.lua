Channel = {}
Channel.__index = Channel

--[[ Functions: Channel ]]--
function Channel:Create(id)
	local channel = setmetatable({
		id = id,
		clients = {},
		talking = {},
	}, Channel)

	Voip.channels[id] = channel

	return channel
end

function Channel:Destroy()
	Voip.channels[self.id] = nil
end

function Channel:AddPlayer(source, _type)
	-- Check already in channel.
	if self.clients[tostring(source)] then
		return false
	end

	-- Inform other clients.
	self:SendPayload("voip:addToChannel", self.id, source)

	-- Trigger events.
	TriggerEvent("voip:addToChannel", source, self.id, _type)
	TriggerClientEvent("voip:addToChannel", source, self.id, self.clients, self.talking)
	
	-- Cache client.
	self.clients[tostring(source)] = _type or true

	-- Success.
	return true
end

function Channel:RemovePlayer(source)
	-- Check already in channel.
	if not self.clients[tostring(source)] then
		return false
	end

	-- Cache client.
	self.clients[tostring(source)] = nil

	-- Inform other clients.
	self:SendPayload("voip:removeFromChannel", self.id, source)

	-- Trigger events.
	TriggerEvent("voip:removeFromChannel", source, self.id)
	TriggerClientEvent("voip:removeFromChannel", source, self.id)
	
	-- Cleanup channel.
	local next = next
	if next(self.clients) == nil then
		self:Destroy()
	end

	-- Success.
	return true
end

function Channel:SendPayload(eventName, ...)
	for _client, _ in pairs(self.clients) do
		TriggerClientEvent(eventName, _client, ...)
	end
end

function Channel:SetTalking(source, value)
	if self.talking[tostring(source)] == value then return end

	self.talking[tostring(source)] = value or nil

	self:SendPayload("voip:setTalking", self.id, source, value)
end