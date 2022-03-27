Items = {}

--[[ Repairing ]]--
AddEventHandler("inventory:use", function(item, slot, cb)
	if slot.durability and slot.durability < 0.01 then return end

	if item.category == "Vehicle" then
		local _item = Items[item.name]
		if _item and _item.Use then
			local vehicle = GetFacingVehicle(PlayerPedId(), 1.0)
			if vehicle and (GetVehicleBodyHealth(vehicle) > 0 or IsVehicleDriveable(vehicle)) then
				Items.vehicle = vehicle
				local retval, result = _item.Use(vehicle, item, slot, cb)
				if not retval and result then
					TriggerEvent("chat:notify", { class = "error", text = result })
				end
			end
		end
		return
	elseif item.category ~= "Vehicle Repair" then
		return
	end

	local ped = PlayerPedId()
	local pedCoords = GetEntityCoords(ped)

	if IsPedInAnyVehicle(ped) then
		return
	end

	local partName = item.repair or item.name
	local part, dist = Parts:Find(partName, pedCoords)

	local repair = part and part.settings.Repair
	if not repair or not dist or dist > (repair.Dist or 1.5) then
		TriggerEvent("chat:notify", {
			text = "Cannot find that part...",
			class = "error",
		})
		return
	end

	local isEngine = partName == "Engine"
	if isEngine and (part.health or 1.0) > (Parts.nearLift and 0.99 or Config.Repair.Engine.MaxHealth) then
		TriggerEvent("chat:notify", {
			text = "There's nothing more I can do...",
			class = "error",
		})
		return
	end

	if not exports.health:CheckEnergy(Config.Repair.Energy, true) then
		return
	end

	local direction = Normalize(part:GetCoords() - pedCoords)
	local forward = GetEntityForwardVector(ped)
	
	if Dot(direction, forward) < 0.5 then
		TriggerEvent("chat:notify", {
			text = "You aren't facing that part!",
			class = "error",
		})
		return
	end

	Parts.repairing = {
		part = part,
		slot = slot and slot.id,
		vehicle = Parts.vehicle,
	}

	exports.emotes:Stop(true)

	cb(repair.Duration or 3000, repair.Emote)
end)

AddEventHandler("inventory:useCancel", function(item, slot)
	if Parts.repairing then
		Parts.repairing = nil
	end

	if item and item.category == "Vehicle" then
		local _item = Items[item.name]
		if _item and _item.Cancel then
			_item.Cancel(Items.vehicle, item, slot)
			Items.vehicle = nil
		end
	end
end)

AddEventHandler("inventory:useFinish", function(item, slot)
	if item.category == "Vehicle" then
		local _item = Items[item.name]
		if _item and _item.Finish then
			if _item.Finish(Items.vehicle, item, slot) then
				TriggerServerEvent("vehicles:useItem", GetNetworkId(Items.vehicle), item.name, slot.slot_id)
			end
			Items.vehicle = nil
		end
		return
	elseif item.category ~= "Vehicle Repair" then
		return
	end

	local repairing = Parts.repairing
	if not repairing or repairing.slot ~= slot.id or repairing.vehicle ~= Parts.vehicle then return end

	local part = repairing.part
	if not part then return end

	TriggerServerEvent("vehicles:useItem", GetNetworkId(Parts.vehicle), part.id, slot.slot_id, Parts.nearLift)

	exports.health:TakeEnergy(Parts.nearLift and Config.Repair.EnergyNearLift or Config.Repair.Energy)
end)

--[[ Other Items ]]--
Items["Rag"] = {
	Use = function(vehicle, item, slot, cb)
		if GetVehicleDirtLevel(vehicle) < 0.01 then
			return false, "It's already clean!"
		end

		cb(10400, {
			Dict = "amb@world_human_maid_clean@",
			Name = "base",
			Flag = 1,
			BlendSpeed = 1.0,
			Props = {
				{ Model = "prop_sponge_01", Bone = 0x6F06, Offset = { 0.0, 0.0, -0.02, 110.0, 0.0, 0.0 } },
			},
		})

		return true
	end,
	Finish = function(vehicle, item, slot)
		return true
	end,
}

Items["Body Repair Kit"] = {
	Use = function(vehicle, item, slot, cb)
		if not Modding:CanModify(vehicle) then
			return false, "Cannot modify that vehicle right now!"
		end

		cb(12000, "mechfix2")

		return true
	end,
	Finish = function(vehicle, item, slot)
		if not WaitForAccess(vehicle) then
			return false
		end

		local tires = {}
		for boneName, wheelIndex in pairs(GetTires(vehicle)) do
			tires[wheelIndex] = { IsVehicleTyreBurst(vehicle, wheelIndex, true) and 1 or IsVehicleTyreBurst(vehicle, wheelIndex) and 2 or 0, GetTyreHealth(vehicle, wheelIndex) }
		end
		
		SetVehicleFixed(vehicle)
		
		for wheelIndex, values in pairs(tires) do
			local state, health = table.unpack(values)

			SetTyreHealth(vehicle, wheelIndex, health or 1000.0)

			if state ~= 0 then
				SetVehicleTyreBurst(vehicle, wheelIndex, state == 1, 1000.0 - (health or 1000.0))
			end
		end

		return true
	end,
}

Items["Car Jack"] = {
	Use = function(vehicle, item, slot, cb)
		if not Modding:CanModify(vehicle) then
			return false, "Cannot modify that vehicle right now!"
		end

		local ped = PlayerPedId()
		local coords = GetEntityCoords(ped)
		local tireIndex, tireDist = GetNearestTire(coords, vehicle)

		if not tireIndex or tireDist > 1.5 then
			return false, "Cannot find a tire to replace..."
		end

		if not IsVehicleTyreBurst(vehicle, tireIndex, true) and not IsVehicleTyreBurst(vehicle, tireIndex) then
			return false, "That tire is fine..."
		end

		if not exports.inventory:HasItem("Wheel", 0.01) then
			return false, "You need a wheel..."
		end

		Items.tire = tireIndex

		cb(8000, "mechfix2")

		return true
	end,
	Finish = function(vehicle, item, slot)
		local tireIndex = Items.tire

		if not tireIndex or not WaitForAccess(vehicle) or not exports.inventory:HasItem("Wheel", 0.01) then
			return false
		end

		SetTyreHealth(vehicle, tireIndex, 1000.0)
		SetVehicleTyreFixed(vehicle, tireIndex)

		Items.tire = nil

		return true
	end,
}