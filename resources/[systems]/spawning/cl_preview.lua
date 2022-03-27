Preview = setmetatable({
	peds = {},
}, {
	__index = function(table, key)
		return key ~= "settings" and Preview.settings and Preview.settings[key]
	end
})

function Preview:Init()
	-- Fade out.
	DoScreenFadeOut(0)
	Citizen.Wait(1000)

	-- Cache settings.
	local settings = Config.Previews[GetRandomIntInRange(1, #Config.Previews + 1)]

	self.settings = settings
	self.isActive = true

	-- Move to area.
	local ped = PlayerPedId()
	local coords = settings.Camera.Coords

	if coords then
		SetEntityCoordsNoOffset(ped, coords.x, coords.y, 0.0, true)
	end
	
	-- Init functions.
	for k, v in pairs(self) do
		if k:sub(1, 5) == "Init_" then
			v(self)
		end
	end
	
	-- Fade in.
	DoScreenFadeIn(2000)
end

function Preview:Destroy()
	local camera = self.camera
	if camera then
		camera:Destroy()
		self.camera = nil
	end
	
	ClearFocus()
	ClearTimecycleModifier()
	
	for _, audioScene in ipairs(Config.AudioScenes) do
		StopAudioScene(audioScene)
	end
	
	for ped, _ in pairs(self.peds) do
		DeleteEntity(ped)
	end

	self.peds = {}
	self.isActive = false
end

function Preview:Init_Cam()
	local camera = Camera:Create({
		coords = self.Camera.Coords,
		rotation = self.Camera.Rotation,
		fov = self.Camera.Fov,
		shake = {
			type = "HAND_SHAKE",
			amount = 0.1,
		}
	})

	camera:Activate()

	self.camera = camera
end

function Preview:Init_Timecycle()
	if self.Timecycle then
		SetTimecycleModifier(self.Timecycle.Name)
		SetTimecycleModifierStrength(self.Timecycle.Strength or 1.0)
	else
		ClearTimecycleModifier()
	end
end

function Preview:Init_Audio()
	for _, audioScene in ipairs(Config.AudioScenes) do
		StartAudioScene(audioScene)
	end
end

function Preview:Init_Peds()
	if not self.settings then return end
	
	local characters = Main.characters
	if not characters then return end

	local index = 1
	local order = {}

	for id, character in pairs(characters) do
		table.insert(order, { r = GetRandomFloatInRange(0.0, 1.0), id = id })
	end

	table.sort(order, function(a, b)
		return a.r < b.r
	end)

	for k, v in ipairs(order) do
		local character = characters[v.id]
		local data = {
			appearance = character.appearance,
			features = character.features,
		}

		local magnet = self.settings.Peds[index]
		local coords = magnet and magnet.Coords
		local ped = magnet and exports.customization:CreatePed(data, coords)

		if ped then
			self.peds[ped] = tonumber(id) or true

			FreezeEntityPosition(ped, true)
			SetEntityCollision(ped, false, false)
			SetEntityCoordsNoOffset(ped, coords.x, coords.y, coords.z)

			exports.emotes:PlayOnPed(ped, magnet.Anim)

			index = index + 1
		end
	end
end

function Preview:Update()
	-- local cam = self.cam
	-- if not cam then return end

	-- cam:Set("pos", self.Camera.Coords)
	-- cam:Set("rot", self.Camera.Rotation)
	-- cam:Set("fov", self.Camera.Fov)
	
	SetFocusPosAndVel(self.Camera.Coords)
end

--[[ Threads ]]--
Citizen.CreateThread(function()
	while true do
		if Preview.isActive then
			Preview:Update()
			Citizen.Wait(0)
		else
			Citizen.Wait(200)
		end
	end
end)

--[[ Events ]]--
AddEventHandler("spawning:stop", function()
	for ped, info in pairs(Preview.peds) do
		DeleteEntity(ped)
	end
end)