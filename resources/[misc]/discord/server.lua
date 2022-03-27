Citizen.CreateThread(function()
	Citizen.Wait(2000)
	
	while true do
		TriggerClientEvent(
			"discord:update",
			-1,
			GetNumPlayerIndices(),
			GetConvarInt("sv_maxClients", 0),
			GetConvarInt("dev_mode", 0) == 1
		)

		Citizen.Wait(15000)
	end
end)