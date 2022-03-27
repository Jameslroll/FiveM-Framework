Up = vector3(0, 0, 1)

function GetDirection(heading)
	local rad = (heading % 360.0) / 180.0 * math.pi
	
	return vector3(math.cos(rad), math.sin(rad), 0)
end

function FromRotation(vector)
	local pitch, yaw = (vector.x % 360.0) / 180.0 * math.pi, (vector.z % 360.0) / 180.0 * math.pi

	return vector3(
		math.cos(yaw) * math.cos(pitch),
		math.sin(yaw) * math.cos(pitch),
		math.sin(pitch)
	)
end

function ToRotation(vector)
	local yaw = math.atan2(vector.y, vector.x) * 180.0 / math.pi
	local pitch = math.asin(Dot(vector, vector3(0, 0, 1))) * 180.0 / math.pi

	return vector3(pitch, 0.0, yaw - 90)
end

function ToRotation2(v0)
	local v1 = Cross(v0, Up)
	local v2 = Cross(v0, v1)
	
	local r11, r12, r13 = v0.x, v1.x, v2.x
	local r21, r22, r23 = v0.y, v1.y, v2.y
	local r31, r32, r33 = v0.z, v1.z, v2.z
	
	return vector3(
		math.deg(math.atan2(r32, r33)),
		math.deg(math.atan2(-r31, math.sqrt(r32^2 + r33^2))) - 90,
		math.deg(math.atan2(r21, r11))
	)
end

function Cross(v1, v2)
	return vector3(
		v1.y * v2.z - v2.y * v1.z,
		(v1.x * v2.z - v2.x * v1.z) * -1,
		v1.x * v2.y - v2.x * v1.y
	)
end

function Dot(a, b)
	return (a.x * b.x) + (a.y * b.y) + (a.z * b.z)
end

function Normalize(vector)
	return vector / #vector
end