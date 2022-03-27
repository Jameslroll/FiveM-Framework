LastListTime = 0
NextListTime = 0
Seed = 0
List = nil
Cooldowns = {}

--[[ Threads ]]--
Citizen.CreateThread(function()
	while true do
		Seed = os.time()
		math.randomseed(Seed)

		local delay = math.random(Config.ListDuration.Min, Config.ListDuration.Max)
		LastListTime = os.time()
		NextListTime = os.time() + delay * 60
		List = GetList(Seed)
		
		math.randomseed(GetGameTimer())

		TriggerClientEvent("chopShop:updateSeed", -1, Seed)

		Citizen.Wait(delay * 60000)
	end
end)

--[[ Functions ]]--
function FindCar(index, list)
	if not list then list = GetList(Seed) end

	for k, v in ipairs(list) do
		if index == v.index then
			return v.car
		end
	end
	return nil
end

--[[ Events ]]--
RegisterNetEvent("chopShop:requestSeed")
AddEventHandler("chopShop:requestSeed", function()
	TriggerClientEvent("chopShop:updateSeed", source, Seed)
end)

RegisterNetEvent("chopShop:requestTime")
AddEventHandler("chopShop:requestTime", function()
	TriggerClientEvent("chopShop:receiveTime", source, NextListTime - os.time())
end)

RegisterNetEvent("chopShop:chopVehicle")
AddEventHandler("chopShop:chopVehicle", function(index, modifier, netId)
	local source = source

	local vehicle = NetworkGetEntityFromNetworkId(tonumber(netId) or 0)
	if not DoesEntityExist(vehicle) then return end

	-- Cooldown to prevent spam.
	if Cooldowns[source] then
		TriggerClientEvent("chopShop:chopResult", source, 2)
		return
	end

	Cooldowns[source] = true
	Citizen.CreateThread(function()
		Citizen.Wait(10000)
		Cooldowns[source] = nil
	end)

	-- Find car from index.
	local car = FindCar(index, List)
	if not car then
		TriggerClientEvent("chopShop:chopResult", source, 3)
		return
	end

	modifier = math.min(math.max(modifier, 0.0), 1.0)

	-- Chop the car.
	local presence = exports.jobs:CountActiveEmergency("ChopShop")
	local result = 1
	if presence >= Config.Presence.Min then
		local price = math.floor(car.BasePrice * math.min(1.0 + (presence - Config.Presence.Min + 1) / (Config.Presence.Max - Config.Presence.Min + 1), Config.Presence.MaxRate) * modifier)
		if price == 0 or exports.inventory:GiveItem(source, "bills", price) then
			exports.log:AddEarnings(source, "Chopping", price)
			exports.log:Add({
				source = source,
				verb = "chopped",
				noun = "vehicle",
				extra = ("for: $%s"):format(price),
			})
			DeleteEntity(vehicle)
			result = 0
		else
			result = 4
		end
	else
		result = 1
	end
	TriggerClientEvent("chopShop:chopResult", source, result)
end)