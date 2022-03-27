Outfits = {
	cooldowns = {},
	maxLength = 64,
}

function Outfits:Init()
	self:LoadDatabase()
end

function Outfits:LoadDatabase()
	WaitForTable("characters")

	for _, path in ipairs({
		"sql/outfits.sql",
	}) do
		RunQuery(path)
	end
end

function Outfits:Save(source, name)
	-- Check cooldown.
	local cooldown = self.cooldowns[source]
	if cooldown and os.clock() - cooldown < 1.0 then
		return false, "Too fast"
	end

	self.cooldowns[source] = os.clock()

	-- Check name.
	if type(name) ~= "string" then
		return false, "Invalid name"
	elseif name:len() > self.maxLength then
		return false, "Name too long"
	end

	-- Check character.
	local id = exports.character:Get(source, "id")
	if not id then
		return false, "No character"
	end

	-- Get character.
	local data = exports.character:Get(source, "appearance")
	if not data then
		return false, "No appearance"
	end

	-- Save outfit.
	exports.GHMattiMySQL:QueryAsync([[
		INSERT INTO `outfits` SET
			`character_id`=@id, `name`=@name, `appearance`=@data
		ON DUPLICATE KEY UPDATE
			`character_id`=@id, `name`=@name, `appearance`=@data
	]], {
		["@id"] = id,
		["@name"] = name,
		["@data"] = json.encode(data),
	})

	return true
end

function Outfits:Select(source, name)
	-- Check cooldown.
	local cooldown = self.cooldowns[source]
	if cooldown and os.clock() - cooldown < 1.0 then
		return false, "Too fast"
	end

	self.cooldowns[source] = os.clock()

	-- Check name.
	if type(name) ~= "string" then
		return false, "Invalid name"
	elseif name:len() > self.maxLength then
		return false, "Name too long"
	end

	-- Check character.
	local id = exports.character:Get(source, "id")
	if not id then
		return false, "No character"
	end

	-- Get data.
	local data = exports.GHMattiMySQL:QueryResult("SELECT `appearance` FROM `outfits` WHERE `character_id`=@id AND `name`=@name", {
		["@id"] = id,
		["@name"] = name,
	})[1]

	-- Decode data.
	if data and data.appearance then
		data = json.decode(data.appearance)
	else
		data = nil
	end
	
	-- Check data.
	if not data then
		return false, "Outfit does not exist"
	end

	-- Update character.
	exports.character:Set(source, "appearance", data)

	-- Success!
	return true
end

function Outfits:Delete(source, name)
	-- Check cooldown.
	local cooldown = self.cooldowns[source]
	if cooldown and os.clock() - cooldown < 1.0 then
		return false, "Too fast"
	end

	self.cooldowns[source] = os.clock()

	-- Check name.
	if type(name) ~= "string" then
		return false, "Invalid name"
	elseif name:len() > self.maxLength then
		return false, "Name too long"
	end

	-- Check character.
	local id = exports.character:Get(source, "id")
	if not id then
		return false, "No character"
	end

	-- Delete.
	exports.GHMattiMySQL:QueryAsync("DELETE FROM `outfits` WHERE `character_id`=@id AND `name`=@name", {
		["@id"] = id,
		["@name"] = name,
	})

	-- Success!
	return true
end

--[[ Events ]]--
AddEventHandler("customization:start", function()
	Outfits:Init()
end)

AddEventHandler("playerDropped", function(reason)
	local source = source
	Outfits.cooldowns[source] = nil
end)

--[[ Events: Net ]]--
RegisterNetEvent("customization:requestOutfits", function()
	local source = source

	-- Check cooldown.
	local cooldown = Outfits.cooldowns[source]
	if cooldown and os.clock() - cooldown < 1.0 then return end

	Outfits.cooldowns[source] = os.clock()

	-- Get character id.
	local id = exports.character:Get(source, "id")
	if not id then return end

	-- Load outfits.
	local result = exports.GHMattiMySQL:QueryResult("SELECT `name`, `time_stamp` FROM `outfits` WHERE `character_id`=@id", {
		["@id"] = id
	})

	-- Convert result.
	for k, v in ipairs(result) do
		v.age = os.time() - (v.time_stamp or 0) / 1000
	end

	-- Send outfits.
	TriggerClientEvent("customization:receiveOutfits", source, result)
end)

RegisterNetEvent("customization:selectOutfit", function(name)
	local source = source

	name = name:lower()

	local retval, result = Outfits:Select(source, name)

	TriggerClientEvent("customization:switchOutfit", source, name, retval, result)

	if retval then
		exports.log:Add({
			source = source,
			verb = "switched",
			noun = "outfit",
			extra = name,
		})
	end
end)

RegisterNetEvent("customization:deleteOutfit", function(name)
	local source = source

	name = name:lower()

	local retval, result = Outfits:Delete(source, name)

	TriggerClientEvent("customization:deletedOutfit", source, name, retval, result)
	
	if retval then
		exports.log:Add({
			source = source,
			verb = "deleted",
			noun = "outfit",
			extra = name,
		})
	end
end)

RegisterNetEvent("customization:saveOutfit", function(name, data)
	local source = source

	name = name:lower()

	local retval, result = Outfits:Save(source, name)

	TriggerClientEvent("ui:notify", source, {
		color = retval and "green" or "red",
		message = retval and ("Saved outfit '%s'"):format(name) or result or "Error"
	})

	if retval then
		exports.log:Add({
			source = source,
			verb = "saved",
			noun = "outfit",
			extra = name,
		})
	end
end)