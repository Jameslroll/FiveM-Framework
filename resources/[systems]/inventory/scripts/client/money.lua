--[[ Functions: Inventory ]]--
function Inventory:CanAfford(amount, checkWallet)
	local container = self:GetPlayerContainer()
	if not container then return false end

	return (container:CountMoney(checkWallet) or 0.0) >= amount
end
Inventory:Export("CanAfford")

function Inventory:CountMoney(amount, checkWallet)
	local container = self:GetPlayerContainer()
	if not container then return false end

	return container:CountMoney(amount, checkWallet)
end
Inventory:Export("CountMoney")