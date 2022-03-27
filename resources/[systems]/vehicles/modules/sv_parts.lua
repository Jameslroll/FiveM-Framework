RegisterNetEvent("vehicles:setDamage", function(netId, info)
	local source = source
	
	-- Check input.
	if type(info) ~= "table" then return end

	-- Check cooldown.
	if not PlayerUtil:CheckCooldown(source, 1.0, true) then return end

	-- Get entity from net id.
	local entity = Main:GetEntityFromNetworkId(netId)
	if not entity then return end

	-- Get vehicle.
	local vehicle = Main.vehicles[netId]
	if not vehicle then return end

	-- Check driver.
	if GetPedInVehicleSeat(entity, -1) ~= GetPlayerPed(source) then
		return
	end

	-- Check info.
	for id, value in pairs(info) do
		if type(id) ~= "number" or type(value) ~= "number" or not Main.parts[id] then
			-- TODO: anti-cheat.
			return
		else
			info[id] = math.ceil(value * 1000.0) / 1000.0
		end
	end

	-- Update vehicle.
	vehicle:Set("damage", info)
end)