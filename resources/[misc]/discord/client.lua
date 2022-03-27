Main = {
	clientId = 0,
	default = "Selecting a character",
	stopped = {},
	actions = {
		{ 0, "Join Discord", "https://discord.gg/" },
		{ 1, "Visit Website", "https://" },
	},
}

--[[ Functions ]]--
function Main:Update()
	-- App Id.
	SetDiscordAppId(self.clientId)
	
	-- Presence.
	local serverId = GetPlayerServerId(PlayerId())
	local text = ""

	if self.devMode then
		text = ("Dev - %s"):format(self.devText or "Coding something...")
	elseif not self.numPlayers or not self.maxPlayers then
		text = "Loading..."
	else
		text = ("[%s] %s - %s/%s players"):format(
			serverId,
			self.text or self.default,
			self.numPlayers,
			self.maxPlayers
		)
	end

	SetRichPresence(text)

	-- Large asset.
	SetDiscordRichPresenceAsset("logo")
	SetDiscordRichPresenceAssetText("Server Name")

	-- Small asset.
	SetDiscordRichPresenceAssetSmall("info")
	SetDiscordRichPresenceAssetSmallText("discord.gg")

	-- Join action.
	for _, action in ipairs(self.actions) do
		SetDiscordRichPresenceAction(table.unpack(action))
	end
end

function Main:SetText(text)
	self.text = text or "Doing something"
end

--[[ Exports ]]--
exports("SetText", function(...)
	Main:SetText(...)
end)

--[[ Events ]]--
AddEventHandler("discord:clientStart", function()
	Main:Update()
end)

AddEventHandler("character:selected", function(character)
	if not character then
		Main.text = Main.default
		return
	end

	Main.text = ("Playing as %s %s"):format(character.first_name or "", character.last_name or "")
end)

AddEventHandler("onClientResourceStop", function(resourceName)
	Main.stopped[resourceName] = true
end)

AddEventHandler("onClientResourceStart", function(resourceName)
	if Main.stopped[resourceName] and (not Main.lastRestart or GetGameTimer() - Main.lastRestart > 5000) then
		Main.stopped[resourceName] = nil
		Main.devText = ("Restarting '%s'"):format(resourceName)
		Main.lastRestart = GetGameTimer()
		Main.nextUpdate = GetGameTimer() + 15000
		
		Main:Update()
	end
end)

--[[ Events: Net ]]--
RegisterNetEvent("discord:update", function(numPlayers, maxPlayers, devMode)
	Main.numPlayers = numPlayers
	Main.maxPlayers = maxPlayers
	Main.devMode = devMode

	Main:Update()
end)

--[[ Threads ]]--
Citizen.CreateThread(function()
	while true do
		if Main.nextUpdate and GetGameTimer() > Main.nextUpdate then
			Main.devText = nil
			Main:Update()
		end

		Citizen.Wait(1000)
	end
end)