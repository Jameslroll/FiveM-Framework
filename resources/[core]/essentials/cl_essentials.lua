Main = {
	funcs = {},
	lastRagdoll = 0,
}

--[[ Functions: Main ]]--
function Main:Init()
end

function Main:UpdateFrame()
	Ped = PlayerPedId()
	Player = PlayerId()
	IsRagdoll = IsPedRagdoll(Ped)

	self:UpdateMelee()

	-- Variables.
	local isArmedExplosives = IsPedArmed(Ped, 2)
	local isArmedMelee = IsPedArmed(Ped, 1)
	local isArmedOther = IsPedArmed(Ped, 4)

	-- Disable dispatch services.
	for service, toggle in pairs(Config.DispatchServices) do
		EnableDispatchService(service, toggle)
	end

	-- Disable unarmed attacks.
	if (isArmedOther or isArmedExplosives or not IsControlPressed(0, 25)) and not isArmedMelee then
		for _, control in ipairs(Config.UnarmedDisabled) do
			DisableControlAction(0, control)
		end
	end

	-- Ragdolling.
	if IsRagdoll ~= self.ragdoll then
		self.lastRagdoll = GetGameTimer()
		self.ragdoll = IsRagdoll
	end

	-- Tripping.
	if (not self.nextTripCheck or GetGameTimer() > self.nextTripCheck) and not IsPedOpeningADoor(ped) then
		self.shouldTrip = GetRandomFloatInRange(0.0, 1.0) < 0.2
		self.nextTripCheck = GetGameTimer() + 1000
	end

	SetPedRagdollOnCollision(Ped,
		GetGameTimer() - self.lastRagdoll > 4000 and
		self.shouldTrip and
		(IsPedRunning(Ped) or IsPedSprinting(Ped)) and
		GetFollowPedCamViewMode() ~= 4 and
		not IsRagdoll and
		not IsPedGettingUp(Ped) and
		not GetPedConfigFlag(Ped, 147) and
		not GetPedConfigFlag(Ped, 148)
	)

	-- Disable reticle.
	HideHudComponentThisFrame(14)

	-- Camera stuff.
	SetFollowPedCamThisUpdate("FOLLOW_PED_ON_EXILE1_LADDER_CAMERA", 0)

	local zoomMode = GetFollowPedCamViewMode(Ped)

	-- Anti combat roll/jump spam.
	local lastJump = self.lastJump and GetGameTimer() - self.lastJump
	local canJump = not lastJump or lastJump > 2000

	if not canJump then
		SetPedMoveRateOverride(Ped, lastJump and (math.cos(lastJump / 2000.0 * 2.0 * math.pi) * 0.3 + 0.7) or 1.0)
		DisableControlAction(0, 22)
	elseif IsControlJustPressed(0, 22) then
		if GetPedConfigFlag(Ped, 78) then
			TriggerEvent("roll")
		end

		self.lastJump = GetGameTimer()
	end

	if self.canJump ~= canJump then
		if canJump then
			SetPedMoveRateOverride(Ped, 1.0)
		end
		self.canJump = self.canJump
	end

	-- Update ped.
	if self.ped ~= Ped then
		self.ped = Ped
		self:UpdatePed()
	end
end

function Main:UpdateSlow()
	Ped = PlayerPedId()
	Player = PlayerId()

	-- Turn friendly fire on.
	NetworkSetFriendlyFireOption(true)

	-- Disable idle camera.
	InvalidateIdleCam()
	InvalidateVehicleIdleCam()

	-- Reset wanted level.
	if GetPlayerWantedLevel(Player) ~= 0 then
		SetPlayerWantedLevel(Player, 0, false)
		SetPlayerWantedLevelNow(Player, false)
		SetMaxWantedLevel(0)
	end

	-- Disable action mode.
	if IsPedUsingActionMode(Ped) then
		SetPedUsingActionMode(Ped, false, -1, 0)
	end
	
	for _, ped in ipairs(GetGamePool("CPed")) do
		SetPedDropsWeaponsWhenDead(ped, false)
	end
end

function Main:UpdateSlower()
	for _, model in ipairs(Config.SuppressedModels) do SetVehicleModelIsSuppressed(model, true) end
	for _, scenario in ipairs(Config.DisabledGroups) do SetScenarioGroupEnabled(scenario, false) end
	for _, scenario in ipairs(Config.DisabledTypes) do SetScenarioTypeEnabled(scenario, false) end

	SetPoliceRadarBlips(false)
	DistantCopCarSirens(false)
end

function Main:UpdatePed()
	for flagId, value in pairs(Config.Flags) do
		SetPedConfigFlag(Ped, flagId, value)
	end
end

function Main:UpdateMelee()
	-- Update melee.
	for _, control in ipairs(Config.UnarmedDisabled) do
		if IsControlJustPressed(0, control) then
			self.lastMelee = GetGameTimer()
			break
		end
	end

	-- Cooldown disable.
	local disableMelee = GetGameTimer() - (self.lastMelee or 0) < Config.Melee.Cooldown
	if disableMelee then
		for _, control in ipairs(Config.UnarmedDisabled) do
			DisableControlAction(0, control)
		end
	end
end

--[[ Threads ]]--
Citizen.CreateThread(function()
	Main:Init()
end)

Citizen.CreateThread(function()
	while true do
		Main:UpdateFrame()

		Citizen.Wait(0)
	end
end)

Citizen.CreateThread(function()
	while true do
		Main:UpdateSlow()

		Citizen.Wait(200)
	end
end)

Citizen.CreateThread(function()
	while true do
		Main:UpdateSlower()

		Citizen.Wait(2000)
	end
end)