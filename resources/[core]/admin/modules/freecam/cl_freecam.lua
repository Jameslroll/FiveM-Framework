Freecam = {
	speed = 0.2,
	fov = 70.0,
}

function Freecam:Update()
	local camera = self.camera
	if not camera then return end

	local ped = PlayerPedId()
	local vehicle = IsPedInAnyVehicle(ped) and GetVehiclePedIsIn(ped) or nil
	local delta = GetFrameTime()
	local isPaused = IsPauseMenuActive()
	local hasFocus = _Get("hasFocus") or isPaused

	-- Check vehicle.
	if vehicle and GetPedInVehicleSeat(vehicle, -1) ~= ped then
		vehicle = nil
	end

	-- Get input.
	local lookX = hasFocus and 0.0 or GetDisabledControlNormal(0, 1) -- Mouse left/right.
	local lookY = hasFocus and 0.0 or GetDisabledControlNormal(0, 2) -- Mouse up/down.

	local horizontal = hasFocus and 0.0 or GetDisabledControlNormal(0, 30) -- Left/right.
	local vertical = hasFocus and 0.0 or GetDisabledControlNormal(0, 31) -- Forward/back.
	local height = hasFocus and 0.0 or (IsDisabledControlPressed(0, 205) and -1.0) or (IsDisabledControlPressed(0, 206) and 1.0) or 0.0

	-- Calculate vectors.
	local forward = FromRotation(self.rotation + vector3(0, 0, 90))
	local right = Cross(forward, Up)
	local up = Cross(forward, right)

	-- Scrolling.
	local scroll = hasFocus and 0.0 or ((IsDisabledControlPressed(0, 241) and 1.0) or (IsDisabledControlPressed(0, 242) and -1.0) or 0.0)
	if IsDisabledControlPressed(0, 19) then -- Left alt.
		-- Changing fov.
		self.fov = math.min(math.max(self.fov - scroll * 10.0, 10.0), 100.0)
		camera.fov = self.fov
	else
		-- Changing speed.
		self.speed = math.min(math.max(self.speed + scroll * 0.1, 0.1), 1.0)
	end

	-- Get offsets.
	local speed = math.pow(self.speed, 2.0) * 400.0 * (IsDisabledControlPressed(0, 209) and 2.0 or 1.0)
	local rotation = self.rotation - vector3(lookY, 0.0, lookX) * 15.0
	local coords = self.coords + (forward * -vertical + right * horizontal + up * height) * delta * speed

	-- Following.
	if not hasFocus and IsDisabledControlJustPressed(0, 203) then -- Spacebar.
		if self.follow then
			self.follow = nil
		else
			local retval, didHit, hitCoords, surfaceNormal, materialHash, entity = Raycast()
			if didHit and GetEntityType(entity) ~= 0 then
				self.follow = entity
			end
		end
	end

	if self.follow and DoesEntityExist(self.follow) then
		local followCoords = GetEntityCoords(self.follow)
		rotation = ToRotation(Normalize(followCoords - coords))
		coords = coords + GetEntityVelocity(self.follow) * delta
	end

	-- Update camera.
	self.rotation = rotation
	self.coords = coords

	camera.rotation = self.rotation
	camera.coords = self.coords

	-- Update focus.
	SetFocusPosAndVel(coords.x, coords.y, coords.z, 0.0, 0.0, 0.0)

	-- Other controls.
	if not hasFocus and IsDisabledControlJustPressed(0, 69) then -- Left click.
		self:Deactivate()
	elseif not hasFocus and IsDisabledControlJustPressed(0, 70) then -- Right click.
		SetEntityCoordsNoOffset(vehicle or ped, coords.x, coords.y, coords.z, true)
		
		if vehicle then
			SetEntityRotation(vehicle, 0.0, 0.0, rotation.z)
		else
			SetEntityHeading(ped, rotation.z)
		end
	end

	-- Update blip.
	local blip = self.blip
	if blip and DoesBlipExist(blip) then
		local height = GetFinalRenderedCamCoord().z

		SetBlipCoords(blip, coords.x, coords.y, coords.z)
		SetBlipRotation(blip, math.floor(rotation.z))
		LockMinimapPosition(coords.x, coords.y)

		GlobalState.hudAngle = rotation.z % 360.0
		GlobalState.hudForced = true
		GlobalState.hudZoom = 94.5 + math.min(math.max(height / 500.0, 0.0), 1.0) * 5.0
	end

	-- Disable controls.
	for control = 0, 169 do DisableControlAction(0, control) end
	for control = 257, 287 do DisableControlAction(0, control) end
	for control = 329, 360 do DisableControlAction(0, control) end
end

function Freecam:Activate()
	if self.active then return end

	-- Stop spectating.
	if Spectate.active then
		-- Set target.
		local target = Spectate.target
		local player = GetPlayerFromServerId(target)
		local ped = GetPlayerPed(player)
		
		if ped ~= PlayerPedId() then
			self.follow = ped
		end

		-- Deactivate after target.
		Spectate:Deactivate()
	end

	-- Update cache.
	self.active = true
	self.coords = GetFinalRenderedCamCoord()
	self.rotation = GetFinalRenderedCamRot()
	
	-- Create camera.
	self.camera = Camera:Create({
		coords = self.coords,
		rotation = self.rotation,
		fov = self.fov,
	})
	
	self.camera:Activate()
	
	-- Create blip.
	local blip = AddBlipForCoord(self.coords)
	self.blip = blip

	SetBlipHiddenOnLegend(blip, true)
	SetBlipScale(blip, 1.0)
	SetBlipSprite(blip, 6)
	SetBlipColour(blip, 1)
	SetBlipAlpha(blip, 192)
end

function Freecam:Deactivate()
	if not self.active then return end

	-- Uncache.
	self.active = false
	self.follow = nil

	-- Destroy camera.
	if self.camera then
		self.camera:Destroy()
		self.camera = nil
	end

	-- Remove blip.
	local blip = self.blip
	if blip and DoesBlipExist(blip) then
		RemoveBlip(blip)
		self.blip = nil
	end

	-- Clear focus.
	ClearFocus()

	-- Unlock minimap.
	UnlockMinimapPosition()
	
	GlobalState.hudAngle = nil
	GlobalState.hudForced = nil
	GlobalState.hudZoom = nil

	-- Temporary disable controls.
	Citizen.CreateThread(function()
		local startTime = GetGameTimer()
		while GetGameTimer() - startTime < 1000 do
			DisableControlAction(0, 24)
			DisableControlAction(0, 25)

			Citizen.Wait(0)
		end
	end)
end

--[[ Threads ]]--
Citizen.CreateThread(function()
	while true do
		if Freecam.active then
			Freecam:Update()
		end

		Citizen.Wait(0)
	end
end)

--[[ Commands ]]--
RegisterKeyMapping("+roleplay_freecam", "Admin - Freecam", "KEYBOARD", "EQUALS")
RegisterCommand("+roleplay_freecam", function(source, args, command)
	if not exports.user:IsMod() then return end

	if Freecam.active then
		Freecam:Deactivate()
	else
		Freecam:Activate()
	end
end, true)