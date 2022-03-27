--[[ Functions ]]--
function Main:UpdateCrouching()
	local ped = PlayerPedId()
	local isCrouching = self.isCrouching
	local lastCrouch = self.lastCrouch

	if not isCrouching and IsControlJustPressed(0, 36) then
		self.lastCrouch = GetGameTimer()
	elseif IsDisabledControlJustReleased(0, 36) and lastCrouch and (isCrouching or (GetGameTimer() - lastCrouch > 500 and IsControlEnabled(0, 26) and not IsPedInAnyVehicle(ped))) then
		isCrouching = not isCrouching
		Main:OverrideWalkstyle((isCrouching and "crouch") or (not isCrouching and nil))
	elseif isCrouching and GetPedStealthMovement(ped) then
		SetPedStealthMovement(ped, false)
	elseif isCrouching then
		DisableControlAction(0, 36)
	end

	self.isCrouching = isCrouching
end

function Main:OverrideWalkstyle(name)
	print("overriding walkstyle", name)
	self.overrideWalkstyle = name
	self:SetWalkstyle(name or self.walkstyle)
end
Export(Main, "OverrideWalkstyle")

function Main:SetWalkstyle(name)
	local ped = PlayerPedId()

	if self.overrideWalkstyle and self.overrideWalkstyle ~= name then
		return
	end
	
	if not name or name:lower() == "reset" then
		ResetPedMovementClipset(ped, 1.0)
		ResetPedStrafeClipset(ped, 1.0)

		self.walkstyle = nil
		return
	end

	local walkstyle = Config.Walkstyles[name]
	if not walkstyle then return end
	
	print(json.encode(walkstyle))

	if self.overrideWalkstyle == nil then
		self.walkstyle = name
	end
	
	self:LoadAnimSet(walkstyle.Name)
	SetPedMovementClipset(ped, walkstyle.Name, 1.0)
	
	if walkstyle.Strafe then
		self:LoadAnimSet(walkstyle.Strafe)
		SetPedStrafeClipset(ped, walkstyle.Strafe, 1.0)
	else
		ResetPedStrafeClipset(ped, 1.0)
	end
end
Export(Main, "SetWalkstyle")

function Main:LoadAnimSet(name)
	while not HasAnimSetLoaded(name) do
		RequestAnimSet(name)
		Citizen.Wait(0)
	end

	return true
end

function Main:UpdatePointing()
	local ped = PlayerPedId()
	if not IsPedHuman(ped) then return end

	local isPointing = IsControlPressed(0, 29)
	local state = LocalPlayer.state

	-- Change pointing state.
	if self.isPointing ~= isPointing then
		self.isPointing = isPointing

		if isPointing then
			local dict, name = "anim@mp_point", "task_mp_pointing"

			Emote:RequestDict(dict)

			SetPedConfigFlag(ped, 36, 1)
			TaskMoveNetworkByName(ped, name, 0.5, 0, dict, 24)
			RemoveAnimDict(dict)
		else
			RequestTaskMoveNetworkStateTransition(ped, "Stop")
			SetPedConfigFlag(ped, 36, 0)
			ClearPedSecondaryTask(ped)
		end

		state:set("pointing", isPointing, true)
	end

	-- Hands up.
	if IsControlJustPressed(0, 252) and not IsPedInAnyVehicle(ped) then
		if self.handsUp then
			self:Stop(self.handsUp)
			self.handsUp = nil
		else
			self.handsUp = self:Play("handsup"..GetRandomIntInRange(2,  6))
		end
	end

	-- Update when pointing.
	if not isPointing then return end

	local camPitch = GetGameplayCamRelativePitch()
	if camPitch < -70.0 then
		camPitch = -70.0
	elseif camPitch > 42.0 then
		camPitch = 42.0
	end
	
	camPitch = (camPitch + 70.0) / 112.0

	local camHeading = GetGameplayCamRelativeHeading()
	local cosCamHeading = Cos(camHeading)
	local sinCamHeading = Sin(camHeading)
	if camHeading < -180.0 then
		camHeading = -180.0
	elseif camHeading > 180.0 then
		camHeading = 180.0
	end

	camHeading = (camHeading + 180.0) / 360.0

	local coords = GetOffsetFromEntityInWorldCoords(ped, (cosCamHeading * -0.2) - (sinCamHeading * (0.4 * camHeading + 0.3)), (sinCamHeading * -0.2) + (cosCamHeading * (0.4 * camHeading + 0.3)), 0.6)
	local ray = Cast_3dRayPointToPoint(coords.x, coords.y, coords.z - 0.2, coords.x, coords.y, coords.z + 0.2, 0.4, 95, ped, 7);
	local retval, didHit, _, _, _ = GetShapeTestResult(ray)

	-- Update signals.
	SetTaskMoveNetworkSignalFloat(ped, "Pitch", camPitch)
	SetTaskMoveNetworkSignalFloat(ped, "Heading", camHeading * -1.0 + 1.0)
	SetTaskMoveNetworkSignalBool(ped, "isBlocked", didHit)
	SetTaskMoveNetworkSignalBool(ped, "isFirstPerson", GetFollowPedCamViewMode() == 4)

	-- Update state.
	if not self.lastState or GetGameTimer() - self.lastState > 200.0 then
		local retval, didHit, hitCoords, surfaceNormal, materialHash, entity = Raycast()

		state:set("pointingCoords", hitCoords, true)
		state:set("pointingEntity", NetworkGetEntityIsNetworked(entity) and NetworkGetNetworkIdFromEntity(entity) or nil, true)

		self.lastState = GetGameTimer()
	end

	if IsDisabledControlJustPressed(0, 24) then
		state:set("pointAndClick", GetNetworkTime(), true)
	end
end

--[[ Threads ]]--
Citizen.CreateThread(function()
	while true do
		Main:UpdateCrouching()
		Main:UpdatePointing()

		Citizen.Wait(0)
	end
end)