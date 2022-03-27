Stretcher = {
	speed = 0.0,
	models = {
		[`stretcher`] = {},
		[`stryker_M1`] = {},
		[`mxpro`] = { Offset = vector3(0.0, -1.0, 1.2) },
		[`stryker_M1_coroner`] = {},
		-- [`stretcher_basket`] = {},
	},
	controls = {
		21,
		22,
		24,
		25,
		30,
		31,
		34,
		35,
	},
}

function Stretcher:Activate(vehicle)
	if IsEntityAttachedToAnyPed(vehicle) then return end

	local model = GetEntityModel(vehicle)

	local info = self.models[model]
	if not info then return end

	-- Request access.
	if not WaitForAccess(vehicle) then return end

	local ped = PlayerPedId()
	local boneIndex = GetEntityBoneIndexByName(vehicle, "bonnet")
	local pos = info.Offset or vector3(0.0, 1.3, -0.42)
	local rot = info.Rotation or vector3(0.0, 0.0, 180.0)

	-- Check distance to offset.
	local magnet = GetEntityBonePosition_2(vehicle, boneIndex)
	local coords = GetEntityCoords(ped)

	if #(vector2(coords.x, coords.y) - vector2(magnet.x, magnet.y)) > 1.0 or math.abs(coords.z - magnet.z) > 1.5 then
		return
	end

	-- Update stretcher.
	SetVehicleExtra(vehicle, 1, false)
	SetVehicleExtra(vehicle, 2, true)

	-- Attach stretcher to ped.
	AttachEntityToEntity(vehicle, ped, -1, pos.x, pos.y, pos.z, rot.x, rot.y, rot.z, false, false, false, true, 0, true)

	-- Cache stuff.
	self.vehicle = vehicle
	self.startTime = GetGameTimer()
end

function Stretcher:Deactivate()
	local ped = PlayerPedId()
	local vehicle = self.vehicle

	WaitForAccess(vehicle)

	if not IsEntityAttachedToAnyVehicle(vehicle) then
		SetVehicleExtra(vehicle, 1, true)
		SetVehicleExtra(vehicle, 2, false)
	end
	
	if IsEntityAttachedToEntity(vehicle, ped) then
		DetachEntity(vehicle, true, true)
	end
	
	self.vehicle = nil
	self.startTime = nil
	self.lastUpdate = nil

	-- Stop emote.
	if self.emote then
		exports.emotes:Stop(self.emote)
		self.emote = nil
	end
end

function Stretcher:Update()
	local ped = PlayerPedId()
	local vehicle = self.vehicle

	-- Check ped.
	if IsPedRagdoll(ped) or not IsEntityAttachedToEntity(vehicle, ped) or (IsDisabledControlJustReleased(0, 23) and GetGameTimer() - self.startTime > 1000) then
		self:Deactivate()
		return
	end

	local deltaTime = self.lastUpdate and (GetGameTimer() - self.lastUpdate) / 1000.0 or 0
	local heading = GetEntityHeading(ped)
	local horizontal = GetDisabledControlNormal(0, 30) --(IsDisabledControlPressed(0, 34) and -1.0) or (IsDisabledControlPressed(0, 35) and 1.0) or 0.0
	local vertical = math.max(-GetDisabledControlNormal(0, 31), 0.0)

	self.lastUpdate = GetGameTimer()
	self.speed = Lerp(self.speed, horizontal * vertical * 0.5, deltaTime * 2.0)

	if vertical > 0.01 and (not self.lastGait or GetGameTimer() - self.lastGait > 500) then
		SimulatePlayerInputGait(PlayerId(), 1.0, 500, 0.0, 1, 0)
		self.lastGait = GetGameTimer()
	end

	-- Disable input.
	for _, control in ipairs(self.controls) do
		DisableControlAction(0, control)
	end
	
	-- Update heading.
	SetEntityHeading(ped, heading - self.speed * 5.0, true)

	-- Force view mode.
	if GetFollowPedCamViewMode() ~= 1 then
		SetFollowPedCamViewMode(1)
	end

	-- Play emote.
	if not self.emote or not exports.emotes:IsPlaying(self.emote) then
		self.emote = exports.emotes:Play({ Dict = "anim@heists@box_carry@", Name = "idle", Flag = 49 })
	end
end

function Stretcher:GetSettings(vehicle)
	return vehicle and DoesEntityExist(vehicle) and self.models[GetEntityModel(vehicle)] or nil
end

function Stretcher:GetVehicleStretcherAttached(vehicle)
	for _vehicle, _ in EnumerateVehicles() do
		if self.models[GetEntityModel(_vehicle)] and IsEntityAttachedToEntity(_vehicle, vehicle) then
			return _vehicle
		end
	end
end

function Stretcher:Load(stretcher, vehicle)
	local model = GetEntityModel(vehicle)
	local settings = Main:GetSettings(model)

	settings = settings and settings.Stretcher
	if not settings then return end

	-- Request access to the vehicle.
	if not WaitForAccess(vehicle) then return end

	-- Open doors.
	if settings.Doors then
		for _, doorIndex in ipairs(settings.Doors) do
			SetVehicleDoorOpen(vehicle, doorIndex, true, true)
			Citizen.Wait(0)
		end
	end

	Citizen.Wait(1000)

	-- Request access to the stretcher.
	if not WaitForAccess(stretcher) then return end
	
	local pos = settings.Offset or vector3(0.0, 0.0, 0.0)
	local rot = settings.Rotation or vector3(0.0, 0.0, 0.0)
	local boneIndex = settings.Bone and GetEntityBoneIndexByName(source, settings.Bone) or -1

	-- Update stretcher.
	SetVehicleExtra(stretcher, 1, false)
	SetVehicleExtra(stretcher, 2, true)
	
	-- Attach stretcher.
	AttachEntityToEntity(stretcher, vehicle, boneIndex, pos.x, pos.y, pos.z, rot.x, rot.y, rot.z, false, false, false, false, 0, true)

	-- Close doors.
	Citizen.Wait(1000)

	if not WaitForAccess(vehicle) then return end

	if settings.Doors then
		for _, doorIndex in ipairs(settings.Doors) do
			SetVehicleDoorShut(vehicle, doorIndex, true)
			Citizen.Wait(0)
		end
	end
end

function Stretcher:Unload(stretcher, vehicle)
	local model = GetEntityModel(vehicle)
	local settings = Main:GetSettings(model)

	settings = settings and settings.Stretcher
	if not settings then return end

	-- Request access to the vehicle.
	if not WaitForAccess(vehicle) then return end

	-- Open doors.
	if settings.Doors then
		for _, doorIndex in ipairs(settings.Doors) do
			SetVehicleDoorOpen(vehicle, doorIndex, true, true)
			Citizen.Wait(0)
		end
	end

	Citizen.Wait(1000)

	-- Request access to the stretcher.
	if not WaitForAccess(stretcher) then return end

	-- Get position.
	local rotation = GetEntityRotation(vehicle)
	local offset = settings.Unload or vector3(0.0, 0.0, 0.0)
	local coords = GetOffsetFromEntityInWorldCoords(vehicle, offset)

	-- Request access... again.
	if not WaitForAccess(stretcher) then return end
	
	-- Update position.
	DetachEntity(stretcher, true, true)
	SetEntityCoords(stretcher, coords.x, coords.y, coords.z)
	PlaceObjectOnGroundProperly(stretcher)

	SetVehicleExtra(stretcher, 1, true)
	SetVehicleExtra(stretcher, 2, false)

	-- Close doors.
	Citizen.Wait(1000)

	if not WaitForAccess(vehicle) then return end

	if settings.Doors then
		for _, doorIndex in ipairs(settings.Doors) do
			SetVehicleDoorShut(vehicle, doorIndex, true)
			Citizen.Wait(0)
		end
	end
end

--[[ Exports ]]--
exports("IsStretcher", function(vehicle)
	return Stretcher:GetSettings(vehicle) ~= nil
end)

exports("GetStretcher", function(vehicle)
	return Stretcher:GetSettings(vehicle)
end)

--[[ Listeners ]]--
Main:AddListener("Enter", function(vehicle)
	if Stretcher.models[GetEntityModel(vehicle)] then
		local ped = PlayerPedId()
		ClearPedTasksImmediately(ped)
	end
end)

Main:AddListener("ActivateStretcher", function(vehicle)
	Stretcher:Activate(vehicle)
end)

--[[ Events ]]--
AddEventHandler("vehicles:clientStart", function()
	for model, settings in pairs(Stretcher.models) do
		exports.interact:Register({
			id = "stretcher-"..model,
			model = model,
			text = "Lay",
			event = "activateStretcher"
		})
	end
end)

AddEventHandler("interact:onNavigate_loadStretcher", function(option)
	local stretcher = option.stretcher
	if not stretcher or not DoesEntityExist(stretcher) then return end

	local vehicle = option.vehicle
	if not vehicle or not DoesEntityExist(vehicle) then return end

	Stretcher:Load(stretcher, vehicle)
end)

AddEventHandler("interact:onNavigate_unloadStretcher", function(option)
	local stretcher = option.stretcher
	if not stretcher or not DoesEntityExist(stretcher) then return end

	local vehicle = option.vehicle
	if not vehicle or not DoesEntityExist(vehicle) then return end

	Stretcher:Unload(stretcher, vehicle)
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