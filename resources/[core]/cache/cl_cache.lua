Cache = {}

exports("Get", function(t)
	return Cache[t]
end)

exports("Set", function(t, v)
	Cache[t] = v

	return v
end)