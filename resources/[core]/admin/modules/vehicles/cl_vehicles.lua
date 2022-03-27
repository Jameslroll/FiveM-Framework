local invisible = false

--[[ Functions ]]--
function SetInvisible(entity, value)
	-- NetworkSetEntityInvisibleToNetwork(entity, value)

	if value then
		SetEntityAlpha(entity, 128)
	else
		ResetEntityAlpha(entity)
	end

	local state = Entity(entity).state
	state:set("invisible", value, true)
end

--[[ Hooks ]]--
Admin:AddHook("toggle", "vehicleVisibility", function(value)
	invisible = value

	local ped = PlayerPedId()
	local vehicle = IsPedInAnyVehicle(ped) and GetVehiclePedIsIn(ped)

	if vehicle then
		SetInvisible(vehicle, value)
	end
end)

Admin:AddHook("select", "listVehicles", function(option)
	local options = {}
	local classes = exports.vehicles:GetClasses()

	for classId, vehicles in pairs(classes) do
		local class = exports.vehicles:GetClass(classId)
		local _vehicles = {}

		for model, settings in pairs(vehicles) do
			_vehicles[#_vehicles + 1] = {
				label = settings.Name,
				caption = model,
				model = model,
			}
		end

		table.sort(_vehicles, function(a, b)
			return a.label < b.label
		end)

		options[#options + 1] = {
			label = class.Name,
			options = _vehicles
		}
	end

	table.sort(options, function(a, b)
		return a.label < b.label
	end)

	function Navigation:OnSelect(option)
		if option and option.model then
			ExecuteCommand("a:vehspawn "..option.model)
		end
	end

	Navigation:SetOptions(options)
end)

--[[ Threads ]]--
Citizen.CreateThread(function()
	while true do
		local ped = PlayerPedId()
		local vehicle = GetVehiclePedIsIn(ped)
		local vehicle2 = GetVehiclePedIsIn(ped, true)
		local vehicle3 = GetVehiclePedIsEntering(ped)

		for entity in EnumerateVehicles() do
			local state = Entity(entity).state
			if (
				state and state.invisible and
				not NetworkIsEntityConcealed(entity) and
				entity ~= vehicle and
				entity ~= vehicle2 and
				entity ~= vehicle3
			) then
				NetworkConcealEntity(entity, true)
			end
		end

		Citizen.Wait(3000)
	end
end)

--[[ State Handlers ]]--
AddStateBagChangeHandler("invisible", nil, function(bagName, key, value, reserved, replicated)
	if not replicated then return end

	-- Get net id.
	local _, netId = bagName:match("([^:]+):([^:]+)")
	netId = tonumber(netId)

	-- Get entity.
	local entity = netId and NetworkDoesNetworkIdExist(netId) and NetworkGetEntityFromNetworkId(netId)
	if not entity or not DoesEntityExist(entity) then
		return
	end

	-- Check peds.
	local ped = PlayerPedId()
	if ped == entity then
		return
	end

	-- Check vehicles.
	if IsEntityAVehicle(entity) and GetVehiclePedIsIn(ped) == entity then
		return
	end

	-- Conceal.
	NetworkConcealEntity(entity, value == true)
end)