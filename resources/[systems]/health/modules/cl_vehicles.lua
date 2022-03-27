local minSpeed = 1.0
local maxSpeed = 40.0
local fractureSpeed = 20.0

Main:AddListener("TakeDamage", function(weapon, boneId, data)
	if weapon ~= `WEAPON_RUN_OVER_BY_CAR` and weapon ~= `WEAPON_RAMMED_BY_CAR` then return end
	
	if not data.attacker or not IsPedInAnyVehicle(data.attacker) then return end
	
	local vehicle = GetVehiclePedIsIn(data.attacker)
	if not vehicle or not DoesEntityExist(vehicle) then return end

	local speed = GetEntitySpeed(vehicle)
	if speed < minSpeed then return end

	local bone = Main:GetBone(boneId)
	if not bone or GetGameTimer() - (bone.lastDamage or 0) < 200 then return end

	local damage = math.min(math.max((speed - minSpeed) / (maxSpeed - minSpeed), 0.0), 1.0)
	local isFracture = speed > fractureSpeed

	if isFracture then
		bone:SetFracture(true)
	end

	bone:TakeDamage(damage, isFracture and "Fracture" or "Bruising")
end)