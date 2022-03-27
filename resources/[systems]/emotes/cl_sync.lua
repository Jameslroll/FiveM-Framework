Main.sync = {}

--[[ Functions: Main ]]--
function Main:Invite(serverId, name)
	local player = GetPlayerFromServerId(serverId)
	local ped = GetPlayerPed(player)
	if not DoesEntityExist(ped) then return end
	
	local emote = self.emotes[name]
	if not emote then return end
	
	local text = exports.interact:AddText({
		duration = 12000,
		text = emote.Text or name,
		entity = ped,
		offset = emote.Target.Offset,
	})
	
	self.sync[serverId] = {
		emote = name,
		text = text,
	}
	
	Citizen.SetTimeout(12000, function()
		self.sync[serverId] = nil
	end)
end

function Main:ExpireInvite(serverId)
	local info = self.sync[serverId]
	if not info then return end

	if info.text then
		exports.interact:RemoveText(info.text)
	end

	self.sync[serverId] = nil
end

function Main:UpdateInvites()
	local ped = PlayerPedId()

	if
		IsPedInAnyVehicle(ped) or
		IsPedSwimming(ped) or
		IsPedRunning(ped) or
		IsPedSprinting(ped) or
		IsPedRagdoll(ped) or
		IsPedFalling(ped)
	then
		return
	end

	local coords = GetEntityCoords(ped)
	local localPlayer = PlayerId()

	for serverId, info in pairs(self.sync) do
		local player = GetPlayerFromServerId(serverId)
		if player == localPlayer then goto skipPlayer end

		local playerPed = GetPlayerPed(player)
		local playerCoords = GetEntityCoords(playerPed)
		local emote = self.emotes[info.emote]
		local magnet = GetOffsetFromEntityInWorldCoords(playerPed, emote.Target.Offset)
		local dist = Distance(playerCoords, coords)

		if dist < 1.2 and IsControlJustPressed(0, 46) then
			TriggerServerEvent("emotes:accept", serverId, info.emote)
			break
		end

		::skipPlayer::
	end
end

--[[ Events: Net ]]--
RegisterNetEvent("emotes:invite", function(serverId, name)
	Main:Invite(serverId, name)
end)

RegisterNetEvent("emotes:expire", function(serverId)
	Main:ExpireInvite(serverId)
end)

--[[ Threads ]]--
Citizen.CreateThread(function()
	while true do
		Main:UpdateInvites()
		Citizen.Wait(0)
	end
end)