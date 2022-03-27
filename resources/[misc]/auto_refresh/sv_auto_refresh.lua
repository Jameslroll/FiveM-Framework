Resources = {}
ShouldUpdate = false

AddEventHandler("onResourceStart", function(resourceName)
	Resources[resourceName] = nil
	ShouldUpdate = true
end)

AddEventHandler("onResourceStop", function(resourceName)
	Resources[resourceName] = true
end)

Citizen.CreateThread(function()
	while true do
		if ShouldUpdate then
			for resourceName, _ in pairs(Resources) do
				Citizen.Wait(200)
				print("Auto-starting: "..resourceName)
				StartResource(resourceName)
			end
		end
		
		Resources = {}

		Citizen.Wait(1000)
	end
end)