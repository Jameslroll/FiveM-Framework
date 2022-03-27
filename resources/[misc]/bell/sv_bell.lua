RegisterNetEvent(EventName.."ring", function(coords)
	local source = source
	
	if not PlayerUtil:CheckCooldown(source, 1.0) or type(coords) ~= "vector3" then return end
	PlayerUtil:UpdateCooldown(source)

	print(("[%s] is ringing a bell"):format(source))
	
	exports.sound:PlaySound3D(coords, "bell", GetRandomFloatInRange(0.5, 1.0), 1.0)
end)