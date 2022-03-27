Main = {}

--[[ Functions ]]--
function Main:Update()
	DisableControlAction(0, 24)
	DisableControlAction(0, 25)
end

function Main:Begin(data)
	if self.active then return end

	-- Enable nui focus.
	SetNuiFocus(true, false)
	SetNuiFocusKeepInput(true)
	SetCursorLocation(0.5, 0.5)
	
	-- Enable ui minigame.
	SendNUIMessage({
		play = data or {}
	})
	
	-- Cache.
	self.active = true

	-- Wait until done.
	while self.active do
		Citizen.Wait(0)
	end

	-- Return result.
	return self.result
end

function Main:End(success)
	if not self.active then return end

	-- Cache.
	self.result = success
	self.active = false
	
	-- Disable nui focus.
	SetNuiFocus(false, false)
	SetNuiFocusKeepInput(false)
end

function Main:Cancel(success)
	self:End(success)

	SendNUIMessage({ cancel = success })
end

--[[ Events ]]--
RegisterNetEvent("quickTime:begin", function(data)
	Main:Begin(data)
end)

RegisterNetEvent("quickTime:end", function(status)
	Main:End(status)
end)

--[[ Exports ]]--
exports("Begin", function(...)
	return Main:Begin(...)
end)

exports("Cancel", function(...)
	return Main:Cancel(...)
end)

--[[ NUI Callbacks ]]--
RegisterNUICallback("finish", function(success, cb)
	cb(true)
	Main:End(success)
end)

--[[ Threads ]]--
Citizen.CreateThread(function()
	while true do
		if Main.active then
			Main:Update()
		end
		Citizen.Wait(0)
	end
end)