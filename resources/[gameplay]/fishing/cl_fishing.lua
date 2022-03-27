Main = {
	debug = false,
}

--[[ Functions ]]--
function GetHabitat(coords, depth)
	if depth > 100.0 then
		return "Pelagic"
	end
	coords = vector2(coords.x, coords.y)
	local nearestZone = nil
	local nearestDist = 0.0
	for zone, settings in pairs(Config.Zones) do
		for _, zoneCoords in ipairs(settings.Coords) do
			local dist = #(coords - zoneCoords)
			if not nearestZone or dist < nearestDist then
				nearestDist = dist
				nearestZone = zone
			end
		end
	end
	if nearestZone and Config.Zones[nearestZone].DepthPrefix then
		if depth > 10.0 then
			nearestZone = "Deep "..nearestZone
		else
			nearestZone = "Shallow "..nearestZone
		end
	end
	return nearestZone
end

--[[ Functions: Main ]]--
function Main:Init()
	if not self.debug then return end

	local color = 0
	for zone, settings in pairs(Config.Zones) do
		for _, coords in ipairs(settings.Coords) do
			local blip = AddBlipForCoord(coords.x, coords.y, 0.0)
			SetBlipSprite(blip, 68)
			SetBlipColour(blip, color)
			SetBlipScale(blip, 1.0)
			SetBlipAlpha(blip, 192)
			SetBlipHiddenOnLegend(blip, true)
			SetBlipDisplay(blip, 3)
		end
		color = color + 5
	end
end

function Main:CanFish()
	local ped = PlayerPedId()

	return (
		not IsPedInAnyVehicle(ped) and
		not IsPedSwimming(ped)
	)
end

function Main:Start(slot)
	if self.fishing then return end

	self.slot = slot.slot_id
	self.fishing = true
	self.emote = exports.emotes:Play(Config.Anims.Idle)
end

function Main:Stop()
	if not self.fishing then return end

	self.fishing = false
	self.slot = nil
	
	if self.emote then
		exports.emotes:Stop(self.emote)
		self.emote = nil
	end
end

function Main:Update()
	local delay = GetRandomIntInRange(Config.Delay[1] * 1000, Config.Delay[2] * 1000)
	Citizen.Wait(delay)

	if not self.fishing then return end

	local ped = PlayerPedId()
	local coords = GetPedBoneCoords(ped, 60309, 0.0, 0.0, 2.5)
	local zone = GetNameOfZone(coords.x, coords.y, coords.z)
	local obstructions = 0
	local depth = 0.0

	for i = 0, 19 do
		local target = GetOffsetFromEntityInWorldCoords(ped, 0.0, 10.0 + i * 60.0, -300.0)
		local retval, surface = TestProbeAgainstWater(coords.x, coords.y, coords.z, target.x, target.y, target.z)
		if retval and #(surface - coords) > 100.0 then
			retval = false
		end
		if retval then
			local rayHandle = StartShapeTestRay(surface.x, surface.y, surface.z + 1000.0, surface.x, surface.y, surface.z - 1000.0, 1, nil, 0)
			local _retval, hit, floor, surfaceNormal, entityHit = GetShapeTestResult(rayHandle)
			if hit == 1 then
				depth = math.max(depth, #(floor - coords) - #(surface - coords))
				if self.debug then
					Citizen.CreateThread(function()
						for i = 1, 300 do
							DrawLine(surface.x, surface.y, surface.z, floor.x, floor.y, floor.z, 0, 0, 255, 255)
							Citizen.Wait(0)
						end
					end)
				end
			elseif zone == "SanAnd" or zone == "OCEANA" then
				depth = 1000.0
			end
		else
			obstructions = obstructions + 1
		end

		if self.debug then
			Citizen.CreateThread(function()
				for i = 1, 300 do
					local r, g, b = 255, 0, 0
					if retval then
						r = 0
						g = 255
					end
					DrawLine(coords.x, coords.y, coords.z, target.x, target.y, target.z, r, g, b, 255)
					Citizen.Wait(0)
				end
			end)
		end
	end

	local peers = 0
	local localPlayer = PlayerId()

	for _, player in ipairs(GetActivePlayers()) do
		if (
			player ~= localPlayer and
			#(coords - GetEntityCoords(GetPlayerPed(GetPlayerFromServerId(player)))) < Config.PeerBonus.Range
		) then
			peers = peers + 1
		end
	end

	local weatherType, weatherType2, percentWeather = GetWeatherTypeTransition()
	if percentWeather > 0.5 then
		weatherType = weatherType2
	end

	local chance = (
		Config.Chance * (1.0 - (obstructions / 15)) +
		Config.PeerBonus.Chance * math.min(peers / Config.PeerBonus.Count, 1.0) +
		(Config.WeatherModifiers[weatherType] or 0.0)
	)
	local random = GetRandomFloatInRange(0.0, 1.0)

	if self.debug then
		print("chance", chance, "obstructions", obstructions, "peers", peers, "depth", depth, "random", random)
	end

	-- Can't catch.
	if obstructions >= 15 then
		TriggerEvent("chat:notify", obstructions >= 20 and "The line won't move without water!" or "The line is stuck!", "inform")
		return
	end
	
	-- No catch. :(
	if random > chance then
		TriggerEvent("chat:notify", obstructions > 0 and "The line is a little stuck, but you feel it reeling..." or "The line is reeling...", "success")
		return
	end

	-- Catch!
	TriggerEvent("chat:notify", "You feel a bite!", "success")

	Citizen.Wait(2000)

	if not self.fishing then return end
	if not exports.quickTime:Begin(Config.QuickTime) then return end

	Citizen.Wait(200)

	if not self.fishing then return end

	local slotId = self.slot
	if not slotId then return end
	
	exports.emotes:Play(Config.Anims.Catch)
	TriggerServerEvent("fishing:catch", slotId, GetHabitat(GetEntityCoords(PlayerPedId()), depth))

	self:Stop()
end

--[[ Threads ]]--
Citizen.CreateThread(function()
	while true do
		if Main.fishing then
			Main:Update()
			Citizen.Wait(0)
		else
			Citizen.Wait(1000)
		end
	end
end)

--[[ Events ]]--
AddEventHandler("inventory:use", function(item, slot, cb)
	if item.name ~= Config.Item or not Main:CanFish() then
		return
	end

	cb(1000)
end)

AddEventHandler("inventory:useFinish", function(item, slot)
	if item.name ~= Config.Item then
		return
	end

	if Main.fishing then
		Main:Stop()
	else
		Main:Start(slot)
	end
end)

AddEventHandler("inventory:updateSlot", function(containerId, slotId, slot, item)
	if slotId == Main.slot and (not item or item.name ~= Config.Item) then
		Main:Stop()
	end
end)

AddEventHandler("emotes:cancel", function(id)
	if Main.emote == id then
		Main:Stop()
	end
end)