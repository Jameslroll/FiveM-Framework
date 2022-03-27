Stretcher = {}

--[[ Functions ]]--
function Stretcher:Activate(vehicle)
	-- Check attached.
	for ped, _ in EnumeratePeds() do
		if IsEntityAttachedToEntity(ped, vehicle) then
			return
		end
	end

	-- Get stretcher.
	local stretcher = exports.vehicles:GetStretcher(vehicle)
	if not stretcher then return end

	-- Get stuff.
	local ped = PlayerPedId()
	local boneIndex = GetEntityBoneIndexByName(vehicle, "bonnet")
	local pos = stretcher.Offset or vector3(0.0, -1.0, 1.0)
	local rot = stretcher.Rotation or vector3(0.0, 0.0, 180.0)
	
	-- Attach to entity.
	AttachEntityToEntity(ped, vehicle, boneIndex, pos.x, pos.y, pos.z, rot.x, rot.y, rot.z, false, false, false, false, 0, true)

	-- Set cache.
	self.vehicle = vehicle
end

function Stretcher:Update()
	local ped = PlayerPedId()
	local state = LocalPlayer.state

	-- Check conditions.
	if
		not DoesEntityExist(self.vehicle) or
		not IsEntityAttachedToEntity(ped, self.vehicle) or
		(IsDisabledControlJustPressed(0, 75) and not state.immobile and not state.restrained)
	then
		self:Deactivate()
		return
	end

	-- Play emote.
	if not self.emote or not exports.emotes:IsPlaying(self.emote) then
		self.emote = exports.emotes:Play({ Dict = "anim@gangops@morgue@table@", Name = "body_search", Flag = 1 })
	end

	-- Suppress interact.
	TriggerEvent("interact:suppress")
end

function Stretcher:Deactivate()
	local ped = PlayerPedId()
	local vehicle = DoesEntityExist(self.vehicle) and self.vehicle

	-- Check for entity.
	if vehicle and IsEntityAttachedToEntity(ped, vehicle) then
		-- Detach from stretcher.
		DetachEntity(ped, true, false)
		SetEntityCollision(ped, true, true)

		-- Teleport.
		local coords = GetOffsetFromEntityInWorldCoords(vehicle, 1.0, 0.0, 0.0)
		SetEntityCoords(ped, coords)
		PlaceObjectOnGroundProperly(ped)
	end

	-- Stop emote.
	if self.emote then
		exports.emotes:Stop(self.emote)
		self.emote = nil
	end

	-- Uncache.
	self.vehicle = nil
end

--[[ Events ]]--
AddEventHandler("interact:on_activateStretcher", function(interactable)
	local entity = interactable.entity
	if not entity then return end

	Stretcher:Activate(entity)
end)

--[[ Threads ]]--
Citizen.CreateThread(function()
	while true do
		if Stretcher.vehicle then
			Stretcher:Update()
		end
		Citizen.Wait(0)
	end
end)