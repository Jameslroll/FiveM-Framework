Main.users = {}
Main.blacklist = {}
Main.mimics = {}
Main.players = {}

--[[ Functions ]]--
function Main:Init()
	for _, path in ipairs({
		"sql/users.sql",
		"sql/bans.sql",
	}) do
		exports.GHMattiMySQL:Query(LoadQuery(path))
	end

	self.columns = DescribeTable("users")
	self.banColumns = DescribeTable("bans")
end

function Main:UpdatePlayers()
	for source, user in pairs(self.users) do
		local player = Player(source)
		if player.state.userId ~= user.id then
			self:TriggerTrap(source, true, ("state bag tampering (user id: %s, state bag: %s)"):format(tostring(user.id), tostring(player.state.userId)))
		end
	end
end

function Main:RegisterPlayer(source)
	-- Check user
	source = tonumber(source)
	if source == nil or self.users[source] ~= nil then return end

	-- Create user.
	local data = self:GetData(source)
	local user = User:Create(data)
	self.users[source] = user
	self.players[user.id] = source

	-- Owner stuff.
	if user:IsOwner() and user.identifiers.steam then
		local principal = ("identifier.steam:%s"):format(user.identifiers.steam)
		if not IsPrincipalAceAllowed(principal, "command") then
			ExecuteCommand(("add_ace %s command allow"):format(principal))
		end
	end

	-- Inform client.
	local endpoint = user.identifiers.endpoint
	user.identifiers.endpoint = nil
	
	TriggerEvent(self.event.."created", source, user)
	TriggerClientEvent(self.event.."sync", source, user)
	
	user.identifiers.endpoint = endpoint

	-- Set player id.
	local player = Player(source)
	player.state.userId = user.id
end

function Main:DestroyPlayer(source)
	local user = self.users[source]
	if user == nil then return end

	self.players[user.id or false] = nil
	self.users[user.source or false] = nil
end

function Main:GetData(source)
	if source == nil then return end

	-- Get identifiers.
	local numIdentifiers = GetNumPlayerIdentifiers(source)
	local identifiers = {
		endpoint = GetPlayerEndpoint(source),
		name = GetPlayerName(source),
	}

	-- Get mimics.
	local mimic = self.mimics[identifiers.endpoint]
	
	-- Set identifiers.
	if mimic then
		local user = mimic ~= 0 and exports.GHMattiMySQL:QueryResult("SELECT * FROM `users` WHERE `id`=@id LIMIT 1", {
			["@id"] = mimic,
		})[1]
	
		if user then
			for _, key in ipairs(Server.Identifiers) do
				identifiers[key] = user[key]
			end
		else
			identifiers.steam = "000000000000000"
			identifiers.license = "0000000000000000000000000000000000000000"
			identifiers.license2 = "0000000000000000000000000000000000000000"
			identifiers.discord = "000000000000000000"
		end
	else
		for i = 1, numIdentifiers do
			local identifier = GetPlayerIdentifier(source, i - 1)
			if identifier ~= nil then
				local key, value = GetIdentifiers(identifier)
				identifiers[key] = value
			end
		end
	end

	-- Get tokens.
	local numTokens = GetNumPlayerTokens(source)
	local tokens = {}
	
	for i = 1, numTokens do
		local token = GetPlayerToken(source, i - 1)
		if token ~= nil then
			tokens[i] = token
		end
	end
	
	-- Return data.
	return {
		source = source,
		identifiers = identifiers,
		tokens = tokens,
	}
end

function Main:Whitelist(hex, value)
	local index = Queue.whitelist[hex]
	if (value and index) or (not value and not index) then
		return false
	end

	Queue.whitelist[hex] = value and true or nil

	exports.GHMattiMySQL:QueryAsync((
		value and [[
			IF EXISTS (SELECT 1 FROM `users` WHERE `steam`=@steam) THEN
				UPDATE `users` SET `priority`=0 WHERE `steam`=@steam;
			ELSE
				INSERT INTO `users` SET `steam`=@steam;
			END IF;
		]] or "UPDATE `users` SET `priority`=-128 WHERE `steam`=@steam"
	), {
		["@steam"] = hex,
	})

	return true
end

function Main:TriggerTrap(source, ban, reason)
	exports.log:Add({
		source = source,
		verb = "triggered",
		noun = "anti-cheat",
		extra = ("%s - %s"):format(GetInvokingResource() or "user", reason or "?"),
		channel = "cheat",
	})

	if ban then
		self:Ban(source, 0, "Anti-cheat")
	end
end
Export(Main, "TriggerTrap")

function Main:Ban(target, duration, reason)
	local key, value = ConvertTarget(target, true)
	if not key then
		return false, value
	end

	-- Defaults.
	duration = math.floor(duration or 0)
	reason = reason or "No reason specified"

	-- Check reason.
	if reason:len() > 255 then
		return false, "reason too long"
	end
	
	-- Find users.
	local users = exports.GHMattiMySQL:QueryResult("SELECT * FROM `users` WHERE `"..key.."`=@identifier", {
		["@identifier"] = value,
	})
	
	-- Ban users.
	for _, user in ipairs(users) do
		local setters = "`duration`=@duration,`reason`=@reason"
		local values = {
			["@duration"] = duration,
			["@reason"] = reason,
		}

		local ban = {
			duration = duration,
			reason = reason,
			start_time = os.time() * 1000,
		}

		-- Get bannable identifiers.
		for _key, column in pairs(self.banColumns) do
			local _value = user[_key]
			if _value and type(_value) == column.type then
				setters = setters..(",`%s`=@%s"):format(_key, _key)
				values["@".._key] = _value
				ban[_key] = _value
			end
		end

		-- Save ban.
		exports.GHMattiMySQL:QueryAsync("INSERT INTO `bans` SET "..setters, values)

		-- Cache ban.
		Queue:AddBan(ban)

		-- Drop player.
		local serverId = self:GetPlayer(user.id)
		if serverId then
			DropPlayer(serverId, ("You have been banned. (%s)"):format(reason))
		end
	end

	-- Force ban.
	if #users == 0 then
		if not self.banColumns[key] then
			return false, "invalid identifier (or no user found)"
		end

		exports.GHMattiMySQL:QueryAsync("INSERT INTO `bans` SET "..key.."=@value", {
			["@value"] = value
		})
	end

	return true, key..":"..value
end
Export(Main, "Ban")

function Main:Unban(target)
	local key, value = ConvertTarget(target)
	if not key then
		return false, value
	end

	local targetQuery = ("`%s`=@%s"):format(key, key)
	local values = { ["@"..key] = value }

	-- Get bans.
	local result = exports.GHMattiMySQL:QueryResult("SELECT * FROM `bans` WHERE "..targetQuery, values)
	if not result[1] then
		return false, "not banned"
	end

	-- Unban query.
	exports.GHMattiMySQL:QueryAsync("UPDATE `bans` SET `unbanned`=1 WHERE "..targetQuery, values)

	-- Uncache bans.
	for _, info in ipairs(result) do
		Queue:RemoveBan(info)
	end
	
	return true, key..":"..value
end
Export(Main, "Unban")

function Main:Set(source, ...)
	local user = self.users[source]
	if user == nil then return false end

	return user:Set(...)
end
Export(Main, "Set")

function Main:Get(source, key)
	local user = self.users[source]
	if user == nil then return end

	return user[key]
end
Export(Main, "Get")

function Main:GetUser(source)
	return self.users[source]
end
Export(Main, "GetUser")

function Main:GetIdentifier(source, identifier)
	local identifiers = self:Get(source, "identifiers")
	return identifiers ~= nil and identifiers[identifier]
end
Export(Main, "GetIdentifier")

function Main:GetPlayer(id)
	return self.players[id]
end
Export(Main, "GetPlayer")

function Main:Mimic(endpoint, user)
	if not endpoint then return end

	self.mimics[endpoint] = user
	
	print(("'%s' will now mimic '%s'"):format(endpoint, user or "None"))
end

--[[ Thread ]]--
Citizen.CreateThread(function()
	while true do
		Main:UpdatePlayers()
		Citizen.Wait(5000)
	end
end)

--[[ Events ]]--
AddEventHandler(Main.event.."start", function()
	Main:Init()
end)

RegisterNetEvent(Main.event.."ready")
AddEventHandler(Main.event.."ready", function()
	local source = source
	Main:RegisterPlayer(source)
end)

AddEventHandler("playerDropped", function(reason)
	local source = source
	Main:DestroyPlayer(source)
end)