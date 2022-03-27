--[[ Hooks ]]--
Inventory:AddHook("itemAdded", function(container, slot, amount)
	local settings = container:GetSettings()
	if settings and settings.wallet then
		container:UpdateMoney()
	end
end)

Inventory:AddHook("slotMoved", function(sourceContainer, sourceSlot, targetContainer, targetSlot)
	if sourceContainer.id == targetContainer.id then return end
	
	local sourceSettings = sourceContainer:GetSettings()
	if not sourceSettings then return end

	local targetSettings = targetContainer:GetSettings()
	if not targetSettings then return end

	if sourceSettings.wallet then
		sourceContainer:UpdateMoney()
	end

	if targetSettings.wallet then
		targetContainer:UpdateMoney()
	end
end)

--[[ Functions: Inventory ]]--
function Inventory:CanAfford(source, amount)
	local container = self:GetPlayerContainer(source)
	if not container then return false end

	return (container:CountMoney() or 0.0) >= amount
end
Inventory:Export("CanAfford")

function Inventory:CountMoney(source, amount, checkWallet)
	local container = self:GetPlayerContainer(source)
	if not container then return false end

	return container:CountMoney(amount, checkWallet)
end
Inventory:Export("CountMoney")

function Inventory:GiveMoney(source, amount)
	local container = self:GetPlayerContainer(source)
	if not container then return false end

	return container:AddMoney(amount)
end
Inventory:Export("GiveMoney")

function Inventory:TakeMoney(source, amount)
	-- Get container.
	local container = self:GetPlayerContainer(source)
	if not container then return false end

	-- Count money.
	if (container:CountMoney() or 0.0) < amount then
		return false
	end

	return container:RemoveMoney(amount)
end
Inventory:Export("TakeMoney")

--[[ Functions: Container ]]--
function Container:UpdateMoney()
	-- Get parent.
	local parent = self:GetParent()
	if parent == nil then return end

	-- Get slot.
	local slot = parent.slots[self.slot_id]

	-- Set field.
	local money = self:CountMoney()
	slot:SetField(1, money)
end

function Container:CalculateMoneyInput(amount)
	local weight = 0.0
	local output = {}
	
	for _, change in ipairs(Config.Change) do
		if not change.Weight then
			local item = Inventory:GetItem(change.Name)
			change.Weight = item and item.weight or 0.0
		end

		local count = math.floor(amount / change.Nominal)

		amount = amount - count * change.Nominal
		
		if count > 0 then
			output[change.Name] = {
				quantity = count,
				amount = count * change.Nominal,
			}

			weight = weight + count * change.Weight
		end

		if amount <= 0 then
			break
		end
	end

	return output
end

function Container:AddMoney(amount)
	local added = 0.0

	if amount < 0.001 then
		return added
	end
	
	local input = self:CalculateMoneyInput(amount)
	for name, entry in pairs(input) do
		if self:AddItem(name, entry.quantity) then
			added = added + entry.amount or 0.0
		end
	end

	return added
end

function Container:RemoveMoney(amount)
	local _amount = amount
	local slots = {}
	local change = {}

	for slotId, slot in pairs(self.slots) do
		local item = slot:GetItem()
		local change = Inventory.money[slot.item_id]
		if change then
			slots[#slots + 1] = {
				slot = slot,
				nominal = change.Nominal,
			}
		end
	end

	table.sort(slots, function(a, b)
		return a.nominal < b.nominal
	end)

	local coords = self:GetCoords()
	local drop = nil

	for k, v in ipairs(slots) do
		local slot = v.slot
		local nominal = v.nominal
		
		if _amount > nominal then
			-- Calculate as much as possible.
			local value = math.min(slot.quantity * nominal, _amount)
			local quantity = math.floor(value / nominal)

			-- Take from slot.
			if not slot:Subtract(quantity) then
				return false, "failed to take from slot"
			end

			-- Reduce amount.
			_amount = _amount - value
		else
			-- Calculate as little as possible.
			local change = nominal - _amount
			
			-- Take from slot.
			if not slot:Subtract(1) then
				return false, "failed to take from slot"
			end

			-- Clear amount.
			_amount = 0.0

			-- Give change.
			if change > 0.001 then
				local input = self:CalculateMoneyInput(change)
				for name, entry in pairs(input) do
					-- Try to add the change to the container.
					if not self:AddItem(name, entry.quantity) then
						-- Create a drop for the change.
						if not drop and coords then
							drop = Inventory:RegisterContainer({
								coords = coords,
								type = "drop",
								temporary = true,
							})

							drop:Subscribe(self.owner, true)
						end

						-- Add the change to the drop.
						if drop then
							drop:AddItem(name, entry.quantity)
						end
					end
				end
			end
		end

		if _amount < 0.001 then
			return true
		end
	end

	return false, "failed to reduce"
end