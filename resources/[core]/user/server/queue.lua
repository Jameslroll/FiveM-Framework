Queue = {
	attempts = {},
	banned = {},
	bans = {},
	connecting = {},
	whitelist = {},
}

--[[ Functions ]]--
function Queue:Init()
	self.banned.tokens = {}
	
	-- Cache bans.
	local bans = exports.GHMattiMySQL:QueryResult("SELECT * FROM `bans` WHERE `unbanned`=0")
	for index, row in ipairs(bans) do
		self:AddBan(row)
	end

	-- Cache users.
	local users = exports.GHMattiMySQL:QueryResult("SELECT * FROM `users` WHERE `priority`>-128")
	for index, row in ipairs(users) do
		if row.steam then
			self.whitelist[row.steam] = true
		end
	end

	-- Final init.
	self.init = true
end

function Queue:AddBan(info)
	local index = #self.bans + 1

	-- Update identifiers.
	for __, key in ipairs(Server.Identifiers) do
		local value = info[key]
		if value ~= nil then
			if self.banned[key] == nil then
				self.banned[key] = {}
			end
			self.banned[key][value] = index
		end
	end

	-- Update tokens.
	local tokens = info.tokens
	if tokens ~= nil then
		tokens = json.decode(tokens)
		for _, token in ipairs(tokens) do
			self.banned.tokens[token] = index
		end
	end

	-- Get end time.
	local endTime = (info.duration == 0 and 0) or (info.start_time / 1000.0 + info.duration * 3600.0)

	info.endTime = endTime

	-- Cache ban.
	self.bans[index] = info
end

function Queue:RemoveBan(info)
	for key, value in pairs(info) do
		local banned = self.banned[key]
		if banned then
			local index = banned[value]
			if index then
				self.bans[index] = nil
				self.banned[key][value] = nil
			end
		end
	end
end

function Queue:Connect(source, name, setKickReason, deferrals)
	-- Update deferral.
	deferrals.update("Connecting...")
	deferrals.defer()

	Citizen.Wait(0)
	
	-- Get endpoint.
	local endpoint = GetPlayerEndpoint(source)
	if not endpoint then
		print(("no endpoint for [%s]"):format(source))
		return
	end
	
	-- Check tries.
	local tries = self.attempts[endpoint] or 0
	if tries > Server.MaxTries then
		deferrals.done(Server.Deferrals.Blocked)
		return false
	end

	-- Update tries.
	tries = tries + 1
	self.attempts[endpoint] = tries

	-- Basic log.
	print(("Checking %s"):format(endpoint))

	-- Get data.
	local data = Main:GetData(source)

	-- Check bans.
	local banTime, banReason = self:GetBanned(data.identifiers, data.tokens)
	if banTime == 0 then
		deferrals.done(Server.Deferrals.BannedForever:format(banReason or "No reason specified"))
		return false
	elseif banTime then
		deferrals.done(Server.Deferrals.Banned:format(banReason or "No reason specified", math.floor(banTime / 3600.0), math.floor(banTime / 3600.0 % 1.0 * 60.0)))
		return false
	end

	-- Check identifiers.
	for key, text in pairs(Server.Deferrals.Licenses) do
		if data.identifiers[key] == nil then
			deferrals.done(text)
			return false
		end
	end
	
	-- Check whitelist.
	if Server.EnableWhitelist then
		if not self.whitelist[data.identifiers.steam] then
			deferrals.done(Server.Deferrals.Whitelist)
			return false
		end
	end
	
	-- Check name.
	if name:gsub("[\128-\255]", "") ~= name then
		deferrals.done(Server.Deferrals.InvalidName)
		return false
	end

	-- Create user.
	local user = User:Create(data)
	if not user then
		deferrals.done(Server.Deferrals.UserFailed)
		return false
	end

	-- Set deferral.
	user.deferrals = deferrals

	-- Add to queue.
	local waitingCount = #self.connecting
	local position = waitingCount + 1
	local priority = self.priority or 0

	for k, queued in ipairs(self.connecting) do
		if priority > (queued.priority or -1) then
			position = k
		end
	end

	print(("Queue: %s@steam:%s@ip:%s joined - position %s/%s"):format(data.identifiers.name or "?", data.identifiers.steam or "?", data.identifiers.endpoint or "?", position, waitingCount + 1))
	table.insert(self.connecting, position, user)

	-- Finish.
	deferrals.update("Waiting for queue...")
end

function Queue:Update()
	local waitingCount = #self.connecting

	-- Get random emoji.
	math.randomseed(math.floor(os.clock() * 1000))
	local emoji = Server.Emoji[math.random(1, #Server.Emoji)]

	-- Update queue.
	for position = #self.connecting, 1, -1 do
		local user = self.connecting[position]
		local lastMsg = GetPlayerLastMsg(user.source)
		if lastMsg > 60000 then
			table.remove(self.connecting, position)
			print(("Queue: steam:%s removed - position %s/%s"):format(user.identifiers.steam, position, waitingCount))
			user.deferrals.done(Server.Deferrals.Timeout)
		else
			user.deferrals.update(("Your position in queue: %s/%s — %s"):format(position, waitingCount, emoji))
		end
	end

	-- Get first user.
	local user = self.connecting[1]
	if user == nil then return end
	
	-- Check players.
	local playerCount = GetNumPlayerIndices()
	local maxPlayers = GetConvarInt("sv_maxClients", 1)

	if playerCount >= maxPlayers then return end

	-- Let user in.
	user.deferrals.done()
	print(("Queue: %s@steam:%s@ip:%s connected"):format(user.identifiers.name or "?", user.identifiers.steam or "?", user.identifiers.endpoint or "?"))
	table.remove(self.connecting, 1)
end

function Queue:Count()
	return #self.connecting
end

function Queue:CheckBan(index)
	local banned = self.bans[index or false]
	if banned ~= nil and (banned.endTime == 0 or (banned.endTime or 0) > os.time()) then
		return (banned.endTime == 0 and 0) or (banned.endTime - os.time()), banned.reason
	end
end

function Queue:GetBanned(identifiers, tokens)
	-- Check identifiers.
	for _, key in ipairs(Server.Identifiers) do
		local value = identifiers[key]
		if value ~= nil and self.banned[key] ~= nil then
			local timeLeft, reason = self:CheckBan(self.banned[key][value])
			if timeLeft ~= nil then
				return timeLeft, reason
			end
		end
	end

	-- Check tokens.
	for _, token in ipairs(tokens) do
		local timeLeft, reason = self:CheckBan(self.banned.tokens[token])
		if timeLeft ~= nil then
			return timeLeft, reason
		end
	end

	-- Not banned.
	return false
end

--[[ Events ]]--
AddEventHandler(Main.event.."start", function()
	Queue:Init()
end)

AddEventHandler("playerConnecting", function(name, setKickReason, deferrals)
	local source = source
	Queue:Connect(source, name, setKickReason, deferrals)
end)

--[[ Threads ]]--
Citizen.CreateThread(function()
	while true do
		Queue:Update()
		Citizen.Wait(2000)
	end
end)

--[[ Commands ]]--
RegisterCommand("togglequeue", function(source, args, rawcommand)
	if source ~= 0 then return end

	Server.EnableWhitelist = not Server.EnableWhitelist

	print("Queue "..(Server.EnableWhitelist and "enabled" or "disabled").."!")
end, true)