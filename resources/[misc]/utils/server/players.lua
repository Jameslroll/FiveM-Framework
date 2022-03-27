PlayerUtil = {
	cooldowns = {},
}

--[[ Functions: PlayerUtil ]]--
function PlayerUtil:WaitForCooldown(source, duration, update, id)
	local cooldown = self.cooldowns[source]
	local lastUpdate = cooldown and cooldown[id or 1]

	if lastUpdate then
		while (
			self.cooldowns[source] and
			math.floor(lastUpdate * 1000.0) == math.floor((cooldown[id or 1] or 0) * 1000.0) and
			os.clock() - lastUpdate < duration
		) do
			Citizen.Wait(0)
		end
	end

	local isValid = not lastUpdate or not cooldown or lastUpdate == cooldown[id or 1]

	if update then
		self:UpdateCooldown(source, id)
	end

	return isValid
end

function PlayerUtil:CheckCooldown(source, duration, update, id)
	local cooldown = self.cooldowns[source]
	local lastUpdate = cooldown and cooldown[id or 1]
	local isValid = not lastUpdate or os.clock() - lastUpdate > duration

	if update then
		self:UpdateCooldown(source, id)
	end
	
	return isValid
end

function PlayerUtil:UpdateCooldown(source, id)
	local cooldown = self.cooldowns[source]
	if not cooldown then
		cooldown = {}
		self.cooldowns[source] = cooldown
	end

	cooldown[id or 1] = os.clock()
end

--[[ Functions ]]--
function GetActivePlayers()
	local i = 0
	local n = GetNumPlayerIndices()

	return function()
		i = i + 1
		
		if i <= n then
			return tonumber(GetPlayerFromIndex(i - 1))
		end
	end
end

--[[ Events ]]--
AddEventHandler("playerDropped", function(reason)
	local source = source

	PlayerUtil.cooldowns[source] = nil
end)