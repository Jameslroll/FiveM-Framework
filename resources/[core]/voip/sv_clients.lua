Client = {}
Client.__index = Client

--[[ Functions: Client ]]--
function Client:Create(source)
	-- Create client.
	local client = setmetatable({
		source = source,
		channels = {},
		channelCount = 0,
	}, Client)

	-- Cache client.
	Voip.clients[source] = client

	-- Return client.
	return client
end

function Client:Destroy()
	-- Remove from channels.
	for id, channel in pairs(self.channels) do
		channel:RemovePlayer(self.source)
	end

	-- Uncache client.
	Voip.clients[self.source] = nil
end

function Client:JoinChannel(id, _type)
	-- Check id.
	if not id then
		return false
	end

	-- Channel limit.
	if self.channelCount > 8 then
		print(("[%i] hit the channel limit!"):format(self.source))
		return false
	end

	-- Get channel.
	local channel = Voip.channels[id]

	-- Create channel.
	if not channel then
		channel = Channel:Create(id)
	end

	-- Join channel.
	if channel:AddPlayer(self.source, _type) then
		self.channelCount = self.channelCount + 1
		self.channels[id] = channel

		return true
	end

	-- Failure.
	return false
end

function Client:LeaveChannel(id)
	-- Get channel.
	local channel = self.channels[id or false]
	if not channel then
		return false
	end

	-- Try to reomve client.
	if channel:RemovePlayer(self.source) then
		self.channelCount = self.channelCount - 1
		self.channels[id] = nil

		return true
	end

	-- Failure.
	return false
end

function Client:SetTalking(value, filter)
	self.isTalking = value

	-- Update channels.
	for channelId, channel in pairs(self.channels) do
		local channelType = channel.clients[tostring(self.source)]
		if (not filter and channelType == Config.Types.Automatic) or (filter and channelType == Config.Types.Manual and filter[channelId]) then
			channel:SetTalking(self.source, value)
		end
	end
end