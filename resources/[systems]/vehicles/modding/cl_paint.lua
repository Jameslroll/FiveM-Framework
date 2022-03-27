Paint = {
	colors = {
		{
			name = "Primary",
			setter = SetVehicleCustomPrimaryColour,
			getter = GetVehicleCustomPrimaryColour,
		},
		{
			name = "Secondary",
			setter = SetVehicleCustomSecondaryColour,
			getter = GetVehicleCustomSecondaryColour,
		},
	},
	palettes = {
		{
			name = "Interior",
			setter = SetVehicleInteriorColor,
			getter = GetVehicleInteriorColor,
		},
		{
			name = "Dashboard",
			setter = SetVehicleDashboardColor,
			getter = GetVehicleDashboardColor,
		},
		{
			name = "Pearlescent",
			setter = function(vehicle, id)
				local pearlescent, wheel = GetVehicleExtraColours(vehicle)
				SetVehicleExtraColours(vehicle, id, wheel)
			end,
			getter = function(vehicle)
				local pearlescent, wheel = GetVehicleExtraColours(vehicle)
				return pearlescent
			end,
		},
		{
			name = "Wheel",
			setter = function(vehicle, id)
				local pearlescent, wheel = GetVehicleExtraColours(vehicle)
				SetVehicleExtraColours(vehicle, pearlescent, id)
			end,
			getter = function(vehicle)
				local pearlescent, wheel = GetVehicleExtraColours(vehicle)
				return wheel
			end,
		},
	},
}

--[[ Functions: Paint ]]--
function Paint:Enable(vehicle)
	local palette = self:GetPalette()
	local components = {}
	local defaults = {
		palette = palette,
	}

	self.defaults = {
		colors = {},
		palettes = {},
	}

	for index, mod in ipairs(self.colors) do
		local r, g, b = mod.getter(vehicle)
		local component = {
			type = "q-card",
			class = "q-pa-sm q-mb-md",
			text = mod.name.." Color",
			components = {
				{
					template = [[
						<q-color
							flat
							square
							style="width: 10vmin"
							value="#]]..RgbToHex(r, g, b)..[["
							@change="hex => this.$invoke('setColor', 'rgb', ]]..index..[[, hex)"
						/>
					]],
				},
			},
		}

		table.insert(components, component)

		self.defaults.colors[index] = { r, g, b }
	end

	for index, mod in ipairs(self.palettes) do
		local component =  {
			type = "q-card",
			class = "q-pa-sm q-mb-md",
			components = {
				{
					type = "div",
					template = [[
						<div>
							<q-badge
								:style="`
									width: 10;
									padding: 4px;
									background: ${this.$getModel('colorHex-]]..mod.name..[[')};
									color: ${this.$getModel('colorText-]]..mod.name..[[')};
								`"
								:label="this.$getModel('colorName-]]..mod.name..[[')"
								floating
							/>
							<span>]]..mod.name..[[</span>
						</div>
					]]
				},
				{
					template = [[
						<q-color
							flat
							square
							no-header
							no-footer
							default-view="palette"
							style="max-width: 10vmin"
							:palette="this.$getModel('palette')"
							@change="hex => this.$invoke('setColor', 'palette', ]]..index..[[, hex)"
						/>
					]],
				},
			},
		}

		local currentId = mod.getter(vehicle)
		local paletteModel = self:GetPaletteModel(mod.name, currentId)
		if paletteModel then
			for k, v in pairs(paletteModel) do
				defaults[k] = v
			end
		end

		table.insert(components, component)

		self.defaults.palettes[index] = currentId
	end

	local window = Window:Create({
		type = "window",
		title = "Paint",
		class = "compact",
		defaults = defaults,
		style = {
			["width"] = "40vmin",
			["height"] = "90vmin",
			["top"] = "8vmin",
			["left"] = "2vmin",
			["overflow"] = "visible !important",
		},
		prepend = Modding.prepend,
		components = {
			{
				class = "row justify-evenly q-pt-sm",
				components = components,
			}
		},
	})

	-- Window buttons.
	window:OnClick("save", function(window)
		Modding:Exit()
	end)

	window:OnClick("discard", function(window)
		Modding:Exit(true)
	end)

	-- Window events.
	window:AddListener("setColor", function(window, _type, index, hex)
		local isRgb = _type == "rgb"
		local mod = isRgb and Paint.colors[index] or Paint.palettes[index]
		if not mod then return end

		WaitForAccess(vehicle)
		
		if isRgb then
			local r, g, b = HexToRgb(hex)
			mod.setter(vehicle, r, g, b)
		else
			local id = Paint.paletteCache[hex]
			mod.setter(vehicle, id)

			local paletteModel = self:GetPaletteModel(mod.name, id)
			if paletteModel then
				for k, v in pairs(paletteModel) do
					window:SetModel(k, v)
				end
			end
		end
	end)

	return window
end

function Paint:Disable(vehicle, discard)
	if discard and self.defaults then
		WaitForAccess(vehicle)
		
		for k, v in pairs(self.defaults) do
			local funcs = self[k]
			for _k, _v in pairs(v) do
				local func = funcs[_k]
				local a, b, c
				if type(_v) == "table" then
					a, b, c = table.unpack(_v)
				else
					a = _v
				end

				func.setter(vehicle, a, b, c)
			end
		end
	end

	self.defaults = nil
end

function Paint:GetPalette()
	if self.generatedPalette then
		return self.generatedPalette
	end
	
	local sortedColors = {}
	for id, color in pairs(Colors) do
		local startIndex, endIndex = string.find(color.Name, "%s[^%s]*$")
		local sortBy = (not startIndex and color.Name or color.Name:sub(startIndex + 1)):lower()

		table.insert(sortedColors, {
			sortBy = sortBy,
			color = color,
			id = id,
		})
	end
	
	table.sort(sortedColors, function(a, b)
		return a.sortBy > b.sortBy
	end)

	self.paletteCache = {}
	
	local palette = {}
	for k, v in ipairs(sortedColors) do
		self.paletteCache[v.color.Hex] = v.id
		palette[k] = v.color.Hex
	end

	self.generatedPalette = palette

	return palette
end

function Paint:GetPaletteModel(name, id)
	if not id then return end

	local color = Colors[id]
	if not color then return end

	local r, g, b = HexToRgb(color.Hex)
	local brightness = RgbToLuminance(r, g, b)

	return {
		["colorText-"..name] = brightness > 0.5 and "black" or "white",
		["colorHex-"..name] = color.Hex,
		["colorName-"..name] = color.Name,
	}
end

--[[ Functions: Modding ]]--
Modding:RegisterItem("Paint Can", Paint)