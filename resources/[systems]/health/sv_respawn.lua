RegisterNetEvent("health:respawn", function()
	local source = source

	-- Check cooldown.
	if not PlayerUtil:CheckCooldown(source, 1.0) then return end
	PlayerUtil:UpdateCooldown(source)

	-- Get inventory.
	local containerId = exports.inventory:GetPlayerContainer(source, true)
	if not containerId then return end

	-- Log it.
	exports.log:Add({
		source = source,
		verb = "respawned",
	})

	-- Clear inventory.
	exports.inventory:ContainerEmpty(containerId)

	-- Confirm to client.
	TriggerClientEvent("health:respawn", source)
end)