Carry = Carry or {}

--[[ Functions ]]--
function Carry:Activate(source, target, value, ...)
	local sourceState = (Player(source) or {}).state
	local targetState = (Player(target) or {}).state

	if
		not sourceState or
		not targetState or
		(value and (sourceState.carrying or sourceState.carrier)) or
		(value and (targetState.carrying or targetState.carrier))
	then
		return false
	end

	sourceState.carrying = value and target or nil
	targetState.carrier = value and source or nil

	TriggerClientEvent("players:carry", target, "Target", source, value, ...)
	TriggerClientEvent("players:carry", source, "Source", target, value)

	return true
end

--[[ Events: Net ]]--
RegisterNetEvent("players:carryBegin", function(target, value)
	local source = source

	-- Check type.
	if type(target) ~= "number" or (value ~= nil and not Carry.modes[value]) then return end
	
	-- Check cooldown.
	if not PlayerUtil:CheckCooldown(source, 1.0) then return end
	PlayerUtil:UpdateCooldown(source)

	-- Activate carry.
	if Carry:Activate(source, target, value) then
		exports.log:Add({
			source = source,
			target = target,
			verb = "started",
			noun = "carrying",
			extra = value,
		})
	end
end)

RegisterNetEvent("players:carryEnd", function()
	local source = source

	-- Check cooldown.
	if not PlayerUtil:CheckCooldown(source, 1.0) then return end
	PlayerUtil:UpdateCooldown(source)

	-- Get state.
	local state = (Player(source) or {}).state
	if not state then return end

	local carrying = state.carrying
	local carrier = state.carrier

	-- Stop carrying.
	if
		(carrying and Carry:Activate(source, carrying)) or
		(carrier and Carry:Activate(carrier, source))
	then
		exports.log:Add({
			source = source,
			target = carrying or carrier,
			verb = carrying and "stopped" or "left",
			noun = "carry",
		})
	end
end)

RegisterNetEvent("players:force", function(netId, seatIndex)
	local source = source

	if type(netId) ~= "number" and type(seatIndex) ~= "number" then return end

	-- Check cooldown.
	if not PlayerUtil:CheckCooldown(source, 1.0) then return end
	PlayerUtil:UpdateCooldown(source)

	-- Get state.
	local state = Player(source).state
	if not state then return end

	-- Get target.
	local target = state.carrying
	if not target then return end

	-- Check vehicle.
	local vehicle = NetworkGetEntityFromNetworkId(netId)
	if not vehicle or not DoesEntityExist(vehicle) then return end

	-- Uncarry with parameters.
	if Carry:Activate(source, target, false, netId, seatIndex) then
		exports.log:Add({
			source = source,
			target = target,
			verb = "forced",
			noun = "into vehicle",
			extra = ("net id: %s"):format(netId),
		})
	end
end)