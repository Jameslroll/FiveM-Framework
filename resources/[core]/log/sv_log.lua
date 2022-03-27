Main = {
	players = {},
	event = GetCurrentResourceName()..":",
}

--[[ Functions ]]--
function Main:Init()
	-- Load database.
	self:LoadDatabase()

	-- Update current players.
	for i = 1, GetNumPlayerIndices() do
		local player = tonumber(GetPlayerFromIndex(i - 1))
		self:RegisterPlayer(player, exports.user:Get(player, "id"), true)
	end
end

function Main:LoadDatabase()
	WaitForTable("users")

	for _, path in ipairs({
		"sql/logs.sql",
	}) do
		exports.GHMattiMySQL:Query(LoadQuery(path))
	end
end

function Main:Update()
	for player, info in pairs(self.players) do
		info.spam = 0
	end
end

function Main:Add(data)
	if type(data) ~= "table" then return end

	-- Get source.
	local sourceInfo = nil
	local source = data.source
	local isServer = false

	if source == 0 then
		source = nil
		isServer = true

		data.source = nil
	elseif source ~= nil then
		sourceInfo = self.players[source]
		if sourceInfo == nil then return end

		data.source = sourceInfo.id
	end

	-- Get target.
	local targetInfo = nil
	local target = data.target

	if target ~= nil then
		targetInfo = self.players[target]
		if targetInfo == nil then return end
		
		data.target = targetInfo.id
	end

	-- Anti-spam check.
	if source ~= nil and not data.ignoreAntispam then
		sourceInfo.spam = sourceInfo.spam + 1
		if sourceInfo.spam >= 60 then
			DropPlayer(source, "anti-spam")
			return
		end
	end

	data.ignoreAntispam = nil

	-- Switch source and targets.
	if data.switch then
		local _source = data.source
		data.source = data.target
		data.target = _source

		_source = source
		source = target
		target = source
	end

	data.switch = nil

	-- Get webhook.
	local channel = data.channel or "general"
	if data.channel then
		data.channel = nil
	end

	-- Update coordinates.
	if source ~= nil then
		local ped = GetPlayerPed(source)
		if DoesEntityExist(ped) then
			local coords = GetEntityCoords(ped)

			data.pos_x = coords.x
			data.pos_y = coords.y
			data.pos_z = coords.z
		end
	end

	-- Set resource.
	data.resource = data.resource or GetInvokingResource()

	-- Insert into the table.
	exports.GHMattiMySQL:Insert("logs", { data })

	-- Trigger event.
	TriggerEvent("log", data)

	-- Format text.
	if channel ~= "none" then
		local text = ""

		if data.source or isServer then
			text = AppendText(text, isServer and "Server" or self:GetPlayerText(source))
		end

		if data.verb then
			text = AppendText(text, data.verb)
		end
		
		if data.noun then
			text = AppendText(text, data.noun)
		end

		if data.target then
			if source == target then
				text = AppendText(text, "themself")
			else
				text = AppendText(text, self:GetPlayerText(target))
			end
		end

		if data.extra then
			local extra = tostring(data.extra)
			if text ~= "" then
				text = text..", "
			end
			text = text..data.extra
		end

		-- Print the message.
		print(("[%s] %s"):format(data.resource, text))

		-- Send webhook.
		local webhook = GetConvar(channel.."_logs", "")
		if webhook ~= "" then
			PerformHttpRequest(webhook, function(err, text, headers)
			end, "POST", json.encode({
				username = "Log",
				content = text,
				tts = false,
			}), { ["Content-Type"] = "application/json" })
		end
	end
end

function Main:RegisterPlayer(source, id, softLog)
	-- Check user id.
	if type(id) ~= "number" then return false end

	-- Check registered already.
	if self.players[source] ~= nil then return false end

	-- Get name.
	local name = exports.user:GetIdentifier(source, "name")
	if not name then return false end

	-- Get steam.
	local steam = exports.user:GetIdentifier(source, "steam")
	if not steam then return false end

	-- Get player text.
	local text = "["..tostring(source).."] "..tostring(name).."@"..tostring(steam)
	local text = ("[%s:%s] %s@%s"):format(source, id, name, steam)

	-- Cache player.
	self.players[source] = {
		id = id,
		spam = 0,
		text = text,
	}

	-- Log.
	if not softLog then
		self:Add({
			source = source,
			verb = "connected",
			resource = "log",
		})
	end

	-- Return success.
	return true
end

function Main:DestroyPlayer(source, reason)
	-- Get player.
	local player = self.players[source]
	if player == nil then return false end

	-- Log.
	if reason then
		self:Add({
			source = source,
			verb = "disconnected",
			resource = "log",
			extra = reason,
		})
	end
	
	-- Uncache player.
	self.players[source] = nil

	-- Return success.
	return true
end

function Main:GetPlayerText(source)
	local player = self.players[source]
	if player == nil then return "" end

	return player.text
end

--[[ Events ]]--
AddEventHandler(Main.event.."start", function()
	Main:Init()
end)

AddEventHandler("user:created", function(source, user)
	Main:RegisterPlayer(source, user.id)
end)

AddEventHandler("playerDropped", function(reason)
	local source = source
	Main:DestroyPlayer(source, reason)
end)

--[[ Threads ]]--
Citizen.CreateThread(function()
	for k, v in pairs(Main) do
		if type(v) == "function" then
			exports(k, function(...)
				return Main[k](Main, ...)
			end)
		end
	end
end)

Citizen.CreateThread(function()
	while true do
		Main:Update()
		Citizen.Wait(30000)
	end
end)