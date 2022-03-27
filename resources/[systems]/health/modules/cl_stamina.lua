--[[ Functions: Main ]]--
function Main.update:Stamina()
	if GetPlayerInvincible(PlayerId()) then
		return
	end
	
	local isUnderWater = IsPedSwimmingUnderWater(Ped)
	local isSwimming = IsPedSwimming(Ped)
	local isSprinting = IsPedSprinting(Ped)
	local isRunning = IsPedRunning(Ped)
	local oxygen = self:GetEffect("Oxygen")

	if not isUnderWater and IsPedInAnyVehicle(Ped) then
		local vehicle = GetVehiclePedIsIn(Ped)
		if GetVehicleClass(vehicle) ~= 14 and GetEntitySubmergedLevel(vehicle) > 0.9 then
			isUnderWater = true
		end
	end

	-- Ignore vanilla stamina.
	ResetPlayerStamina(Player)

	-- Get rates group.
	local rates = (
		(isUnderWater and Config.Stamina.UnderWater) or
		(isSwimming and Config.Stamina.Swimming) or
		Config.Stamina.Land
	)

	-- Get loss rate.
	local lossRate = rates[(isSprinting and "Sprint") or (isRunning and "Run") or "Normal"]

	if lossRate then
		-- Take health.
		if oxygen < 0.001 and rates.HealthLoss then
			self:AddEffect("Health", MinutesToTicks / -rates.HealthLoss)
		end
		
		-- Take oxygen.
		self:AddEffect("Oxygen", MinutesToTicks / -lossRate)
	else
		-- Regenerate oxygen.
		self:AddEffect("Oxygen", MinutesToTicks / Config.Stamina.RegenRate)
	end
end