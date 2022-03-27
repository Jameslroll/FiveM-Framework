TickRate = 200
MinutesToTicks = 0.0

local floatPrecision = 1000.0
local effectsCache = {}
for k, effect in ipairs(Config.Effects) do
	effectsCache[effect.Name] = true
end

function IsPayloadValid(payload)
	if payload == nil then return true end

	if type(payload) ~= "table" then
		return false, ("payload is type '%s'"):format(type(payload))
	end

	for k, v in pairs(payload) do
		if type(v) ~= "table" then
			return false, ("payload value is type '%s'"):format(type(v))
		end

		if k == "effects" then
			for _k, _v in pairs(v) do
				if not effectsCache[_k] then
					return false, ("effect '%s' does not exist"):format(tostring(_k))
				elseif type(_v) ~= "number" then
					return false, ("effect value is type '%s'"):format(type(_v))
				else
					v[_k] = math.floor(_v * floatPrecision) / floatPrecision
				end
			end
		elseif k == "info" then
			for _k, _v in pairs(v) do
				local bone = Config.Bones[_k]
				if not bone then
					return false, ("bone '%s' does not exist"):format(tostring(_k))
				elseif type(_v) ~= "table" then
					return false, ("bone value type is '%s'"):format(type(_v))
				end
				for __k, __v in pairs(_v) do
					local __type = type(__v)
					if not Config.Saving.ValidInfo[__k] then
						return false, ("info '%s' does not exist"):format(tostring(__k))
					elseif __type ~= "number" and __type ~= "boolean" then
						return false, ("info value type is '%s'"):format(__type)
					elseif __type == "number" then
						_v[__k] = math.floor(__v * floatPrecision) / floatPrecision
					end
				end
			end
		elseif k == "history" then
			for _k, _v in pairs(v) do
				local bone = Config.Bones[_k]
				if not bone then
					return false, ("bone '%s' does not exist for history"):format(tostring(_k))
				elseif type(_v) ~= "table" then
					return false, ("bone value type is '%s' for history"):format(type(_v))
				end
				if #_v > 256 then
					return false, ("bone '%s' history too large"):format(_k)
				end
				for __k, __v in pairs(_v) do
					if type(__k) ~= "number" then
						return false, ("bone '%s' history index type is '%s'"):format(_k, type(__k))
					elseif type(__v) ~= "table" then
						return false, ("bone '%s' history value type is '%s'"):format(type(__v))
					else
						for ___k, ___v in pairs(__v) do
							if ___k == "time" then
								if type(___v) ~= "number" then
									return false, ("bone '%s' history time type is '%s'"):format(_k, type(___v))
								end
							elseif ___k == "name" then
								if not Config.Injuries[___v] and not Config.Treatments[___v] then
									return false, ("bone '%s' injury '%s' does not exist"):format(_k, ___v)
								end
							else
								return false, ("bone '%s' has invalid history field '%s'"):format(_k, ___k)
							end
						end
					end
				end
			end
		else
			return false, ("invalid payload key '%s'"):format(k)
		end
	end

	return true
end

function Export(func, name)
	exports(name, function(...)
		return func[name](func, ...)
	end)
end