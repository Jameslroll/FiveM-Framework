Editor = {}

function Editor:Use(item, slot)
	if self.item == item then
		self:Clear()
		return false
	elseif self.item then
		self:Clear()
	end

	local settings = Decorations[item]
	if not settings or not settings.Model then
		Print("Decoration '%s' missing model!", item)
		return
	end

	self.item = item
	self.settings = settings
	self.slot = slot
	self.variant = self.variant and math.min(self.variant, #settings.Model or 1)

	return true
end

function Editor:Clear()
	self.item = nil
	self.settings = nil
	self.slot = nil
	self.placing = nil

	self:DeleteEntity()

	Citizen.CreateThread(function()
		for i = 1, 30 do
			self:DisableControls()
			Citizen.Wait(0)
		end
	end)
end

function Editor:Place()
	-- Get slot.
	local slot = self.slot
	if not slot then
		self:Clear()
		print("No slot while placing.")
		return
	end

	-- Record snowflake.
	local snowflake = GetGameTimer()
	self.placing = snowflake

	-- Get settings.
	local settings = self.settings
	if not settings then
		self:Clear()
		print("No settings while placing.")
		return
	end

	-- Get emote.
	local anim = (settings and settings.Anim) or Config.Placing.Anim
	anim.Locked = true
	
	-- Perform emote.
	exports.emotes:Play(anim)

	-- Wait for anim.
	Citizen.Wait(anim.Duration or 0)

	-- Check placement is same.
	if self.placing ~= snowflake then return end
	
	-- Trigger events.
	TriggerServerEvent(Main.event.."place", self.item, self.variant or false, self.coords, self.rotation, slot.slot_id)

	-- Clear editor.
	self:Clear()
end

function Editor:DisableControls()
	for name, control in pairs(Config.Controls) do
		DisableControlAction(0, control)
	end
end

function Editor:DeleteEntity()
	if self.entity then
		DeleteEntity(self.entity)
		self.entity = nil
	end
end

function Editor:Update()
	self.canPlace = false

	-- Disable input.
	self:DisableControls()

	-- Cancel input.
	if IsDisabledControlJustPressed(0, Config.Controls.Cancel) then
		self:Clear()
		return
	end

	-- Get settings.
	local settings = self.settings
	if not settings then return end

	local offset = settings.Offset
	local offsetRot = settings.Rotation
	local shouldCenter = not settings.NoCenter

	local retval, didHit, coords, surfaceNormal, materialHash, entityHit = Raycast()
	local entityType = GetEntityType(entityHit)
	local ped = PlayerPedId()
	local pedCoords = GetEntityCoords(ped)

	-- Check distance.
	local dist = #(pedCoords - coords)
	if dist > Config.MaxDistance then
		self:DeleteEntity()
		return
	end

	-- Check target.
	local targetDecoration = entityHit and Main.entities[entityHit]
	local targetStackable = targetDecoration and targetDecoration.settings.Stackable
	local stackable = settings.Stackable
	local isStacking = targetStackable and stackable and (
		(targetStackable.Foundation and (stackable.Structure or stackable.Block)) or
		(not targetStackable.Foundation and stackable.Block)
	)

	if entityType ~= 0 and not isStacking and GetEntityScript(entityHit) ~= "properties" then
		self:DeleteEntity()
		return
	end

	-- Check incline.
	local placement = settings.Placement
	if placement then
		local dot = Dot(surfaceNormal, Up)
		local canPlace = (
			(placement == "Floor" and dot > 0.5) or
			(placement == "Wall" and dot < 0.5 and dot > -0.5) or
			(placement == "Ceiling" and dot < -0.9)
		)

		if not canPlace then
			self:DeleteEntity()
			return
		end
	end

	-- Update variation.
	if type(settings.Model) == "table" then
		local variant = self.variant or 1
		if IsDisabledControlPressed(0, Config.Controls.VariantR) then
			variant = variant + 1
			if variant > #settings.Model then
				variant = 1
			end
		elseif IsDisabledControlPressed(0, Config.Controls.VariantL) then
			variant = variant - 1
			if variant < 1 then
				variant = #settings.Model
			end
		end

		if variant ~= self.variant then
			self.variant = variant
			self:DeleteEntity()
		end
	end

	-- Get model.
	local model = Main:GetModel(settings, self.variant)

	-- Get rotation.
	local rotation = (placement == "Ceiling" and vector3(180, 0, 0) or ToRotation2(surfaceNormal)) + (
		placement == "Wall" and vector3(0, self.angle or 0, 0) or
		vector3(0, 0, self.angle or 0)
	)
	
	-- Unpack model.
	if type(model) == "table" then
		if model.Rotation then
			offsetRot = model.Rotation
		end

		if model.Offset then
			offset = model.Offset
		end

		if model.NoCenter then
			shouldCenter = false
		end

		model = model.Name
	end
	
	if shouldCenter then
		local min, max = GetModelDimensions(model)
		if not offset then
			offset = vector3(0, 0, 0)
		end
		offset = offset + vector3(0, 0, math.abs(min.z))
	end

	-- Check snapping.
	-- if settings.Snap then
	-- 	local nearest, nearestDist = nil, 0.0

	-- 	for id, decoration in pairs(Main.decorations) do
	-- 		local _settings = decoration:GetSettings()
	-- 		local dist = decoration.coords and #(decoration.coords - coords)
	-- 		if dist and _settings and _settings.Snap == settings.Snap and (not nearest or dist < nearestDist) then
	-- 			nearest = decoration
	-- 			nearestDist = dist
	-- 		end
	-- 	end

	-- 	if nearest and nearest.entity then
	-- 		local forward = GetEntityForwardVector(nearest.entity)
	-- 		local min, max = GetModelDimensions(model)
	
	-- 		local snapDir = coords - nearest.coords
	-- 		snapDir = snapDir / #snapDir
	
	-- 		rotation = nearest.rotation
	-- 		coords = nearest.coords + forward
	-- 	end
	-- end
	
	-- Apply offsets.
	if offset then
		coords = coords + offset
	end
	
	if offsetRot then
		rotation = rotation + offsetRot
	end
	
	-- Create object.
	local entity = self.entity
	if not entity or not DoesEntityExist(entity) then
		if not WaitForRequestModel(model) then
			print("invalid model: "..tostring(model))
			model = `prop_ar_arrow_1`
		end

		entity = CreateObject(model, coords.x, coords.y, coords.z, false, true, false)
		FreezeEntityPosition(entity, true)
		SetEntityCollision(entity, false, false)

		SetModelAsNoLongerNeeded(model)
		
		self.entity = entity
	end

	-- Rotating.
	local step = (IsDisabledControlPressed(0, Config.Controls.FineTune) and 22.5 or 90.0) * GetFrameTime()
	if IsDisabledControlPressed(0, Config.Controls.RotateR) then
		self.angle = (self.angle or 0.0) + step
	elseif IsDisabledControlPressed(0, Config.Controls.RotateL) then
		self.angle = (self.angle or 0.0) - step
	end

	-- Update object.
	SetEntityCoords(entity, coords.x, coords.y, coords.z)
	SetEntityRotation(entity, rotation.x, rotation.y, rotation.z)

	-- Update cache.
	self.canPlace = true
	self.coords = coords
	self.rotation = rotation

	-- Check roads/interiors.
	local hasRoad, roadCoords = GetClosestVehicleNode(coords.x, coords.y, coords.z, 0, 0, 0)

	local interiorId = GetInteriorFromEntity(ped)
	local roomHash = GetRoomKeyFromEntity(ped)
	local roomId = GetInteriorRoomIndexByHash(interiorId, roomHash)
	local roomFlag = GetInteriorRoomFlag(interiorId, roomId)

	if roomFlag == -1 and hasRoad and #(roadCoords - coords) < 20.0 then
		self.canPlace = false
	end

	-- Check collision.
	local shapeHandle = StartShapeTestBoundingBox(entity, 16, 16)
	local _retval, _didHit, _hitCoords, _surfaceNormal, _entityHit = GetShapeTestResult(shapeHandle)

	if _didHit == 1 and (isStacking and _entityHit ~= entityHit) then
		self.canPlace = false
	end

	-- Update alpha.
	SetEntityAlpha(entity, self.canPlace and 255 or 128)

	-- Placement.
	if self.canPlace and IsDisabledControlJustReleased(0, Config.Controls.Place) then
		self:Place()
	end
end

--[[ Threads ]]--
Citizen.CreateThread(function()
	while true do
		if Editor.settings then
			Editor:Update()
			Citizen.Wait(0)
		else
			Citizen.Wait(200)
		end
	end
end)