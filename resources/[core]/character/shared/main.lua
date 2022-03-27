function Export(context, name)
	exports(name, function(...)
		return context[name](context, ...)
	end)
end

--[[ Metatables ]]--
Main = {}

Main.ids = {}
Main.event = GetCurrentResourceName()..":"

--[[ Functions ]]--
function Main:GetCharacterById(id)
	if type(id) ~= "number" then return end
	
	return self.ids[id]
end
Export(Main, "GetCharacterById")