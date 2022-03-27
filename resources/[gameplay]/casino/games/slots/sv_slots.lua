Slots.cache = {}
Slots.spinners = {}

--[[ Functions: Slots ]]--
function Slots:Init()
	for model, index in pairs(self.config.machines) do
		local model = self:GetSpinnerModel(index)
		self.cache[model] = true
	end
end

function Slots:RegisterSpinner(source, entity)
	local spinners = self.spinners[source]
	if not spinners then
		spinners = {}
		self.spinners[source] = spinners
	end

	table.insert(spinners, entity)

	if #spinners > 3 then
		local first = spinners[1]
		if DoesEntityExist(first) then
			DeleteEntity(first)
		end

		table.remove(spinners, 1)
	end
end

function Slots:ClearSpinners(source)
	local spinners = self.spinners[source]
	if not spinners then return end

	for k, entity in ipairs(spinners) do
		if DoesEntityExist(entity) then
			DeleteEntity(entity)
		end
	end

	self.spinners[source] = nil
end

function Slots:Spin(source)
	local results = {}
	for k, spinner in ipairs(self.config.spinners) do
		UpdateSeed()

		local random = math.random()
		local value = math.floor(random * self.config.sides)

		results[k] = value
	end

	TriggerClientEvent("casino:spinSlots", source, results)
end

--[[ Events ]]--
AddEventHandler("entityCreated", function(entity)
	if not entity or not DoesEntityExist(entity) then return end
	local model = GetEntityModel(entity)

	if Slots.cache[model] then
		local owner = NetworkGetEntityOwner(entity)
		Slots:RegisterSpinner(owner, entity)
	end
end)

AddEventHandler("playerDropped", function(reason)
	local source = source
	Slots:ClearSpinners(source)
end)

--[[ Events: Net ]]--
RegisterNetEvent("casino:spinSlots", function()
	local source = source
	Slots:Spin(source)
end)