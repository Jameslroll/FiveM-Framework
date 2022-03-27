Npcs = {
	Main = {
		id = "TERRITORY",
		coords = vector4(181.7585601806641, -968.7265014648438, 30.559233169555664, 138.34873962402344),
		floating = true,
		model = "mp_m_freemode_01",
		data = json.decode('[1,22,21,8,10,[5,1,3,8,2,8,5,2,2,4,9,5,8,1,10,5,3,6,7,6],[[0,0.0,1],[0,0.01,1],[12,0.92,1],[0,0.0,1],[0,0.0,1],[0,0.0,1],[0,0.0,1],[0,0.0,1],[0,0.0,1],[0,0.0,1],[0,0.0,1],[0,0.0,1],[0,0.0,1]],[[0,0,1,1],[228,2,1,1],[0,0,1,1],[180,0,1,1],[134,2,1,1],[0,0,1,1],[140,1,1,1],[197,0,1,1],[105,0,1,1],[0,0,1,1],[0,0,1,1],[142,0,1,1]],0,[[0,0],[0,0],[0,0],[],[],[],[0,0],[0,0]],[{"1":1},[],[]]]'),
		idle = {
			dict = "misscarsteal1leadin",
			name = "devon_idle_02",
		},
		dialogue = {
			["INIT"] = {
				text = "So, you have come.",
				responses = {
					{ text = "What do you want from us?", next = "DESC" },
					{ text = "Where do I need to look?", next = "INFO" },
				},
			},
			["DESC"] = {
				text = "This world will undergo a trial. Far more treacherous than any other it has faced. My pumpkins. They have gone rougue. This one, above me, is the final pumpkin I have control over. The others have wandered off. If I attempt to gather them, I might lose my last. Please, help me gather my pumpkins. Take a picture with them, they're very photogenic, and return to me.",
				next = "INIT",
			},
			["INFO"] = {
				text = "There are 6 missing pumpkins. I know the location of two. Do not be frightened, but they will speak to you when you find them. They may know where the others are. The first always liked the smell of coal and the black smoke it produced. The second had a fondness for an activity done on four wheels where the ground was looming.",
				next = "INIT",
			},
		},
	},
}

Locations = {
	[1] = vector3(181.7585601806641, -968.7265014648438, 32.509233169555664), -- Legion.
	[2] = vector3(1098.247802734375, -1981.164794921875, 31.014650344848633), -- Smeltery.
	[3] = vector3(-1370.3702392578125, -1396.538818359375, 4.107173442840576), -- Skatepark.
	[4] = vector3(-262.6850280761719, -2017.1314697265625, 30.042036056518555), -- Maze arena.
	[5] = vector3(-172.91598510742188, 285.0506286621094, 93.61554718017578), -- Jap rest.
	[6] = vector3(1122.83447265625, 67.96484375, 80.89035034179688), -- Track.
	[7] = vector3(2053.154296875, 2985.921630859375, -61.90174865722656), -- IAA.
}

Texts = {
	[2] = "I knew somebody would come eventually. The other pumpkins always said I shouldn't spend my whole life watching coal burn. Especially the one that liked food from overseas. I forgot which country, but they have as many old people as vending machines there. Which was a lot.", -- Smeltry -> Jap rest.
	[3] = "I always watched people skateboarding here and thought it's what I wanted to do with my life. Now I'm not too sure. Maybe I'll join the other pumpkin in his acting carreer. I guess being a star doesn't sound too bad.", -- Skatepark -> Maze arena.
	[4] = "You talking to me? You're probably looking for my cousin, they like to race those big ugly animals that all they do is eat carrots and hay.", -- Maze arena -> Track.
	[5] = "I heard they had some sushi, but all I could find was this green paper stuff... I think I'm going to tell the other pumpkins about this scam! Don't tell them I said this, but they work for the government in a top secret facility. They didn't really tell me how to find it, all he said was \"We have the best view of the stars.\"", -- Jap rest -> IAA.
	[6] = "Horsey go burr-burr.", -- Track.
	[7] = "How'd you find me? Ah whatever just get it over with...", -- IAA.
}

Model = GetHashKey("prop_veg_crop_03_pump")
Sounds = nil
Objective = nil
ObjectiveEntity = 0

Citizen.CreateThread(function()
	while GetResourceState("npcs") ~= "started" do
		Citizen.Wait(100)
	end

	for k, npc in pairs(Npcs) do
		local id = exports.npcs:Add(npc)
	end
	
	local dict = "core"
	local name = "bul_stungun"

	while not HasNamedPtfxAssetLoaded(dict) do
		RequestNamedPtfxAsset(dict)
		Citizen.Wait(0)
	end

	local coords = Npcs.Main.coords
	
	while true do
		local ped = PlayerPedId()
		local pedCoords = GetEntityCoords(ped) 
		local dist = #(pedCoords - vector3(coords.x, coords.y, coords.z))
		local isNearby = dist < 200.0
		if not isNearby then
			if Sounds then
				for _, v in ipairs(Sounds) do
					StopSound(v)
				end
				Sounds = nil
			end
			goto continue
		end

		if dist < 30.0 then
			pedCoords = GetEntityCoords(ped)
			local dir = pedCoords - vector3(coords.x, coords.y, coords.z - 5.0)
			dir = (dir / #dir)
			
			local vehicle = GetVehiclePedIsIn(ped, false)
			if vehicle and DoesEntityExist(vehicle) then
				dir = dir * 40.0
				SetEntityVelocity(vehicle, 1, dir.x, dir.y, dir.z, 0.0, 0.0, 0.0, -1, false, false, false, false, true)
				Citizen.Wait(20)
			elseif IsPedArmed(ped, 6) then
				Citizen.Wait(2000)
				-- Check still armed.
				if IsPedArmed(ped, 6) then
					-- Slap em.
					TriggerEvent("disarmed")
					exports.mythic_notify:SendAlert("error", "Out of my sight with that thing", 4000)
					for i = 1, 120 do
						dir = dir * 50.0
						if not IsPedRagdoll(ped) then
							SetPedToRagdoll(ped, 1000, 1000, 0)
						end
						ApplyForceToEntity(ped, 1, dir.x, dir.y, dir.z, 0.0, 0.0, 0.0, -1, false, false, false, false, true)
						Citizen.Wait(20)
					end
					Citizen.Wait(4000)
				end
			end
		end

		if not Sounds then
			Sounds = {
				PlaySoundFromCoord(-1, "WIND", coords.x, coords.y, coords.z, "EXTREME_01_SOUNDSET", true, 50.0),
				PlaySoundFromCoord(-1, "HOUSE_FIRE", coords.x, coords.y, coords.z, "JOSH_03_SOUNDSET", true, 50.0, 0),
			}
		end

		-- Flashes.
		MakeRandomParticle("core", "ent_anim_paparazzi_flash", 1.0, 30.0, 1.0, 2.0)

		-- Weird lights.
		if GetRandomFloatInRange(0.0, 1.0) < 0.4 then
			MakeRandomParticle("core", "veh_sub_crush", 2.0, 10.0, 2.0, 0.1)
		end

		-- Smoke.
		if GetRandomFloatInRange(0.0, 1.0) < 0.02 then
			MakeRandomParticle("core", "veh_respray_smoke", 2.0, 10.0, 3.0, 0.1)
		end

		-- Big splash.
		if GetRandomFloatInRange(0.0, 1.0) < 0.2 then
			MakeRandomParticle("core", "bul_water_heli", 6.0, 9.0, GetRandomFloatInRange(1.0, 1.2))
			PlaySoundFromCoord(-1, "UNDER_WATER_COME_UP", coords.x, coords.y, coords.z, nil, true, 1.0, 0)
		end

		::continue::
		Citizen.Wait(200)
	end
end)

Citizen.CreateThread(function()
	local lastObjective = nil
	while true do
		Objective = nil
		local coords = GetEntityCoords(PlayerPedId())
		for k, v in ipairs(Locations) do
			if #(v - coords) < 200.0 then
				Objective = k
				break
			end
		end

		if Objective ~= lastObjective then
			if Objective then
				local objectiveCoords = Locations[Objective]
				while not HasModelLoaded(Model) do
					RequestModel(Model)
					Citizen.Wait(0)
				end
				ObjectiveEntity = CreateObject(Model, objectiveCoords, false, true, false)
				FreezeEntityPosition(ObjectiveEntity, true)
			else
				DeleteEntity(ObjectiveEntity)
				ObjectiveEntity = nil
			end
		end

		lastObjective = Objective
		
		Citizen.Wait(1000)
	end
end)

Citizen.CreateThread(function()
	local lastParticle = 0
	while true do
		while not Objective do
			Citizen.Wait(200)
		end

		local objectiveCoords = Locations[Objective]
		local dist = #(GetEntityCoords(PlayerPedId()) - objectiveCoords)
		if ObjectiveEntity then
			local time = GetGameTimer()
			SetEntityRotation(ObjectiveEntity, math.sin(time / 1000) * 45, 0.0, math.cos(time / 3000.0) * 360.0)
			SetEntityCoords(ObjectiveEntity, objectiveCoords.x, objectiveCoords.y, objectiveCoords.z + math.cos(time / 500) * 0.1)
		end
		if GetGameTimer() - lastParticle > 500 then
			MakeRandomParticle("core", "ent_anim_paparazzi_flash", 0.0, 2.0, 1.0, 2.0, objectiveCoords)
			MakeRandomParticle("core", "veh_sub_crush", 0.0, 3.0, 2.0, 0.1, objectiveCoords)
			lastParticle = GetGameTimer()
		end
		if dist < 2.0 and IsControlJustPressed(0, 46) and Texts[Objective] then
			TriggerEvent("chat:addMessage", "Pumpkin: "..Texts[Objective])
		end
		Citizen.Wait(0)
	end
end)

function MakeRandomParticle(dict, name, min, max, scale, zMax, coords)
	while not HasNamedPtfxAssetLoaded(dict) do
		RequestNamedPtfxAsset(dict)
		Citizen.Wait(0)
	end

	local coords = coords or Npcs.Main.coords
	local rad = GetRandomFloatInRange(0.0, 6.28)
	local z = 0.0
	local dist = GetRandomFloatInRange(min, max)

	if zMax then
		z = GetRandomFloatInRange(0.0, zMax)
	end
	
	coords = vector3(coords.x, coords.y, coords.z) + vector3(math.cos(rad), math.sin(rad), z) * dist

	UseParticleFxAssetNextCall(dict)
	local particle = StartParticleFxNonLoopedAtCoord(
		name,
		coords.x, coords.y, coords.z - 0.5,
		0.0, 0.0, 0.0,
		(scale or 1.0)
	)

	SetParticleFxLoopedFarClipDist(particle, 50.0)

	return particle
end

AddEventHandler("halloween-quest:stop", function()
	if ObjectiveEntity then
		DeleteEntity(ObjectiveEntity)
	end
end)