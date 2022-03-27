Camera = nil
CurrentSettings = nil
RotationOffset = vector3(0.0, 0.0, 0.0)
ZoomLevel = 1.0
Scaleform = nil

--[[ Threads ]]--
Citizen.CreateThread(function()
	while true do
		while not Camera do
			Citizen.Wait(500)
		end

		UpdateCamera()
		UpdateInput()

		Citizen.Wait(0)
	end
end)

--[[ Events ]]--
for name, settings in pairs(Config.Types) do
	RegisterNetEvent("inventory:use_"..name)
	AddEventHandler("inventory:use_"..name, function(item, slotId)
		if Camera then
			ExitView()
		elseif not IsPedInAnyVehicle(PlayerPedId()) then
			EnterView(settings)
		end
	end)
end

--[[ Functions ]]--
function EnterView(settings)
	if Camera then
		return
	end

	CurrentSettings = settings

	if settings.Anim then
		exports.emotes:Play(settings.Anim, function()
			ExitView()
		end)
	end

	DoScreenFadeOut(500)
	Citizen.Wait(500)
	
	SetFollowPedCamViewMode(1)
	Citizen.Wait(0)
	
	Camera = exports.oldutils:CreateCam()
	Camera:Set("fov", settings.Zoom.Max or 20.0)
	Camera:Set("shake", settings.Shake or 0.0)
	Camera:Activate()

	RotationOffset = vector3(0.0, 0.0, 0.0)
	ZoomLevel = 1.0

	UpdateCamera()
	
	if settings.Scaleform then
		Scaleform = RequestScaleformMovie(settings.Scaleform)
		while not HasScaleformMovieLoaded(Scaleform) do
			Citizen.Wait(20)
		end

		PushScaleformMovieFunction(Scaleform, "SET_CAM_LOGO")
		PushScaleformMovieFunctionParameterInt(0)
		PopScaleformMovieFunctionVoid()
	else
		Scaleform = nil
	end

	if settings.Timecycle then
		SetTimecycleModifier(settings.Timecycle.Name)
		SetTimecycleModifierStrength(settings.Timecycle.Strength)
	end
	
	Citizen.Wait(250)

	DoScreenFadeIn(500)
end

function ExitView()
	if Camera then
		Camera:Deactivate()
		Camera = nil
	end
	if Scaleform then
		SetScaleformMovieAsNoLongerNeeded(Scaleform)
	end
	ClearTimecycleModifier()
	ClearFocus()

	CurrentSettings = nil
	
	exports.emotes:Stop()
end

function UpdateInput()
	for k, v in ipairs({ 23, 24, 25, 46, 44, 45, 140, 141, 142, 143 }) do
		if IsDisabledControlJustPressed(0, v) then
			ExitView()
			break
		end
	end
end

function UpdateCamera()
	if not Camera or not CurrentSettings then return end

	local lookX, lookY = GetDisabledControlUnboundNormal(1, 1), GetDisabledControlUnboundNormal(1, 2)
	RotationOffset = vector3(
		math.min(math.max(RotationOffset.x - lookY * CurrentSettings.Sensitivity, CurrentSettings.Vertical.Min), CurrentSettings.Vertical.Max),
		0,
		math.min(math.max(RotationOffset.z - lookX * CurrentSettings.Sensitivity, CurrentSettings.Horizontal.Min), CurrentSettings.Horizontal.Max)
	)

	local zoomU, zoomD = GetDisabledControlUnboundNormal(1, 241), GetDisabledControlUnboundNormal(1, 242)
	ZoomLevel = math.min(math.max(ZoomLevel - (zoomU * CurrentSettings.ZoomSensitivity) + (zoomD * CurrentSettings.ZoomSensitivity), 0.0), 1.0)

	local ped = PlayerPedId()
	local bone = GetEntityBoneIndexByName(ped, "IK_Head")
	local forward = GetEntityForwardVector(ped)
	local coords = GetWorldPositionOfEntityBone(ped, bone) + forward * ((CurrentSettings.Forward or 1.0) * 0.3) + vector3(0.0, 0.0, CurrentSettings.Up or 0.1)
	local rotation = vector3(RotationOffset.x, RotationOffset.y, RotationOffset.z + GetEntityHeading(ped))

	-- local rot = vector3(0.0, GetEntityHeading(ped), 0.0)-- GetWorldRotationOfEntityBone(ped, bone) + vector3(0.0, 90.0, 0.0)

	Camera:Set("pos", coords)
	Camera:Set("rot", rotation)
	Camera:Set("fov", exports.misc:Lerp(CurrentSettings.Zoom.Min, CurrentSettings.Zoom.Max, ZoomLevel))

	local retval, didHit, hitCoords, surfaceNormal, materialHash, entity = table.unpack(exports.oldutils:Raycast())
	if didHit == 1 then
		-- DrawLine(coords.x, coords.y, coords.z, hitCoords.x, hitCoords.y, hitCoords.z, 255, 0, 0, 255)
		-- coords = hitCoords
	else
		local range = (math.cos(GetGameTimer() / 2000.0) * 0.5 + 0.5) * 3000.0
		hitCoords = coords + forward * range
		-- coords = coords + forward * 20.0
	end

	-- SetFocusPosAndVel(coords.x, coords.y, coords.z, 0.0, 0.0, 0.0)
	
	local offset = hitCoords - coords
	local dist = #offset

	-- SetFocusPosAndVel(coords.x, coords.y, coords.z, offset.x, offset.y, offset.z)
	SetFocusPosAndVel(hitCoords.x, hitCoords.y, hitCoords.z, 0.0, 0.0, 0.0)

	if Scaleform then
		DrawScaleformMovieFullscreen(Scaleform, 255, 255, 255, 255)
	end
end

--[[ Test ]]--
-- Citizen.CreateThread(function()
-- 	while true do
-- 		if IsControlJustPressed(0, 46) then
-- 			TriggerEvent("inventory:use_Binoculars")
-- 		end
-- 		Citizen.Wait(0)
-- 	end
-- end)