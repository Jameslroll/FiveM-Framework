Window = Component:Create()

--[[ Functions ]]--
function Window:Create(data, canClose)
	-- Default data.
	data.type = "window"
	data.resource = GetCurrentResourceName()
	data.models = {}
	data.listeners = {}

	-- Close component.
	if canClose then
		data.prepend = {
			type = "q-icon",
			name = "cancel",
			binds = {
				color = "red",
			},
			click = {
				event = "close"
			},
		}
	end

	-- Create component.
	data = Component:Create(data)

	-- Set metatable.
	setmetatable(data, self)
	self.__index = self

	-- Cache window.
	UI.windows[data.id] = data

	-- Add default listeners.
	data:AddListener("updateModel", self.UpdateModel)
	data:AddListener("click", self.Click)

	-- Close events.
	if canClose then
		data:OnClick("close", function(self)
			self:Destroy()
			UI:Focus(false)
		end)
	end

	return data
end

function Window:SetModel(...)
	local args = {...}
	if #args == 1 then
		local models = ...
		if type(models) ~= "table" then return end

		UI:Commit("setModel", {
			id = self.id,
			models = models
		})
	else
		local model, value = ...
		if type(model) ~= "string" then return end

		self.models[model] = value
	
		UI:Commit("setModel", {
			id = self.id,
			model = model,
			value = value,
		})
	end
end

function Window:UpdateModel(model, value)
	-- Invoke listener with value and old value.
	local listener = self.modelListeners and self.modelListeners[model]
	if listener then
		listener(self, value, self.models[model])
	end
	
	-- Cache new value.
	self.models[model] = value
end

function Window:OnUpdateModel(name, callback)
	if not self.modelListeners then
		self.modelListeners = {}
	end
	self.modelListeners[name] = callback
end

function Component:Click(name)
	if not self.clickListeners then return end
	local listener = self.clickListeners[name]
	if listener then
		listener(self)
	end
end

function Component:OnClick(name, callback)
	if not self.clickListeners then
		self.clickListeners = {}
	end
	self.clickListeners[name] = callback
end