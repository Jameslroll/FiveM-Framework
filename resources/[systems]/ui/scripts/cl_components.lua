Component = {}

--[[ Functions ]]--
function BuildObject(source, target)
	for k, v in pairs(source) do
		if type(v) == "table" then
			local _v = {}
			target[k] = _v
			BuildObject(v, _v)
		elseif type(v) ~= "function" then
			target[k] = v
		end
	end
end

function GetRecursive(tbl, root)
	for id, component in pairs(root.components) do
		tbl[#tbl + 1] = component

		if component.components then
			GetRecursive(tbl, component)
		end
	end
end

--[[ Functions: Component ]]--
function Component:Create(data, isDiscrete)
	data = data or {}

	-- Set metatable.
	setmetatable(data, self)
	self.__index = self

	if data.type == nil then
		return data
	end

	-- Update ID.
	data.id = (_Get("lastId") or 0) + 1
	_Set("lastId", data.id)

	-- Register nested components.
	if data.components then
		data:ConvertComponents()
	else
		data.components = {}
	end
	
	-- Update defaults.
	if data.defaults then
		for k, v in pairs(data.defaults) do
			data.models[k] = v
		end
		data.defaults = nil
	end

	-- Cache component.
	UI.components[data.id] = data

	-- Update NUI.
	if not isDiscrete then
		local payload = {}

		BuildObject(data, payload)

		UI:Commit("addComponent", json.encode(payload))
	end

	return data
end

function Component:GetParent()
	if self.parent == nil then return end

	return UI.components[self.parent]
end

function Component:Destroy()
	print("destroy component", self.id)

	local parent = self:GetParent()
	if parent ~= nil then
		parent.components[self.id] = nil
	end
	
	UI:Commit("removeComponent", self.id)
	UI.components[self.id] = nil

	if self.OnDestroy then
		self:OnDestroy()
	end
end

function Component:Update(data)
	for k, v in pairs(data) do
		self[k] = v
	end

	local payload = {}

	BuildObject(self, payload)

	UI:Commit("updateComponent", json.encode(payload))
end

function Component:AddComponent(data)
	data = data or {}
	data.type = data.type or "div"
	data.parent = self.id

	local component = Component:Create(data)
	local target = data.target

	if target and not self[target] then
		self[target] = {}
	end

	self[target or "components"][data.id] = component

	return component
end

function Component:AddTab(data)
	data.target = "tabs"
	
	return self:AddComponent(data)
end

function Component:ConvertComponents()
	for id, component in pairs(self.components) do
		self.components[id] = Component:Create(component, true)
	end
end

function Component:GetNestedComponents()
	local components = {}

	if self.components then
		GetRecursive(components, self)
	end

	return components
end

function Component:AddListener(type, callback)
	-- Get listeners.
	local listeners = self.listeners[type]

	-- Create listeners.
	if listeners == nil then
		listeners = {}
		self.listeners[type] = listeners
	end

	-- Get id.
	local id = tostring(callback)

	-- Cache callback.
	listeners[id] = callback
end

function Component:RemoveListener(type, callback)
	local listeners = self.listeners[type]
	if listeners == nil then return false end

	-- Get id.
	local id = tostring(callback)

	-- Remove listener.
	if listeners[id] == nil then
		return false
	else
		listeners[id] = nil
	
		return true
	end
end

function Component:InvokeListener(type, ...)
	local listeners = self.listeners[type]
	if listeners == nil then return end

	for name, func in pairs(listeners) do
		func(self, ...)
	end
end