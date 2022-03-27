Main = {
	event = GetCurrentResourceName()..":",
	listeningStation = 1,
	listenerVolume = 3,
	maxVolume = 3,
}

--[[ Functions ]]--
function Main:Init()
	self:SetVolume(self.listenerVolume)
	self:SetChannel(self.listeningStation)

	for stationId, station in ipairs(Config.Stations) do
		if station.Control then
			exports.interact:Register({
				id = "broadcaster-"..stationId,
				text = "Toggle Broadcast",
				event = "broadcaster",
				coords = station.Control,
				radius = 0.5,
				stationId = stationId,
			})
		end
	end
end

function Main:Update()
	local ped = PlayerPedId()
	local coords = GetEntityCoords(ped)

	local nearestStation = nil
	local activeStation = nil
	local interiorId = GetInteriorAtCoords(coords)
	local roomHash = interiorId and GetRoomKeyFromEntity(ped)
	local roomId = roomHash and GetInteriorRoomIndexByHash(interiorId, roomHash)
	local roomName = roomId and GetInteriorRoomName(interiorId, roomId)

	for stationId, station in ipairs(Config.Stations) do
		local dist = #(station.Center - coords)

		if dist < station.Radius and (not station.Room or station.Room == roomName) and self:IsStationActive(stationId) then
			activeStation = stationId
		end

		if dist < 20.0 then
			nearestStation = stationId
		end
	end

	if self.activeStation ~= activeStation then
		self:UpdateStation(activeStation)
	end

	self.nearestStation = nearestStation
end

function Main:UpdateFrame()
	local stationId = self.nearestStation

	local station = Config.Stations[stationId or false]
	if not station then return end

	local active = self:IsStationActive(stationId)
	local light = station.Light

	if light then
		DrawLightWithRangeAndShadow(light.x, light.y, light.z, active and 0 or 255, active and 255 or 0, 0, 4.0, 4.0, 5.0)
	end

	if self.activeStation and self.channel then
		local set = nil

		if IsControlJustPressed(0, Config.Control) then
			set = true
		elseif IsControlJustReleased(0, Config.Control) then
			set = false
		end
		
		if set ~= nil then
			self.isTalking = set
			exports.voip:SetTalking(set, self.channel)
		end
	end
end

function Main:IsStationActive(stationId)
	return GlobalState["broadcaster"..stationId] == true
end

function Main:UpdateStation(stationId)
	local lastStationId = self.activeStation
	self.activeStation = stationId

	if not stationId then
		local station = Config.Stations[lastStationId]
		self.channel = nil
		exports.voip:LeaveChannel(station.Channel)
		return
	end

	if self.listening then
		self:ToggleListener(false)
	end
	
	local station = Config.Stations[stationId]

	exports.voip:JoinChannel(station.Channel, station.Type or "Automatic", false, Config.BaseVolume)

	self.channel = station.Channel
end

function Main:Commit(type, ...)
	SendNUIMessage({
		commit = {
			type = type,
			args = {...},
		}
	})
end

function Main:ToggleMenu(value)
	-- Focus NUI.
	SetNuiFocus(value, value)
	SetNuiFocusKeepInput(false)

	-- Open menu.
	Main:Commit("setActive", value)

	if value then
		-- Close inventory.
		TriggerEvent("inventory:toggle", false)
	end
end

function Main:ToggleListener(value)
	-- Toggle value.
	if value == nil then
		value = not self.listening
	end

	-- Prevent turning on while in station.
	if value and self.activeStation then
		return
	end

	-- Cache value.
	self.listening = value

	-- Update ui.
	self:Commit("setPower", self.listening)

	-- Update channels.
	local station = Config.Stations[self.listeningStation]
	if value then
		self:AttachListener(station.Channel)
	else
		exports.voip:LeaveChannel(station.Channel)
	end
end

function Main:SetChannel(index)
	if index <= 0 then
		index = #Config.Stations
	elseif index > #Config.Stations then
		index = 1
	end

	-- Get station.
	local station = Config.Stations[index]
	if not station then return end

	-- Remove from last channel.
	local lastStation = self.listeningStation and Config.Stations[self.listeningStation]
	if lastStation then
		exports.voip:LeaveChannel(lastStation.Channel)
	end

	-- Cache channel.
	self.listeningStation = index

	-- Update ui.
	self:Commit("setChannel", index, station.Name)

	-- Join channel.
	if self.listening then
		self:AttachListener(station.Channel)
	end
end

function Main:SetVolume(volume)
	local maxVolme = self.maxVolume
	local station = Config.Stations[self.listeningStation]

	-- Limit volume.
	volume = math.min(math.max(volume, 1), maxVolme)

	-- Cache volume.
	self.listenerVolume = volume

	-- Update ui.
	Main:Commit("setVolume", volume, maxVolme)

	-- Set channel volume.
	exports.voip:SetVolume(volume / maxVolme * Config.BaseVolume, station.Channel)
end

function Main:UpdateListenerVolume(direction)
	self:SetVolume(self.listenerVolume + direction)
end

function Main:UpdateListenerStation(direction)
	self:SetChannel(self.listeningStation + direction)
end

function Main:AttachListener(channel)
	local volume = self.listenerVolume / self.maxVolume * Config.BaseVolume
	exports.voip:JoinChannel(channel, "Receiver", "radio", volume)
end

--[[ NUI Callbacks ]]--
RegisterNUICallback("init", function(value, cb)
	cb(true)
	Main:Init()
end)

RegisterNUICallback("toggle", function(value, cb)
	cb(true)
	Main:ToggleListener(value)
end)

RegisterNUICallback("close", function(_, cb)
	cb(true)
	Main:ToggleMenu(value)
end)

RegisterNUICallback("updateVolume", function(direction, cb)
	cb(true)
	Main:UpdateListenerVolume(direction)
end)

RegisterNUICallback("updateChannel", function(direction, cb)
	cb(true)
	Main:UpdateListenerStation(direction)
end)

--[[ Events: Net ]]--
RegisterNetEvent(Main.event.."toggleListener", function(value)
	Main:ToggleListener(value)
end)

--[[ Events ]]--
AddEventHandler("interact:on_broadcaster", function(interactable)
	local stationId = interactable.stationId
	if not stationId then return end

	TriggerServerEvent(Main.event.."toggle", stationId)
end)

AddEventHandler("inventory:use", function(item, slot, cb)
	if not Config.Items[item.name] then return end
	
	cb(true)
	Main:ToggleMenu(true)
end)

--[[ Threads ]]--
Citizen.CreateThread(function()
	while true do
		Main:Update()
		Citizen.Wait(1000)
	end
end)

Citizen.CreateThread(function()
	while true do
		if Main.nearestStation then
			Main:UpdateFrame()
		end
		Citizen.Wait(0)
	end
end)