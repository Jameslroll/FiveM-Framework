function FromRotation(vector)
	local pitch, yaw = (vector.x % 360.0) / 180.0 * math.pi, (vector.z % 360.0) / 180.0 * math.pi

	return vector3(
		math.cos(yaw) * math.cos(pitch),
		math.sin(yaw) * math.cos(pitch),
		math.sin(pitch)
	)
end

function Dot(a, b)
	return (a.x * b.x) + (a.y * b.y) + (a.z * b.z)
end

function Raycast(flag)
	if not CamCoords then return false end
	
	local rayTarget = CamCoords + CamForward * 10.0
	local rayHandle = StartShapeTestRay(CamCoords.x, CamCoords.y, CamCoords.z, rayTarget.x, rayTarget.y, rayTarget.z, flag, PlayerPedId(), 0)
	
	-- retval, didHit, hitCoords, surfaceNormal, materialHash, entity
	return GetShapeTestResultIncludingMaterial(rayHandle)
end
exports("Raycast", Raycast)

function IntersectSphere(origin, direction, center, radius)
	-- DrawSphere(center.x, center.y, center.z, radius, 255, 255, 255, 0.5)

	local o_minus_c = origin - center

	local p = Dot(direction, o_minus_c)
	local q = Dot(o_minus_c, o_minus_c) - (radius * radius)

	if p > 0.0 then
		return 0
	end

	local discriminant = (p * p) - q
	if discriminant < 0.0 then
		return 0
	end

	local dRoot = (discriminant)^0.5
	dist1 = -p - dRoot
	dist2 = -p + dRoot

	local hDir = origin - center
	local hCoord = center + (hDir / #hDir * radius)

	if discriminant > 1e-7 then
		return 2, hCoord
	else
		return 1, hCoord
	end
end