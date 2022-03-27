function Main.update:Popping()
	if not IsDriver or not Materials then return end

	local min = 32.187
	local max = 128.748

	if GetRandomFloatInRange(0.0, 1.0) > math.max(Speed - min, 0.0) / (max - min) then
		return
	end

	for wheelIndex, material in pairs(Materials) do
		if material == 34 and not IsVehicleTyreBurst(CurrentVehicle, wheelIndex, true) then
			SetVehicleTyreBurst(CurrentVehicle, wheelIndex, true, 1000.0)
		end
	end
end