--[[ Functions: Main ]]--
function Main.update:Stress()
	local stress = self:GetEffect("Stress")
	
	if stress > 0.01 and GetGameTimer() > (self.nextStress or 0) then
		ShakeGameplayCam(Config.Stress.Shake, stress * Config.Stress.Intensity)

		local delay =
			Config.Stress.Delay[1] + (Config.Stress.Delay[2] - Config.Stress.Delay[1]) * stress +
			GetRandomIntInRange(table.unpack(Config.Stress.RandomDelay))

		self.nextStress = GetGameTimer() + delay
	end
end

--[[ Events ]]--
AddEventHandler("shoot", function(didHit, coords, hitCoords, entity, weapon)
	if GetPlayerInvincible(PlayerId()) then
		return
	end
	
	Main:AddEffect("Stress", Config.Stress.PerShot)
end)