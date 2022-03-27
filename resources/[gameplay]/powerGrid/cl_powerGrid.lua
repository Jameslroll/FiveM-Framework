Main = {}

--[[ Functions ]]--
function Main:Init()
	for k, placement in ipairs(Config.Bombs.Placements) do
		exports.interact:Register({
			placementId = k,
			text = "Place",
			id = "powerGrid_bomb-"..k,
			coords = placement.Coords,
			radius = 1.0,
			event = "powerGrid",
			items = {
				{ name = "Plastic Explosive", amount = 1, hidden = true }
			},
		})
	end
end

function Main:Destroy()
	for k, placement in ipairs(Config.Bombs.Placements) do
		exports.interact:Destroy("powerGrid_bomb-"..k)
	end
end

function Main:Update()
	local ped = PlayerPedId()
	local coords = GetEntityCoords(ped)
	local isNearby = #(Config.Center - coords) < Config.Radius

	if self.isNearby ~= isNearby then
		self.isNearby = isNearby

		if isNearby then
			self:Init()
		else
			self:Destroy()
		end
	end
end

function Main:BeginPlacing(id)
	-- Get placement.
	local placement = Config.Bombs.Placements[id]
	local coords = placement.Coords
	local target = placement.Target

	-- Move to target.
	if target and not exports.emotes:MoveTo(target, coords) then
		return
	end

	-- Perform QTE.
	local qte = { 80.0, 60.0, 40.0, 20.0 }

	exports.emotes:Play(Config.Bombs.Anims.Place)
	
	TriggerEvent("disarmed")

	TriggerEvent("quickTime:begin", "linear", qte, function(success, _stage)
		if success then
			exports.emotes:Play(Config.Bombs.Anims.Success)
		else
			-- Perform emote.
			exports.emotes:Play(Config.Bombs.Anims.Fail)
			
			-- Register evidence.
			if GetRandomFloatInRange(0.0, 1.0) < Config.Bombs.Fail.EvidenceChance then
				local ped = PlayerPedId()
				local coords = GetEntityCoords(ped)
				local hasGround, groundZ = GetGroundZFor_3dCoord(coords.x, coords.y, coords.z)

				if hasGround then
					exports.evidence:Register("Blood", vector3(coords.x, coords.y, groundZ))
				end
			end

			-- Send dispatch.
			if GetRandomFloatInRange(0.0, 1.0) < Config.Bombs.Fail.DispatchChance then
				exports.dispatch:Report("Emergency", { "10-31", "Terror" }, 0, coords, false, { coords = coords })
			end
		end

		if _stage >= #qte and success then
			self:FinishPlacing(id)
		end
	end)

	-- self:FinishPlacing(id)
end

function Main:FinishPlacing(id)
	TriggerServerEvent(EventPrefix.."plant", id)
end

function Main:Detonate(object)
	local dict, name = "des_gas_station", "ent_ray_paleto_gas_explosion"
	while not HasNamedPtfxAssetLoaded(dict) do
		RequestNamedPtfxAsset(dict)
		Citizen.Wait(0)
	end

	for k, v in ipairs(object) do
		local coords = v.Coords + (v.Normal or vector3(0.0, 0.0, 0.0)) * 0.5
		local size = (v.Mega and 3.0) or 1.0

		-- Play sound.
		Citizen.CreateThread(function()
			local camDist = #(coords - GetFinalRenderedCamCoord())
			if camDist > ((v.Mega and 500.0) or 1000.0) then return end
			
			Citizen.Wait(math.floor(camDist / 340.29 * 1000))
			PlaySoundFromCoord(-1, (v.Mega and "Jet_Explosions") or "MAIN_EXPLOSION_CHEAP", coords.x, coords.y, coords.z, (v.Mega and "exile_1") or 0, 0, 0, 0)
		end)

		-- Play particle effect.
		UseParticleFxAssetNextCall(dict)
		StartParticleFxNonLoopedAtCoord(name, coords.x, coords.y, coords.z, 0.0, 0.0, 0.0, GetRandomFloatInRange(1.0, 2.0) * size)
		
		-- Damage.
		local ped = PlayerPedId()
		local dir = GetEntityCoords(ped) - coords
		local dist = #dir
		local maxDist = 14.0 * size

		dir = dir / dist

		if dist < maxDist then
			local force = (1.0 - dist / maxDist) * 20.0
			local vel = GetEntityVelocity(ped)

			vel = vel + dir * force

			-- Add force.
			SetPedToRagdoll(ped, 2000, 2000, 0)
			SetEntityVelocity(ped, vel.x, vel.y, vel.z)

			-- Explode vehicle.
			if dist < maxDist * 0.8 and IsPedInAnyVehicle(ped) then
				local vehicle = GetVehiclePedIsIn(ped)
				if GetPedInVehicleSeat(vehicle, -1) == ped then
					local vehCoords = GetEntityCoords(vehicle)
					AddExplosion(vehCoords.x, vehCoords.y, vehCoords.z, 0, 100.0, true, false, 0.5)
				end
			end

			-- Take damage.
			exports.health:TakeDamage(math.ceil((1.0 - dist / 12.0) * 100.0), 0, "WEAPON_EXPLOSION")
		end

		-- Delay.
		Citizen.Wait(GetRandomIntInRange(200, 600))
		
		-- Create proxy explosions.
		if v.Proxies ~= nil then
			Citizen.CreateThread(function()
				self:Detonate(v.Proxies)
			end)
		end
	end
end

function Main:CreateBomb(coords, rotation)
	local model = GetHashKey(Config.Bombs.Model)
	while not HasModelLoaded(model) do
		RequestModel(model)
		Citizen.Wait(20)
	end

	local entity = CreateObject(model, coords.x, coords.y, coords.z, true, true, false)
	SetEntityRotation(entity, rotation)

	PlaySoundFrontend(-1, "Case_Beep", "GTAO_Magnate_Finders_Keepers_Soundset", 0)
end

--[[ Threads ]]--
Citizen.CreateThread(function()
	while true do
		Main:Update()
		Citizen.Wait(1000)
	end
end)

--[[ Events ]]--
AddEventHandler(EventPrefix.."stop", function()
	Main:Destroy()
end)

AddEventHandler("interact:on_powerGrid", function(interactable)
	local id = interactable.placementId
	if id == nil then return end

	TriggerServerEvent(EventPrefix.."check", id)
end)

RegisterNetEvent(EventPrefix.."plant")
AddEventHandler(EventPrefix.."plant", function(id, isPlanted)
	if isPlanted then
		exports.mythic_notify:SendAlert("error", "Already occupied!", 7000)
	else
		Main:BeginPlacing(id)
	end
end)

RegisterNetEvent(EventPrefix.."planted")
AddEventHandler(EventPrefix.."planted", function(id)
	local placement = Config.Bombs.Placements[id]
	if placement == nil then return end

	Main:CreateBomb(placement.Coords, exports.misc:ToRotation(placement.Normal))
end)

RegisterNetEvent(EventPrefix.."detonate")
AddEventHandler(EventPrefix.."detonate", function()
	local camDist = #(Config.Center - GetFinalRenderedCamCoord())
	if camDist < 6000.0 then
		Main:Detonate(Config.Bombs.Placements)
	end
end)

RegisterNetEvent("inventory:use_Detonater")
AddEventHandler("inventory:use_Detonater", function(item, slot)
	-- Emote.
	exports.emotes:Play(Config.Bombs.Anims.Detonate)

	-- Wait.
	Citizen.Wait(3000)

	-- Check distance.
	local coords = GetEntityCoords(PlayerPedId())
	if #(coords - Config.Center) > Config.Bombs.MaxDistance then
		exports.mythic_notify:SendAlert("error", "No signal!", 7000)
		return
	end

	-- Trigger event.
	TriggerServerEvent(EventPrefix.."detonate")
end)