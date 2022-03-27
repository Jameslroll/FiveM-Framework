Radio = {
	channels = {},
	frequencies = {},
}

--[[ Threads ]]--
Citizen.CreateThread(function()
	SetNuiFocus(false, false)

	while true do
		Radio:Update()
		Citizen.Wait(0)
	end
end)

--[[ Functions ]]--
function Radio:Update()
	if self.isTalking ~= self.wasTalking then
		if self.isTalking then
			self.emote = exports.emotes:Play(Config.Anims.Talking)
		elseif self.emote then
			exports.emotes:Stop(self.emote)
			self.emote = nil
		end

		self.wasTalking = self.isTalking
	end

	if not self.isOpen then return end

	for _, control in ipairs(Config.DisabledControls) do
		DisableControlAction(0, control)
	end

	if IsDisabledControlJustPressed(0, 200) then
		self:Toggle(false)
		Citizen.CreateThread(function()
			for i = 1, 60 do
				DisableControlAction(0, 200)
				Citizen.Wait(0)
			end
		end)
		return
	end

	if GetGameTimer() - (self.lastCheck or 0) > 1000 then
		if not self:CanUse() then
			self:Toggle(false)
		end
	end
end

function Radio:CanUse()
	local state = LocalPlayer.state or {}
	local ped = PlayerPedId()

	return
		not state.immobile and
		not state.restrained and
		not IsEntityAttachedToAnyPed(ped) and
		not IsPedRagdoll(ped) and
		not IsPedSwimming(ped) and
		not IsPedFalling(ped) and
		(GetResourceState("inventory") ~= "started" or exports.inventory:HasItem("radio"))
end

function Radio:Toggle(value)
	if value and not self:CanUse() then
		return
	end

	SetNuiFocus(value, value)
	SetNuiFocusKeepInput(value)

	self:Commit("setVisible", value, false) -- TODO: add faction check

	self.isOpen = value

	exports.emotes:Play(value and Config.Anims.Open or Config.Anims.Close)
	
	TriggerEvent("inventory:cancel")
	TriggerEvent("disarmed")
end

function Radio:Commit(method, ...)
	SendNUIMessage({
		method = method,
		data = {...},
	})
end

function Radio:SetFrequency(value, additional)
	local lastChannel = self.channels[additional]

	if lastChannel then
		local count = (self.frequencies[lastChannel] or 0) - 1

		self.frequencies[lastChannel] = count > 0 and count or nil
		self.channels[additional] = nil

		exports.voip:LeaveChannel(lastChannel)
	end

	if value == "" or not tonumber(value) then return end

	exports.voip:JoinChannel(value, additional == 0 and "Manual" or "Receiver", "radio", self.volume or 0.0)

	self.frequencies[value] = (self.frequencies[value] or 0) + 1
	self.channels[additional] = value
end

function Radio:SetVolume(value)
	self.volume = value
	exports.voip:SetVolume(value * 0.4, table.unpack(self:GetChannels()))
end

function Radio:GetChannels()
	local channels = {}

	for index, channel in pairs(self.channels) do
		channels[#channels + 1] = channel
	end

	return channels
end

function Radio:SetActive(value)
	if (self.volume or 0.0) < 0.01 then return end
	
	local channelId = self.channels[0]
	if not channelId then return end

	if (value or not self.isTalking) and not self:CanUse() then return end

	self.isTalking = value
	exports.voip:SetTalking(value, channelId)
end

function Radio:Reset()
	self:Commit("reset")
	
	for index, channelId in pairs(self.channels) do
		exports.voip:LeaveChannel(channelId)
	end
end

--[[ NUI Events ]]--
RegisterNUICallback("invoke", function(data, cb)
	cb(true)

	local func = Radio[data.method]
	if func then
		func(Radio, table.unpack(data.data))
	end
end)

--[[ Events ]]--
AddEventHandler("playerStartedTalking", function(serverId, channelId)
	if Radio.frequencies[channelId] and (Radio.volume or 0.0) > 0.001 then
		local isSelf = GetPlayerFromServerId(serverId) == PlayerId()
		local volume = (Radio.clickVolume or 1.0) * Radio.volume

		Radio:Commit("playSound", "mic/on_"..(Radio.clickVariant or 1), volume * (isSelf and 1.0 or 0.5))
	end
end)

AddEventHandler("playerStoppedTalking", function(serverId, channelId)
	if Radio.frequencies[channelId] and (Radio.volume or 0.0) > 0.001 then
		local isSelf = GetPlayerFromServerId(serverId) == PlayerId()
		local volume = (Radio.clickVolume or 1.0) * Radio.volume

		Radio:Commit("playSound", "mic/off_"..(Radio.clickVariant or 1), volume * (isSelf and 1.0 or 0.5))
	end
end)

AddEventHandler("radio:clientStart", function()
	local clickVariant = GetResourceKvpInt(Config.Clicks.Key.."Variant")
	local clickVolume = GetResourceKvpFloat(Config.Clicks.Key.."Volume")

	Radio.clickVariant = clickVariant > 0 and clickVariant or 1
	Radio.clickVolume = clickVolume > 0.001 and clickVolume or 0.5
end)

RegisterNetEvent("jobs:clock")
AddEventHandler("jobs:clock", function(name, message)
	if message ~= false then return end
	
	Radio:Reset()
end)

RegisterNetEvent("character:switch")
AddEventHandler("character:switch", function()
	Radio:Reset()
end)

AddEventHandler("health:die", function()
	if Radio.volume then
		Radio.cachedVolume = Radio.volume
		Radio:SetVolume(0.05)
	end
end)

AddEventHandler("health:resurrect", function()
	if Radio.cachedVolume then
		Radio:SetVolume(Radio.cachedVolume)
		Radio.cachedVolume = nil
	end
end)