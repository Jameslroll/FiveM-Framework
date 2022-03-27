-- RegisterNetEvent("schedule:warn")
-- AddEventHandler("schedule:warn", function(special)
-- 	if special == "james" then
-- 		for i = 1, 30 do
-- 			PlaySoundFrontend(-1, "Beep_Red", "DLC_HEIST_HACKING_SNAKE_SOUNDS", 0)

-- 			Citizen.Wait(1000 * (1.0 - i / 35))
-- 		end
		
-- 		if exports.instances:GetPlayerInstance() then
-- 			exports.instances:LeaveInstance()
-- 			Citizen.Wait(0)
-- 		end
		
-- 		exports.health:ResurrectPed()

-- 		targets = {
-- 			vector4(-413.5270690917969, 1134.240966796875, 325.9045715332031, 0.0),
-- 			vector4(-432.1929931640625, 1139.64013671875, 325.9045715332031, 0.0),
-- 		}

-- 		local target = targets[GetRandomIntInRange(1, #targets)] + vector4(GetRandomFloatInRange(-10.0, 10.0), GetRandomFloatInRange(-10.0, 10.0), 0.0, GetRandomFloatInRange(0.0, 360.0))
-- 		local bones = { "SKEL_Pelvis", "SKEL_L_Foot", "SKEL_R_Foot", "SKEL_L_Hand", "SKEL_R_Hand" }
		
-- 		exports.teleporters:TeleportTo(target)

-- 		Citizen.CreateThread(function()
-- 			while true do
-- 				SetWind(100.0)
-- 				if IsPedArmed(PlayerPedId(), 4) then
-- 					TriggerEvent("disarmed")
-- 				end
-- 				Citizen.Wait(0)
-- 			end
-- 		end)

-- 		Citizen.CreateThread(function()
-- 			Citizen.Wait(15000)

-- 			local startTime = GetGameTimer()

-- 			while GetGameTimer() - startTime < 30000 do
-- 				local ped = PlayerPedId()
-- 				if not IsPedRagdoll(ped) then
-- 					SetPedToRagdoll(ped, 1000, 1000, 0)
-- 				end

-- 				SetEntityHasGravity(ped, false)
				
-- 				local r = 0.3
-- 				for _, bone in ipairs(bones) do
-- 					ApplyForceToEntity(ped, 0, GetRandomFloatInRange(-r, r), GetRandomFloatInRange(-r, r), GetRandomFloatInRange(0.2, 0.4), 0.0, 0.0, 0.0, GetEntityBoneIndexByName(ped, bone), false, true, true, false, true)
-- 				end

-- 				Citizen.Wait(0)
-- 			end

-- 			SetEntityHasGravity(PlayerPedId(), true)

-- 			while true do
-- 				local ped = PlayerPedId()
-- 				local coords = GetEntityCoords(ped)
-- 				local hasGround, groundZ = GetGroundZFor_3dCoord(coords.x, coords.y, coords.z)

-- 				if not hasGround or math.abs(groundZ - coords.z) < 5.0 then
-- 					SetEntityVelocity(ped, 0.0, 0.0, -0.2)
-- 					SetEntityHasGravity(ped, false)
					
-- 					Citizen.Wait(1000)
					
-- 					SetEntityVelocity(ped, 0.0, 0.0, 0.0)
-- 					SetEntityHasGravity(ped, true)

-- 					break
-- 				end

-- 				Citizen.Wait(0)
-- 			end
-- 		end)
-- 	end
-- end)