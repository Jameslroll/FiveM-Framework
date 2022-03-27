Main = Main or {}
Main.event = GetCurrentResourceName()..":"
Main.hooks = {}

function Main:AddHook(name, func)
	local hook = self.hooks[name]
	if not hook then
		hook = {}
		self.hooks[name] = hook
	end

	hook[#hook + 1] = func
end

function Main:InvokeHook(name, ...)
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