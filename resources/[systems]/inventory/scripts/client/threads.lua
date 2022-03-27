Citizen.CreateThread(function()
	while true do
		Inventory:UpdateInput()
		
		Citizen.Wait(0)
	end
end)

Citizen.CreateThread(function()
	while true do
		Drops:Update()
		Citizen.Wait(100)
	end
end)

Citizen.CreateThread(function()
	while true do
		Drops:ProcessQueue()
		Citizen.Wait(0)
	end
end)