Menu = {}

function Menu:SetData(key, value)
	SendNUIMessage({
		setter = {
			key = key,
			value = value
		}
	})
end

function Menu:Commit(type, payload, options)
	SendNUIMessage({
		commit = {
			type = type,
			payload = payload,
			options = options
		}
	})
end

function Menu:Focus(value)
	self.hasFocus = value

	SetNuiFocus(value, value)
	SetNuiFocusKeepInput(false)

	self:SetData("isEnabled", value)
end

function Menu:CanOpen()
	return not IsPauseMenuActive()
end

function Menu:Update()
	DisableControlAction(0, 199)
	DisableControlAction(0, 200)

	if not self:CanOpen() or IsDisabledControlJustPressed(0, 200) then
		-- Close menu.
		Menu:Focus(false)

		-- Disable pause/escape.
		Citizen.CreateThread(function()
			for i = 1, 30 do
				DisableControlAction(0, 200)
				Citizen.Wait(0)
			end
		end)
	end
end

--[[ NUI Callbacks ]]--
RegisterNUICallback("init", function(data, cb)
	cb(true)
	Menu.hasLoaded = true
end)