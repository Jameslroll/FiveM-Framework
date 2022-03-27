Main = Main or {}
Main.devices = {}
Main.apps = {}
Main.items = {}

--[[ Functions: Main ]]--
function Main:Init()
	-- Load devices.
	self.characterId = self.characterId or exports.character:Get("id")
	for id, info in pairs(Config.Devices) do
		self:RegisterDevice(id, info)
	end
end

function Main:RegisterDevice(id, info)
	local device = Device:Create(id, info)
	
	self.devices[id] = device

	if info.item then
		self.items[info.item] = id
	end
end

function Main:UpdateDevices()
	for id, device in pairs(Main.devices) do
		device:UpdateKvp()
		device:Load()
	end
end

function Main:Update()
	if not self.open then
		return
	end

	DisableAllControlActions(0)

	for _, control in ipairs(Config.EnabledControls) do
		EnableControlAction(0, control)
	end

	if not self:CanOpen() then
		self:CloseAll()
	end
end

function Main:Toggle(name, value, ...)
	local device = self.devices[name]
	if device then
		device:Toggle(value, ...)
	end
end

function Main:Set(key, value)
	SendNUIMessage({
		setter = {
			key = key,
			value = value,
		}
	})
end

function Main:Commit(type, payload, options)
	SendNUIMessage({
		commit = {
			type = type,
			payload = payload,
			options = options,
		}
	})
end

function Main:CanOpen()
	local ped = PlayerPedId()
	local state = LocalPlayer.state or {}

	return (
		not IsPedArmed(ped, 1 | 2 | 4) and
		not state.immobile and
		not state.restrained and
		not state.carried and
		not state.carrier
	)
end

function Main:CloseAll()
	for id, device in pairs(self.devices) do
		if device.open then
			device:Toggle(false)
		end
	end
end

function Main:Fetch(eventName, ...)
	local snowflake = (self.lastSnowflake or 0) + 1
	self.lastSnowflake = snowflake

	TriggerServerEvent(Main.event.."call", snowflake, eventName, ...)

	local event
	local data = nil

	event = RegisterNetEvent(Main.event.."fetch-"..snowflake, function(_data)
		data = _data or false
		RemoveEventHandler(event)
	end)

	while data == nil do
		Citizen.Wait(0)
	end

	return data
end

--[[ Threads ]]--
Citizen.CreateThread(function()
	while true do
		Main:Update()
		Citizen.Wait(0)
	end
end)

Citizen.CreateThread(function()
	while true do
		local text
		for id, device in pairs(Main.devices) do
			if device.open then
				if not text then
					local hours = GetClockHours()
					text = ("%02d:%02d %s"):format(hours % 12 == 0 and "12" or hours % 12, GetClockMinutes(), hours >= 12 and "PM" or "AM")
				end
				device:SetData(nil, "time", text)
			end
		end
		Citizen.Wait(1000)
	end
end)

--[[ Events ]]--
AddEventHandler(Main.event.."clientStart", function()
	Main:Init()
end)

AddEventHandler(Main.event.."stop", function()
	Main:CloseAll()
end)

AddEventHandler("character:selected", function(character)
	if not character then
		Main.characterId = nil
		Main:CloseAll()
		
		Main:Commit("reset")
		
		return
	end

	Main.characterId = character.id
	Main:UpdateDevices()
end)

AddEventHandler("inventory:use", function(item, slot, cb)
	local deviceId = Main.items[item.name]
	if not deviceId then return end

	local device = Main.devices[deviceId]
	if not device then return end

	device:Toggle()

	cb()
end)

--[[ Events: Net ]]--

-- TriggerClientEvent("devices:invoke", -1, "Invoke", "addNotification", false, true, "call", {})
-- TriggerClientEvent("devices:invoke", -1, "AddNotification", "call", {})

RegisterNetEvent("devices:invoke", function(deviceName, funcName, ...)
	local device = Main.devices[deviceName]
	if not device then
		error(("server invocation failed (no device '%s')"):format(deviceName))
	end

	local func = device[funcName]
	if not func then
		error(("server invocation failed (no func '%s' for device '%s')"):format(funcName, deviceName))
	end

	func(device, ...)
end)

--[[ NUI Callbacks ]]--
RegisterNUICallback("init", function(name, cb)
	cb(true)

	Main.init = true
end)

RegisterNUICallback("loadDevice", function(name, cb)
	cb(true)

	local device = Main.devices[name]
	if device then
		device:Load()
	end
end)

RegisterNUICallback("invoke", function(data, cb)
	local device = Main.devices[data.device or false]
	if not device then
		print("no device", data.device)
		cb(false)
		return
	end

	local func = device[data.name or false]
	if not func then
		print("no func", data.name)
		cb(false)
		return
	end

	local retval = func(device, table.unpack(data.args))

	cb(retval == nil and true or retval)
end)

RegisterNUICallback("close", function(data, cb)
	cb(true)

	-- Close all devices.
	Main:CloseAll()

	-- Disable pause menu temporarily.
	Citizen.CreateThread(function()
		local startTime = GetGameTimer()
		while GetGameTimer() - startTime < 1000.0 do
			DisableControlAction(0, 200)
			Citizen.Wait(0)
		end
	end)
end)

RegisterNUICallback("focus", function(value, cb)
	cb(true)

	SetNuiFocusKeepInput(not value)
end)