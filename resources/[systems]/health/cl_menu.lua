Menu = {}

--[[ Functions: Menu ]]--
function Menu:Init()
	self.isLoaded = true
	self:Invoke(false, "loadConfig", {
		effects = Config.Effects,
		bones = Config.Bones,
	})
end

function Menu:Invoke(target, method, ...)
	SendNUIMessage({
		invoke = {
			target = target,
			method = method,
			args = {...},
		}
	})
end

function Menu:Focus()
	if GetGameTimer() - (self.lastFocus or 0) < 20 then
		return
	end

	self.lastFocus = GetGameTimer()
	self:Invoke("main", "focus", 1000, 8000)
end

--[[ Events ]]--
AddEventHandler("interact:onNavigate_healthStatus", function()
	Menu:Focus()
end)

--[[ Commands ]]--
exports.chat:RegisterCommand("status", function()
	Menu:Focus()
end, {
	description = "Show your health buddy for a few seconds!",
})