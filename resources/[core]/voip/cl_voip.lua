Voip.channels = {}
Voip.debugTalking = {}
Voip.playerChannels = {}
Voip.talking = {}

function Voip:Init()
	TriggerServerEvent("voip:init")

	while not DoesEntityExist(PlayerPedId()) do
		Citizen.Wait(20)
	end
	
	while not MumbleIsConnected() do
		NetworkSetVoiceActive(true)
		Citizen.Wait(200)
	end
	
	print("Initializing voip...")

	self.hasLoaded = true

	Voip:Clear()
	
	-- Mumble settings.
	MumbleSetVoiceTarget(Config.VoiceTarget)
	MumbleSetAudioInputIntent("speech")
	MumbleSetAudioOutputDistance(100.0)

	-- Set default range.
	self:SetRange(2)

	-- Create submixes.
	if self.submixes then return end

	local radio = CreateAudioSubmix("radio")
	
	AddAudioSubmixOutput(radio, 0)
	SetAudioSubmixEffectRadioFx(radio, 0)
	SetAudioSubmixEffectParamInt(radio, 0, `default`, 0)
	SetAudioSubmixEffectParamFloat(radio, 0, `freq_hi`, 3200.0)
	SetAudioSubmixEffectParamFloat(radio, 0, `freq_low`, 240.0)
	SetAudioSubmixEffectParamFloat(radio, 0, `fudge`, 2.0)

	local phone = CreateAudioSubmix("phone")
	
	AddAudioSubmixOutput(phone, 0)
	SetAudioSubmixEffectRadioFx(phone, 0)
	SetAudioSubmixEffectParamInt(phone, 0, `default`, 0)
	SetAudioSubmixEffectParamFloat(phone, 0, `freq_hi`, 2500.0)
	SetAudioSubmixEffectParamFloat(phone, 0, `freq_low`, 120.0)

	self.submixes = {
		radio = radio,
		phone = phone,
	}

	-- Update debug text.
	self:UpdateDebugText()
end

function Voip:Reset()
	print("Attempting to reset")
	TriggerServerEvent("voip:reset")
	self:UpdateTargets()
end

function Voip:Update()
	-- Check status.
	local status = MumbleIsConnected()
	
	if self.status ~= status then
		if status and self.hasLoaded then
			self:Reset()
		end

		SendNUIMessage({ connected = status })
		self.status = status
	end

	if not status then return end

	-- Get ped.
	local localPed = PlayerPedId()
	local localCoords = GetEntityCoords(localPed)

	-- Update grids.
	local grid = self:GetGrid()
	if grid ~= self.grid then
		Voip:Debug("Set grid: %s", self.grid)
		NetworkSetVoiceChannel(grid)

		self.grid = grid
		self:UpdateTargets()
	end

	-- Find amplifiers.
	local shouldAmplify = false

	for _, amplifier in ipairs(Config.Amplifiers.Stages) do
		if #(amplifier.Coords - localCoords) < amplifier.Radius then
			shouldAmplify = true
			break
		end
	end

	local vehicle = GetNearestVehicle(localCoords, 20.0)
	if vehicle and DoesEntityExist(vehicle) then
		local model = GetEntityModel(vehicle)
		local amplifier = Config.Amplifiers.Vehicles[model or false]
		if amplifier and #(GetOffsetFromEntityInWorldCoords(vehicle, amplifier.Offset) - localCoords) < amplifier.Radius then
			shouldAmplify = true
		end
	end

	-- Update amplifier.
	if shouldAmplify ~= self.amplified then
		self.amplified = shouldAmplify
		if shouldAmplify then
			self:SetRange("M")
			MumbleSetAudioInputIntent("music")
		else
			self:SetRange(self.range)
			MumbleSetAudioInputIntent("speech")
		end
	end

	-- Debug.
	if self.debug then
		local updated = false
		local localPlayer = PlayerId()
		for _, player in ipairs(GetActivePlayers()) do
			if player ~= localPlayer then
				local isTalking = NetworkIsPlayerTalking(player)
				local wasTalking = self.debugTalking[player]
				if wasTalking ~= isTalking then
					self.debugTalking[player] = isTalking or nil
					updated = true
				end
			end
		end
		if updated then
			self:UpdateDebugText()
		end
	end
end

function Voip:Input()
	if (self.talkingCount or 0) > 0 then
		SetControlNormal(0, 249, 1.0)
	end

	local isTalking = NetworkIsPlayerTalking(PlayerId())
	isTalking = isTalking == 1 and true or isTalking
	
	if isTalking ~= (self.wasTalking or false) then
		self.wasTalking = isTalking

		SendNUIMessage({ talking = isTalking })

		TriggerServerEvent("voip:setTalking", isTalking)
	end
end

function Voip:Clear()
	for i = 0, 30 do
		MumbleClearVoiceTarget(i)
		MumbleClearVoiceTargetChannels(i)
		MumbleClearVoiceTargetPlayers(i)
	end

	NetworkClearVoiceChannel()
end

function Voip:SetRange(index)
	local range = Config.Ranges[index]
	if not range then return end
	
	if type(index) == "number" then
		self.range = index
	end
	
	SendNUIMessage({ range = index })
	MumbleSetAudioInputDistance(range.Proximity)
end

function Voip:UpdateDebugText()
	if not self.debug then return end

	local text = "<h4>Grid</h4>"..(self.grid or "None").." x"..#GetActivePlayers()

	text = text.."<br><br><h4>Channels</h4>"
	for channelId, channel in pairs(self.channels) do
		text = text.."("..channelId.." at "..math.ceil((channel.volume or 1.0) * 100.0).."%)"
		local players = self.playerChannels[channelId]
		if players then
			for serverId, _ in pairs(players) do
				text = text.." ["..serverId.."]"
			end
		end
		text = text.."<br>"
	end
	
	text = text.."<br><br><h4>Talking (Channel)</h4>"
	for serverId, _ in pairs(self.talking) do
		text = text.."["..serverId.."] "
	end

	text = text.."<br><br><h4>Talking (Nearby)</h4>"
	for player, _ in pairs(self.debugTalking) do
		if player == PlayerId() then
			self.debugTalking[player] = nil
		else
			text = text.."["..GetPlayerServerId(player).."] "
		end
	end

	SendNUIMessage({
		debug = text
	})
end

--[[ Functions: Players ]]--
function Voip:UpdateTargets()
	self:Debug("Updating targets...")
	
	MumbleClearVoiceTargetPlayers(Config.VoiceTarget)
	MumbleClearVoiceTargetChannels(Config.VoiceTarget)

	if self.grid then
		NetworkSetVoiceChannel(self.grid)
		MumbleAddVoiceTargetChannel(Config.VoiceTarget, self.grid - 1)
		MumbleAddVoiceTargetChannel(Config.VoiceTarget, self.grid)
		MumbleAddVoiceTargetChannel(Config.VoiceTarget, self.grid + 1)
	end
	
	for channelId, players in pairs(self.playerChannels) do
		for serverId, _ in pairs(players) do
			MumbleAddVoiceTargetPlayerByServerId(Config.VoiceTarget, serverId)
		end
	end

	self:UpdateDebugText()
end

function Voip:SetPlayerTalking(channelId, serverId, value)
	if value and self.talking[serverId] then return end
	
	local channel = self.channels[channelId]
	local volume = value and channel.volume or -1.0
	local submix = value and self.submixes[channel.submix or false] or -1
	
	if volume < 0.01 then
		volume = -1.0
		submix = -1
	end

	Voip:Debug("[%i] %s talking in channel %s (volume: %s)", serverId, value and "started" or "stopped", channelId, volume)

	MumbleSetVolumeOverrideByServerId(serverId, volume + 0.0)
	MumbleSetSubmixForServerId(serverId, submix)

	self.talking[serverId] = value and channelId or nil

	TriggerEvent(value and "playerStartedTalking" or "playerStoppedTalking", serverId, channelId)

	self:UpdateTalking(value)
	Voip:UpdateDebugText()
end

function Voip:UpdateTalking(value)
	if self.hideFrequencies then return end

	local channels = {}
	for serverId, channelId in pairs(self.talking) do
		local channel = self.channels[channelId]
		if channel and channel.submix == "radio" then
			channels[#channels + 1] = channelId
		end
	end

	SendNUIMessage({ channels = channels })
end

function Voip:SetTalking(value, ...)
	local channels = {...}
	local filter = #channels > 0 and {} or nil

	for _, channelId in ipairs(channels) do
		filter[channelId] = true
	end

	self.talkingCount = (self.talkingCount or 0) + (value and #channels or -#channels)

	TriggerServerEvent("voip:setTalking", value, filter)
end
Voip:Export("SetTalking")

function Voip:SetVolume(value, ...)
	-- Get channels.
	local channels = {...}
	
	-- Check value.
	if type(value) ~= "number" then return end

	-- Update channels.
	for _, channelId in ipairs(channels) do
		-- Set volume for channel.
		local channel = self.channels[channelId]
		if channel then
			channel.volume = value
		end

		-- Update any talking players.
		local players = self.playerChannels[channelId]
		if players then
			for serverId, _ in pairs(players) do
				local isTalking = self.talking[serverId]
				if isTalking then
					self.talking[serverId] = nil
					self:SetPlayerTalking(channelId, serverId, true)
				end
			end
		end
	end

	-- Debug.
	self:UpdateDebugText()
end
Voip:Export("SetVolume")

function Voip:GetVoiceRange()
	return self.range
end
Voip:Export("GetVoiceRange")

function Voip:GetGrid()
	local coords = GetFinalRenderedCamCoord()
	return 100 + math.ceil((coords.x + coords.y) / (64.0 * 2))
end

---[[ Functions: Channels ]]--
function Voip:AddToChannel(channelId, serverId)
	self:Debug("[%i] joined channel %s", serverId, channelId)

	local channel = self.playerChannels[channelId]
	if not channel then
		channel = {}
		self.playerChannels[channelId] = channel
	end

	channel[serverId] = true

	MumbleAddVoiceTargetPlayerByServerId(Config.VoiceTarget, serverId)

	self:UpdateDebugText()
end

function Voip:RemoveFromChannel(channelId, serverId)
	self:Debug("[%i] left channel %s", serverId, channelId)

	local channel = self.playerChannels[channelId]
	if not channel then return end

	self:SetPlayerTalking(channelId, serverId, false)

	channel[serverId] = nil

	self:UpdateTargets()
end

function Voip:DestroyChannel(channelId)
	self:Debug("Destroyed channel %s", channelId)

	local channel = self.playerChannels[channelId]
	if not channel then return end

	for serverId, _ in pairs(channel) do
		self:SetPlayerTalking(channelId, serverId, false)
	end

	self.playerChannels[channelId] = nil

	self:UpdateTargets()
end

function Voip:JoinChannel(channelId, _type, submix, volume)
	channelId = tostring(channelId)

	-- Default settings.
	if not settings then
		settings = {}
	end

	-- Cache channel.
	self.channels[channelId] = {
		type = _type,
		submix = submix,
		volume = volume or 1.0,
	}

	-- Join channel.
	TriggerServerEvent("voip:joinChannel", channelId, _type)
end
Voip:Export("JoinChannel")

function Voip:LeaveChannel(channelId)
	channelId = tostring(channelId)

	-- Cache channel.
	self.channels[channelId] = nil
	
	-- Join channel.
	TriggerServerEvent("voip:leaveChannel", channelId)
end
Voip:Export("LeaveChannel")

--[[ Threads ]]--
Citizen.CreateThread(function()
	while true do
		Citizen.Wait(1000)

		Voip:Update()
	end
end)

Citizen.CreateThread(function()
	while true do
		Citizen.Wait(0)
		
		Voip:Input()
	end
end)

--[[ Events ]]--
AddEventHandler("voip:clientStart", function()
	Voip.hideFrequencies = GetResourceKvpInt(Config.ChannelHudKey) == 1
	Voip:Init()
end)

AddEventHandler("voip:stop", function()
	Voip:Clear()
end)

--[[ Events: Net ]]--
RegisterNetEvent("voip:addToChannel", function(channelId, serverId, talking)
	if type(serverId) == "table" then
		Voip:Debug("Joining channel: %s", channelId)

		for _serverId, _ in pairs(serverId) do
			Voip:AddToChannel(channelId, tonumber(_serverId))
		end
	else
		Voip:AddToChannel(channelId, serverId)
	end

	if talking then
		for _serverId, value in pairs(talking) do
			Voip:SetPlayerTalking(channelId, tonumber(_serverId), true)
		end
	end
	
	Voip:UpdateDebugText()
end)

RegisterNetEvent("voip:removeFromChannel", function(channelId, serverId)
	if serverId then
		Voip:RemoveFromChannel(channelId, serverId)
	else
		Voip:DestroyChannel(channelId)
	end
end)

RegisterNetEvent("voip:setTalking", function(channelId, serverId, value)
	Voip:SetPlayerTalking(channelId, serverId, value)
end)

RegisterNetEvent("voip:joinChannel", function(...)
	Voip:JoinChannel(...)
end)

RegisterNetEvent("voip:leaveChannel", function(...)
	Voip:LeaveChannel(...)
end)

RegisterNetEvent("voip:setVolume", function(...)
	Voip:SetVolume(...)
end)