App = {}
App.__index = App

--[[ Functions: App ]]--
function App:Register(id, data, devices)
	-- Create app.
	local app = setmetatable({
		id = id,
		devices = devices,
		data = data
	}, App)
	
	-- Cache app.
	Main.apps[id] = app

	-- Init thread for ui.
	Citizen.CreateThread(function()
		-- Wait for ui.
		while not Main.init do
			Citizen.Wait(0)
		end
		
		-- Update data.
		data.component = data.component or "Custom"

		-- Load app.
		Main:Commit("addApp", {
			app = id,
			data = data,
			load = LoadResourceFile(GetCurrentResourceName(), "apps/"..id.."/component.vue"),
		})

		-- Load devices.
		if devices then
			for deviceId, value in pairs(devices) do
				app:SetActive(deviceId, value)
			end
		end
	end)

	-- Return meta instance.
	return app
end

function App:SetActive(deviceId, value)
	while not Main.init do
		Citizen.Wait(0)
	end

	local device = Main.devices[deviceId]
	if not device then return false end

	Main:Commit("setAppActive", {
		device = deviceId,
		app = self.id,
		value = value,
	})

	self.devices[deviceId] = value or nil

	return true
end

function App:Invoke(deviceId, name, ...)
	while not Main.init do
		Citizen.Wait(0)
	end

	local device = Main.devices[deviceId]
	if not device then return false end

	device:Invoke("invokeApp", false, false, self.id, name, ...)

	return true
end

--[[ Functions: Device ]]--
function Device:OpenApp(id, data)
	local app = Main.apps[id]
	if not app then return end

	app.active = true

	if app.Activate then
		return app:Activate(self, data)
	end
end

function Device:CloseApp(id)
	local app = Main.apps[id]
	if not app then return end
	
	app.active = false
	
	if app.Deactivate then
		return app:Deactivate(self)
	end
end

function Device:SetApp(id, data)
	Main:Commit("setApp", {
		device = self.id,
		app = id,
		data = data,
	})
end