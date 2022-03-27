Emote = {}
Emote.__index = Emote

function Emote:Create(data, id)
	if type(data) == "string" then
		data = Main.emotes[data]
	end
	
	local emote = setmetatable({
		id = id,
		settings = data,
	}, Emote)
	
	if id then
		local override = Main.playing[id]
		if override then
			override:Remove()
		end

		Main.playing[id] = emote
	end
	
	emote.isUpperBody = IsUpperBody(emote.settings.Flag)

	if data.Autoplay ~= false then
		emote:Play()
	end

	return emote
end

function Emote:Play(settings)
	-- Get settings.
	local settings = settings or self.settings
	if not settings then return end

	-- Clear old emotes.
	for k, v in pairs(Main.playing) do
		local settings = v.settings or {}
		if
			v.id ~= self.id and
			not v.Facial and
			v.isUpperBody == self.isUpperBody and
			not settings.Force
		then
			v:Remove()
		end
	end

	-- Get ped.
	local ped = settings.ped or PlayerPedId()
	self.ped = ped

	-- Check weapon.
	if settings.Unarmed or settings.Armed then
		local weaponGroup = IsPedArmed(ped, 1 | 2 | 4) and exports.weapons:GetWeaponGroup()
		local _settings = {}

		if weaponGroup and weaponGroup.Anim and settings.Armed then
			_settings = settings.Armed[weaponGroup.Anim]
		elseif (not weaponGroup or not weaponGroup.Anim) and settings.Unarmed then
			_settings = settings.Unarmed
		else
			return
		end

		if not _settings then return end

		for k, v in pairs(_settings) do
			settings[k] = v
		end
	end

	-- Disarming.
	if type(settings.Disarm) == "number" then
		Citizen.SetTimeout(settings.Disarm, function()
			TriggerEvent("disarmed")
		end)
	elseif settings.Disarm then
		TriggerEvent("disarmed")
	end

	-- Freezing.
	if settings.Freeze then
		FreezeEntityPosition(ped, true)
		self.frozen = true
	end

	-- Set coords.
	if settings.Coords then
		SetEntityCoordsNoOffset(ped, settings.Coords.x, settings.Coords.y, settings.Coords.z, true)
	end

	-- Set heading.
	if settings.Heading then
		SetEntityHeading(ped, settings.Heading)
	end

	-- Play secondary emote.
	if settings.Secondary then
		self:Play(settings.Secondary)
	end

	-- Play animations.
	if settings.Facial then
		self:RequestDict(settings.Dict)

		ClearFacialIdleAnimOverride(ped)
		SetFacialClipsetOverride(ped, settings.Dict)
		SetFacialIdleAnimOverride(ped, settings.Name)
	elseif settings.Dict then
		self:RequestDict(settings.Dict)

		TaskPlayAnim(
			ped,
			settings.Dict,
			settings.Name,
			settings.BlendIn or settings.BlendSpeed or 2.0,
			settings.BlendOut or settings.BlendSpeed or 2.0,
			settings.Duration or -1,
			settings.Flag or 0,
			settings.Rate or 0.0,
			settings.Lock or false,
			settings.Lock or false,
			settings.Lock or false
		)
	elseif settings.Advanced then
		local coords = settings.Coords or GetEntityCoords(ped)
		local rotation = settings.Rotation or GetEntityRotation(ped)

		TaskPlayAnimAdvanced(
			ped,
			settings.Dict,
			settings.Name,
			coords.x,
			coords.y,
			coords.z,
			rotation.x,
			rotation.y,
			rotation.z,
			settings.BlendIn or settings.BlendSpeed or 2.0,
			settings.BlendOut or settings.BlendSpeed or 2.0,
			settings.Duration or -1,
			settings.Flag or 0,
			settings.Rate or 0.0
		)
	end

	-- Hands up.
	if settings.HandsUp then
		local state = LocalPlayer.state
		state:set("handsup", true, true)
		self.handsup = true
	end

	-- Create props.
	if settings.Props then
		if not self.props then
			self.props = {}
		end

		for k, v in ipairs(settings.Props) do
			if not IsModelValid(v.Model) then
				print("Invalid model during emote: "..tostring(v.Model))
				break
			end

			while not HasModelLoaded(v.Model) do
				RequestModel(v.Model)
				Citizen.Wait(0)
			end

			local coords = GetEntityCoords(ped)
			local entity = CreateObject(v.Model, coords.x, coords.y, coords.z, NetworkGetEntityIsNetworked(ped), true, false)
			local offset = v.Offset or { 0, 0, 0, 0, 0, 0 }

			SetEntityCollision(entity, v.Collision or false, v.Collision or false)
			AttachEntityToEntity(entity, ped, GetPedBoneIndex(ped, v.Bone), offset[1], offset[2], offset[3], offset[4], offset[5], offset[6], false, false, true, true, 0, true)
			SetModelAsNoLongerNeeded(v.Model)

			table.insert(self.props, entity)
		end
	end

	-- Trigger event.
	TriggerEvent("emotes:play", self.id, settings)
end

function Emote:Remove()
	print("removing", self.id)
	
	local ped = PlayerPedId()

	-- Trigger event.
	TriggerEvent("emotes:cancel", self.id)

	-- Clear cache.
	if self.id then
		Main.playing[self.id] = nil
	end

	-- Unfreeze.
	if self.frozen then
		FreezeEntityPosition(ped, false)
	end

	-- Hands up.
	if self.handsup then
		local state = LocalPlayer.state
		state:set("handsup", false, true)
	end
	
	-- Clear props.
	self:RemoveProps()
end

function Emote:RemoveProps()
	if not self.props then return end

	for _, entity in ipairs(self.props) do
		Delete(entity)
	end

	self.props = nil
end

function Emote:RequestDict(dict)
	-- Get dict.
	if not dict then return
		false
	end

	-- Check dict exists.
	if not DoesAnimDictExist(dict) then
		return false
	end

	-- Load dict.
	while not HasAnimDictLoaded(dict) do
		RequestAnimDict(dict)
		Citizen.Wait(0)
	end

	-- Dict loaded.
	return true
end
