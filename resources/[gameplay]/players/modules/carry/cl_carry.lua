Carry = Carry or {}

--[[ Options ]]--
Main:AddOption({
	id = "forcePlayer",
	text = "Force",
	icon = "airline_seat_recline_normal",
}, function(player, playerPed, dist, serverId)
	-- Get state.
	if not Carry.player then
		return false
	end
	
	-- Check force target.
	if not Carry:GetForceTarget() then
		return false
	end
	
	return true
end, function(player, playerPed)
	if not Carry.player then return end
	
	local vehicle, seatIndex = Carry:GetForceTarget()
	if not vehicle or not seatIndex then return end
	
	TriggerServerEvent("players:force", GetNetworkId(vehicle), seatIndex)
end)

for k, v in pairs(Carry.modes) do
	local event = "player-"..k

	Main:AddOption({
		id = event,
		text = v.Name,
		icon = v.Icon,
		sub = sub,
	}, function(player, playerPed, dist, serverId)
		if Carry.player then
			return false
		end

		local playerState = Player(serverId).state or {}
		if not v.Immobile and playerState.immobile then
			return false
		end

		return true
	end, function(player, playerPed, serverId)
		Carry:Send(k)

		TriggerServerEvent("players:carryEnd")
	end)
end

--[[ Functions ]]--
function Carry:Send(id)
	if not Main.serverId or not self:CanCarry() then return end

	local playerPed = Main.ped
	if not playerPed then return end

	if IsPedInAnyVehicle(playerPed) then
		local seatIndex = FindSeatPedIsIn(playerPed)
		if not seatIndex or not IsVehicleDoorOpen(GetVehiclePedIsIn(playerPed), seatIndex + 1) then return end
	end

	-- Trigger event.
	TriggerServerEvent("players:carryBegin", Main.serverId, id)
end

function Carry:Activate(direction, target, id)
	local ped = PlayerPedId()
	local state = (LocalPlayer or {}).state or {}

	-- Get player.
	local player = GetPlayerFromServerId(target)
	local playerPed = GetPlayerPed(player)
	
	-- Check player ped.
	if not DoesEntityExist(playerPed) or playerPed == ped then return end

	-- Get mode.
	local mode = self.modes[id]
	if not mode then return end

	self.isBeingCaried = direction == "Target"

	-- Disarm weapon.
	TriggerEvent("disarmed")

	-- Attach source to target.
	if self.isBeingCaried then
		local attach = mode.Attachment
		local boneIndex = GetPedBoneIndex(playerPed, attach.Bone)
		local pos = attach.Offset
		local rot = attach.Rotation

		-- Leave vehicle.
		while IsPedInAnyVehicle(ped) do
			ped = PlayerPedId()
			TaskLeaveAnyVehicle(ped, 0, 16)

			Citizen.Wait(50)
		end

		-- Attach.
		AttachEntityToEntity(ped, playerPed, boneIndex, pos.x, pos.y, pos.z, rot.x, rot.y, rot.z, false, false, false, true, 0, true)
	end

	-- Add option.
	exports.interact:AddOption({
		id = "carryEnd",
		text = direction == "Target" and "Break-out" or "Drop",
		icon = "pan_tool",
	})

	-- Cache stuff.
	self.mode = mode
	self.player = player
	self.ped = playerPed

	-- Play animation.
	local anim = mode[direction]
	if anim then
		self:SetAnim(anim)
	end
end

function Carry:Deactivate()
	local ped = PlayerPedId()

	-- Detach entity.
	if IsEntityAttachedToAnyPed(ped) then
		DetachEntity(ped, true, false)
		SetEntityCollision(ped, true, true)
	end

	-- Clear cache.
	self.mode = nil
	self.anim = nil
	self.player = nil
	self.ped = nil
	self.isBeingCaried = nil

	-- Stop emote.
	if self.emote then
		exports.emotes:Stop(self.emote)
		self.emote = nil
	end

	-- Remove navigation option.
	exports.interact:RemoveOption("carryEnd")
end

function Carry:Update()
	local mode = self.mode
	if not mode then return end

	local ped = PlayerPedId()
	local playerPed = self.ped
	local state =  (LocalPlayer or {}).state
	local isBeingCaried = self.isBeingCaried
	
	if not playerPed or not state then return end

	-- Check emote.
	if self.anim and self.emote and not exports.emotes:IsPlaying(self.emote) then
		self:SetAnim(self.anim)
	end

	-- Check carry.
	if
		(playerPed and (not DoesEntityExist(playerPed) or IsPedRagdoll(playerPed))) or
		IsPedInAnyVehicle(ped) or
		IsPedArmed(playerPed, 1 | 2 | 4) or
		(state.immobile and (not isBeingCaried or not mode.Immobile)) or
		(state.restrained and (not isBeingCaried or not mode.Immobile)) or
		not IsEntityAttachedToEntity(isBeingCaried and ped or playerPed, isBeingCaried and playerPed or ped)
	then
		TriggerServerEvent("players:carryEnd")
	end
end

function Carry:UpdateInput()
	if not self.mode then return end

	for _, control in ipairs(self.controls) do
		DisableControlAction(0, control)
	end
end

function Carry:SetAnim(anim)
	self.anim = anim
	self.emote = exports.emotes:Play(anim)
end

function Carry:CanCarry()
	local state = (LocalPlayer or {}).state
	if not state then return false end

	local ped = PlayerPedId()

	return (
		not IsPedRagdoll(ped) and
		not state.immobile and
		not state.restrained and
		not IsEntityAttached(ped)
	)
end

function Carry:GetForceTarget()
	local ped = PlayerPedId()
	local coords = GetEntityCoords(entity)

	-- Get vehicle.
	local vehicle, hitCoords, vehicleDist = GetFacingVehicle(ped, 3.0, true)
	if not vehicle then return end

	-- Check stretcher.
	if exports.vehicles:IsStretcher(vehicle) then
		return vehicle, -1
	end
	
	-- Get seat.
	local seatIndex, seatDist = GetClosestSeat(hitCoords, vehicle)
	if not seatIndex or not IsVehicleDoorOpen(vehicle, seatIndex + 1) then return end

	-- Return result.
	return vehicle, seatIndex
end

--[[ Events: Net ]]--
RegisterNetEvent("players:carry", function(direction, target, id, netId, seatIndex)
	if id then
		Carry:Activate(direction, target, id)
	else
		Carry:Deactivate()
	end

	if netId and seatIndex then
		local vehicle = NetworkGetEntityFromNetworkId(netId)
		if not vehicle or not DoesEntityExist(vehicle) then return end

		if exports.vehicles:IsStretcher(vehicle) then
			Stretcher:Activate(vehicle)
			return
		end
		
		SetPedIntoVehicle(PlayerPedId(), vehicle, seatIndex)
	end
end)

--[[ Events ]]--
AddEventHandler("interact:onNavigate_carryEnd", function()
	TriggerServerEvent("players:carryEnd")
end)

--[[ Threads ]]--
Citizen.CreateThread(function()
	while true do
		Carry:Update()
		Citizen.Wait(200)
	end
end)

Citizen.CreateThread(function()
	while true do
		Carry:UpdateInput()
		Citizen.Wait(0)
	end
end)