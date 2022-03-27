HUD = { cooldowns = {} }
Thread = {}

--[[ Functions: HUD ]]--
function HUD:Init()
	DisplayRadar(false)

	local dict = "map"
	while not HasStreamedTextureDictLoaded(dict) do
		RequestStreamedTextureDict(dict)
		Citizen.Wait(200)
	end

	AddReplaceTexture("platform:/textures/graphics", "radarmasksm", dict, "radarmasksm")
end

function HUD:Update()
	self.ped = PlayerPedId()
	self.vehicle = GetVehiclePedIsIn(self.ped, false)
	
	if DoesEntityExist(self.vehicle) then
		local class = GetVehicleClass(self.vehicle)
		local model = GetEntityModel(self.vehicle)

		self.entity = self.vehicle
		self.inVehicle = true
		self.inAir = class == 15 or class == 16
		self.isUnderwater = Config.Submersibles[model]
	else
		self.entity = self.ped
		self.inVehicle = false
		self.lastVehicle = nil
	end

	for name, func in pairs(Thread) do
		local cooldown = self.cooldowns[name]
		if cooldown == nil or GetGameTimer() >= cooldown then
			cooldown = func(Thread)
			if cooldown ~= nil then
				self.cooldowns[name] = GetGameTimer() + cooldown
			end
		end
	end
end

function HUD:GetStreetText()
	-- Bearing.
	local heading = GetEntityHeading(self.entity) / 90
	if heading % 1.0 > 0.5 then
		heading = math.ceil(heading)
	else
		heading = math.floor(heading)
	end
	local direction = ""
	if heading == 0 or heading == 4 then
		direction = "North"
	elseif heading == 3 then
		direction = "East"
	elseif heading == 2 then
		direction = "South"
	elseif heading == 1 then
		direction = "West"
	end
	
	-- Position.
	local coords = GetEntityCoords(self.entity)
	local streetText = ""
	local streetName, crossingRoad = GetStreetNameAtCoord(coords.x, coords.y, coords.z)
	local zone = GetNameOfZone(coords.x, coords.y, coords.z)

	if streetName ~= 0 then
		streetText = GetStreetNameFromHashKey(streetName)
		if crossingRoad ~= 0 then
			streetText = streetText.." & "..GetStreetNameFromHashKey(crossingRoad)
		end
	end

	if noZone then
		return streetText
	end

	return direction.." "..streetText.."<br>"..GetLabelText(zone)
end

function HUD:GetAnchor()
	local safezone = math.abs(GetSafeZoneSize() - 1.0) * 10
	local safezoneX = 1.0 / 20.0 * safezone
	local safezoneY = 1.0 / 20.0 * safezone
	local screenWidth, screenHeight = GetActiveScreenResolution()
	local xScale = 1.0 / screenWidth
	local yScale = 1.0 / screenHeight
	local data = {}
	local wideRes = 16.0 / 9.0
	local aspect = GetAspectRatio(0)
	local realAspect = screenWidth / screenHeight

	-- If anybody smarter than me can figure out how to make this work for non-auto aspects, please.
	-- local aspectFactor = wideRes - (screenHeight / screenWidth * wideRes)

	-- data.aspect = wideRes
	-- data.aspect = aspectFactor
	
	data.aspect = wideRes
	-- if math.abs(aspectFactor - wideRes) > 0.001 then
	-- 	print("using wideres")
	-- else
	-- 	data.aspect = aspectFactor
	-- 	print("using aspectfactor")
	-- end
	
	local isUltrawide = realAspect - 0.001 > wideRes
	if isUltrawide then
		data.left = (realAspect - wideRes) / realAspect * 0.5
	end

	-- data.aspectError = math.abs(realAspect - aspect) > 0.001 and math.abs(aspectFactor - aspect) > 0.001
	-- data.aspectError = math.abs(realAspect - aspect) > 0.001 and math.abs(wideRes - aspect) > 0.001
	data.aspectError = false

	data.height = 0.3
	data.width = data.height / data.aspect 
	
	data.left = (data.left or 0.0) + screenWidth * safezoneX * xScale
	data.bottom = yScale * screenHeight * safezoneY

	return data
end

function HUD:Commit(_type, data)
	SendNUIMessage({
		commit = {
			type = _type,
			data = data,
		}
	})
end

--[[ Functions: Thread ]]--
function Thread:Visibility()
	-- Vehicle visiblity.
	if HUD.wasInVehicle ~= HUD.inVehicle then
		HUD.wasInVehicle = HUD.inVehicle
		HUD:Commit("setDisplay", { target = "vehicle", value = HUD.inVehicle })
	end
	-- Air visibility.
	if HUD.wasInAir ~= HUD.inAir then
		HUD.wasInAir = HUD.inAir
		HUD:Commit("setDisplay", { target = "air", value = HUD.inAir })
	end
	-- Land.
	if HUD.wasUnderwater ~= HUD.isUnderwater then
		HUD.wasUnderwater = HUD.isUnderwater
		HUD:Commit("setUnderwater", HUD.isUnderwater)
	end
	-- Overall visibility.
	local isVisible = (GlobalState.hudForced or HUD.inVehicle) and not IsCinematicCamRendering() and not IsPauseMenuActive()
	if not isVisible and GetResourceState("emotes") == "started" then
		local emote = nil-- exports.emotes:GetCurrentEmote()
		if emote ~= nil then
			isVisible = emote.ShowMinimap
		end
	end
	if HUD.isVisible ~= isVisible then
		DisplayRadar(isVisible)

		HUD.isVisible = isVisible
		HUD:Commit("setDisplay", { target = "content", value = isVisible })
	end
	return 500
end

function Thread:Position()
	local anchor = HUD:GetAnchor()
	
	if HUD.lastAnchor then
		local diff = false
		for k, v in pairs(anchor) do
			local _v = HUD.lastAnchor[k]
			local _type = type(v)
			if (_type == "number" and math.abs(v - _v) > 0.001) or (_type ~= "number" and v ~= _v) then
				diff = true
				break
			end
		end
		if not diff then return 2000 end
	end

	HUD.lastAnchor = anchor

	local width = anchor.width
	local height = anchor.height

	local posX = 0.0
	local posY = 0.0
	local paddingX, paddingY = 0.05, 0.125

	SetMinimapComponentPosition("minimap", "L", "B", posX + (width * paddingX / 2), posY - (height * paddingY) - 0.0125, width * (1.0 - paddingX), height * (1.0 - paddingY * 2))
	SetMinimapComponentPosition("minimap_mask", "L", "B", posX + 0.1, posY + 0.2, width - 0.075, height - 0.15)
	SetMinimapComponentPosition("minimap_blur", "L", "B", posX, posY, width, height)

	-- Remove north blip.
	local northBlip = GetNorthRadarBlip()
	if DoesBlipExist(northBlip) then
		SetBlipAlpha(northBlip, 0)
	end

	-- Safe zones.
	HUD:Commit("setAnchor", anchor)

	return 1000
end

function Thread:Frames()
	-- Check visible.

	-- Check minimap.
	if HUD.minimap == nil then
		HUD.minimap = RequestScaleformMovie("minimap")

		SetRadarBigmapEnabled(true, false)
		
		Citizen.Wait(0)
		
		SetRadarBigmapEnabled(false, false)
	end

	-- Minimap.
	if HUD.entity then
		LockMinimapAngle(math.floor(GlobalState.hudAngle or GetEntityHeading(HUD.entity)))
		SetRadarZoomPrecise(GlobalState.hudZoom or 94.5)
	end

	-- Set bigmap inactive.
	if IsBigmapActive() then
		SetRadarBigmapEnabled(false, false)
	end

	-- Hide default components.
	for _, v in ipairs(Config.DisabledComponents) do
		HideHudComponentThisFrame(v)
	end

	-- Hide health/armor bars.
	BeginScaleformMovieMethod(HUD.minimap, "SETUP_HEALTH_ARMOUR")
	ScaleformMovieMethodAddParamInt(3)
	EndScaleformMovieMethod()
	
	-- Minimap.
	SetMinimapClipType(IsPauseMenuActive() and 0 or 1)
	SetMinimapComponent(2, false)
	-- DontTiltMinimapThisFrame()

	return 0
end

function Thread:Fuel()
	if not HUD.inVehicle then return end

	-- Get fuel.
	local fuel = GetVehicleFuelLevel(HUD.entity)
	local maxFuel = GetVehicleHandlingFloat(HUD.entity, "CHandlingData", "fPetrolTankVolume") or 60.0

	-- Update fuel.
	HUD:Commit("setFuel", fuel / maxFuel)

	return 500
end

function Thread:Compass()
	local heading = GlobalState.hudAngle or GetEntityHeading(HUD.entity)

	HUD:Commit("setBearing", {
		heading = heading,
	})

	return 0
end

function Thread:Speedometer()
	if not HUD.inVehicle then return end

	local speed = GetEntitySpeed(HUD.entity)

	HUD:Commit("setText", {
		element = "speed",
		text = math.floor(speed * 2.236936),
	})

	if HUD.inAir then
		local groundZ = GetEntityHeightAboveGround(HUD.entity) or 0.0
		HUD:Commit("setText", {
			element = "altitude",
			text = math.floor(groundZ * 3.28084),
		})
	end

	return 50
end

function Thread:Location()
	HUD:Commit("setText", {
		element = "location",
		text = HUD:GetStreetText(),
	})
	
	return 1000
end

--[[ Exports ]]--
exports("Commit", function(_type, data)
	HUD:Commit(_type, data)
end)

--[[ NUI Callbacks ]]--
RegisterNUICallback("ready", function(_, cb)
	cb(true)
	HUD.ready = true
end)

--[[ Threads ]]--
Citizen.CreateThread(function()
	while true do
		if HUD.ready then
			HUD:Update()
		end
		Citizen.Wait(0)
	end
end)

--[[ Events ]]--
AddEventHandler("hud:clientStart", function()
	HUD:Init()
end)