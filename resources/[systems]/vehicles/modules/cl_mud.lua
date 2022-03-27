local materials = {
	[9] = true,
	[19] = true,
	[21] = true,
	[23] = true,
	[24] = true,
	[31] = true,
	[32] = true,
	[35] = true,
	[38] = true,
	[40] = true,
	[43] = true,
	[46] = true,
	[47] = true,
	[48] = true,
}

function Main.update:Mud()
	if not IsDriver or not Materials then return end

	local mudRatio = 0.0
	local rainLevel = GetRainLevel()
	local wheelType = GetVehicleWheelType(CurrentVehicle)
	local isOffroad = wheelType == 4 --or classType == ?

	for wheelIndex, material in pairs(Materials) do
		if materials[material] then
			mudRatio = mudRatio + (isOffroad and 0.5 or 1.0)
		end
	end
	
	if mudRatio < 0.001 then return end

	mudRatio = 1.0 / (mudRatio * (rainLevel * 0.5 + 0.5))
	
	if mudRatio < 0.001 or mudRatio > 1.001 then return end

	BrakeModifier = BrakeModifier * mudRatio
	MaxFlatModifier = MaxFlatModifier * math.pow(mudRatio, 2.0)
	TractionCurveModifier = TractionCurveModifier * (1.0 + mudRatio * 0.5)
	TractionLossModifier = TractionLossModifier * mudRatio
end