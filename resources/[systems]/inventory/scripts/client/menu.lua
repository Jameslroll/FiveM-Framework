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
	SetNuiFocusKeepInput(value)

	self:SetData("isEnabled", value)

	if not value then
		self:SetData("station", false)
	end

	TriggerEvent(EventPrefix.."focused", value)
end

--[[ Events ]]--
RegisterNetEvent(EventPrefix.."toggle", function(value)
	Menu:Focus(value)
end)

--[[ Exports ]]--
exports("Focus", function(...)
	Menu:Focus(...)
end)

exports("HasFocus", function()
	return Menu.hasFocus
end)