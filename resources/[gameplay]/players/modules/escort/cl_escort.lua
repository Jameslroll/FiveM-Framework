Escort = {}

--[[ Options ]]--
Main:AddOption({
	id = "playerEscort",
	text = "Escort",
	icon = "follow_the_signs",
}, function(player, playerPed, dist, serverId)
	if not serverId then return false end

	local state = Player(serverId).state
	if not state then return false end

	return state.restrained and not state.immobile
end, function(player, playerPed, serverId)
	if not serverId then return end

	-- Check door.
	local seatIndex = FindSeatPedIsIn(playerPed)
	if seatIndex and not IsVehicleDoorOpen(GetVehiclePedIsIn(playerPed), seatIndex + 1) then
		return
	end

	-- Get state.
	local state = (Player(serverId) or {}).state
	if not state or state.immobile or not state.restrained then
		return
	end

	-- Begin escort.
	TriggerServerEvent("players:escort", serverId)
end)

--[[ Functions: Escort ]]--
function Escort:Start(serverId)
	-- Get player.
	local player = GetPlayerFromServerId(serverId)
	if not player then return end

	-- Get peds.
	local ped = PlayerPedId()
	local playerPed = GetPlayerPed(player)
	
	-- Update cache.
	self.target = playerPed
	self.serverId = serverId

	if IsPedInAnyVehicle(ped) then
		TaskLeaveAnyVehicle(ped, 0, 256)
	end

	-- Update state.
	LocalPlayer.state:set("following", serverId, true)
end

function Escort:Stop()
	if not self.target then return end
	local ped = PlayerPedId()

	-- Clear cache.
	self.target = nil
	self.serverId = nil

	-- Clear tasks.
	ClearPedTasks(ped)
	ClearPedSecondaryTask(ped)

	-- Update state.
	LocalPlayer.state:set("following", nil, true)
end

function Escort:Update()
	if not self.target or not self.serverId then return end

	if not DoesEntityExist(self.target) then
		self:Stop()
		return
	end

	local ped = PlayerPedId()
	local dist = Distance(GetEntityCoords(ped), GetEntityCoords(self.target))
	local state = (LocalPlayer or {}).state

	if dist > 10.0 or not state or state.immobile or not state.restrained then
		TriggerServerEvent("players:escort")
		return
	end

	local state = (Player(self.serverId) or {}).state
	local pointTime = state.pointing and state.pointAndClick

	if pointTime and self.pointTime ~= pointTime then
		local vehicle = state.pointingEntity and NetworkGetEntityFromNetworkId(state.pointingEntity) or 0
		local coords = state.pointingCoords or vector3(0, 0, 0)

		self.pointTime = pointTime

		if vehicle and DoesEntityExist(vehicle) then
			local seatIndex, dist = GetClosestSeat(coords, vehicle, true)
			local doorIndex = seatIndex and seatIndex + 1

			print("open?", doorIndex, IsVehicleDoorOpen(vehicle, doorIndex))
			if doorIndex and IsVehicleDoorOpen(vehicle, doorIndex) then
				ClearPedTasks(ped)
				ClearPedSecondaryTask(ped)

				TriggerServerEvent("players:escort", self.serverId)
				
				local startTime = GetGameTimer()
				while not GetIsTaskActive(ped, 160) and DoesEntityExist(vehicle) and GetGameTimer() - startTime < 6000 do
					TaskEnterVehicle(ped, vehicle, -1, seatIndex, 1.0, 1, 0)
					Citizen.Wait(200)
				end
			end
		end

		return
	end

	local isInVehicle = IsPedInAnyVehicle(ped)
	local isEntering = not isInVehicle and IsPedInAnyVehicle(ped, true)

	if dist > 2.0 and not isInVehicle then
		print("refollow")
		TaskFollowToOffsetOfEntity(ped, self.target, 0.0, 0.0, 0.0, 1.0, -1, 1.5, false)
	end
end

--[[ Events: Net ]]--
RegisterNetEvent("players:escort", function(serverId)
	if serverId then
		Escort:Start(serverId)
	else
		Escort:Stop()
	end
end)

--[[ Threads ]]--
Citizen.CreateThread(function()
	while true do
		Escort:Update()
		Citizen.Wait(200)
	end
end)