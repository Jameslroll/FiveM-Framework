Chairs = {}
Chairs.maxPlayerDist = 3.0
Chairs.cached = {}

--[[ Functions: Chair ]]--
function Chairs:Init()
	for model, bases in pairs(Models) do
		for base, info in pairs(bases) do
			local settings = Bases[base]
			if settings then
				exports.interact:Register({
					id = "chair-"..model.."_"..base,
					event = "chair",
					text = settings.Text or "Sit",
					model = model,
					base = base,
				})
			end
		end
	end
end

function Chairs:Update()
	local chair = self.chair
	if not chair then return end

	local entity = chair.entity
	local ped = PlayerPedId()

	-- Check conditions.
	if
		not DoesEntityExist(entity) or
		not IsEntityAttachedToEntity(ped, entity) or
		(IsDisabledControlJustReleased(0, 46) and not self.locked) or
		self:IsOccupied(entity, ped)
	then
		self:Deactivate()
		return
	end

	-- First person toggle.
	if self.cam and IsControlJustReleased(0, 0) then
		if self.cam.isActive then
			self.cam:Deactivate()
			Citizen.Wait(0)
			SetFollowPedCamViewMode(4)
		else
			self.cam:Activate()
		end
	end

	-- Disable controls.
	DisableControlAction(0, 52)

	-- Disable camera collisions.
	DisableCamCollisionForEntity(entity)

	-- Suppress interactions.
	if GetGameTimer() - (self.lastSuppress or 0) > 200 then
		TriggerEvent("interact:suppress")
		self.lastSuppress = GetGameTimer()
	end
end

function Chairs:Activate(entity, baseName)
	local ped = PlayerPedId()
	local modelHash = GetEntityModel(entity)

	-- Get/check settings.
	local base = Bases[baseName or false]
	local model = (Models[modelHash] or {})[baseName or false]

	if not base or not model then return end
	
	-- Defaults.
	local offset = model.Offset or vector3(0.0, 0.0, 0.0)
	local rotation = model.Rotation or vector3(0.0, 0.0, 0.0)
	local anim = model.Anim or base.Anim
	local camera = model.Camera or base.Camera

	-- Cache.
	self.chair = {
		entity = entity,
		offset = offset,
		rotation = rotation,
		anim = anim,
		camera = camera,
		entered = GetEntityCoords(ped, true),
		exit = model.Exit or vector3(0.8, 0.0, 0.0),
		heading = model.Heading,
	}

	-- Trigger events.
	TriggerEvent("chairs:activate", entity)

	-- Emote.
	if anim then
		anim.BlendSpeed = 100.0
		anim.Flag = 1

		self.emote = exports.emotes:Play(anim)
	end

	-- Create camera.
	if camera then
		local origin = GetOffsetFromEntityInWorldCoords(entity, camera.Offset.x, camera.Offset.y, camera.Offset.z)
		local target = GetOffsetFromEntityInWorldCoords(entity, camera.Target.x, camera.Target.y, camera.Target.z)

		local cam = Camera:Create()
		cam.coords = origin
		cam.rotation = ToRotation(Normalize(target - origin))
		cam.fov = camera.Fov

		self.cam = cam
		cam:Activate()
	end
	
	-- Update ped.
	FreezeEntityPosition(ped, true)
	SetEntityCoords(ped, GetEntityCoords(entity))
	AttachEntityToEntity(ped, entity, 0, offset.x, offset.y, offset.z, rotation.x, rotation.y, rotation.z, false, false, true)

	-- Update entity.
	FreezeEntityPosition(entity, true)
end

function Chairs:Deactivate()
	local chair = self.chair
	local entity = chair and chair.entity

	-- Trigger events.
	TriggerEvent("chairs:deactivate", entity)

	-- Update ped.
	local ped = PlayerPedId()
	FreezeEntityPosition(ped, false)

	-- Check attachment.
	if not DoesEntityExist(entity) or not IsEntityAttachedToEntity(ped, entity) then
		self:Uncache()
		return
	end
	
	-- Get exit coords.
	local coords = GetOffsetFromEntityInWorldCoords(entity, chair.exit)
	local hasGround, groundZ = GetGroundZFor_3dCoord(coords.x, coords.y, coords.z, true)
	
	-- Flip the exit coords if invalid exit.
	if not hasGround or math.abs(groundZ - coords.z) > 1.0 then
		coords = GetOffsetFromEntityInWorldCoords(entity, -chair.exit)
		hasGround, groundZ = GetGroundZFor_3dCoord(coords.x, coords.y, coords.z, true)
	end

	-- Final check for ground.
	if not hasGround or math.abs(groundZ - coords.z) > 1.0 then
		coords = GetEntityCoords(entity)
		groundZ = coords.z
	end
	
	-- Update ped.
	ped = PlayerPedId()
	DetachEntity(ped, true, true)
	SetEntityCoords(ped, coords.x, coords.y, groundZ, true)
	SetEntityHeading(ped, GetEntityHeading(entity) + (chair.heading or 180.0))
	ClearPedTasksImmediately(ped)

	-- Clear cache.
	self:Uncache()
end

function Chairs:Uncache()
	-- Uncache chair.
	self.chair = nil

	-- Remove camera.
	if self.cam then
		self.cam:Destroy()
		self.cam = nil
	end

	-- Stop emote.
	if self.emote then
		exports.emotes:Stop(self.emote)
		self.emote = nil
	end
end

function Chairs:FindAll(_type, checkOccupied)
	local objects = {}
	for entity in EnumerateObjects() do
		local model = Models[GetEntityModel(entity)]
		if model and model[_type] and (not checkOccupied or not self:IsOccupied(entity)) then
			objects[#objects + 1] = entity
		end
	end
	return objects
end

function Chairs:FindFirst(_type, checkOccupied)
	for entity in EnumerateObjects() do
		local model = Models[GetEntityModel(entity)]
		if model and model[_type] and (not checkOccupied or not self:IsOccupied(entity)) then
			return entity
		end
	end
end

function Chairs:IsOccupied(entity, ped)
	if not self.cachedTime or GetGameTimer() - self.cachedTime > 2000.0 then
		self.cached = {}
		self.cachedTime = GetGameTimer()

		for ped in EnumeratePeds() do
			local entity = IsEntityAttached(ped) and GetEntityAttachedTo(ped)
			if entity and DoesEntityExist(entity) then
				self.cached[entity] = ped
			end
		end
	end

	local attachedPed = self.cached[entity or false]
	return attachedPed ~= nil and (not ped or attachedPed ~= ped)
end

--[[ Threads ]]--
Citizen.CreateThread(function()
	while true do
		if Chairs.chair then
			Chairs:Update()
			Citizen.Wait(0)
		else
			Citizen.Wait(200)
		end
	end
end)

--[[ Exports ]]--
exports("FindAll", function(...)
	return Chairs:FindAll(...)
end)

exports("FindFirst", function(...)
	return Chairs:FindFirst(...)
end)

exports("Activate", function(...)
	return Chairs:Activate(...)
end)

exports("Lock", function(value)
	Chairs.locked = value == true
end)

--[[ Events ]]--
AddEventHandler("chairs:clientStart", function()
	Chairs:Init()
end)

AddEventHandler("interact:on_chair", function(interactable)
	Chairs:Activate(interactable.entity, interactable.base)
end)