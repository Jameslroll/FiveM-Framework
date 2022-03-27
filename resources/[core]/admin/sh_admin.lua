Admin = {
	hooks = {},
	players = {},
	event = GetCurrentResourceName()..":",
}

function Admin:AddHook(_type, message, callback)
	if self.hooks[_type] == nil then
		self.hooks[_type] = {}
	end
	self.hooks[_type][message] = callback
end

function Admin:InvokeHook(_type, message, ...)
	local func = (self.hooks[_type] or {})[message]
	if func then
		func(...)
	end
	if TriggerServerEvent then
		TriggerServerEvent(self.event.."invokeHook", _type, message, ...)
	end
end

function GetVehicles()
	
end