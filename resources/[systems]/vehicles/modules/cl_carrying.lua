Carry = {}

--[[ Functions ]]--
function Carry:Start(vehicle)
	if self.emote or self.vehicle then
		self:Stop()
		return
	end

	-- Get ped.
	local ped = PlayerPedId()
	
	-- Check carryable.
	if not self:CanCarry(vehicle) or (IsEntityAttached(vehicle) and not IsEntityAttachedToEntity(vehicle, ped)) then
		return
	end
	
	-- Cache vehicle.
	self.vehicle = vehicle

	-- Attach vehicle.
	local offset = vector3(-0.3, 0.4, 0.0)
	local rotation = vector3(90, 0, 90)
	local bone = GetPedBoneIndex(ped, 0x60F2)

	-- Request access.
	WaitForAccess(vehicle)

	-- Play the emote.
	self.emote = exports.emotes:Play({
		Dict = "anim@heists@box_carry@", Name = "idle", Flag = 49
	})

	AttachEntityToEntity(vehicle, ped, bone, offset.x, offset.y, offset.z, rotation.x, rotation.y, rotation.z, false, false, false, true, 0, true)
end

function Carry:Stop()
	if self.vehicle then
		while IsEntityAttachedToEntity(self.vehicle, PlayerPedId()) do
			WaitForAccess(self.vehicle)
			DetachEntity(self.vehicle, true, true)
			ActivatePhysics(self.vehicle)

			Citizen.Wait(20)
		end

		self.vehicle = nil
	end
	
	if self.emote then
		local id = self.emote
		self.emote = nil
		
		exports.emotes:Stop(id)
	end
end

function Carry:CanCarry(vehicle)
	local ped = PlayerPedId()

	return
		not IsPedRagdoll(ped) and
		not IsVehicleOccupied(vehicle) and
		not IsPedInAnyVehicle(ped) and
		IsControlEnabled(0, 52) and
		not GetPedConfigFlag(ped, 388)
end

--[[ Events ]]--
AddEventHandler("emotes:cancel", function(id)
	if id and Carry.emote == id then
		Carry:Stop()
	end
end)

--[[ Threads ]]--
Citizen.CreateThread(function()
	while true do
		if Carry.vehicle and (not Carry:CanCarry(Carry.vehicle) or not IsEntityAttachedToEntity(Carry.vehicle, PlayerPedId())) then
			Carry:Stop()
		end
		Citizen.Wait(200)
	end
end)