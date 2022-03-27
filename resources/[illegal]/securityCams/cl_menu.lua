Menu = {}

function Menu:Commit(_type, data)
	SendNUIMessage({
		commit = {
			type = _type,
			data = data,
		}
	})
end

function Menu:Toggle(value)
	self.isVisible = value
	self:Commit("setDisplay", {
		id = "content",
		value = value,
	})
end

function Menu:Focus(value)
	self.hasFocus = value
	
	SetNuiFocusKeepInput(value)
	SetNuiFocus(value, value)
end

function Menu:SetLoading(value)
	self:Commit("setDisplay", {
		id = "loading",
		value = value,
	})
end