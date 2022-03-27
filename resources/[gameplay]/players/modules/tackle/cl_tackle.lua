Tackle = {
	speed = 2.2,
	radius = 2.0,
	dot = 0.3,
	effects = {
		oxygen = 0.1,
		fatigue = 0.05,
	},
	times = {
		delay = 500,
		send = { 800, 1200 },
		receive = { 4000, 5000 },
	},
	emote = {
		Dict = "swimming@first_person@diving",
		Name = "dive_run_fwd_-45_loop",
		Flag = 48,
		Duration = 200
	},
}

--[[ Functions ]]--
function Tackle:Update()
	if not IsControlJustPressed(0, 46) then
		return
	end

	local state = LocalPlayer.state
	if not state then return end

	local ped = PlayerPedId()

	-- Checks.
	if (
		IsPedRagdoll(ped) or
		state.immobile or
		state.restrained or
		IsPedFalling(ped) or
		IsPedSwimming(ped) or
		IsEntityAttached(ped)
	) then
		return
	end

	-- Speed.
	local speed = GetEntitySpeed(ped)
	print("your speed was", speed)
	if speed < self.speed then return end

	-- Find nearest ped.
	local coords = GetEntityCoords(ped)
	local nearestPlayer, nearestPed, nearestDist = GetNearestPlayer(coords)

	if not nearestPed or not nearestDist or nearestDist > self.radius then
		nearestPed, nearestDist = GetNearestPed(coords)
	end

	print("dist is", nearestDist)
	if not nearestPed or not DoesEntityExist(nearestPed) or nearestDist > self.radius then
		return
	end

	-- Check movement.
	local velocity = GetEntityVelocity(ped)
	local forward = GetEntityForwardVector(ped)
	local dir = Normalize(GetEntityCoords(nearestPed) - coords)
	local dot = Dot(dir, forward)

	print("dot product", dot)
	if dot < self.dot then
		return
	end

	-- Check and take stamina.
	if (exports.health:GetEffect("Oxygen") or 1.0) < self.effects.oxygen then
		return
	end

	if not GetPlayerInvincible(PlayerId()) then
		exports.health:AddEffect("Oxygen", -self.effects.oxygen)
	end

	-- Disarm.
	TriggerEvent("disarmed")

	-- Play emote and tackle.
	exports.emotes:Play(self.emote)
	
	if nearestPlayer then
		TriggerServerEvent("players:tackle", GetPlayerServerId(nearestPlayer))
	else
		WaitForAccess(nearestPed)
		SetPedToRagdoll(nearestPed, GetRandomIntInRange(table.unpack(self.times.receive)))
	end

	Citizen.Wait(self.times.delay)

	SetPedToRagdoll(ped, GetRandomIntInRange(table.unpack(self.times.send)))
end

function Tackle:Fall()
	local ped = PlayerPedId()

	TriggerEvent("disarmed")

	SetPedToRagdoll(ped, GetRandomIntInRange(table.unpack(self.times.receive)))

	if not GetPlayerInvincible(PlayerId()) then
		exports.health:AddEffect("Fatigue", self.effects.fatigue)
	end
end

--[[ Events ]]--
RegisterNetEvent("players:tackle", function()
	Tackle:Fall()
end)

--[[ Threads ]]--
Citizen.CreateThread(function()
	while true do
		Tackle:Update()
		Citizen.Wait(0)
	end
end)