--[[ Functions: Main ]]--
function Main.update:Nutrition()
	if GetPlayerInvincible(PlayerId()) then
		return
	end

	local isSprinting = IsPedSprinting(Ped)
	local isRunning = IsPedRunning(Ped)
	local isWalking = IsPedWalking(Ped)
	local modifier = (
		(isSprinting and Config.Nutrition.Modifiers.Sprint) or
		(isRunning and Config.Nutrition.Modifiers.Run) or
		(isWalking and Config.Nutrition.Modifiers.Walk) or
		1.0
	)

	-- Update effects.
	local hunger = math.max((self:GetEffect("Hunger") or 1.0) - MinutesToTicks / Config.Nutrition.Rates.Hunger * modifier, 0.0)
	local thirst = math.max((self:GetEffect("Thirst") or 1.0) - MinutesToTicks / Config.Nutrition.Rates.Thirst * modifier, 0.0)

	self:SetEffect("Hunger", hunger)
	self:SetEffect("Thirst", thirst)

	-- Update health.
	IsStarving = hunger < 0.001
	IsDehydrated = thirst < 0.001

	if IsStarving then
		self:AddEffect("Health", -MinutesToTicks / Config.Nutrition.Damage.Hunger)
	end
	
	if IsDehydrated then
		self:AddEffect("Health", -MinutesToTicks / Config.Nutrition.Damage.Thirst)
	end

	-- Visual queues.
	if (IsStarving or IsDehydrated) and (not self.nextShake or GetGameTimer() > self.nextShake) then
		ShakeGameplayCam("JOLT_SHAKE", GetRandomFloatInRange(0.2, 0.6))
		self.nextShake = GetGameTimer() + GetRandomIntInRange(1500, 3000)
	end

	if (IsStarving or IsDehydrated) and (not self.nextSound or GetGameTimer() > self.nextSound) then
		TriggerEvent("playSound", "tummy", GetRandomFloatInRange(0.3, 0.6))
		self.nextSound = GetGameTimer() + GetRandomIntInRange(12000, 24000)
	end

	-- Update sprint.
	local isDying = IsStarving or IsDehydrated
	if isDying ~= WasMalnourished then
		SetPlayerSprint(PlayerId(), not isDying)
		WasMalnourished = isDying
	end
end

--[[ Events ]]--
AddEventHandler("inventory:use", function(item, slot, cb)
	-- Check durability.
	if (slot.durability or 1.0) < 0.001 then return end

	-- Check item is usable.
	local anim = item.usable and Config.Nutrition.Anims[item.usable]
	if not anim then return end

	-- Get values.
	local hunger = item.hunger or 0.0
	local thirst = item.thirst or 0.0

	-- Check stats.
	if (
		(hunger > 0.001 and Main:GetEffect("Hunger") >= 0.9) or
		(thirst > 0.001 and Main:GetEffect("Thirst") >= 0.9)
	) then
		TriggerEvent("chat:notify", {
			class = "error",
			text = "I'm too full...",
		})

		return
	end

	-- Get prop.
	local prop = anim.Props[1]
	if not prop then return end

	-- Update prop.
	prop.Model = item.model
	prop.Offset = item.offset or { 0.0, 0.0, 0.0, 0.0, 0.0, 0.0 }

	-- Update anim.
	anim.Duration = item.duration or 12000

	cb(anim.Duration, anim)
end)

AddEventHandler("inventory:useFinish", function(item, slot)
	if item.hunger then Main:AddEffect("Hunger", item.hunger) end
	if item.thirst then Main:AddEffect("Thirst", item.thirst) end
	if item.comfort then Main:AddEffect("Comfort", item.comfort) end
	if item.energy then Main:AddEffect("Energy", item.energy) end
end)