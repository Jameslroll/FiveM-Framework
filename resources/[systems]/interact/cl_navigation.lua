Navigation = {
	controls = {
		1,
		2,
		21,
		24,
		25,
		68,
		69,
		70,
		91,
		92,
	},
	options = {},
}

--[[ Functions ]]--
function Navigation:Toggle(value)
	if value then
		if exports.ui:HasFocus() then
			return
		end

		SetCursorLocation(0.5, 0.5)
	end
	
	self.open = value
	
	SetNuiFocus(value, value)
	SetNuiFocusKeepInput(value)

	TriggerEvent("interact:navigate", value)

	SendNUIMessage({
		method = "toggleNavigation",
		data = {
			value = value,
		}
	})
end

function Navigation:CacheOption(data)
	if not data.id then return end

	self.options[data.id] = data

	if data.sub then
		for _, sub in ipairs(data.sub) do
			self:CacheOption(sub)
		end
	end
end

function Navigation:UncacheOption(id)
	local option = self.options[id]
	if not option then return end

	if option.sub then
		for _, sub in ipairs(option) do
			self:UncacheOption(sub.id)
		end
	end

	self.options[id] = nil
end

function Navigation:AddOption(data)
	while not Interaction.ready do
		Citizen.Wait(0)
	end
	
	SendNUIMessage({
		method = "addOption",
		data = data,
	})

	self:CacheOption(data)
end

function Navigation:RemoveOption(id)
	SendNUIMessage({
		method = "removeOption",
		data = id,
	})

	self:UncacheOption(id)
end

function Navigation:Update()
	if not self.open then return end

	for _, control in ipairs(self.controls) do
		DisableControlAction(0, control)
	end
end

--[[ Threads ]]--
Citizen.CreateThread(function()
	while true do
		Navigation:Update()

		Citizen.Wait(0)
	end
end)

--[[ Exports ]]--
exports("AddOption", function(...)
	Navigation:AddOption(...)
end)

exports("RemoveOption", function(...)
	Navigation:RemoveOption(...)
end)

--[[ NUI Callbacks ]]--
RegisterNUICallback("closeNavigation", function(data, cb)
	cb(true)

	SetNuiFocus(false, false)
	SetNuiFocusKeepInput(false)
end)

RegisterNUICallback("selectNavigation", function(id, cb)
	cb(true)

	SetNuiFocus(false, false)
	SetNuiFocusKeepInput(false)

	local option = Navigation.options[id or false]

	TriggerEvent("interact:onNavigate", id, option)
	TriggerEvent("interact:onNavigate_"..tostring(id), option)
end)

--[[ Commands ]]--
RegisterKeyMapping("+roleplay_navigate", "Interact - Navigation Wheel", "KEYBOARD", "LMENU")

RegisterCommand("+roleplay_navigate", function(source, args, command)
	if not IsControlEnabled(0, 52) then
		return
	end
	
	Navigation:Toggle(true)
end)

RegisterCommand("-roleplay_navigate", function(source, args, command)
	Navigation:Toggle(false)
end)