-- { Dict = "mp_arresting", Name = "idle", Flag = 0 },
Restraints = Restraints or {}

Restraints.controls = {
	22, -- INPUT_JUMP
	24, -- INPUT_ATTACK
	25, -- INPUT_AIM
	45, -- INPUT_RELOAD
	46, -- INPUT_TALK
	47, -- INPUT_DETONATE
	51, -- INPUT_CONTEXT
	52, -- INPUT_CONTEXT_SECONDARY
	55, -- INPUT_DIVE
	58, -- INPUT_THROW_GRENADE
	59, -- INPUT_VEH_MOVE_LR
	68, -- INPUT_VEH_AIM
	69, -- INPUT_VEH_ATTACK
	70, -- INPUT_VEH_ATTACK2
	74, -- INPUT_VEH_HEADLIGHT
	76, -- INPUT_VEH_HANDBRAKE
	101, -- INPUT_VEH_ROOF
	140, -- INPUT_MELEE_ATTACK_LIGHT
	141, -- INPUT_MELEE_ATTACK_HEAVY
	142, -- INPUT_MELEE_ATTACK_ALTERNATE
	143, -- INPUT_MELEE_BLOCK
	144, -- INPUT_PARACHUTE_DEPLOY
	145, -- INPUT_PARACHUTE_DETACH
	257, -- INPUT_ATTACK2
	263, -- INPUT_MELEE_ATTACK1
	264, -- INPUT_MELEE_ATTACK2
}

--[[ Functions: Restraints ]]--
function Restraints:Start(name)
	if self.active then return end
	local ped = PlayerPedId()
	
	-- Update cache.
	self.active = true
	self.freeing = nil

	-- Update ped.
	SetPedConfigFlag(ped, 146, true)
	SetPedConfigFlag(ped, 120, true)
	SetEnableHandcuffs(ped, true)

	-- Disarm weapon.
	TriggerEvent("disarmed")

	-- Update state.
	LocalPlayer.state:set("restrained", name, true)
end

function Restraints:Stop()
	if not self.active then return end
	local ped = PlayerPedId()
	
	-- Clear cache.
	self.active = nil
	self.freeing = nil

	-- Update ped.
	SetPedConfigFlag(ped, 146, false)
	SetPedConfigFlag(ped, 120, false)
	SetEnableHandcuffs(ped, false)

	-- Update state.
	LocalPlayer.state:set("restrained", nil, true)
end

function Restraints:UpdateEmote()
	local state = LocalPlayer.state or {}

	-- Play emote.
	local ped = PlayerPedId()
	local active = (
		self.active and
		not self.freeing and
		not state.immobile and
		not state.carrier and
		not IsPedGettingUp(ped) and
		not IsPedRagdoll(ped)
	)

	if active and not self.emote then
		self.emote = exports.emotes:Play(self.anims.cuffed)
	elseif not active and self.emote then
		exports.emotes:Stop(self.emote, false)
		self.emote = nil
	end

	if not self.active then return end

	-- Disable controls.
	for _, control in ipairs(self.controls) do
		DisableControlAction(0, control)
	end
end

function Restraints:UpdateState(delta)
	if not self.active then return end
	
	-- Check dead.
	local state = LocalPlayer.state or {}
	if state.immobile then return end

	-- Get ped stuff.
	local ped = PlayerPedId()
	local chance = 0.0
	local isRagdoll = IsPedRagdoll(ped)
	local isMoving = GetEntitySpeed(ped) > 0.1

	-- Cache ragdoll.
	if isRagdoll ~= self.ragdoll then
		self.ragdollTime = GetGameTimer()
		self.ragdoll = isRagdoll
	end

	-- Sprinting.
	if IsPedSprinting(ped) then
		chance = chance + 0.25
	elseif IsPedRunning(ped) then
		chance = chance + 0.05
	end

	-- Stairs.
	if not IsPedStill(ped) and GetPedConfigFlag(ped, 253) then
		chance = chance * 2.0
	end

	-- Check fatigue.
	local fatigue = exports.health:GetEffect("Fatigue") or 0.0
	
	-- Ragdoll chance.
	local shouldRagdoll = GetRandomFloatInRange(0.0, 1.0) < chance / delta * (fatigue * 0.8 + 0.2)
	if shouldRagdoll then
		SetPedToRagdoll(ped, 1000, 0, 3, true, true, false)
	end

	-- Water.
	if IsPedSwimming(ped) and (exports.health:GetEffect("Health") or 1.0) > 0.01 then
		exports.health:SetEffect("Health", 0.0)
	end

	-- Disable interact.
	TriggerEvent("interact:suppress")
end

function Restraints:UseItem(item, slot)
	self.using = nil
	self.target = nil

	-- Get info.
	local name = item.name
	local info = Restraints.items[name]
	if not info then return false end
	
	-- Check ped.
	local ped = PlayerPedId()
	if IsPedInAnyVehicle(ped) then
		return false
	end

	-- Get player.
	local player, playerPed, playerDist = GetNearestPlayer()
	if not player or playerDist > Config.MaxDist then return false end
	-- local player = PlayerId()

	local serverId = GetPlayerServerId(player)
	local playerState = (Player(serverId) or {}).state

	-- Check vehicle.
	if IsPedInAnyVehicle(playerPed) then
		return false
	end

	if not playerState.immobile then
		-- Check direciton.
		local forward = GetEntityForwardVector(ped)
		local playerForward = GetEntityForwardVector(playerPed)
		local dot = Dot(forward, playerForward)
		if dot < 0.5 then return false end

		-- Check behind.
		local coords = GetEntityCoords(ped)
		local playerCoords = GetEntityCoords(playerPed)
		local dir = Normalize(playerCoords - coords)
		local forwardDot = Dot(forward, dir)
		if forwardDot < 0.0 then return false end
	end

	-- Get restrained.
	local restrained = playerState and playerState.restrained
	local stateInfo = restrained and self.items[restrained]

	-- Check counters.
	if (info.Restraint and restrained) or (not info.Restraint and (not stateInfo or not stateInfo.Counters[name])) then return false end

	-- For shared emotes.
	local anim
	if info.Shared then
		TriggerServerEvent("players:restrain", slot.slot_id, GetPlayerServerId(player))
	elseif info.Anim then
		anim = self.anims[info.Anim]
		self.using = slot
		self.target = GetPlayerServerId(player)
	end

	return true, info.Duration, anim
end

function Restraints:CanResist()
	local state = (LocalPlayer or {}).state
	local ped = PlayerPedId()

	return (
		state and
		not state.immobile
	)
end

--[[ Events: Net ]]--
RegisterNetEvent("players:restrainFinish", function(name)
	local info = name and Restraints.items[name]
	if info and info.Restraint then
		Restraints:Start(name)
	else
		Restraints:Stop()
	end
end)

RegisterNetEvent("players:restrainBegin", function(name)
	local info = Restraints.items[name]
	if not info then return end

	if info.Resist and Restraints:CanResist() then
		local success = exports.quickTime:Begin({ speed = 1.4, goalSize = 0.2 })
		if success then
			TriggerServerEvent("players:restrainResist")
		end
	end

	if not info.Restraint then
		Restraints.freeing = true
	end
end)

--[[ Events ]]--
AddEventHandler("emotes:cancel", function(id)
	if Restraints.emote == id then
		Restraints.emote = nil
	end
end)

AddEventHandler("inventory:use", function(item, slot, cb)
	local success, duration, anim = Restraints:UseItem(item, slot)
	if success then
		cb(duration, anim)
		return
	end
end)

AddEventHandler("inventory:useFinish", function(item, slot)
	local using = Restraints.using
	if not using or not slot or using.slot_id ~= slot.slot_id then
		return
	end

	TriggerServerEvent("players:restrain", slot.slot_id, Restraints.target)

	Restraints.target = nil
	Restraints.using = nil
end)

--[[ Threads ]]--
Citizen.CreateThread(function()
	while true do
		Restraints:UpdateEmote()
		Citizen.Wait(0)
	end
end)

Citizen.CreateThread(function()
	local delay = 200
	while true do
		Restraints:UpdateState(1000 / delay)
		Citizen.Wait(delay)
	end
end)