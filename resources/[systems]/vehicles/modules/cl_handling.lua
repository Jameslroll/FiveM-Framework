Handling = {
	cached = {},
	defaults = {},
	values = {},
}

--[[ Functions ]]--
function Handling:GetType(name)
	local fieldType = Config.Handling.Types[Config.Handling.Fields[name] or false]
	if not fieldType then
		error(("invalid handling field (%s)"):format(name))
	end

	return fieldType
end

function Handling:SetField(name, value)
	-- Get handling type.
	local fieldType = self:GetType(name)

	-- Cache value.
	self.values[name] = value

	-- Update field.
	fieldType.setter(self.vehicle, "CHandlingData", name, value)

	-- Needed for some values to work.
	ModifyVehicleTopSpeed(self.vehicle, 1.0)
end

function Handling:GetField(name, value)
	-- Get handling type.
	local fieldType = self:GetType(name)

	-- Return field.
	return fieldType.getter(self.vehicle, "CHandlingData", name)
end

function Handling:GetDefault(name)
	return self.defaults[name]
end

function Handling:SetModifier(name, func)
	local default = self:GetDefault(name)
	if not default then
		error(("no default when modifying handling (%s)"):format(name))
	end

	self:SetField(name, func(default))
end

function Handling:Init(vehicle)
	self.vehicle = vehicle
	self.defaults = {}
	
	for name, _type in pairs(Config.Handling.Fields) do
		self.defaults[name] = self:GetField(name)
		-- print(name, self.defaults[name])
	end

	print("Handling initialized")
	print("Mass", self.defaults["fMass"])
end

function Handling:Restore()
	for name, _type in pairs(Config.Handling.Fields) do
		local value = self.defaults[name]
		if value then
			self:SetField(name, value)
		end
	end
end

function Handling:CopyDefaults()
	local handling = {}
	for name, value in pairs(self.defaults) do
		handling[name] = value
	end
	return handling
end

-- function Handling:UpdateField(name, value)
-- 	self.cached[name] = value

-- 	-- Check cache.
-- 	if self.values[name] and self.values[name] - value < 0.01 then
-- 		return
-- 	end

-- 	-- Set field.
-- 	self:SetField(name, value)
-- end

--[[ Listeners ]]--
Main:AddListener("Enter", function(vehicle)
	Handling:Init(vehicle)
end)

Main:AddListener("Exit", function(vehicle)
	Handling:Restore()
end)

--[[ Events ]]--
AddEventHandler("vehicles:stop", function()
	if Handling.vehicle then
		Handling:Restore()
	end
end)