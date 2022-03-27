Inventory:AddHook("init", function()
	Inventory.money = {}

	for _, change in ipairs(Config.Change) do
		local item = Inventory:GetItem(change.Name)
		Inventory.money[item.id] = change
	end
end)

--[[ Functions: Container ]]--
function Container:CountMoney(checkWallet)
	if self:CompareSnowflake(self.moneySnowflake) then
		return self.money
	end
	
	local amount = 0.0

	for slotId, slot in pairs(self.slots) do
		local item = slot:GetItem()
		local change = Inventory.money[slot.item_id]
		if change then
			amount = amount + slot.quantity * change.Nominal
		elseif checkWallet and item.wallet then
			amount = amount + (slot.fields and slot.fields[1] or 0.0)
		end
	end
	
	self.moneySnowflake = self.snowflake
	self.money = amount

	return amount
end