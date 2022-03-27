-- Shake types:

-- DEATH_FAIL_IN_EFFECT_SHAKE
-- DRUNK_SHAKE
-- FAMILY5_DRUG_TRIP_SHAKE
-- HAND_SHAKE
-- JOLT_SHAKE
-- LARGE_EXPLOSION_SHAKE
-- MEDIUM_EXPLOSION_SHAKE
-- SMALL_EXPLOSION_SHAKE
-- ROAD_VIBRATION_SHAKE
-- SKY_DIVING_SHAKE
-- VIBRATE_SHAKE

--[[ Metatables ]]--
Cameras = {
	lastId = 0,
	objects = {},
}

Camera = {}
Camera.__index = Camera

--[[ Functions ]]--
function Camera:Create(data)
	if not data then
		data = {}
	end
	
	-- Create camera.
	data.handle = CreateCam(data.type or "DEFAULT_SCRIPTED_CAMERA", false)

	-- Set id.
	data.id = Cameras.lastId + 1

	-- Set metatable.
	setmetatable(data, self)
	
	-- Cache camera.
	Cameras.lastId = data.id
	Cameras.objects[data.id] = data

	-- Return camera.
	return data
end

function Camera:Activate()
	-- Check camera.
	if not DoesCamExist(self.handle) then return end

	-- Set active.
	SetCamActive(self.handle, true)
	self.isActive = true

	-- Start rendering.
	RenderScriptCams(true, false, 0, 1, 0)

	-- Shake camera.
	if self.shake then
		ShakeCam(self.handle, self.shake.type or "HAND_SHAKE", self.shake.amount or 1.0)
	end
end

function Camera:Deactivate()
	-- Check camera.
	if not DoesCamExist(self.handle) then return end

	-- Stop rendering.
	if IsCamRendering(self.handle) then
		RenderScriptCams(false, false, 0, 1, 0)
	end

	-- Set inactive.
	if IsCamActive(self.handle) then
		SetCamActive(self.handle, false)
	end

	self.isActive = false
end

function Camera:Destroy()
	-- Check camera.
	if not DoesCamExist(self.handle) then return end

	-- Deactivate self.
	if self.isActive then
		self:Deactivate()
	end

	-- Destroy camera.
	DestroyCam(self.handle)

	-- Uncache camera.
	Cameras.objects[self.id] = nil
end

function Camera:Update()
	if self.coords then
		SetCamCoord(self.handle, self.coords)
	end

	if self.rotation then
		SetCamRot(self.handle, self.rotation)
	end

	if self.fov then
		SetCamFov(self.handle, self.fov)
	end

	if self.lookAt then
		local _type = type(self.lookAt)

		if _type == "vector3" then
			PointCamAtCoord(self.handle, self.lookAt)
		elseif _type == "number" then
			PointCamAtEntity(self.handle, self.lookAt)
		end
	end
end

--[[ Threads ]]--
Citizen.CreateThread(function()
	while true do
		for id, camera in pairs(Cameras.objects) do
			if camera.isActive then
				camera:Update()
			end
		end

		Citizen.Wait(0)
	end
end)