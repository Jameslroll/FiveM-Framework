--[[ Events ]]--
RegisterNetEvent("health:respawn", function()
	Main:ResetInfo()
	Main:ResetEffects()

	Main:SetEffect("Fatigue", GetRandomFloatInRange(0.8, 1.0))
	Main:SetEffect("Hunger", GetRandomFloatInRange(0.6, 0.8))
	Main:SetEffect("Thirst", GetRandomFloatInRange(0.6, 0.8))
	Main:SetEffect("Stress", GetRandomFloatInRange(0.2, 0.3))

	exports.teleporters:TeleportTo(Config.Respawn.Coords)
end)

--[[ Commands ]]--
exports.chat:RegisterCommand("respawn", function(source, args, command, cb)
	if not Injury.isDead then
		return
	end

	local respawnTimer = Injury:GetRespawnTimer()
	if not respawnTimer or respawnTimer > 0.001 then
		return
	end

	TriggerServerEvent("health:respawn")
end, {
	description = "Respawn... only when it's safe.",
})