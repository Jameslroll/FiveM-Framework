Main.tableColumns = { "appearance", "features", "health" }
Main.players = {}
Main.responses = {}

function Main:Init()
	self:LoadDatabase()

	-- Modules:LoadDatabase()

	Citizen.Wait(0)

	if GetResourceState("user") == "started" then
		for i = 1, GetNumPlayerIndices() do
			local player = tonumber(GetPlayerFromIndex(i - 1))
			local id = exports.user:Get(player, "id")

			if player and id then
				self:RegisterPlayer(player, id)
			end
		end

		self:RestoreCache()
	end
end

function Main:LoadDatabase()
	WaitForTable("users")
	WaitForTable("bans")

	for _, path in ipairs({
		"sql/characters.sql",
	}) do
		exports.GHMattiMySQL:Query(LoadQuery(path))
	end
	
	self.columns = DescribeTable("characters")
end

function Main:Update()
	for source, client in pairs(self.players) do
		local clock = os.clock()
		local delta = (client.lastUpdate and clock - client.lastUpdate) or 0.0
		client.lastUpdate = clock
		
		local character = client:GetActiveCharacter()
		if not character then goto skip end

		local ped = GetPlayerPed(source)
		if not ped or not DoesEntityExist(ped) then goto skip end

		local coords = GetEntityCoords(ped)
		if not coords or #(coords - vector3(0.0, 0.0, 0.0)) < 1.0 then goto skip end
		
		character:Set({
			["time_played"] = (character.time_played or 0.0) + delta,
			["pos_x"] = coords.x,
			["pos_y"] = coords.y,
			["pos_z"] = coords.z,
		})

		self.responses[character.id] = clock

		::skip::
	end

	local clock = os.clock()
	for characterId, lastUpdate in pairs(self.responses) do
		if clock - lastUpdate > 60.0 * 15.0 then
			self.responses[characterId] = nil
		end
	end
end

function Main:RegisterPlayer(source, id)
	if self.players[source] then return end

	-- Create player.
	local player = Client:Create(source, id)

	-- Sync characters.
	TriggerClientEvent(self.event.."load", source, player.characters)

	-- Cache player.
	self.players[source] = player
end

function Main:GetPlayer(source)
	return self.players[source]
end
Export(Main, "GetPlayer")

function Main:CreateCharacter(source, data)
	local client = Main:GetPlayer(source)
	if not client then
		return false, "Player not loaded"
	end

	return client:AddCharacter(data)
end
Export(Main, "CreateCharacter")

function Main:ValidateData(data)
	-- Check fields.
	local fields = { "firstName", "lastName", "dob", "biography", "gender", "origin" }
	for _, field in ipairs(fields) do
		local value = data[field]
		if value == nil or type(value) ~= "string" then
			return false, "Missing field '"..field.."'"
		end
	end

	-- Check genders.
	local genders = {
		["Male"] = true,
		["Female"] = true,
		["Non-binary"] = true,
	}

	if not genders[data.gender] then
		return false, "Invalid gender"
	end

	-- Check first and last name.
	if not CheckName(data.firstName) then
		return false, "Invalid first name"
	end

	if not CheckName(data.lastName) then
		return false, "Invalid last name"
	end

	-- Format dob (date of birth).
	local dob = data.dob
	local year, month, day = dob:match("(%d+)/(%d+)/(%d+)")

	data.year = tonumber(year)
	data.month = tonumber(month)
	data.day = tonumber(day)
	
	-- Check dob are numbers.
	if not data.year or not data.month or not data.day then
		return false, "Invalid date format"
	end

	-- Check dob range.
	if data.year < 1900 or data.year > 2003 then
		return false, "Invalid date range"
	end
	
	-- Format biography.
	data.biography = data.biography:gsub("[\\]", ""):gsub("%s+", " ")

	-- Check biography.
	local bioLen = data.biography:len()

	if bioLen < 256 then
		return false, "Biography too short"
	elseif bioLen > 65535 then
		return false, "Biography too long"
	end

	-- Validate success.
	return true
end
Export(Main, "ValidateData")

function Main:SelectCharacter(source, id)
	local client = self.players[source]
	if client == nil then return end
	
	client:SelectCharacter(id)
end
Export(Main, "SelectCharacter")

function Main:GetCharacter(source)
	local client = self:GetPlayer(source)
	if client == nil then return end

	return client:GetActiveCharacter()
end
Export(Main, "GetCharacter")

function Main:IsSelected(source)
	local character = self:GetCharacter(source)
	
	return character ~= nil
end
Export(Main, "IsSelected")

function Main:Get(source, key)
	local character = self:GetCharacter(source)
	if character == nil then return end

	return character:Get(key)
end
Export(Main, "Get")

function Main:Set(source, key, value)
	local character = self:GetCharacter(source)
	if character == nil then return end

	return character:Set(key, value)
end
Export(Main, "Set")

function Main:GetName(source)
	local character = self:GetCharacter(source)
	if character == nil then return end

	return character:GetName()
end
Export(Main, "GetName")

function Main:GetActiveCharacters()
	local characters = {}

	for source, client in pairs(self.players) do
		if client.activeCharacter then
			characters[source] = client:GetActiveCharacter()
		end
	end

	return characters
end
Export(Main, "GetActiveCharacters")

function Main:Cache()
	if GetResourceState("cache") ~= "started" then return end

	local activeCharacters = {}
	for source, client in pairs(self.players) do
		if client.activeCharacter then
			activeCharacters[source] = client.activeCharacter
		end
	end

	exports.cache:Set("Character", activeCharacters)
end

function Main:RestoreCache()
	if GetResourceState("cache") ~= "started" then return end

	local activeCharacters = exports.cache:Get("Character")
	if not activeCharacters then return end

	for source, client in pairs(self.players) do
		client.activeCharacter = activeCharacters[source]
	end

	exports.cache:Set("Character", nil)
end

--[[ Events ]]--
AddEventHandler("user:created", function(source, user)
	Main:RegisterPlayer(source, user.id)
end)

AddEventHandler(Main.event.."start", function()
	Main:Init()
end)

AddEventHandler(Main.event.."stop", function()
	Main:Cache()
end)

AddEventHandler("playerDropped", function(reason)
	local source = source
	local client = Main:GetPlayer(source)

	if client then
		client:Destroy()
	end
end)

--[[ Events: Net ]]--
RegisterNetEvent(Main.event.."create", function(data)
	local source = source
	local success, result = Main:CreateCharacter(source, data)

	TriggerClientEvent(Main.event.."created", source, success, result)
end)

RegisterNetEvent(Main.event.."delete", function(id)
	local source = source
	-- local character = Main:GetCharacterById(id)
end)

RegisterNetEvent(Main.event.."select", function(id)
	local source = source
	if id ~= nil and type(id) ~= "number" then return end

	Main:SelectCharacter(source, id)
end)

--[[ Threads ]]--
Citizen.CreateThread(function()
	while true do
		Main:Update()
		Citizen.Wait(5000)
	end
end)

--[[ Commands ]]--
RegisterCommand("character:debug", function(source, args, command)
	if source ~= 0 then return end

	-- Debug everything about a specific character.
	local target = tonumber(args[1])
	if target then
		local character = Main.ids[target]
		if character then
			print("Character", json.encode(character))
		end
		return
	end

	-- Debug players/characters currently loaded.
	print("Players (Source | Character ID | Character)")

	for k, v in pairs(Main.players) do
		for _k, _v in pairs(v.characters) do
			print(k, _k, _v)
		end
	end

	print("Ids (Character ID | Character)")

	for k, v in pairs(Main.ids) do
		print(k, v)
	end
end, true)