Tackle = {}

RegisterNetEvent("players:tackle", function(target)
	local source = source

	if not PlayerUtil:CheckCooldown(source, 3.0, true) then return end

	exports.log:Add({
		source = source,
		target = target,
		verb = "tackled",
	})

	TriggerClientEvent("players:tackle", target)
end)