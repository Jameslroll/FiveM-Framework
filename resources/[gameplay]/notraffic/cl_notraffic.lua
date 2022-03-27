Citizen.CreateThread(function()
	while true do
		-- Traffic.
		SetVehicleDensityMultiplierThisFrame(0.0)
		SetRandomVehicleDensityMultiplierThisFrame(0.0)
		SetAmbientVehicleRangeMultiplierThisFrame(0.1)
		SetParkedVehicleDensityMultiplierThisFrame(0.0)
		
		-- Peds.
		SetPedDensityMultiplierThisFrame(0.0)

		Citizen.Wait(0)
	end
end)
