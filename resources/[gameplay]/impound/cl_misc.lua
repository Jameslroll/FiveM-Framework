function WaitForAnimWhileFacingVehicle(anim, vehicle)
	-- Cache time.
	local startTime = GetGameTimer()

	-- Start emote.
	exports.emotes:Play(anim)

	-- Check vehicle.
	while GetGameTimer() - startTime < anim.Duration do
		TriggerEvent("interact:suppress")
		if vehicle ~= exports.oldutils:GetFacingVehicle() then
			exports.emotes:Stop()
			return false
		end
		Citizen.Wait(200)
	end

	-- Return result.
	return true
end