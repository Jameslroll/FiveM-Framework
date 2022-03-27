Main = Main or {}
Main.events = {}
Main.players = {}
Main.characters = {}
Main.modules = {}

--[[ Functions ]]--
function Main:Init()
	-- Create phones table.
	WaitForTable("characters")

	for _, path in ipairs({
		"sql/phones.sql",
		"sql/phone_contacts.sql",
		"sql/phone_calls.sql",
		"sql/phone_messages.sql",
		"sql/phone_conversations.sql",
	}) do
		RunQuery(path)
	end

	WaitForTable("phone_messages")
	WaitForTable("phone_conversations")

	RunQuery("sql/foreign_keys.sql")
end

function Main:Call(source, snowflake, eventName, ...)
	local func = self.events[eventName]
	local args = {...}
	local result, retval

	if func then
		result, retval = pcall(function()
			return { func(Main, source, table.unpack(args)) }
		end)

		if not result then
			print(("[%s] '%s' callback error (%s)"):format(source, eventName, retval))
		end
	end

	TriggerClientEvent(self.event.."fetch-"..snowflake, source, result and table.unpack(retval))
end

function Main:CachePlayer(source, characterId)
	self.players[source] = characterId
	self.characters[characterId] = source

	self:InvokeHook("LoadPlayer", source, characterId)
end

function Main:UncachePlayer(source)
	local characterId = self.players[source]
	if not characterId then return end

	self.players[source] = nil
	self.characters[characterId] = nil

	self:InvokeHook("UnloadPlayer", source, characterId)
end

--[[ Events ]]--
AddEventHandler(Main.event.."start", function()
	Main:Init()
end)

AddEventHandler("character:selected", function(source, character)
	if not character then
		Main:UncachePlayer(source)
		return
	end

	Main:CachePlayer(source, character.id)
end)

AddEventHandler("playerDropped", function(reason)
	local source = source
	Main:UncachePlayer(source)
end)

--[[ Events: Net ]]--
RegisterNetEvent(Main.event.."ready", function()
	local source = source
	if Main.players[source] then
		return
	end

	local characterId = exports.character:Get(source, "id")
	if characterId then
		Main:CachePlayer(source, characterId)
	end
end)