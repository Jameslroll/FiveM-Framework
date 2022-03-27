UI = {
	data = {},
	resource = GetCurrentResourceName(),
	windows = {},
	components = {},
}

function UI:Reset()

end

function UI:SetData(key, value)
	_SendNUIMessage({
		setter = {
			key = key,
			value = value
		}
	})
end

function UI:Commit(type, payload, options)
	_SendNUIMessage({
		commit = {
			type = type,
			payload = payload,
			options = options
		}
	})
end

function UI:Notify(data)
	_SendNUIMessage({
		notify = data
	})
end

function UI:Dialog(data, ok, cancel)
	_SendNUIMessage({
		resource = GetCurrentResourceName(),
		dialog = data
	})

	self.dialog = {
		ok = ok,
		cancel = cancel,
	}

	self:Focus(true)
end

function UI:Focus(value, keepInput)
	_Set("hasFocus", value)
	_Set("keepInput", keepInput)

	_SetNuiFocus(value, value)
	_SetNuiFocusKeepInput(keepInput or false)

	self:SetData("isEnabled", value)
end

function UI:GetWindow(id)
	return self.windows[id]
end

--[[ Events ]]--
RegisterNetEvent("ui:reset", function()
	UI:Reset()
end)

AddEventHandler(UI.resource..":stop", function()
	UI:Commit("stopResource", {
		resource = UI.resource
	})
end)

--[[ NUI Callbacks ]]--
RegisterNUICallback("init", function(data, cb)
	cb(true)
	UI.hasLoaded = true
end)

RegisterNUICallback("invoke", function(data, cb)
	cb(true)

	local window = UI:GetWindow(data.window)
	if window == nil then return end

	window:InvokeListener(data.name, table.unpack(data.args))
end)

RegisterNUICallback("keydown", function(key, cb)
	cb(true)

	TriggerEvent("ui:keydown", key)
end)

RegisterNUICallback("keyup", function(key, cb)
	cb(true)

	TriggerEvent("ui:keyup", key)
end)

RegisterNUICallback("dialogFinish", function(data, cb)
	cb(true)

	UI:Focus(false)

	local dialog = UI.dialog
	if not dialog then return end

	if dialog.ok and data.status == "ok" then
		dialog.ok(data.data)
	elseif dialog.cancel and data.status == "cancel" then
		dialog.cancel()
	end
end)

--[[ Threads ]]--
if IsUi then
	RegisterNetEvent("copy", function(text)
		_SendNUIMessage({ copy = text })
	end)

	Citizen.CreateThread(function()
		while true do
			if UI.data.hasFocus and UI.data.keepInput then
				for _, control in ipairs(Config.DisabledControls) do
					DisableControlAction(0, control)
				end

				Citizen.Wait(0)
			elseif UI.data.hasFocus then
				DisableControlAction(0, 51)
				DisableControlAction(0, 52)
				
				Citizen.Wait(0)
			else
				Citizen.Wait(200)
			end
		end
	end)
end

--[[ Testing ]]--
-- Citizen.CreateThread(function()
-- 	Citizen.Wait(500)

-- 	local window = Window:Create({
-- 		id = "createCharacter",
-- 		type = "window",
-- 		title = "Create Character",
-- 		style = {
-- 			["width"] = "60vmin",
-- 			["height"] = "auto",
-- 			["top"] = "50%",
-- 			["left"] = "50%",
-- 			["transform"] = "translate(-50%, -50%)",
-- 		},
-- 		components = {
-- 			{
-- 				type = "q-form",
-- 				components = {
-- 					{
-- 						type = "div",
-- 						class = "row",
-- 						binds = {
-- 							style = {
-- 								["flex-wrap"] = "nowrap",
-- 							}
-- 						},
-- 						components = {
-- 							{
-- 								type = "name-input",
-- 								model = "firstName",
-- 								icon = "person",
-- 								binds = {
-- 									label = "First Name",
-- 									hint = "Your character's name",
-- 									filled = true,
-- 									style = {
-- 										["width"] = "auto",
-- 										["flex-grow"] = 1,
-- 									},
-- 								},
-- 							},
-- 							{
-- 								type = "name-input",
-- 								model = "lastName",
-- 								style = {
-- 									["width"] = "auto",
-- 									["flex-grow"] = 1,
-- 								},
-- 								binds = {
-- 									label = "Last Name",
-- 									filled = true,
-- 								},
-- 							},
-- 						}
-- 					},
-- 					{
-- 						type = "date-input",
-- 						model = "dob",
-- 						min = "1900/01/01",
-- 						max = "2003/01/01",
-- 						binds = {
-- 							label = "Date of Birth",
-- 							filled = true,
-- 							lazyRules = true,
-- 						},
-- 					},
-- 					{
-- 						type = "q-input",
-- 						model = "biography",
-- 						rules = { "val => !!val || 'Backstory required'", "val => val.length > 256 || 'Must be at least 256 characters'" },
-- 						prepend = {
-- 							icon = "auto_stories",
-- 						},
-- 						binds = {
-- 							label = "Biography",
-- 							hint = "Tell us about this character",
-- 							counter = true,
-- 							filled = true,
-- 							autogrow = true,
-- 							lazyRules = true,
-- 							maxlength = 65535,
-- 						},
-- 					},
-- 					{
-- 						type = "q-btn-group",
-- 						binds = {
-- 							push = true,
-- 							spread = true,
-- 						},
-- 						components = {
-- 							{
-- 								type = "q-btn",
-- 								click = {
-- 									event = "cancel"
-- 								},
-- 								binds = {
-- 									label = "Cancel",
-- 									color = "red",
-- 								},
-- 							},
-- 							{
-- 								type = "q-btn",
-- 								click = {
-- 									event = "create"
-- 								},
-- 								binds = {
-- 									label = "Next",
-- 									color = "green",
-- 								},
-- 							},
-- 						}
-- 					},
-- 				},
-- 			},
-- 		},
-- 	})

-- 	UI:Focus(true)
-- end)