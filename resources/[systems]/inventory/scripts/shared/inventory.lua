EventPrefix = GetCurrentResourceName()..":"

Inventory = {
	categories = {},
	containers = {},
	hooks = {},
	ids = {},
	items = {},
	list = {},
	recipes = {},
	stations = {},
}

--[[ Functions: Inventory]]--
function Inventory:AddHook(type, func)
	if self.hooks[type] == nil then
		self.hooks[type] = {}
	end
	table.insert(self.hooks[type], func)
end

function Inventory:InvokeHook(type, ...)
	-- Get hooks.
	local hook = self.hooks[type]
	local result, message

	-- Execute hooks.
	if hook ~= nil then
		for _, func in ipairs(hook) do
			local _result, _message = func(...)
			if _result == false then
				result = false
				message = _message
			elseif _result == true then
				result = true
			elseif _result ~= nil then
				result = _result
			end
		end
	end

	-- Return result.
	return result, message
end

function Inventory:Random(...)
	if self.seed == nil then
		self.seed = GetGameTimer()
	else
		math.randomseed(self.seed)
		self.seed = math.random(0, 2147483648)
	end

	math.randomseed(self.seed)

	return math.random(...)
end

function Inventory:Export(name)
	exports(name, function(...)
		return Inventory[name](Inventory, ...)
	end)
end