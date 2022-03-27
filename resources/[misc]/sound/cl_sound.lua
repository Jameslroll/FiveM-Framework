RegisterNetEvent("playSound", function(name, volume)
	SendNUIMessage({
		playSound = {
			name = name,
			volume = volume,
		},
	})
end)

RegisterNetEvent("playSound3D", function(name, p2, volume, range)
	local coords

	if type(p2) == "vector3" then
		coords = p2
	elseif type(p2) == "number" then
		local entity = NetworkGetEntityFromNetworkId(p2)
		if not entity or not DoesEntityExist(entity) then return end
		
		coords = GetEntityCoords(entity)
	end

	local ped = PlayerPedId()
	local pedCoords = GetEntityCoords(ped)
	local dist = #(coords - pedCoords)

	volume = (1 / (dist / (range or 1.0) + 1.0)) * (volume or 1.0)
	if volume < 0.01 then return end

	SendNUIMessage({
		playSound = {
			name = name,
			volume = volume,
		},
	})
end)