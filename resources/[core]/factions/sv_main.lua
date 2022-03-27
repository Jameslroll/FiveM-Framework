Main = {
	event = GetCurrentResourceName()..":",
	table = "factions",
	players = {},
	factions = {},
}

function Main:Init()
	-- Database.
	WaitForTable("characters")
	RunQuery("sql/factions.sql")

	-- Update players.
	for source in GetActivePlayers() do
		local characterId = exports.character:Get(source, "id")
		if characterId then
			self:LoadPlayer(source, characterId)
		end
	end

	-- Test.
	-- Citizen.SetTimeout(1000, function()
	-- 	print("JOIN", Main:JoinFaction(1, "test", "a"))
	-- 	print("JOIN", Main:JoinFaction(1, "test", "b"))
	-- 	print("JOIN", Main:JoinFaction(1, "test", "c"))

	-- 	print(json.encode(Main.players))
	-- 	print(json.encode(Main.factions))
	-- end)

	-- Citizen.SetTimeout(2000, function()
	-- 	print("LEAVE", Main:LeaveFaction(1, "test", "a"))

	-- 	print(json.encode(Main.players))
	-- 	print(json.encode(Main.factions))
	-- end)

	-- Citizen.SetTimeout(1500, function()
	-- 	print(self:Has(1, "test", "a"))
	-- end)
end

function Main:LoadPlayer(source, characterId)
	local factions = exports.GHMattiMySQL:QueryResult(([[
		SELECT
			`name`,
			`group`,
			`level`,
			`fields`
		FROM %s
		WHERE `character_id`=@characterId
	]]):format(self.table), {
		["@characterId"] = characterId,
	})

	self.players[source] = {}

	for k, info in ipairs(factions) do
		local name = info.name
		if not name then return end

		local faction = self.factions[name]
		if not faction then
			faction = Faction:Create(name)
		end

		faction:AddPlayer(source, info.group, info.level, info.fields and json.decode(info.fields))
	end

	TriggerEvent(self.event.."loaded", source, characterId, factions)
	TriggerClientEvent(self.event.."load", source, factions)
end

function Main:UnloadPlayer(source)
	local factions = self.players[source]
	if not factions then return end

	for name, _ in pairs(factions) do
		local faction = self.factions[name]
		if faction then
			faction:RemovePlayer(source)
		end
	end

	self.players[source] = nil
end

function Main:JoinFaction(source, name, group, level, fields)
	if type(name) ~= "string" or (group ~= nil and type(group) ~= "string") or (fields ~= nil and type(fields) ~= "table") then return false end

	local characterId = exports.character:Get(source, "id")
	if not characterId then return false end

	local faction = self.factions[name]
	if not faction then
		faction = Faction:Create(name)
	end

	level = tonumber(level) or 0

	if faction:AddPlayer(source, group, level, fields) then
		exports.GHMattiMySQL:QueryAsync(([[
			INSERT INTO %s
			SET
				`character_id`=@characterId,
				`name`=@name,
				`level`=@level,
				`group`=%s,
				`fields`=%s
		]]):format(
			self.table,
			group and group ~= "" and "@group" or "NULL",
			fields and "@fields" or "NULL"
		), {
			["@characterId"] = characterId,
			["@name"] = name,
			["@group"] = group,
			["@fields"] = fields and json.encode(fields),
			["@level"] = level,
		})

		TriggerEvent(Main.event.."join", source, name, group, level, fields)
		TriggerClientEvent(Main.event.."join", source, name, group, level, fields)

		return true
	else
		return false
	end
end

function Main:LeaveFaction(source, name, group)
	if type(name) ~= "string" or (group ~= nil and type(group) ~= "string") then return false end

	local characterId = exports.character:Get(source, "id")
	if not characterId then return false end

	local faction = self.factions[name]
	if not faction then return false end

	if faction:RemovePlayer(source, group) then
		exports.GHMattiMySQL:QueryAsync(([[
			DELETE FROM %s
			WHERE
				`character_id`=@characterId AND
				`name`=@name AND
				%s
		]]):format(
			self.table,
			group and group ~= "" and "`group`=@group" or "`group` IS NULL"
		), {
			["@characterId"] = characterId,
			["@name"] = name,
			["@group"] = group,
		})

		TriggerEvent(Main.event.."leave", source, name, group)
		TriggerClientEvent(Main.event.."leave", source, name, group)

		return true
	else
		return false
	end
end

function Main:UpdateFaction(source, name, group, key, value, isCharacter)
	if type(name) ~= "string" or (group ~= nil and type(group) ~= "string") then return false end

	local characterId = isCharacter and source or exports.character:Get(source, "id")
	if not characterId then return false end

	local faction = self.factions[name]
	if not faction then return false end

	if faction:UpdatePlayer(source, group, key, value) then
		local isLevel = key == "level"
		local info = not isLevel and faction:GetPlayer(source, group)

		exports.GHMattiMySQL:QueryAsync(([[
			UPDATE %s
			SET
				%s
			WHERE
				`character_id`=@characterId AND
				`name`=@name AND
				%s
		]]):format(
			self.table,
			(isLevel and "level=@level" or "fields=@fields")..(isLevel and ", update_time=current_timestamp()" or ""),
			group and group ~= "" and "`group`=@group" or "`group` IS NULL"
		), {
			["@characterId"] = characterId,
			["@name"] = name,
			["@group"] = group,
			["@level"] = isLevel and value,
			["@fields"] = info and json.encode(info.fields or {}),
		})

		TriggerEvent(Main.event.."update", source, name, group, key, value)
		TriggerClientEvent(Main.event.."update", source, name, group, key, value)

		return true
	else
		return false
	end
end

function Main:Has(...)
	return self:Get(...) ~= nil
end

function Main:Get(source, name, groupName)
	groupName = groupName or ""

	local faction = self.factions[name]
	if not faction then return end

	local group = faction.groups[groupName]
	if not group then return end

	return group[source]
end

--[[ Exports ]]--
for k, v in pairs(Main) do
	if type(v) == "function" then
		exports(k, function(...)
			return Main[k](Main, ...)
		end)
	end
end

--[[ Events ]]--
AddEventHandler(Main.event.."start", function()
	Main:Init()
end)

AddEventHandler("playerDropped", function(reason)
	local source = source
	Main:UnloadPlayer(source)
end)

AddEventHandler("character:selected", function(source, character, wasActive)
	if character then
		Main:LoadPlayer(source, character.id)
	else
		Main:UnloadPlayer(source)
	end
end)