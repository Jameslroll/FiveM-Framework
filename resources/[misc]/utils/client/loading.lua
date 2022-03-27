function WaitForGround(coords, timeout)
	if not coords then
		coords = GetEntityCoords(PlayerPedId())
	end

	local startTime = GetGameTimer()
	local hasGround, groundZ

	while GetGameTimer() - startTime < (timeout or 6000) do
		hasGround, groundZ = GetGroundZFor_3dCoord(coords.x, coords.y, coords.z)

		if hasGround then
			break
		else
			Citizen.Wait(0)
		end
	end

	return hasGround, groundZ
end