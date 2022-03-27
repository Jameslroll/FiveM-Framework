Marking = Marking or {}
Marking.objects = {}
Marking.coords = vector3(0.0, 0.0, 0.0)

--[[ Functions ]]--
function Marking:Register(entity)
	local isValid = self:IsValid(entity)
	local isRegistered = self:IsRegistered(entity)

	if isValid and not isRegistered then
		self.objects[entity] = Marked:Create(entity)
	elseif not isValid and isRegistered then
		self:Remove(entity)
	end
end

function Marking:Remove(entity)
	local marked = self.objects[entity]
	if marked ~= nil then
		marked:Destroy()
	end
end

function Marking:Update()
	local ped = PlayerPedId()
	self.coords = GetEntityCoords(ped)

	local vehicles = exports.oldutils:GetVehicles()
	for _, vehicle in ipairs(vehicles) do
		self:Register(vehicle)
	end
end

function Marking:IsValid(entity)
	-- Check exists.
	if not DoesEntityExist(entity) or not NetworkGetEntityIsNetworked(entity) then
		return false
	end

	-- Check entity.
	local _entity = Entity(entity)
	if not _entity or not _entity.state.shouldImpound then
		return
	end

	-- Check distance.
	local coords = GetEntityCoords(entity)
	local dist = #(self.coords - coords)

	if dist > 6.0 then
		return false
	end

	-- Finally return.
	return true
end

function Marking:IsRegistered(entity)
	return self.objects[entity] ~= nil
end

function Marking:PlaceSticker()
	-- Get vehicle.
	local vehicle = exports.oldutils:GetFacingVehicle()
	if not DoesEntityExist(vehicle) or not NetworkGetEntityIsNetworked(vehicle) then return end

	-- Check already registered.
	if self:IsRegistered(vehicle) then
		return
	end

	-- Check driver.
	if DoesEntityExist(GetPedInVehicleSeat(vehicle, -1)) then
		return
	end

	-- Animation.
	if not WaitForAnimWhileFacingVehicle(Config.Marking.Anim, vehicle) then return end

	-- Trigger event.
	local netId = VehToNet(vehicle)
	TriggerServerEvent("impound:mark", netId)
	SetEntityAsMissionEntity(vehicle)
end

function Marking:RemoveSticker(entity)
	-- Check vehicle.
	if entity ~= exports.oldutils:GetFacingVehicle() then
		return
	end

	-- Animation.
	if not WaitForAnimWhileFacingVehicle(Config.Unmarking.Anim, entity) then return end

	-- Get marked.
	local marked = Marking.objects[entity or false]
	if marked == nil then return end

	-- Unmark.
	marked:Unmark()

	-- Clear interaction.
	exports.interact:ClearOptions(entity)

	for i = 1, 5 do
		TriggerEvent("interact:suppress")
		Citizen.Wait(200)
	end
end

--[[ Threads ]]--
Citizen.CreateThread(function()
	while true do
		Marking:Update()
		Citizen.Wait(1000)
	end
end)

--[[ Events ]]--
AddEventHandler("impound:stop", function()
	for entity, marked in pairs(Marking.objects) do
		exports.interact:RemoveText(marked.text)
		exports.interact:Destroy(marked.interactable)
		if marked.impound then
			exports.interact:Destroy(marked.impound)
		end
	end
end)

AddEventHandler("interact:on_unmarkImpound", function(interactable)
	if IsPedInAnyVehicle(PlayerPedId()) then return end
	Marking:RemoveSticker(interactable.entity)
end)

AddEventHandler("character:switch", function()
	Blips:Clear()
end)

RegisterNetEvent("inventory:use_"..Config.Marking.Item:gsub("%s", ""))
AddEventHandler("inventory:use_"..Config.Marking.Item:gsub("%s", ""), function(item, slotId)
	if not Marking:CanMark() or IsPedInAnyVehicle(PlayerPedId()) then return end
	Marking:PlaceSticker()
end)

RegisterNetEvent("impound:inform")
AddEventHandler("impound:inform", function(data)
	if data.add then
		Blips:Add(data.add.netId, data.add.coords)
	elseif data.remove then
		Blips:Remove(data.remove)
	elseif data.clear then
		Blips:Clear()
	elseif data.update then
		for _, _data in pairs(data.update) do
			Blips:Update(_data.netId, _data.coords)
		end
	elseif data.bulk then
		for _, _data in pairs(data.bulk) do
			Blips:Add(_data.netId, _data.coords)
		end
	end
end)