Controller = {}
Controller.__index = Controller

function Controller:Create(data)
	data = data or {}
	data.map = data.map or {}
	data.binds = {}
	data.bound = {}
	data.watchers = {}

	data = setmetatable(data, Controller)

	for map, node, group in MapIter() do
		-- Add watcher for model first.
		if node.model then
			data:AddWatcher(node.model, node)
		end
		
		-- Add other watchers to respond to.
		if node.watchers then
			for _, model in ipairs(node.watchers) do
				data:AddWatcher(model, node)
			end
		end
	end

	return data
end

function Controller:SetData(data, ignoreWindow)
	local models = {}
	self.map = data

	for map, node, group in MapIter() do
		local groupData = data[group]
		if node.model then
			local value = groupData[node.model]

			self:SetMap(node.model, value, not ignoreWindow and self.window ~= nil)

			if type(value) == "table" then
				for k, v in pairs(value) do
					models[k] = v
				end
			else
				models[node.model] = value
			end
		end
	end

	if self.window then
		self.window:SetModel(models)
	end

	Main:ResetToggles()
end

function Controller:GetData(defaults)
	local data = {}

	for map, node, group in MapIter() do
		local groupData = data[group]
		if not groupData then
			groupData = {}
			data[group] = groupData
		end

		if node.model then
			local value = (defaults and (defaults[node.model] or node.default)) or self:GetMap(node.model)
			if not defaults and node.value then
				value = node.value(self, value) or value
			end
			if defaults and not value and node.randomize then
				value = node.randomize(self)
			end
			groupData[node.model] = value
		end
	end

	return data
end

function Controller:ConvertData(data)
	for map, node, group in MapIter() do
		local groupData = data[group]
		if not groupData then
			groupData = {}
			data[group] = groupData
		end
		
		if node.model then
			local value = groupData[node.model]
			if node.value then
				value = node.value(self, value) or value
			end
			groupData[node.model] = value
		end
	end

	return data
end

function Controller:old_ConvertData(source, target)
	local blendData = {
		source[2] + 1,
		source[3] + 1,
		1,
		source[2] + 1,
		source[3] + 1,
		1,
		source[4] / 11.0,
		source[5] / 11.0,
		0.0,
	}
	
	local faceFeatures = source[6]
	for k, v in ipairs(faceFeatures) do
		faceFeatures[k] = v / 11.0 * 2.0 - 1.0
	end

	target.features.blendData = blendData
	target.features.eyeColor = source[9] or 1
	target.features.faceFeatures = faceFeatures
	target.features.overlays = {}
	target.features.hairOverlays = {}

	return self:ConvertData(target)
end

function Controller:SetMap(key, value, isMenu, bind)
	Ped = self.ped or PlayerPedId()
	Player = PlayerId()

	-- Update map.
	local lastValue = self.map[key]
	self.map[key] = value

	-- Update menu.
	local window = self.window
	if window then
		local bound = self.bound[key]

		if bound then
			local models = {}
			for model, index in pairs(bound) do
				models[model] = value and value[index]
			end
			window:SetModel(models)
		else
			window:SetModel(key, value)
		end
	end

	Debug("setting map", key, value)

	-- Trigger watchers.
	local watcher = self.watchers[key]
	if watcher then
		for i, node in ipairs(watcher) do
			Debug("|_ watcher triggered", i)

			if node._component then
				local component = node.component(self)
				
				if component then
					component.model = node.model
					component.condition = node.condition and tostring(node.condition(self) == true)

					node._component:Update(component)
				end
			end

			if node.update then
				node.update(self, key, value, lastValue, isMenu, bind)
			end
		end
	end
end

function Controller:GetMap(key)
	return self.map[key]
end

function Controller:LoadDefaults()
	for group, map in pairs(Map) do
		for k, node in ipairs(map) do
			if node.model and node.default then
				self:SetMap(node.model, node.default)
			end
		end
	end
end

function Controller:SetWindow(window)
	self.window = window
	window.controller = self

	for map, node, group in MapIter() do
			-- Create component.
		local target = (node.group and Editor:GetGroup(node.tab, node.group)) or Editor.tabPanels[node.tab]

		if target and node.component then
			local component = node.component(self)

			if component then
				component.model = node.model
				component.condition = node.condition and tostring(node.condition(self) == true)

				node._component = target:AddComponent(component)
			end
		end
	end

	window:AddListener("updateModel", function(self, model, value)
		local controller = self.controller

		-- Convert number values.
		value = tonumber(value) or value

		-- Handle binds.
		local bind = controller.binds[model]
		if bind then
			model = bind.target
			
			-- Get map.
			local map = controller.map[model]
			if type(map) ~= "table" then
				map = {}
			end

			-- Set map.
			map[bind.index] = value
			value = map
		end

		-- Update tabs.
		if model == "tab" then
			if controller.map.tab == value then return end
			local lastTab = controller.map.tab and Editor.tabPanels[controller.map.tab]

			if lastTab and lastTab.ondeselect then
				lastTab.ondeselect(controller)
			end

			local tab = Editor.tabPanels[value]
			if tab and tab.onselect then
				tab.onselect(controller)
			end

			Editor:ClearTarget()
		end

		-- Set map.
		controller:SetMap(model, value, true, bind)
	end)

	window:AddListener("setPed", function(self, index)
		local controller = self.controller
		controller:SetMap("model", index, true)
	end)

	window:AddListener("randomize", function(self, tab)
		local controller = self.controller
		controller:Randomize(tab)

		local panel = Editor.tabPanels.tools
		if panel and panel.onselect then
			panel.onselect(controller)
		end
	end)

	window:AddListener("import", function(self)
		local controller = self.controller

		local model = json.decode(self.models["import"])
		if not model then return end

		local data = controller:ConvertData(model)
		if not data then return end

		controller:SetData(data, true)
	end)

	window:AddListener("importOld", function(self)
		local controller = self.controller

		local model = json.decode(self.models["importOld"])
		if not model then return end

		local data = controller:GetData()
		if not data then return end

		controller:SetData(controller:old_ConvertData(model, data), true)
	end)

	window:AddListener("setTarget", function(self, target)
		Editor:SetTarget(target)
	end)

	window:OnClick("discard", function(self)
		Editor:Toggle(false)
		
		local controller = self.controller
		if controller.defaults then
			controller:SetData(json.decode(controller.defaults), true)
		end
	end)

	window:OnClick("save", function(self)
		local controller = self.controller
		local data = controller:GetData()

		TriggerServerEvent("customization:update", data.appearance or false, data.features or false)

		controller:SetData(controller:ConvertData(data), true)
	end)
	
	-- window:SetModel("tab", "features")

	for key, value in pairs(self.map) do
		self:SetMap(key, value)
	end
end

function Controller:BindModel(source, target, index)
	local bound = self.bound[target]
	if not bound then
		bound = {}
		self.bound[target] = bound
	end

	bound[source] = index

	self.binds[source] = {
		target = target,
		index = index,
	}
end

function Controller:AddWatcher(model, node)
	Debug("add watcher", model, node.id)

	local watchers = self.watchers[model]
	if not watchers then
		watchers = {}
		self.watchers[model] = watchers
	end
	table.insert(watchers, node)
end

function Controller:Randomize(tab)
	if GetGameTimer() - (self.lastRandomize or 0) < 1000 then return end

	local models = {}

	for map, node, group in MapIter() do
		if node.randomize ~= nil and (tab == nil or node.tab == tab) then
			local value = node.randomize(self)
			self:SetMap(node.model, value)
		end
	end

	self.lastRandomize = GetGameTimer()
end