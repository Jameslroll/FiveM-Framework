Falling = {
	speedBuffer = {},
	isFalling = false,
	bufferSize = 10,
	maxSpeed = 40.0,
	minSpeed = 1.0,
	fractureSpeed = 20.0,
}

--[[ Functions ]]--
function Falling:Update()
	local speed = GetEntitySpeed(Ped)

	table.insert(self.speedBuffer, speed)

	if #self.speedBuffer > self.bufferSize then
		table.remove(self.speedBuffer, 1)
	end
end

function Falling:GetAverageSpeed()
	local totalSpeed = 0.0
	for _, speed in ipairs(self.speedBuffer) do
		totalSpeed = totalSpeed + speed
	end
	return totalSpeed / #self.speedBuffer
end

--[[ Listeners ]]--
Main:AddListener("TakeDamage", function(weapon, boneId, data)
	if weapon ~= `WEAPON_FALL` then return end

	local speed = Falling:GetAverageSpeed()
	if speed < Falling.minSpeed then return end
	
	local damage = (speed - Falling.minSpeed) / (Falling.maxSpeed - Falling.minSpeed)
	local bone = Main:GetBone(boneId)
	if not bone or GetGameTimer() - (bone.lastDamage or 0) < 200 then return end
	
	local isFracture = speed > Falling.fractureSpeed
	if isFracture then
		bone:SetFracture(true)
		bone:TakeDamage(damage, "Fracture")
	end

	bone:SpreadDamage(damage, 0.15, 0.2, "Bruising")
end)

--[[ Threads ]]--
Citizen.CreateThread(function()
	while true do
		if Ped and DoesEntityExist(Ped) then
			Falling:Update()
		end
		Citizen.Wait(0)
	end
end)