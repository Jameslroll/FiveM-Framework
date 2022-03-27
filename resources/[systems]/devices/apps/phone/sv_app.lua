Phone = {
	phones = {},
	players = {},
	calls = {},
	cache = {},
	areaCodes = { "273", "323" },
	tables = {
		phone = "phones",
		contacts = "phone_contacts",
		calls = "phone_calls",
	},
}

--[[ Functions: Main Events ]]--
function Main.events:Call(source, number)
	if not tonumber(number) or not PlayerUtil:CheckCooldown(source, 3.0, true, "call") then return end

	if Phone:Call(source, number) then
		return true
	end

	Phone:SaveCall(Phone.players[source], number)
end

function Main.events:CallAnswer(source)
	PlayerUtil:UpdateCooldown(source, "call")

	return Phone:Answer(source)
end

function Main.events:CallEnd(source)
	PlayerUtil:UpdateCooldown(source, "call")

	return Phone:Hangup(source)
end

function Main.events:LoadContacts(source)
	if not PlayerUtil:WaitForCooldown(source, 1.0, true, "load") then return {} end

	local characterId = Main.players[source]
	if not characterId then return {} end

	local result = exports.GHMattiMySQL:QueryResult("SELECT * FROM `"..Phone.tables.contacts.."` WHERE `character_id`=@characterId", {
		["@characterId"] = characterId,
	})

	return result
end

function Main.events:SaveContact(source, data)
	if type(data) ~= "table" then return end

	local avatar = data.avatar
	local color = data.color or 0
	local name = data.name
	local notes = data.notes
	local number = data.number

	if
		(type(name) ~= "string" or name:len() > 16) or
		(type(color) ~= "number" or color > 255 or color < 0) or
		(type(number) ~= "string" or not tonumber(number) or number:len() > 32) or
		(notes ~= nil and (type(notes) ~= "string" or notes:len() > 255)) or
		(avatar ~= nil and (type(avatar) ~= "string" or avatar:len() > 2048)) or
		not PlayerUtil:CheckCooldown(source, 3.0, true, "save")
	then
		return
	end

	if avatar and avatar:gsub("%s+", "") == "" then
		avatar = nil
	end

	if notes and notes:gsub("%s+", "") == "" then
		notes = nil
	end

	local characterId = Main.players[source]
	if not characterId then return end

	local setters = ("`name`=@name, `number`=@number, `color`=@color, `notes`=%s, `avatar`=%s"):format(
		notes and "@notes" or "NULL",
		avatar and "@avatar" or "NULL"
	)

	exports.GHMattiMySQL:QueryAsync("INSERT INTO `"..Phone.tables.contacts.."` SET `character_id`=@characterId, "..setters.." ON DUPLICATE KEY UPDATE "..setters, {
		["@characterId"] = characterId,
		["@avatar"] = avatar,
		["@color"] = color,
		["@name"] = name,
		["@notes"] = notes,
		["@number"] = number,
	})

	return true
end

function Main.events:DeleteContact(source, number)
	if not tonumber(number) or not PlayerUtil:CheckCooldown(source, 1.0, true, "save") then return end

	local characterId = Main.players[source]
	if not characterId then return end

	exports.GHMattiMySQL:QueryAsync("DELETE FROM `"..Phone.tables.contacts.."` WHERE `character_id`=@characterId AND `number`=@number", {
		["@characterId"] = characterId,
		["@number"] = number,
	})

	return true
end

function Main.events:FavoriteContact(source, number, value)
	if not tonumber(number) or not PlayerUtil:CheckCooldown(source, 0.1, true, "save") then return end

	local characterId = Main.players[source]
	if not characterId then return end

	exports.GHMattiMySQL:QueryAsync("UPDATE `"..Phone.tables.contacts.."` SET `favorite`=@value WHERE `character_id`=@characterId AND `number`=@number", {
		["@characterId"] = characterId,
		["@number"] = number,
		["@value"] = value == true,
	})

	return true
end

function Main.events:LoadRecentCalls(source, offset)
	if type(offset) ~= "number" or not PlayerUtil:CheckCooldown(source, 1.0, true, "load") then return end

	local number = Phone.players[source]
	if not number then return end

	return exports.GHMattiMySQL:QueryResult([[
		SELECT * FROM
			`]]..Phone.tables.calls..[[`
		WHERE
			`source_number`=@number OR
			`target_number`=@number
		ORDER BY time_stamp DESC
		LIMIT 10 OFFSET ]]..math.max(offset - 1, 0)..[[
	]], {
		["@number"] = number,
	})
end

--[[ Functions: Phone ]]--
function Phone:Init()
	WaitForTable("phones")

	-- Cache phone numbers.
	local result = exports.GHMattiMySQL:QueryResult("SELECT * FROM `"..Phone.tables.phone.."`")
	for k, row in ipairs(result) do
		self.phones[row.phone_number] = row.character_id
	end
end

function Phone:LoadPlayer(source, characterId)
	-- Load phone number.
	local phoneNumber = exports.GHMattiMySQL:QueryScalar("SELECT `phone_number` FROM `"..Phone.tables.phone.."` WHERE `character_id`=@characterId", {
		["@characterId"] = characterId,
	})

	-- Create phone number.
	if not phoneNumber then
		phoneNumber = self:GetRandomPhoneNumber()
		self.phones[phoneNumber] = characterId

		exports.GHMattiMySQL:QueryAsync("INSERT INTO `"..Phone.tables.phone.."` SET `phone_number`=@phoneNumber, `character_id`=@characterId", {
			["@phoneNumber"] = phoneNumber,
			["@characterId"] = characterId,
		})
	end

	-- Set character.
	exports.character:Set(source, "phone", phoneNumber)

	-- Assign phone number.
	self.players[source] = phoneNumber
end

function Phone:UnloadPlayer(source, characterId)
	-- Uncache player.
	self.players[source] = nil

	-- Set character.
	exports.character:Set(source, "phone", nil)

	-- Hang up.
	self:Hangup(source)
end

function Phone:GetRandomPhoneNumber()
	local phoneNumber

	repeat
		local areaCode = self.areaCodes[GetRandomIntInRange(1, #self.areaCodes)]
		local leadingNumbers = GetRandomText(7, Numbers)

		phoneNumber = areaCode..leadingNumbers
	until phoneNumber and not self.phones[phoneNumber]

	return phoneNumber
end

function Phone:Call(source, number)
	-- Check source busy.
	if self.calls[source] then return false end

	-- Get and check source number.
	local sourceNumber = self.players[source]
	if not sourceNumber or sourceNumber == number then return false end

	-- Get character from number.
	local characterId = self.phones[number]
	if not characterId then return false end

	-- Get target.
	local target = Main.characters[characterId]
	if not target then return false end

	-- Check busy.
	if self.calls[target] then return false end

	-- Log it.
	exports.log:Add({
		source = source,
		target = target,
		verb = "started",
		noun = "call",
	})

	-- Cache target players.
	self.calls[source] = target
	self.calls[target] = source
	self.cache[source] = os.clock()

	-- Ring target.
	TriggerClientEvent(Main.event.."receiveCall", target, sourceNumber)
	
	return true
end

function Phone:Hangup(source)
	-- Get target.
	local target = self.calls[source]
	if not target then return false end

	-- Get sender and time.
	local startTime = self.cache[source]
	local isSender = startTime ~= nil
	
	if not startTime then
		startTime = self.cache[target] or os.clock()
	end

	-- Save call.
	self:SaveCall(self.players[isSender and source or target], self.players[isSender and target or source], math.ceil(os.clock() - startTime))

	-- Log it.
	exports.log:Add({
		source = source,
		target = target,
		verb = "ended",
		noun = "call",
	})

	-- Clear cache.
	self.calls[source] = nil
	self.calls[target] = nil
	self.cache[isSender and source or target] = nil

	-- Inform target.
	TriggerClientEvent(Main.event.."endCall", source)
	TriggerClientEvent(Main.event.."endCall", target)

	-- Trigger events.
	TriggerEvent("phone:endCall", source, target)

	-- Return success.
	return true
end

function Phone:Answer(source)
	-- Get target.
	local target = self.calls[source]
	if not target then return false end

	-- Get numbers.
	local sourceNumber = self.players[source]
	local targetNumber = self.players[target]

	if not sourceNumber or not targetNumber then return false end

	-- Log it.
	exports.log:Add({
		source = source,
		target = target,
		verb = "answered",
		noun = "call",
	})

	-- Inform both.
	TriggerClientEvent(Main.event.."joinCall", target, sourceNumber)

	-- Trigger events.
	TriggerEvent("phone:joinCall", source, target)

	-- Return success.
	return targetNumber
end

function Phone:SaveCall(sourceNumber, targetNumber, duration)
	if not sourceNumber or not targetNumber then return end

	exports.GHMattiMySQL:QueryAsync("INSERT INTO `"..Phone.tables.calls.."` SET `source_number`=@source, `target_number`=@target, `duration`=@duration", {
		["@source"] = sourceNumber,
		["@target"] = targetNumber,
		["@duration"] = duration or 0,
	})
end

--[[ Hooks ]]--
Main:AddHook("LoadPlayer", function(self, ...)
	Phone:LoadPlayer(...)
end)

Main:AddHook("UnloadPlayer", function(self, ...)
	Phone:UnloadPlayer(...)
end)

--[[ Events: Net ]]--
RegisterNetEvent(Main.event.."call", function(snowflake, eventName, ...)
	local source = source

	if type(snowflake) ~= "number" or type(eventName) ~= "string" then return end

	Main:Call(source, snowflake, eventName, ...)
end)

--[[ Events ]]--
AddEventHandler(Main.event.."start", function()
	Phone:Init()
end)