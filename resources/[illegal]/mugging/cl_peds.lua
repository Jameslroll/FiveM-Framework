Ped = {}
Ped.__index = Ped

function Ped:Create(entity, canInteract)
	print("create", entity)

	-- Check armed.
	if IsPedArmed(entity, 4) then
		return false
	end

	-- Check ignore.
	math.randomseed(entity)
	if math.random() < Config.IngoreChance then
		if not IsPedFleeing(entity) then
			WaitForAccess(entity)
			TaskReactAndFleePed(entity, PlayerPedId())
		end
		return false
	end

	-- Get hostile.
	math.randomseed(entity + 821)

	local isImmune = false
	local isHostile = math.random() < Config.HostileChance and not isImmune
	
	-- Create ped.
	local netId = PedToNet(entity)
	local ped = setmetatable({
		confidence = GetRandomFloatInRange(0.0, 0.1),
		delay = GetRandomIntInRange(1000, 3000),
		entity = entity,
		isHostile = isHostile,
		isImmune = isImmune,
		netId = netId,
		startTime = GetGameTimer(),
	}, Ped)

	-- Cache ped.
	Main.peds[entity] = ped

	-- Update entity.
	if canInteract then
		WaitForAccess(entity)
		TaskSetBlockingOfNonTemporaryEvents(entity, true)
		SetPedFleeAttributes(entity, 15, false)
	end

	return ped
end

function Ped:Destroy(isHard)
	local ped = self.entity
	print("destroy")

	-- Unregister state.
	self:SetState(false)

	-- Remove forever.
	if isHard then
		ClearPedTasks(ped)
		SetPedFleeAttributes(ped, 15, true)
		TaskSetBlockingOfNonTemporaryEvents(ped, false)
		TaskReactAndFleePed(ped, PlayerPedId())
		TriggerServerEvent("mugging:destroy", self.netId)
	end
	
	-- Unregister interactable.
	if self.interactable then
		exports.interact:Destroy(self.interactable)
		exports.interact:ClearOptions(ped)
	end
	
	-- Uncache ped.
	if Main.peds[ped] then
		Main.peds[ped] = nil
	end
end

function Ped:Update(canInteract)
	local ped = self.entity

	-- Check valid.
	if not Main:IsValidTarget(ped) then
		self:Destroy()
		return
	end

	-- Get entity.
	local entity = Entity(self.entity)
	if not entity then return end

	-- Check interaction.
	local mugging = entity.state.mugging or 0
	if (not canInteract and mugging <= 0) or entity.state.mugged then
		self:Destroy()
		return
	elseif not canInteract and self.state and mugging == 1 then
		self:Challenge()
		return
	elseif (self.state or false) ~= canInteract then
		self:SetState(canInteract)
	end

	-- Update interactable.
	self:UpdateInteractable()

	-- Check reaction delay.
	if not canInteract or self:GetLifetime() < self.delay then return end

	-- Random delete.
	if GetRandomFloatInRange(0.0, 1.0) < Config.DeleteChance / mugging then
		self:Destroy(true)
		return
	end

	-- Get player.
	local playerPed = PlayerPedId()
	local forward = GetEntityForwardVector(playerPed)

	-- Get ped.
	local coords = GetEntityCoords(ped)
	local dir = coords - GetEntityCoords(playerPed)
	local dist = #dir
	local dot = Dot(forward, dir / dist)
	
	-- Check cone.
	if dot < Config.MinDot then return end

	-- Confidence.
	self.confidence = math.max(self.confidence - Config.ConfidenceRate, 0.0)

	-- Request access.
	WaitForAccess(ped)

	-- Check hostility.
	if self.isHostile then
		if not IsPedInCombat(ped) then
			ClearPedSecondaryTask(ped)
			GiveWeaponToPed(ped, Config.Weapon, 60, true, true)
			SetPedCombatMovement(ped, 1)
			SetPedCombatAbility(ped, 0)
			SetPedCombatAttributes(ped, 1, true)
			SetPedCombatAttributes(ped, 2, true)
			SetPedCombatAttributes(ped, 3, true)
			SetPedCombatAttributes(ped, 46, true)
			TaskCombatPed(ped, playerPed, 0, 16)
		end

		return
	end

	-- Armed robbery.
	Citizen.CreateThread(function()
		local startTime = GetGameTimer()
		while GetGameTimer() - startTime < 1000 do
			-- exports.peds:AddEvent("robbing", GetEntityCoords(PlayerPedId()), ped)
			Citizen.Wait(200)
		end
	end)

	-- Exit vehicle.
	if GetGameTimer() - (self.leaveAt or 0.0) < 3000 then return end

	if IsPedInAnyVehicle(ped) then
		local speed = GetEntitySpeed(ped)
		if speed > Config.MaxSpeed then return end

		local vehicle = GetVehiclePedIsIn(ped, false)
		local isDriver = GetPedInVehicleSeat(vehicle, -1) == ped

		if isDriver then
			WaitForAccess(vehicle)
			SetVehicleEngineOn(vehicle, false, true, true)
			SetVehicleDoorsLocked(vehicle, 2)
		end

		TaskLeaveVehicle(ped, vehicle, 256)
		
		self.leaveAt = GetGameTimer()
		
		return
	end

	-- print("action", IsPedInAnyVehicle(ped, true))

	-- Actions.
	if entity.state.action ~= nil then return end

	-- Make look.
	local isTurning = GetIsTaskActive(ped, 225)
	if isTurning then return end
	
	if dist > Config.RobDistance and not IsPedFacingPed(ped, playerPed, 90.0) then
		ClearPedTasks(ped)
		TaskTurnPedToFaceEntity(ped, playerPed, 2000)
		return
	end

	-- Hands up.
	self:PlayAnim(Config.Anims.HandsUp)
end

function Ped:UpdateInteractable()
	if self.interactable then return end

	local id = "mugging-"..tostring(self.entity)
	local embedded = {}
	
	self.interactable = id

	for k, action in pairs(Config.Actions) do
		action.id = id.."-"..action.action
		action.ped = self.entity

		embedded[k] = action
	end
	
	exports.interact:Register({
		id = id,
		embedded = embedded,
		entity = self.entity,
		event = "mug",
	})
end

function Ped:PlayAnim(emote)
	local ped = self.entity

	-- Check time.
	if GetGameTimer() - (self.lastAnimTime or 0) < 1000 then
		return false
	end

	-- Check already playing.
	if IsEntityPlayingAnim(ped, emote.Dict, emote.Name, 3) then
		return false
	end

	-- Load anim dict.
	while not HasAnimDictLoaded(emote.Dict) do
		RequestAnimDict(emote.Dict)
		Citizen.Wait(20)
	end

	-- Request access.
	WaitForAccess(ped)

	-- Play anim.
	ClearPedTasks(ped)
	TaskPlayAnim(ped, emote.Dict, emote.Name, 3.0, 3.0, -1, emote.Flag, 0.0, false, false, false)
	PlayPedAmbientSpeechNative(ped, "APOLOGY_NO_TROUBLE", "SPEECH_PARAMS_STANDARD")

	-- Cache time.
	self.lastAnimTime = GetGameTimer()

	return true
end

function Ped:SetState(state)
	if self.state == (state or nil) then return end
	self.state = state or nil

	print("set state", self.state)
	
	TriggerServerEvent("mugging:interact", self.netId, state)
end

function Ped:Challenge()
	print("challenge")
	local ped = self.entity
	print(self.confidence)
	if GetRandomFloatInRange(0.0, 1.0) < Config.FleeMult * self.confidence then
		WaitForAccess(ped)

		ClearPedTasks(ped)
		TaskSetBlockingOfNonTemporaryEvents(ped, false)
		SetPedFleeAttributes(ped, 15, true)
		TaskReactAndFleePed(ped, PlayerPedId())

		print("challenge accepted")

		self:Destroy()
	else
		self.confidence = math.min(self.confidence + Config.ConfidenceRate, 1.0)
	end
end

function Ped:GetLifetime()
	return GetGameTimer() - self.startTime
end

--[[ Events ]]--
AddEventHandler("interact:on_mug", function(interactable)
	-- Get action.
	local action = interactable.action
	if action == nil then return end

	-- Check ped.
	local entity = interactable.ped or 0
	if not DoesEntityExist(entity) then return end

	local ped = Main.peds[entity]
	if ped == nil then return end

	-- Invoke action.
	ped:PerformAction(action)
end)