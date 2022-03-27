function Door:Create(group, entity, state, info)
	-- Check entity.
	if not entity or not DoesEntityExist(entity) then
		print(("tried creating door with invalid entity (%s)"):format(entity))
		return
	end

	-- Get model settings.
	local model = GetEntityModel(entity)
	local settings = Config.Doors[model] or {}

	-- Get id.
	local id = (Main.lastId or 0) + 1
	Main.lastId = id

	-- Create instance.
	self = setmetatable({
		id = id,
		sid = "door-"..id,
		model = model,
		entity = entity,
		group = group,
		coords = info and info.coords or GetEntityCoords(entity),
		rotation = info and info.rotation or GetEntityRotation(entity),
		forward = info and info.forward or GetEntityForwardVector(entity),
		heading = info and info.heading or GetEntityHeading(entity),
		settings = settings,
	}, Door)

	-- Create door system.
	self:RegisterSystem()

	-- Register interactables.
	self:RegisterInteract()

	-- Fallback default state.
	if state == nil then
		state = self:GetDefaultState()
	end

	-- Update the state.
	self:SetState(state or false, true)

	-- Return instance.
	return self
end

function Door:Destroy()
	-- Cache the destruction.
	self.destroyed = true

	-- Cache the state in the group.
	self.group:Cache(self.coords, self.state)

	--- Remove from group.
	self.group.doors[self.entity] = nil

	-- Remove from door system.
	if IsDoorRegisteredWithSystem(self.id) then
		RemoveDoorFromSystem(self.id)
	end

	-- Clear doubles.
	local double = self.double
	if double and double.double and double.double.id == self.id then
		double.double = nil
	end

	-- Destroy the interact.
	exports.interact:Destroy(self.sid)

	-- Debug.
	if Main.debug then
		exports.interact:RemoveText(self.sid)
		exports.interact:RemoveText(self.sid.."_2")
	end
end

function Door:RegisterSystem()
	if not IsDoorRegisteredWithSystem(self.id) then
		AddDoorToSystem(self.id, self.model, self.coords.x, self.coords.y, self.coords.z, false, false, true)
	end
end

function Door:RegisterInteract()
	-- Register interacts.
	local embedded = {
		{
			id = self.sid.."_1",
			text = "",
			event = "doorLock",
			group = self.group.id,
			entity = self.entity,
			distance = self.settings.Distance,
			-- factions = self.settings.Factions or group.factions,
		},
	}

	-- if self.settings.Item then
	-- 	table.insert(embedded, {
	-- 		id = self.id.."_2",
	-- 		text = "Tamper",
	-- 		event = "doorItem",
	-- 		entity = self.object,
	-- 		items = {
	-- 			{ name = self.settings.Item, amount = 1, hidden = true },
	-- 		},
	-- 	})
	-- end

	exports.interact:Register({
		id = self.sid,
		text = "",
		embedded = embedded,
	})
end

function Door:SetState(value, ignoreDouble)
	-- Cache the state.
	self.state = value

	-- Get settings.
	local settings = self.settings

	-- Wait until the door closes.
	if not settings.Sliding and math.abs(DoorSystemGetOpenRatio(self.id)) > 0.1 then
		local handle = GetGameTimer()

		self = self
		self.timeoutHandle = handle

		Citizen.SetTimeout(20, function()
			if self.destroyed and self.timeoutHandle == handle then
				return
			end

			self.timeoutHandle = nil
			self:SetState(value, ignoreDouble)
		end)

		return
	end

	-- Create door system.
	self:RegisterSystem()

	-- Force it closed.
	if value then
		DoorSystemSetOpenRatio(self.id, 0.0, false, false)
	end

	-- Sliding doors.
	if settings.Speed then
		DoorSystemSetAutomaticRate(self.id, settings.Speed, false, false)
	end

	-- Set the system state.
	local state = value and 1 or 0
	DoorSystemSetDoorState(self.id, state, true)

	-- Set interact text.
	exports.interact:Set(self.sid.."_1", "text", state == 1 and "Unlock" or "Lock")
	exports.interact:ClearOptions(self.object)

	-- Double doors.
	if not ignoreDouble then
		local double, createdDouble = self:FindDouble()

		if double then
			double:SetState(value, true)
		end
	end

	-- Debug.
	if Main.debug then
		print(("door '%s' set state: %s"):format(self.id, (state == 1 and "locked") or (state == 0 and "unlocked") or "default"))

		exports.interact:RemoveText(self.sid)
		exports.interact:RemoveText(self.sid.."_2")

		exports.interact:AddText({
			id = self.sid,
			entity = self.entity,
			text = ([[
				Id: %s<br>
				Entity: %s<br>
				Locked: %s<br>
				Item: %s<br>
			]]):format(
				self.id,
				self.entity,
				tostring(state),
				self.settings.Item or "None"
			)
		})

		if self.settings.HandleOffset then
			exports.interact:AddText({
				id = self.sid.."_2",
				entity = self.entity,
				text = "Handle",
				offset = self.settings.HandleOffset,
			})
		end
	end
end

function Door:FindDouble()
	if self.double then
		return self.double, false
	end

	-- Calculate directions.
	local forward = self.forward
	local right = Cross(forward, Up)

	-- Calculate sizes.
	local min, max = GetModelDimensions(self.model)
	local size = max - min

	-- Find the target.
	local id = self.id
	local door

	for i = 1, 3 do
		local offset = i == 3 and vector3(0, 0, 0) or (i == 1 and right or -right) * (math.max(size.x, size.y) * 2.0)
		local _coords = self.coords + offset

		door = self.group and self.group:FindDoor(_coords, 0.1, function(_entity, _door)
			return _door.id ~= id
		end)

		-- Citizen.CreateThread(function()
		-- 	while not self.destroyed do
		-- 		DrawLine(coords.x, coords.y, coords.z, _coords.x, _coords.y, _coords.z, 255, 0, 0, 255)
		-- 		DrawLine(_coords.x, _coords.y, _coords.z, _coords.x, _coords.y, _coords.z + 1.0, 0, 255, 0, 255)

		-- 		Citizen.Wait(0)
		-- 	end
		-- end)

		if door then
			door.double = self
			self.double = door

			break
		end
	end

	if door then
		return door, true
	end
end

function Door:Update()
	local settings = self.settings

	if settings.Vault then
		-- Freeze the door.
		FreezeEntityPosition(self.entity, true)

		-- Get heading.
		local heading = GetEntityHeading(self.entity)
		local targetHeading = heading

		-- Set target heading.
		if self.state then
			targetHeading = self.heading
		else
			targetHeading = self.heading + settings.Vault
		end

		-- Set current heading.
		if targetHeading > heading then
			heading = math.min(heading + 0.2, targetHeading)
		else
			heading = math.max(heading - 0.2, targetHeading)
		end

		SetEntityHeading(self.entity, heading)

		-- Sounds.
		if math.abs(targetHeading - heading) > 1.0 and GetGameTimer() - (self.lastSound or 0) > 900 then
			PlaySoundFromCoord(-1, "OPENING", self.coords.x, self.coords.y, self.coords.z, "MP_PROPERTIES_ELEVATOR_DOORS", 1, 5.0)
			self.lastSound = GetGameTimer()
		end
	end

	if settings.Force then
		DoorSystemSetOpenRatio(self.id, (self.state and 0.0) or tonumber(settings.Force) or 1.0, true, true)
	end
end

function Door:GetDefaultState()
	-- Return cached default.
	if self.defaultState ~= nil then
		return self.defaultState
	end

	-- Handle group overrides.
	local group = self.group
	local groupOverrides = group.overrides
	if groupOverrides then
		for _, override in ipairs(groupOverrides) do
			if #(self.coords - override.coords) < 0.1 then
				self.defaultState = override.locked
				return override.locked
			end
		end
	end

	-- Model override.
	local settings = self.settings
	if settings.Locked ~= nil then
		self.defaultState = settings.Locked
		return settings.Locked
	end

	-- Either group is locked or it isn't.
	self.defaultState = group.locked or false

	return self.defaultState
end

function Door:ToggleLock()
	local anim = Config.Anims.Locking
	local ped = PlayerPedId()
	local vehicle = IsPedInAnyVehicle(ped) and GetVehiclePedIsIn(ped)

	if vehicle then
		-- Vehicle stuff.
		SetVehicleHandbrake(vehicle, true)
	else
		-- Play emote.
		exports.emotes:Play(anim)
	end

	-- Play sound.
	TriggerServerEvent("playSound3D", "doorlock", 0.4, 0.1)

	-- Disable movement.
	local startTime = GetGameTimer()
	while GetGameTimer() - startTime < anim.Duration do
		DisableControlAction(0, 30)
		DisableControlAction(0, 31)
		DisableControlAction(0, 71)
		DisableControlAction(0, 72)
		DisableControlAction(0, 73)

		Citizen.Wait(0)
	end

	-- Vehicle stuff.
	if vehicle and DoesEntityExist(vehicle) then
		SetVehicleHandbrake(vehicle, false)
	end

	-- Debug.
	Debug("toggle lock", self.id)

	-- Check double door, and decide which one to lock.
	local coords = self.coords
	local double, createdDouble = self:FindDouble()
	if double then
		if coords.x + coords.y + coords.z > double.coords.x + double.coords.y + double.coords.z then
			coords = double.coords
			Debug("use double door pair", double.id)
		end
	end

	-- Finally, toggle lock.
	TriggerServerEvent("doors:toggle", self.group.id, coords, not self.state)
end

--[[ Events ]]--
AddEventHandler("interact:on_doorLock", function(interactable)
	local group = Main.groups[interactable.group or false]
	if not group then print("no group for door") return end

	local door = group.doors[interactable.entity or false]
	if not door then print("no door in group") return end

	door:ToggleLock()
end)