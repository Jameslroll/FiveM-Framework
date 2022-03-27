Client = {}
Client.__index = Client

function Client:Create(source, id)
	-- Load characters.
	local result = exports.GHMattiMySQL:QueryResult([[
		SELECT * FROM `characters` WHERE user_id=@userId
	]], {
		["@userId"] = id,
	})

	-- Convert characters.
	local characters = {}

	for index, data in ipairs(result) do
		local character = Character:Create(source, data)
		characters[tostring(data.id)] = character
	end

	-- Create metatable.
	local client = setmetatable({
		characters = characters,
		lastAction = os.clock(),
		lastUpdate = os.clock(),
		source = source,
	}, self)

	-- Return player.
	return client
end

function Client:Destroy()
	for sid, character in pairs(self.characters) do
		Main.ids[character.id] = nil
	end

	Main.players[self.source] = nil
end

function Client:AddCharacter(data)
	-- Check cooldown.
	if self:GetTimeSinceLastAction() < 6.0 then
		return false, "Slow down!"
	end

	self:UpdateLastAction()

	-- Check data.
	if type(data) ~= "table" then
		return false, "No data"
	end

	-- Get user id.
	local userId = exports.user:Get(source, "id")
	if not userId then
		return false, "User not loaded"
	end

	-- Validate data.
	local isValid, validateResult = Main:ValidateData(data)
	if not isValid then
		return false, validateResult
	end

	-- Invalid date.
	if not IsDateValid(data.month, data.day, data.year) then
		return false, "Invalid date"
	end

	-- Create character.
	local character = exports.GHMattiMySQL:QueryResult([[
		INSERT INTO `characters` SET
			user_id=@userId,
			first_name=@firstName,
			last_name=@lastName,
			gender=@gender,
			dob=@dob,
			biography=@biography;
		SELECT * FROM `characters` WHERE id=LAST_INSERT_ID() LIMIT 1;
	]], {
		["@userId"] = userId,
		["@firstName"] = data.firstName,
		["@lastName"] = data.lastName,
		["@gender"] = data.gender,
		["@dob"] = ("%s-%s-%s"):format(data.year, data.month, data.day),
		["@biography"] = data.biography,
	})[1]

	if not character then
		return false, "Database error"
	end

	character = Character:Create(self.source, character)
	
	self.characters[tostring(character.id)] = character

	return true, character
end

function Client:GetTimeSinceLastAction()
	return os.clock() - self.lastAction
end

function Client:UpdateLastAction()
	self.lastAction = os.clock()
end

function Client:GetCharacter(id)
	if not id then return end

	return self.characters[tostring(id)]
end

function Client:GetActiveCharacter()
	return self:GetCharacter(self.activeCharacter)
end

function Client:SelectCharacter(id)
	if self:GetTimeSinceLastAction() < 2.0 then return end
	self:UpdateLastAction()

	local character = (id and self:GetCharacter(id)) or nil
	local wasActive = id and Main.responses[id] ~= nil or nil
	self.activeCharacter = tonumber(id)

	-- Events.
	TriggerEvent(Main.event.."selected", self.source, character, wasActive)
	TriggerClientEvent(Main.event.."select", self.source, id, wasActive)

	-- Logging.
	exports.log:Add({
		source = self.source,
		verb = character and "selected" or "switched",
		noun = "character",
		extra = character and ("%s %s (%s)"):format(character.first_name, character.last_name, id)
	})
end