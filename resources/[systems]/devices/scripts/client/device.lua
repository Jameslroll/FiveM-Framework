Device = { hooks = {} }
Device.__index = Device

function Device:Create(id, info)
	local device = setmetatable(info or {}, Device)
	device.id = id
	device.data = device.data or {}
	device:UpdateKvp()

	return device
end

function Device:Invoke(name, autoEnable, autoPeek, ...)
	Main:Commit("invokeDevice", {
		name = self.id,
		func = name,
		autoEnable = autoEnable,
		autoPeek = autoPeek,
		args = {...},
	})
end

function Device:AddHook(name, func)
	local hook = self.hooks[name]
	if not hook then
		hook = {}
		self.hooks[name] = hook
	end

	hook[#hook + 1] = func
end

function Device:InvokeHook(name, ...)
	local hook = self.hooks[name]
	if not hook then return true end

	for k, func in ipairs(hook) do
		local result, retval = func(self, ...)
		if result ~= nil then
			return result, retval
		end
	end

	return true
end

function Device:Toggle(value)
	-- Flip state.
	if value == nil then
		value = not self.open
	else
		value = value == true
	end

	-- Check openable.
	if value and not Main:CanOpen() then
		return
	end

	-- Check can open.
	if (Main.open or not Main.characterId) and value then
		return false
	end

	-- Hooks.
	local retval, shouldPeek = self:InvokeHook("Toggle", isOpen)
	if not retval then
		return retval
	end

	-- Cache.
	self.peek = shouldPeek
	self.open = value
	Main.open = value and self or nil

	-- Disarm.
	TriggerEvent("disarmed")

	-- Emotes.
	if value and (not Phone.call or Phone.state == "in") then
		self.emote = exports.emotes:Play(self.anim)
	elseif self.emote then
		exports.emotes:Stop(self.emote)
		self.emote = nil
	end

	-- NUI focus.
	SetNuiFocus(self.open, self.open)
	SetNuiFocusKeepInput(self.open)

	-- Enable UI.
	Main:Commit("toggleDevice", {
		name = self.id,
		value = shouldPeek or value,
		peek = not value and shouldPeek,
	})

	return true
end

function Device:Peek()
	Main:Commit("toggleDevice", {
		name = self.id,
		value = true,
		peek = true,
	})
end

function Device:UpdateKvp()
	self.kvp = Main.characterId and Config.Kvp:format(Main.characterId, self.id) or nil
end

function Device:Load()
	self:LoadData()

	Main:Commit("setData", {
		device = self.id,
		data = self.data or {},
	})

	Main:InvokeHook("LoadDevice", self)
end

-- Sets persistent data, saved in the store, and can be used globally.
function Device:SetData(app, key, value)
	if not app then
		app = "SYS"
	end
	
	Main:Commit("setAppData", {
		device = self.id,
		app = app,
		key = key,
		value = value,
	})
end

-- Sets component data, which is only possible when the app is active.
function Device:SetAppData(app, key, value)
	Main:Commit("updateDevice", {
		name = self.id,
		app = app,
		key = key,
		value = value,
	})
end

function Device:UpdateData(app, key, value, time)
	local appData = self.data[app]
	if not appData then
		appData = {}
		self.data[app] = appData
	end

	appData[key] = value

	print("updated data", app, key, value)

	if Config.LocalData[app.."/"..key] then
		self:SaveData()
	end
end

function Device:SaveData()
	if not self.kvp then
		print("no kvp, cannot save data")
		return
	end

	local data = {}
	for app, appData in pairs(self.data) do
		for key, value in pairs(appData) do
			if Config.LocalData[app.."/"..key] then
				local _appData = data[app]
				if not _appData then
					_appData = {}
					data[app] = _appData
				end

				_appData[key] = value
			end
		end
	end

	local value = data and json.encode(data)
	if not value then
		print("deleting data", self.kvp)
		
		DeleteResourceKvp(self.kvp)

		return
	end
	
	print("saving data", self.kvp, value)
	
	SetResourceKvp(self.kvp, value)
end

function Device:LoadData()
	if not self.kvp then return end

	local value = GetResourceKvpString(self.kvp)

	print("loading data", self.kvp, value)

	self.isLoaded = true
	self.data = value and json.decode(value) or {}
end