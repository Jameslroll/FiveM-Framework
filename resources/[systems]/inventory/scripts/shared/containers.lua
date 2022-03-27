Container = Container or {}
Container.__index = Container

--[[ Functions: Container ]]--
function Container:IsVirtual()
	return self.coords == nil
end

function Container:GetSettings(key)
	local settings = self.settings or Config.Containers[self.type or "default"] or Config.Containers["default"]
	if key ~= nil and settings ~= nil then
		return settings[key]
	end
	return settings
end

function Container:Get(key)
	return self[key]
end

function Container:UpdateSnowflake()
	if self.snowflake == nil then
		self.snowflake = 1
	else
		self.snowflake = self.snowflake + 1
	end
end

function Container:CompareSnowflake(snowflake)
	return self.snowflake ~= nil and self.snowflake == snowflake
end

function Container:GetWeight()
	if self:CompareSnowflake(self.weightSnowflake) then
		return self.weight
	else
		return self:UpdateWeight()
	end
end

function Container:UpdateWeight()
	local weight = 0.0
	for id, slot in pairs(self.slots) do
		weight = weight + slot:GetWeight()
	end

	self.weightSnowflake = self.snowflake
	self.weight = weight

	Debug("Update weight: %s %s", self.id, self.weight)

	return weight
end

function Container:CanCarry(weight)
	local maxWeight = self.maxWeight or self:GetSettings("maxWeight")
	if not maxWeight then return true end
	
	weight = weight + self:GetWeight()

	if self.IsNested ~= nil and self:IsNested() then
		local parent = self:GetParent()
		while parent ~= nil and parent:IsNested() do
			weight = weight + parent:GetWeight()
			parent = parent:GetParent()
		end
	end

	return weight < maxWeight + 0.0001
end

function Container:GetSize()
	local settings = self:GetSettings()
	return (self.width or settings.width) * (self.height or settings.height)
end

--[[ Functions: Inventory ]]--
function Inventory:GetContainer(id)
	return self.containers[id or false]
end
Inventory:Export("GetContainer")

function Inventory:GetFromContainer(id, key)
	local container = self.containers[id or false]
	if not container then return end

	return container[key or false]
end
Inventory:Export("GetFromContainer")

--[[ Threads ]]--
Citizen.CreateThread(function()
	for k, v in pairs(Container) do
		if type(v) == "function" then
			local name = "Container"..k
			Debug("Export: %s", name)
			exports(name, function(id, ...)
				if id == "self" then
					id = Inventory.selfContainer
				end

				local container = Inventory:GetContainer(id or false)
				if container == nil then return end

				return container[k](container, ...)
			end)
		end
	end
end)