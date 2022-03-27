--[[ Functions ]]--
function Admin:Init()
	local function formatOptions(options)
		for k, option in ipairs(options) do
			if option.checkbox ~= nil then
				option.OnValueChange = function(self, value)
					Admin:InvokeHook("toggle", option.hook, value)
				end
			elseif option.options then
				formatOptions(option.options)
			else
				option.func = function(self)
					if option.command then
						ExecuteCommand(option.command)
					end
					if option.close then
						Menu:Toggle(false)
					end
					Admin:InvokeHook("select", option.hook, self)
				end
			end
		end
	end

	formatOptions(Config.Options)
end

function Admin:GetPlayer(serverId)
	local player = self.players[serverId]
	if player then
		return player
	end

	TriggerServerEvent(self.event.."requestPlayer", serverId)

	local startTime = GetGameTimer()
	while self.players[serverId] == nil or GetGameTimer() - startTime > 500 do
		Citizen.Wait(20)
	end

	return self.players[serverId]
end

--[[ Events ]]--
AddEventHandler(Admin.event.."clientStart", function()
	Admin:Init()
end)

RegisterNetEvent(Admin.event.."receivePlayer", function(serverId, data)
	Admin.players[serverId] = data
end)

RegisterNetEvent(Admin.event.."goto", function(coords, instance, serverId)
	exports.teleporters:TeleportTo(coords, instance)

	local player = GetPlayerFromServerId(serverId)
	if not player or player == PlayerId() then return end

	local playerPed = GetPlayerPed(player)
	if not DoesEntityExist(playerPed) then return end

	local ped = PlayerPedId()
	local vehicle = GetVehiclePedIsIn(playerPed)

	if DoesEntityExist(vehicle) then
		local seatIndex = FindFirstFreeVehicleSeat(vehicle)
		if seatIndex then
			SetPedIntoVehicle(ped, vehicle, seatIndex)
		end
	end
end)

--[[ Threads ]]--
Citizen.CreateThread(function()
	while true do
		Citizen.Wait(0)
	end
end)

--[[ Callbacks ]]--
RegisterNUICallback("request", function(data)
	Admin:InvokeHook("request", data.name, data.active)
end)

RegisterNUICallback("toggle", function(data)
	Admin:InvokeHook("toggle", data.name, data.active)
end)