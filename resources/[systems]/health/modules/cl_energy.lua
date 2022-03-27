--[[ Functions: Main ]]--
function Main.update:Energy()
	self:AddEffect("Energy", MinutesToTicks / Config.Energy.RegenRate)
end

function Main:CheckEnergy(amount, notify)
	local energy = self:GetEffect("Energy")
	local hasEnergy = energy > amount

	if not hasEnergy and notify then
		TriggerEvent("chat:notify", {
			text = ("Not enough energy (%.2f/%.2f)!"):format(energy, amount),
			class = "error",
		})
	end
	
	return hasEnergy
end
Export(Main, "CheckEnergy")

function Main:TakeEnergy(amount)
	self:AddEffect("Energy", -amount)
	self:Sync()
end
Export(Main, "TakeEnergy")