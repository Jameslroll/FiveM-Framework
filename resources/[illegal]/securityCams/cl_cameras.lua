Camera = {}
Camera.__index = Camera

function Camera:CreateFromObject(entity)
	local hash = GetCoordsHash(GetEntityCoords(entity))
	local settings = Main:GetCameraSettings(entity) or {}
	local offset = settings.Offset or {}
	local coords = GetOffsetFromEntityInWorldCoords(entity, offset.x, offset.y, offset.z)

	local data = {
		hash = hash,
		coords = coords,
		entity = entity,
		group = _k,
		rotation = GetEntityRotation(entity) + (settings.Rotation or vector3(0.0, 0.0, 0.0)),
		settings = settings,
	}

	return setmetatable(data, Camera)
end

function Camera:Activate()
	if IsScreenFadedOut() then
		Menu:SetLoading(false)
		DoScreenFadeIn(0)
	end

	Main:UpdateCamera(self.coords, self.rotation)
end

function Camera:Deactivate()
	RenderScriptCams(false, false, 0, 1, 0)
	DestroyCam(self.camera)
	ClearFocus()
	ClearTimecycleModifier()

	Menu:SetLoading(false)
	DoScreenFadeIn(0)
end

function Camera:Update()
	local camera = Main.camera

	-- Timecycles.
	SetTimecycleModifier("scanline_cam_cheap")
	SetTimecycleModifierStrength(2.0)

	-- Skip input.
	if Menu.hasFocus then return end

	-- Update object.
	local min, max = self.settings.Min or vector3(-90.0, 0.0, -180.0), self.settings.Max or vector3(90.0, 0.0, 180.0)
	local lookX, lookY = GetDisabledControlUnboundNormal(1, 1) * 6.0, GetDisabledControlUnboundNormal(1, 2) * 6.0

	-- Get object (rotation) offset.
	self.offset = self.offset or vector3(0.0, 0.0, 0.0)

	-- Calculate yaw.
	local yaw = self.offset.z - lookX
	if yaw > 180.0 then
		yaw = yaw % 180.0 - 180.0
	elseif yaw < -180.0 then
		yaw = yaw % 180.0
	end

	-- Set rotation.
	self.offset = vector3(
		math.max(math.min(self.offset.x - lookY, max.x), min.x),
		0.0,
		math.max(math.min(yaw, max.z), min.z)
	)

	-- Update camera.
	Main:UpdateCamera(self.coords, self.rotation + self.offset, self.settings.Fov or 60.0)
	-- SetCamCoord(self.cam, object.coords)
	-- SetCamRot(self.cam, object.rotation + object.offset)
	-- SetCamFov(self.cam, object.settings.Fov or 60.0)
end

-- -- Fade out.
-- DoScreenFadeOut(200)
-- Citizen.Wait(200)

-- -- Get settings.
-- local settings = self:GetSettings()
-- if settings == nil then return false end

-- -- Get group.
-- local group = settings.Groups[index]
-- if group == nil then return false end

-- -- Cache stuff.
-- local camera = self.camera
-- local coords = group.Center

-- self.group = index

-- -- Set coordinates.
-- SetCamActive(camera, true)
-- SetCamCoord(camera, coords)
-- SetFocusPosAndVel(coords.x, coords.y, coords.z, 0.0, 0.0, 0.0)

-- -- Wait to load.
-- local hasGround, groundZ
-- local startTime = GetGameTimer()
-- while not hasGround and GetGameTimer() - startTime < 5000 do
-- 	hasGround, groundZ = GetGroundZFor_3dCoord(coords.x, coords.y, coords.z)
-- 	Citizen.Wait(20)
-- end

-- if not hasGround then
-- 	self:Deactivate()
-- 	print("could not load the ground (either misplaced group or slow computer)")
-- end

-- -- Load objects.
-- self:UpdateObjects()

-- -- Fade in.
-- DoScreenFadeIn(200)

-- return true