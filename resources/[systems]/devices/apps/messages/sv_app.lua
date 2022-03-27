Messages = {
	tables = {
		conversations = "phone_conversations",
		messages = "phone_messages",
	},
}

--[[ Functions: Messages ]]--
function Messages:GetConversationId(sourceCharacterId, targetCharacterId)
	return exports.GHMattiMySQL:QueryScalar([[
		SELECT * FROM
			`]]..Messages.tables.conversations..[[`
		WHERE
			(`source_character_id`=@sourceCharacterId AND `target_character_id`=@targetCharacterId) OR
			(`source_character_id`=@targetCharacterId AND `target_character_id`=@sourceCharacterId)
		LIMIT 1
	]], {
		["@sourceCharacterId"] = sourceCharacterId,
		["@targetCharacterId"] = targetCharacterId,
	})
end

function Messages:Send(sourceCharacterId, targetCharacterId, scope, text)
	-- Setup source/target query values.
	local values = {
		["@sourceCharacterId"] = sourceCharacterId,
		["@targetCharacterId"] = targetCharacterId,
		["@scope"] = scope,
		["@text"] = text,
	}

	-- Get the conversation id.
	local conversationId = nil
	if targetCharacterId then
		conversationId = self:GetConversationId(sourceCharacterId, targetCharacterId)

		-- Create the conversation if there isn't an id.
		if not conversationId then
			conversationId = exports.GHMattiMySQL:QueryScalar([[
				INSERT INTO
					`]]..Messages.tables.conversations..[[`
				SET
					`source_character_id`=@sourceCharacterId,
					`target_character_id`=@targetCharacterId;
				
				SELECT LAST_INSERT_ID();
			]], values)
	
			if not conversationId then return false end
		end

		-- Update the conversation id values.
		values["@conversationId"] = conversationId
	end

	local query = [[
		INSERT INTO
			`]]..Messages.tables.messages..[[`
		SET
			`conversation_id`=@conversationId,
			`source_character_id`=@sourceCharacterId,
			]]..(conversationId and "`target_character_id`=@targetCharacterId," or "")..[[
			`scope`=@scope,
			`text`=@text
		;
	]]

	if conversationId then
		query = query..[[
			UPDATE
				`]]..Messages.tables.conversations..[[`
			SET
				`last_message_id`=(SELECT LAST_INSERT_ID())
			WHERE
				`id`=@conversationId
			;
		]]
	end

	-- Create the message and update the conversation.
	exports.GHMattiMySQL:QueryAsync(query, values)

	-- Inform the target they were sent a message.
	local target = targetCharacterId and Main.characters[targetCharacterId]
	if target then
		local source = sourceCharacterId and Main.characters[sourceCharacterId]
		local sourceNumber = (
			(source and Phone.players[source]) or
			(sourceCharacterId and exports.GHMattiMySQL:QueryScalar("SELECT `phone_number` FROM `"..Phone.tables.phone.."` WHERE character_id=@characterId LIMIT 1", {
				["@characterId"] = sourceCharacterId,
			})) or
			"Unknown"
		)

		TriggerClientEvent(Main.event.."receiveMessage", target, sourceNumber, scope, text)
	end

	return true
end

--[[ Functions: Main ]]--
function Main.events:LoadConversations(source)
	if not PlayerUtil:WaitForCooldown(source, 2.0, true, "load") then return end

	local characterId = Main.players[source]
	if not characterId then return end

	local result = exports.GHMattiMySQL:QueryResult(([[
		SELECT
			messages.source_character_id,
			messages.target_character_id,
			messages.time_stamp,
			SUBSTRING(messages.text, 1, 128) as 'text',
			phones.phone_number AS 'number'
		FROM
			%s AS conversations
		LEFT JOIN %s AS messages ON
			messages.id=conversations.last_message_id
		LEFT JOIN %s AS phones ON
			phones.character_id=IF(
				messages.source_character_id=@characterId,
				messages.target_character_id,
				messages.source_character_id
			)
		WHERE
			conversations.source_character_id=@characterId OR
			conversations.target_character_id=@characterId
		ORDER BY messages.time_stamp DESC
	]]):format(
		Messages.tables.conversations,
		Messages.tables.messages,
		Phone.tables.phone
	), {
		["@characterId"] = characterId,
	})

	return result
end

function Main.events:LoadMessages(source, number, offset)
	if not tonumber(number) or type(offset) ~= "number" or not PlayerUtil:WaitForCooldown(source, 1.0, true, "load") then return end

	local characterId = Main.players[source]
	if not characterId then return end

	local targetCharacterId = Phone.phones[number]
	if not targetCharacterId then return end

	local conversationId = Messages:GetConversationId(characterId, targetCharacterId)
	if not conversationId then return end

	local result = exports.GHMattiMySQL:QueryResult(([[
		SELECT
			messages.*,
			source_character_id=@characterId AS 'sent'
		FROM
			%s AS messages
		WHERE
			`conversation_id`=@conversationId
		ORDER BY id DESC
		LIMIT 30 OFFSET @offset
	]]):format(
		Messages.tables.messages
	), {
		["@conversationId"] = conversationId,
		["@characterId"] = characterId,
		["@offset"] = offset,
	})

	return result
end

function Main.events:SendMessage(source, targetNumber, text)
	if not tonumber(targetNumber) or type(text) ~= "string" or not PlayerUtil:CheckCooldown(source, 3.0, true, "message") then
		return false
	end

	-- Get character ids.
	local sourceCharacterId = Main.players[source]
	if not sourceCharacterId then return false end

	local targetCharacterId = Phone.phones[targetNumber]
	if not targetCharacterId then return false end
	
	-- Send the message.
	if Messages:Send(sourceCharacterId, targetCharacterId, "text", text) then
		-- Log it.
		exports.log:Add({
			source = source,
			verb = "sent",
			noun = "message to",
			extra = targetNumber,
		})

		return true
	else
		return false
	end
end

-- Citizen.CreateThread(function()
-- 	local messages = {
-- 		"Wow, that's pretty gay. And that's okay.",
-- 		"What's up cutie?",
-- 		"Looking pretty good.",
-- 		"Do you have my money yet?",
-- 		"I'm going to come over there and beat your ass until it's raw.",
-- 		"Did you do the thing that you needed to do with that thing?",
-- 	}

-- 	for i = 1, 20000 do
-- 		local r = GetRandomFloatInRange(0.0, 1.0) > 0.5
-- 		local source = r and 1 or GetRandomIntInRange(2, 6)
-- 		local target = r and GetRandomIntInRange(2, 6) or 1
-- 		local msg = messages[GetRandomIntInRange(1, #messages)]

-- 		print(Messages:Send(source, target, "text", msg))
-- 	end
-- end)

-- Citizen.CreateThread(function()
-- 	Citizen.Wait(5000)

-- 	Messages:Send(6, 1, "text", "Hey, this is a test. A pretty cool test, might I add. A long test, too. Wow. Pog.")

-- 	Citizen.Wait(500)

-- 	for i = 1, 3 do
-- 		Messages:Send(4, 1, "text", "It's Billy. We need to talk.")
-- 		Citizen.Wait(200)
-- 	end
-- end)