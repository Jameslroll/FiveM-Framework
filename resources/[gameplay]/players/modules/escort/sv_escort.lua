Escort = {
	players = {},
}

--[[ Functions: Escort ]]--
function Escort:Start(source, target)
	self.players[target] = source

	TriggerClientEvent("players:escort", target, source)

	return true
end

function Escort:Stop(source)
	self.players[source] = nil
	
	TriggerClientEvent("players:escort", source)

	return true
end

--[[ Events: Net ]]--
RegisterNetEvent("players:escort", function(target)
	local source = source

	-- Check cooldown.
	if not PlayerUtil:CheckCooldown(source, 1.0) then return end
	PlayerUtil:UpdateCooldown(source)

	-- Check target.
	if target ~= nil and (type(target) ~= "number" or target <= 0) then return end

	-- Check ped.
	if target then
		local ped = GetPlayerPed(target)
		if not ped or not DoesEntityExist(ped) then
			return
		end
	end

	-- Following logic.
	local following = target and Escort.players[target]

	if target and following == source and Escort:Stop(target) then
		exports.log:Add({
			source = source,
			target = target,
			verb = "stopped",
			noun = "escort",
		})
	elseif not target and Escort:Stop(source) then
		exports.log:Add({
			source = source,
			target = target,
			verb = "left",
			noun = "escort",
		})
	elseif Escort:Start(source, target) then
		exports.log:Add({
			source = source,
			target = target,
			verb = "started",
			noun = "escort",
		})
	end
end)