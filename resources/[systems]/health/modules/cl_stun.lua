--[[ Functions: Main ]]--
function Main.update:Stun()
	local rage = self:GetEffect("Rage") or 0.0

	SetPedMinGroundTimeForStungun(Ped, math.max(math.floor(GetRandomIntInRange(6000, 9000) * (1.0 - rage)), 20))

	local stunned = IsPedBeingStunned(Ped)
	if self.stunned ~= stunned then
		self.stunned = stunned

		if stunned then
			self:AddEffect("Fatigue", GetRandomFloatInRange(0.05, 0.1))
		end
	end
end