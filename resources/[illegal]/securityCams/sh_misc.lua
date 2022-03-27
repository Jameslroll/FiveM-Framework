function Round(val)
	if val % 1.0 > 0.5 then
		return math.ceil(val)
	else
		return math.floor(val)
	end
end

function GetCoordsHash(coords)
	if type(coords) ~= "vector3" then return end
	
	local x = Round(coords.x * 3.0)
	local y = Round(coords.y * 3.0)
	local z = Round(coords.z * 3.0)

	return GetHashKey(x.." "..y.." "..z)
end

function FindObjects()
	local objects = {}
	
	for object, _ in EnumerateObjects() do
		objects[#objects + 1] = object
	end
	
	return objects
end

function IsInTable(table, compare, hash)
	for k, v in pairs(table) do
		if (hash and GetHashKey(v) == compare) or (not hash and v == compare) then
			return true
		end
	end
	return false
end