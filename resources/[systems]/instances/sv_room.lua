Room = {}
Room.__index = Room

function Room:Create(id, data)
	local bucket = math.abs(GetHashKey(id))

	if bucket ~= 0 then
		SetRoutingBucketPopulationEnabled(bucket, false)
	end

	data = data or {}
	data.id = id
	data.bucket = bucket
	data.players = {}

	local room = setmetatable(data, Room)

	Instances.rooms[id] = room

	return room
end

function Room:AddPlayer(source)
	if self.players[source] then return false end

	-- Cache player.
	self.players[source] = true
	Instances.players[source] = self.id

	-- Update routing bucket.
	SetPlayerRoutingBucket(source, self.bucket)

	return true
end

function Room:RemovePlayer(source)
	if not self.players[source] then return false end

	-- Uncache player.
	self.players[source] = nil
	Instances.players[source] = nil

	-- Update routing bucket.
	SetPlayerRoutingBucket(source, 0)

	-- Cleanup room.
	if not self.persistent then
		local next = next
		if next(self.players) == nil then
			self:Destroy()
			return true
		end
	end

	return true
end

function Room:Destroy()
	print("Destroying instance", self.id)

	for source, _ in pairs(self.players) do
		self:RemovePlayer(source)
	end

	Instances.rooms[self.id] = nil

	return true
end

function Room:InformAll(payload)
	for source, _ in pairs(self.players) do
		TriggerClientEvent("instances:inform", payload)
	end

	return true
end