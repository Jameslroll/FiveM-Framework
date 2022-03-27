Items = {}

RegisterNetEvent("vehicles:useItem", function(netId, partId, slotId, nearLift)
	local source = source

	-- Check parameters.
	local inputType = type(partId)
	if type(netId) ~= "number" or type(slotId) ~= "number" or (inputType ~= "string" and inputType ~= "number") then return end

	-- Check cooldown.
	if not PlayerUtil:CheckCooldown(source, 3.0, true) then return end

	-- Check entity exists.
	local entity = NetworkGetEntityFromNetworkId(netId)
	if not DoesEntityExist(entity) then return end

	-- Get player container.
	local containerId = exports.inventory:GetPlayerContainer(source, true)
	if not containerId then return end

	-- Get slot.
	local slot = exports.inventory:ContainerGetSlot(containerId, slotId)
	if not slot then return end

	-- Get item.
	local item = exports.inventory:ContainerInvokeSlot(containerId, slotId, "GetItem")
	if not item then return end

	-- Arbitrary items.
	if inputType == "string" then
		local _item = Items[item.name]
		if _item then
			_item(netId, entity, containerId, slot)
		end
		return
	end

	-- Get part from cache.
	local part = Main.parts[partId]
	if not part then
		return
	end
	
	-- Check item for part.
	if (item.repair or item.name) ~= part.Name then return end

	-- Check engine.
	local isEngine = item.repair == "Engine"

	-- Get or create vehicle.
	local vehicle = Main.vehicles[netId or false]
	if not vehicle then
		vehicle = Vehicle:Create(netId)
	end

	-- Get durabilities.
	local oldDurability = (vehicle.info.damage[partId] or 1.0) - GetRandomFloatInRange(0.0, Config.Repair.Degradation)
	local newDurability = isEngine and math.max(oldDurability, nearLift and 1.0 or Config.Repair.Engine.MaxHealth) or slot.durability or 1.0

	-- Take item.
	local didTake, tookAmount = isEngine or table.unpack(exports.inventory:TakeItem(source, item.name, 1, slotId))
	if not didTake then return end

	-- Give or update item.
	if isEngine then
		exports.inventory:ContainerInvokeSlot(containerId, slotId, "Decay", GetRandomFloatInRange(table.unpack(Config.Repair.Engine.ItemDurability)))
	elseif oldDurability > 0.01 or GetRandomFloatInRange(0.0, 1.0) < Config.Repair.SalvageChance then
		exports.inventory:GiveItem(source, {
			item = item.name,
			durability = oldDurability < 0.99 and (oldDurability < 0.01 and 0.0 or oldDurability) or nil,
			quantity = 1,
		})
	else
		TriggerClientEvent("chat:notify", source, {
			class = "inform",
			text = "The part broke upon removal!",
			duration = 15000,
		})
	end

	-- Log it.
	exports.log:Add({
		source = source,
		verb = "switched",
		noun = "part",
		extra = ("vin: %s - part: %s (%.2f->%.2f)"):format(vehicle:Get("vin"), item.name, oldDurability, newDurability),
	})

	-- Set damage.
	vehicle.info.damage[partId] = newDurability
	vehicle:Set("damage", vehicle.info.damage)
end)

Items["Rag"] = function(netId, vehicle, containerId, slot)
	local dirtLevel = (GetVehicleDirtLevel(vehicle) or 0.0) / 15.0

	SetVehicleDirtLevel(vehicle, 0.0)

	exports.inventory:ContainerInvokeSlot(containerId, slot.slot_id, "Decay", dirtLevel * Config.Washing.ItemDurability)
	
	TriggerClientEvent("vehicles:clean", -1, netId) -- Removes additional decals for clients.
end

Items["Car Jack"] = function(netId, vehicle, containerId, slot)
	-- Decay car jack.
	exports.inventory:ContainerInvokeSlot(containerId, slot.slot_id, "Decay", GetRandomFloatInRange(table.unpack(Config.Repair.CarJack.ItemDurability)))

	-- Break a wheel.
	local wheelSlot = exports.inventory:ContainerFindFirst(containerId, "Wheel", "return not slot.durability or slot.durability > 0.001")
	if wheelSlot then
		exports.inventory:ContainerInvokeSlot(containerId, wheelSlot.slot_id, "Decay", 1.0)
	end
end