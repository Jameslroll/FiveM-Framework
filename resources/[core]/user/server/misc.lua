function ConvertTarget(target, checkPlayers)
	-- Check target.
	if not target then
		return false, "invalid target"
	end

	-- Convert target.
	local key, value
	local targetN = tonumber(target)
	local targetUser = checkPlayers and targetN and Main.users[targetN]
	local targetId = type(target) == "string" and target:sub(1, 1) == ":" and tonumber(target:sub(2))

	if targetUser then
		key = "steam"
		value = targetUser.identifiers.steam
	elseif targetId then
		key = "id"
		value = targetId
	elseif IsHex(target) then
		key = "steam"
		value = target
	elseif IsDecimal(target) then
		key = "steam"
		value = ToHex(target)
	else
		-- Get identifier.
		key, value = GetIdentifiers(target)

		-- Check identifier.
		if not IsIdentifierValid(key) then
			return false, "missing identifier"
		end

		key = key:lower()

		-- Check hex.
		if key == "steam" then
			if IsDecimal(value) then
				value = ToHex(value)
			elseif not IsHex(value) then
				return false, "invalid hex"
			end
		end
	end

	-- Check value.
	if not value then
		return false, "missing value"
	end

	-- Return identifier.
	return key, value
end

function GetHex(key)
	if not key then return end

	key = key:lower()

	if key:match(":") then
		local _key, value = GetIdentifiers(key)
		if value then
			key = value
		else
			return
		end
	end
	
	if IsHex(key) then
		return key
	elseif IsDecimal(key) then
		return GetHex(ToHex(key))
	end
end

function IsHex(key)
	return key:len() == 15 and key:sub(1, 7) == "1100001" and not key:match("[^0-9a-f]")
end

function IsDecimal(key)
	return key:len() == 17 and tonumber(key)
end

function ToHex(key)
	return string.format("%X", key)
end

function GetIdentifiers(key)
	return key:match("([^:]+):([^:]+)")
end

function IsIdentifierValid(key)
	if not key then return false end

	if not ValidIdentifiers then
		ValidIdentifiers = {}
		for _, v in ipairs(Server.Identifiers) do
			ValidIdentifiers[v] = true
		end
	end

	return ValidIdentifiers[key] or false
end