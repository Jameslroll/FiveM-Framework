Parts = {}

Part = {}
Part.__index = Part

--[[ Functions: Damage ]]--
function Damage.process:Parts(data, deltas, direction)
	if not Parts.parts then return end

	local mult = Config.DamageMults.Base

	-- World collision.
	local isWorld = data.attacker == -1 or data.attacker == PlayerPedId()
	if isWorld then
		mult = mult * Config.DamageMults.WorldCollision
	end
	
	-- Car collisions.
	local isCollision = not isWorld and (data.weapon == `WEAPON_RUN_OVER_BY_CAR` or data.weapon == `WEAPON_RAMMED_BY_CAR`)
	if isCollision then
		mult = mult * Config.DamageMults.CarCollision
	end
	
	local damage = ((deltas.engine or 0.0) + (deltas.body or 0.0) + (deltas.petrol or 0.0)) / 1000.0 * mult
	
	print("TAKING DAMAGE", damage, mult, json.encode(data))
	
	for partId, part in pairs(Parts.parts) do
		local partDirection = part:GetDirection()
		local dot = (partDirection and Dot(partDirection, direction) or GetRandomFloatInRange(-1.0, 1.0)) * 0.5 + 0.5
		if dot > 0.01 then
			part:Damage(dot * damage * (part.settings.DamageMult or 1.0))
		end
	end
end

--[[ Functions: Parts ]]--
function Parts:Init(vehicle)
	if self.vehicle == vehicle then return end
	
	self:Destroy()

	if not vehicle then return end

	Main:Subscribe(vehicle, true)

	self.vehicle = vehicle
	self.parts = {}
	self.built = nil
	self.hasFocus = false
	
	self:Build(Config.Parts)
end

function Parts:Destroy()
	if not self.vehicle then return end
	
	if self.parts then
		for partId, part in pairs(self.parts) do
			part:Focus(false)
		end
	end

	Main:Subscribe(self.vehicle, false)

	self.vehicle = nil
	self.parts = nil
	self.built = nil
	self.hasFocus = false
end

function Parts:Save()
	if not self.updated then return end

	self.updated = nil
	TriggerServerEvent("vehicles:setDamage", GetNetworkId(self.vehicle), self:GetPayload())
end

function Parts:Sync(damage)
	if self.vehicle and self.parts then
		for partId, part in pairs(self.parts) do
			local health = damage[partId] or 1.0
			if math.abs(health - part.health) > 0.01 then
				part.health = health
				part:Update()
			end
		end
	else
		self.healths = damage
	end
end

function Parts:Update()
	if not self.vehicle or not DoesEntityExist(self.vehicle) then return end

	if not self.lastUpdateLift or GetGameTimer() - self.lastUpdateLift > 1000 then
		self.nearLift = false
		self.lastUpdateLift = GetGameTimer()

		local vehicleCoords = GetEntityCoords(self.vehicle)
		for k, lift in ipairs(Config.Lifts) do
			if #(vehicleCoords - lift.Coords) < lift.Radius then
				self.nearLift = true
				break
			end
		end
	end

	if self.parts then
		local isEngineVisible, engineDoor = false, nil
		if self.isNearHood or self.isNearTrunk or self.nearLift then
			isEngineVisible, engineDoor = IsVehicleEngineVisible(self.vehicle)
		end

		local hasFocus = (self.debug and (1 << 1 | 1 << 2)) or (
			(self.nearLift and 1 << 1 or 0) |
			(
				((self.isNearHood and engineDoor == "bonnet") or (self.isNearTrunk and engineDoor == "boot") or self.nearLift) and (
					isEngineVisible or (self.nearLift and not engineDoor)
				) and 1 << 2 or 0
			)
		)

		if self.hasFocus ~= hasFocus then
			self:Focus(hasFocus)
		end

		if IsDriver and (not self.lastUpdate or GetGameTimer() - self.lastUpdate > 200) then
			self.lastUpdate = GetGameTimer()
			
			local values = Handling.values
			local handling = Handling:CopyDefaults()

			for partId, part in pairs(self.parts) do
				local health = part.health or 1.0
				if part.settings.Update then
					part.settings.Update(part, CurrentVehicle, health, handling)
				end
			end
			
			for name, newValue in pairs(handling) do
				local currentValue = values[name]
				if not currentValue or math.abs(newValue - currentValue) > 0.001 then
					Handling:SetField(name, newValue)
				end
			end
		end
	end
end

function Parts:Build(parts, parent)
	self.built = true

	for _, info in ipairs(parts) do
		-- Check conditions.
		if info.Condition and not info.Condition(self.vehicle, parent) then
			goto skipPart
		end
		
		-- Build parts from bones.
		local boneType = type(info.Bone)
		if boneType == "table" then
			for k, bone in ipairs(info.Bone) do
				local _boneType = type(bone)
				if _boneType == "string" then
					self:Create(info, bone, parent)
				elseif _boneType == "table" and bone.Name and (not bone.Condition or bone.Condition(self.vehicle, parent)) then
					self:Create(info, bone.Name, parent)
				end
			end
		else
			self:Create(info, info.Bone, parent)
		end

		::skipPart::
	end
end

function Parts:Create(info, boneName, parent)
	-- Inherit bones.
	if boneName == nil then
		boneName = parent and parent.boneName or -1
	end

	-- Get/find bone index.
	local boneIndex
	if type(boneName) == "string" then
		boneIndex = GetEntityBoneIndexByName(self.vehicle, boneName)
		if boneIndex == -1 then
			return
		end
	else
		boneIndex = boneName
	end

	-- Get offset from info.
	local offset = info.Offset
	if type(offset) == "function" then
		offset = offset(self.vehicle)
	end

	-- Fallback offset to zero.
	if offset == nil then
		offset = vector3(0.0, 0.0, 0.0)
	end

	-- Get positions of bones.
	local boneCoords = boneIndex == -1 and GetEntityCoords(self.vehicle) or GetEntityBonePosition_2(self.vehicle, boneIndex)
	local localCoords = GetOffsetFromEntityGivenWorldCoords(self.vehicle, boneCoords.x, boneCoords.y, boneCoords.z)

	-- Mirror offsets.
	if localCoords.x < -0.0001 then
		offset = vector3(offset.x * -1, offset.y, offset.z)
	end

	-- Convert bone offset to entity offset.
	if parent then
		offset = parent.offset + offset
	else
		offset = localCoords + offset
	end

	-- Create part.
	local rootName = parent and parent.rootName or boneName
	local id = GetHashKey(info.Name.."_"..rootName)
	
	local part = setmetatable({
		boneIndex = boneIndex,
		boneName = boneName,
		direction = #offset > 0.001 and Normalize(offset) or nil,
		health = self.healths and self.healths[id] or 1.0,
		id = id,
		name = info.Name,
		offset = offset,
		parent = parent,
		rootName = rootName,
		settings = info,
	}, Part)
	
	self.parts[id] = part

	-- Create children.
	if info.Parts then
		self:Build(info.Parts, part)
	end

	-- Debug.
	print("Create", info.Name, boneName, id)
end

function Parts:GetPayload()
	local payload = {}

	for partId, part in pairs(self.parts) do
		payload[partId] = part.health and part.health < 0.999 and part.health or nil
	end

	return payload
end

function Parts:Restore()
	if not self.parts then return end

	for partId, part in pairs(self.parts) do
		part:Restore()
	end
end

function Parts:Focus(value)
	self.hasFocus = value

	for partId, part in pairs(self.parts) do
		local isEngine = part:IsEngine()
		local _value = (
			value ~= 0 and (
				value & (1 << 1) ~= 0 and not isEngine or
				value & (1 << 2) ~= 0 and isEngine
			)
		)

		part:Focus(_value)
	end
end

function Parts:Find(name, coords)
	if not self.parts then
		return nil, 0.0
	end

	local nearestPart, nearestDist = nil, 0.0
	
	for partId, part in pairs(self.parts) do
		if part.name == name then
			if not coords then
				return part
			end

			local partCoords = part:GetCoords()
			local dist = #(partCoords - coords)
			if not nearestPart or dist < nearestDist then
				nearestPart = part
				nearestDist = dist
			end
		end
	end

	return nearestPart, nearestDist
end

--[[ Functions: Part ]]--
function Part:GetText()
	local imgHtml = "<img src='nui://vehicles/icons/"..self.name:gsub("%s+", "")..".png' style='height: 32px !important; padding: 4px; filter: drop-shadow(0px 0px 2px rgba(0, 0, 0, 0.5))' />"
	local innerBarHtml = "<div style='position: absolute; width: 100%; bottom: 0%; top: "..((1.0 - self.health) * 100.0).."%; background: rgba(0, 255, 0, 0.8)'></div>"
	local barHtml = "<div style='position: relative; min-width: 8px; min-height: 100%; background: rgba(0, 0, 0, 0.4);'>"..innerBarHtml.."</div>"

	return "<div style='display: flex'>"..imgHtml..barHtml.."</div>"
end

function Part:Focus(value)
	self.hasFocus = value

	-- Remove label and check.
	if not value and self.label then
		exports.interact:RemoveText(self.label)
		self.label = nil

		return
	elseif value and self.label then
		return
	elseif not value then
		return
	end

	-- Create label.
	self.label = exports.interact:AddText({
		text = self:GetText(),
		transparent = true,
		entity = Parts.vehicle,
		offset = self.offset,
		distance = 20.0,
	})
end

function Part:Update()
	if not self.label then return end

	exports.interact:SetText(self.label, self:GetText())
end

function Part:Damage(amount)
	Parts.updated = true

	self.health = math.max(math.min(self.health - amount or 0.0, 1.0), 0.0)
	self:Update()
end

function Part:Restore()
	Parts.updated = true

	self.health = 1.0
	self:Update()
end

function Part:IsEngine()
	return self.name == "Engine" or (self.parent and self.parent.name == "Engine")
end

function Part:GetCoords()
	return GetOffsetFromEntityInWorldCoords(Parts.vehicle, self.offset.x, self.offset.y, self.offset.z)
end

function Part:GetDirection()
	if not self.direction then return end

	local coords = self:GetCoords()
	if not coords then return end

	local _coords = GetEntityCoords(Parts.vehicle)
	return Normalize(coords - _coords)
end

--[[ Listeners ]]--
Main:AddListener("Sync", function(key, value)
	if type(key) == "table" and key.damage then
		Parts:Sync(key.damage)
	elseif key == "damage" then
		Parts:Sync(value)
	end
end)

Main:AddListener("Enter", function(vehicle)
	Parts:Init(vehicle)
end)

Main:AddListener("Exit", function(vehicle)
	Parts:Init(vehicle)
end)

Main:AddListener("UpdateNearestDoor", function(vehicle, door)
	Parts.isNearHood = door == "bonnet"
	Parts.isNearTrunk = door == "boot"
end)

Main:AddListener("UpdateNearestVehicle", function(vehicle)
	Parts.nearestVehicle = vehicle
	if Parts.vehicle ~= vehicle and not IsInVehicle then
		Parts:Init(vehicle)
	end
end)

Main:AddListener("Update", function()
	if not IsDriver then return end

	local fuelInjector = Parts:Find("Fuel Injector")
	if not fuelInjector then return end

	local health = fuelInjector.health or 1.0
	if health > 0.3 then return end
	health = health / 0.3

	local chokeTime = Main.nextChoke and GetGameTimer() - Main.nextChoke
	local max = GetRandomFloatInRange(0.2, 1.0) * (1.0 - health) * 800.0
	if not chokeTime or chokeTime > max then
		Main.nextChoke = GetGameTimer() + GetRandomFloatInRange(0.5, 1.0) * (1.0 - health) * 10000.0
		chokeTime = 0.0
	end
	local chokeNormal = math.min(math.max(math.abs(chokeTime) / max, 0.0), 1.0) * 0.8 + 0.2
	if chokeNormal < 0.99 then
		SetVehicleCurrentRpm(CurrentVehicle, Rpm * chokeNormal)
	end
end)

--[[ Threads ]]--
Citizen.CreateThread(function()
	while true do
		Parts:Update()
		Citizen.Wait(0)
	end
end)

Citizen.CreateThread(function()
	while true do
		Parts:Save()
		Citizen.Wait(5000)
	end
end)

--[[ Commands ]]--
exports.chat:RegisterCommand("a:vehdebug", function(source, args, command, cb)
	Parts.debug = not Parts.debug
	cb("inform", "Vehicle parts will now "..(Parts.debug and "always show" or "act normally")..".")
end, {
	description = "Visualize the nearest vehicle's information.",
}, "Dev")