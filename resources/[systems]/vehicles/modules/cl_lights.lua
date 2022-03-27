Lights = {
	blinkers = {},
	horns = {},
	sirens = {},
	sounds = {},
}

--[[ Functions ]]--
function Lights:PlaySound(id, vehicle, sound)
	local sounds = self.sounds[id]
	if not sounds then
		sounds = {}
		self.sounds[id] = sounds
	end

	local soundId = sounds[vehicle]
	if soundId then
		StopSound(soundId)
		ReleaseSoundId(soundId)
		sounds[vehicle] = nil
	end

	if sound then
		soundId = GetSoundId()
		sounds[vehicle] = soundId

		PlaySoundFromEntity(soundId, sound, vehicle, 0, 0, 0)
	end
end

function Lights:UpdateSiren(vehicle, state)
	self.sirens[vehicle] = state

	SetVehicleHasMutedSirens(vehicle, true)
	SetVehicleSiren(vehicle, state and state > 0)

	local model = GetEntityModel(vehicle)
	local _type = Main:GetSettings(model).Type or "Police"
	local siren = state and state > 0 and Config.Sirens[_type][state]

	self:PlaySound("siren", vehicle, siren)
end

function Lights:UpdateHorn(vehicle, state)
	self.horns[vehicle] = state

	self:PlaySound("horn", vehicle, state == 1 and "SIRENS_AIRHORN")
end

function Lights:UpdateBlinkers(vehicle, state)
	self.blinkers[vehicle] = state

	SetVehicleIndicatorLights(vehicle, 0, state == 2 or state == 3)
	SetVehicleIndicatorLights(vehicle, 1, state == 1 or state == 3)
end

function Lights:UpdateCache()
	self.vehicles = {}
	for vehicle, _ in EnumerateVehicles() do
		if NetworkGetEntityIsNetworked(vehicle) and GetVehicleClass(vehicle) == 18 then
			self.vehicles[vehicle] = true
		end
	end
end

function Lights:Update()
	local cached = {}
	for vehicle, _ in pairs(self.vehicles) do
		if DoesEntityExist(vehicle) then
			cached[vehicle] = true
			local entity = Entity(vehicle)
			
			if entity.state.siren and self.sirens[vehicle] ~= entity.state.siren then
				self:UpdateSiren(vehicle, entity.state.siren)
			end

			if entity.state.blinker and self.blinkers[vehicle] ~= entity.state.blinker then
				self:UpdateBlinkers(vehicle, entity.state.blinker)
			end

			if entity.state.horn and self.horns[vehicle] ~= entity.state.horn then
				self:UpdateHorn(vehicle, entity.state.horn)
			end
		end
	end

	for id, sounds in pairs(self.sounds) do
		for vehicle, soundId in pairs(sounds) do
			if not cached[vehicle] then
				StopSound(soundId)
				ReleaseSoundId(soundId)
	
				sounds[vehicle] = nil
			end
		end
	end

	for vehicle, state in pairs(self.sirens) do
		if not cached[vehicle] then
			self.sirens[vehicle] = nil
		end
	end

	for vehicle, state in pairs(self.blinkers) do
		if not cached[vehicle] then
			self.blinkers[vehicle] = nil
		end
	end
end

--[[ Listeners ]]--
Main:AddListener("Update", function()
	if
		not IsInVehicle or
		not IsControlEnabled(0, 51) or
		not IsControlEnabled(0, 52) or
		(FindSeatPedIsIn(Ped) or 1) > 0
	then
		return
	end

	-- Sirens.
	if ClassSettings.UseSirens then
		for i = 80, 86 do
			DisableControlAction(0, i)
		end
		
		local entity = Entity(CurrentVehicle)
		if not entity then return end
		
		local currentSiren = IsSirenOn and entity.state.siren
		local sirenValue = nil
		local hornValue = nil

		-- Toggle light.
		if IsDisabledControlJustPressed(0, 85) then
			local enabled = not IsSirenOn
			sirenValue = enabled and 1 or 0
		end

		-- Toggle sound.
		if IsDisabledControlJustPressed(0, 80) then
			sirenValue = (entity.state.siren or 1) > 1 and 1 or 2
		end
		
		-- Siren stages.
		if IsDisabledControlJustPressed(0, 224) and currentSiren and currentSiren > 1 then
			sirenValue = (entity.state.siren or 1) + 1
			if sirenValue > 3 then
				sirenValue = 2
			end
		end

		-- Horny.
		if IsDriver then
			if IsDisabledControlJustPressed(0, 86) then
				hornValue = 1
			elseif IsDisabledControlJustReleased(0, 86) then
				hornValue = 0
			end
			
			if IsDisabledControlJustPressed(0, 209) and currentSiren and currentSiren > 1 and Config.Sirens[Main:GetSettings(Model).Type or "Police"][4] ~= nil then
				Lights.lastSiren = currentSiren == 4 and Lights.lastSiren or currentSiren
				sirenValue = 4
			elseif IsDisabledControlJustReleased(0, 209) and currentSiren == 4 then
				sirenValue = Lights.lastSiren or 2
			end
		end
		
		-- Update sirens.
		if sirenValue then
			TriggerServerEvent("vehicles:setState", "siren", sirenValue)
		end

		-- Update horns.
		if hornValue then
			TriggerServerEvent("vehicles:setState", "horn", hornValue)
		end
	end

	-- Blinkers.
	if IsDisabledControlPressed(0, 62) then
		DisableControlAction(0, 59)
		DisableControlAction(0, 63)
		DisableControlAction(0, 64)
		DisableControlAction(0, 72)

		local turnSignal = nil

		if IsDisabledControlJustPressed(0, 63) then
			turnSignal = 1
		elseif IsDisabledControlJustPressed(0, 64) then
			turnSignal = 2
		elseif IsDisabledControlJustPressed(0, 72) then
			turnSignal = 3
		end

		if turnSignal then
			local value = GetVehicleIndicatorLights(CurrentVehicle)

			if turnSignal == value then
				turnSignal = 0
			end

			TriggerServerEvent("vehicles:setState", "blinker", turnSignal)
		end
	end
end)

--[[ Threads ]]--
Citizen.CreateThread(function()
	while true do
		Lights:UpdateCache()
		Citizen.Wait(1000)
	end
end)

Citizen.CreateThread(function()
	while true do
		Lights:Update()
		Citizen.Wait(20)
	end
end)