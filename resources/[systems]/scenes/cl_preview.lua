Preview = {}

function Preview:Update()
	local retval, didHit, hitCoords, surfaceNormal, materialHash, entity = table.unpack(Raycast())

	if not retval or not didHit then return end

	local ped = PlayerPedId()
	local coords = GetEntityCoords(ped)
	local dist = #(coords - hitCoords)
	
	-- Check can place.
	local canPlace = dist < 6.0 and GetEntityType(entity) == 0
	self.canPlace = canPlace

	-- Create or destroy preview.
	if canPlace and not self.interactable then
		self:Create()
	elseif not canPlace and self.interactable then
		self:Destroy()
	end

	-- Get rotation offset.
	local rotation = ToRotation(surfaceNormal)

	if math.abs(surfaceNormal.z) < 0.25 then
		rotation = rotation + vector3(90, -90, -90)
	else
		local camCoords = GetFinalRenderedCamCoord()
		local toCam = vector2(camCoords.x, camCoords.y) - vector2(hitCoords.x, hitCoords.y)
		local camAngle = math.atan2(toCam.y, toCam.x)

		rotation = vector3(rotation.x, rotation.y, math.deg(camAngle) - 90)
	end

	-- Cache placement info.
	self.coords = hitCoords
	self.rotation = rotation

	-- Update coords.
	exports.interact:SetCoords(self.interactable, hitCoords, rotation)
end

function Preview:Create()
	-- Destroy any old preview.
	self:Destroy()

	-- Create new preview.
	self.interactable = (self.scene and self.scene:CreateInteractable()) or exports.interact:AddText({
		text = "<div style='width: 100%; height: 100%; background: rgba(128, 128, 255, 0.5); border-radius: 100%' />",
		useCanvas = true,
		fit = true,
		transparent = true,
		width = 0.3,
		height = 0.3,
	})
end

function Preview:Destroy()
	if self.interactable == nil then return end

	-- Remove text.
	exports.interact:RemoveText(self.interactable)

	-- Clear cache.
	self.interactable = nil
end

function Preview:UseScene(data)
	local scene = Scene:Create(data)

	self.text = data.text
	self.lifetime = data.lifetime
	self.scene = scene
	
	self:Create()
end