Main = Main or {}

--[[ Events ]]--
AddEventHandler("onClientResourceStart", function(resourceName)
	TriggerEvent(resourceName..":clientStart")
	TriggerServerEvent(resourceName..":ready")
end)

AddEventHandler("onClientResourceStop", function(resourceName)
	TriggerEvent(resourceName..":clientStop")
end)

local damageTargets = {
	[93] = "tire",
	[116] = "body",
	[117] = "window",
	[120] = "sidewindow",
	[121] = "rearwindow",
	[122] = "windscreen",
}

-- AddEventHandler("onEntityDamaged", function(victim, attacker, isFatal, weapon, isMelee, time, damageTarget) end)
AddEventHandler("gameEventTriggered", function(name, args)
	if name == "CEventNetworkEntityDamage" then
		local victim, attacker, time, _, _, isFatal, weapon, _, _, _, _, isMelee, damageTarget = table.unpack(args)
		
		damageTarget = damageTarget ~= 0 and damageTargets[damageTarget]
		isFatal = isFatal == 1
		isMelee = isMelee == 1
		
		local retval, outBone = false, nil
		if victim and IsEntityAPed(victim) then
			retval, outBone = GetPedLastDamageBone(victim)
		end

		local data = {
			attacker = attacker,
			pedBone = retval and outBone or nil,
			damageTarget = damageTarget or nil,
			isFatal = isFatal,
			isMelee = isMelee,
			time = time,
			victim = victim,
			weapon = weapon,
		}

		TriggerEvent("onEntityDamaged", data)
	end
end)