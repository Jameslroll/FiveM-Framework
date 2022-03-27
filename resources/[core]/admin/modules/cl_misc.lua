local godmode = false
local invisible = false
local flying = false

--[[ Functions ]]--
local function SetGodmode(value)
	local player = PlayerId()

	SetPlayerInvincible(player, value)
end

local function SetInvisible(value)
	local ped = PlayerPedId()

	SetEntityVisible(ped, not value)
	
	if value then
		SetEntityAlpha(ped, 128)
	else
		ResetEntityAlpha(ped)
	end
end

--[[ Hooks ]]--
Admin:AddHook("toggle", "godmode", function(value)
	godmode = value
	
	SetGodmode(value)
end)

Admin:AddHook("toggle", "invisibility", function(value)
	local ped = PlayerPedId()

	invisible = value

	SetInvisible(value)
end)

Admin:AddHook("toggle", "superman", function(value)
	local ped = PlayerPedId()

	flying = value

	SetPedCanRagdoll(ped, not value)
end)

--[[ Threads ]]--
Citizen.CreateThread(function()
	while true do
		local ped = PlayerPedId()
		local player = PlayerId()

		if godmode and not GetPlayerInvincible(player) then
			SetGodmode(true)
		end

		if invisible then
			if not IsEntityVisible(ped) ~= invisible then
				SetInvisible(true)
			end

			SetPlayerVisibleLocally(player, true)
		end

		if flying then
			local forward = GetEntityForwardVector(ped)
			local velocity = GetEntityVelocity(ped)
			local up = vector3(0.0, 0.0, 1.0)

			-- SetSuperJumpThisFrame(player)
			if IsPedFalling(ped) and not GetIsPedGadgetEquipped(ped, `GADGET_PARACHUTE`) then
				GiveWeaponToPed(ped, `GADGET_PARACHUTE`, 0, true, true)
				SetPedGadget(ped, `GADGET_PARACHUTE`, true)
				print("GIVE GADGET")
			end

			SetPedComponentVariation(ped, 5, 0)
			
			if IsDisabledControlJustPressed(0, 22) then
				velocity = velocity + vector3(0.0, 0.0, 50.0)
			elseif IsPedInParachuteFreeFall(ped) and IsDisabledControlPressed(0, 21) then
				local vertical = ((IsDisabledControlPressed(0, 33) and 1.0) or (IsDisabledControlPressed(0, 32) and -1.0) or 0.0)

				velocity = velocity + Normalize(forward + up * vertical)

				if math.abs(vertical) < 0.01 then
					velocity = vector3(velocity.x, velocity.y, velocity.z * 0.5)
				end
			end
			
			SetEntityVelocity(ped, velocity)
		end

		Citizen.Wait(0)
	end
end)