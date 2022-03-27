--[[ Functions: Inventory ]]--
function Inventory:UpdateDecay()
	local updated = {}
	for containerId, container in pairs(self.containers) do
		local settings = container:GetSettings() or {}
		for slotId, slot in pairs(container.slots) do
			if not updated[slot.id] then
				if slot:UpdateDecay(settings.decayRate) then
					updated[slot.id] = true
					didUpdate = true

					Citizen.Wait(0)
				end
			end
		end
	end
end

--[[ Functions: Slots ]]--
function Slot:UpdateDecay(multiplier)
	-- Get item.
	local item = self:GetItem()
	if not item or item.decay == nil then return false end
	
	-- Get decay time.
	local time = nil
	
	if type(item.decay) == "table" then
		time = item.decay.time
	else
		time = item.decay
	end

	if not time then return false end

	-- Decay slot.
	return self:Decay(nil, true, multiplier)
end

function Slot:Decay(amount, setLastUpdate, multiplier)
	local item = self:GetItem()
	local isDecayTable = type(item.decay) == "table"
	local container = self:GetContainer()
	local lastDurability = self.durability or 1.0

	-- Get amount.
	if amount == nil then
		local time = nil
		if isDecayTable then
			time = item.decay.time
		else
			time = item.decay
		end
		if not time then return false end
		local delta = (os.time() * 1000.0 - (self.last_update or os.time() * 1000.0)) / 60000.0
		amount = delta / time
	end

	-- Update durability.
	if not amount then return end
	self.durability = math.max((self.durability or 1.0) - amount * (multiplier or 1.0), 0.0)

	-- Check destroyed.
	local isDestroyed = self.durability < 0.001

	if isDestroyed and (not isDecayTable or item.decay.destroy) then
		-- Destroy slot.
		self:Destroy()
	elseif lastDurability > 0.001 then
		-- Save and inform.
		self:Save(setLastUpdate)
		container:InformSlots(self.slot_id)
	end

	return true
end

--[[ Threads ]]--
Citizen.CreateThread(function()
	while true do
		Inventory:UpdateDecay()

		Citizen.Wait(30000)
	end
end)