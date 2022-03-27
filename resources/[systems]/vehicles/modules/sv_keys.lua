function Main:ToggleEngine(source, netId)
	local vehicle = self.vehicles[netId]
	if not vehicle then return end
	
	local entity = NetworkGetEntityFromNetworkId(netId)
	if not entity then return end

	local value = not GetIsVehicleEngineRunning(entity)
	local hasKey = vehicle:Get("key")
	local starter = not hasKey and vehicle:Get("starter") or nil

	local vin = vehicle:Get("vin") or ""
	if vin == "" then return end

	local success = hasKey or starter

	-- Get state.
	local state = (Entity(entity) or {}).state

	-- No key, check if player has one!
	if value and not hasKey then
		local playerContainer = exports.inventory:GetPlayerContainer(source, true)
		if not playerContainer then return end

		local slot = exports.inventory:ContainerFindFirst(playerContainer, "Vehicle Key", "return slot:GetField(1) == '"..vin.."'")
		if slot and exports.inventory:TakeItem(source, "Vehicle Key", 1, slot.slot_id) then
			success = true

			exports.sound:PlaySoundPlayer(source, "keys", 0.5)
	
			vehicle:Set("key", true)

			hasKey = true
		end
	elseif not value and hasKey then
		local gaveItem, reason = table.unpack(exports.inventory:GiveItem(source, {
			item = "Vehicle Key",
			fields = { vin },
		}))

		if gaveItem then
			exports.sound:PlaySoundPlayer(source, "keys", 0.5)

			vehicle:Set("key", false)

			success = true
		end
	end

	-- Try hotwiring.
	if not hasKey and state and state.hotwired then
		if value and not starter then
			local playerContainer = exports.inventory:GetPlayerContainer(source, true)
			if not playerContainer then return end

			local slot = exports.inventory:ContainerFindFirst(playerContainer, "Screwdriver")
			if slot and exports.inventory:TakeItem(source, "Screwdriver", 1, slot.slot_id) then
				vehicle:Set("starter", slot.durability or 1.0)

				success = true
			end
		elseif not value and starter then
			local gaveItem, reason = table.unpack(exports.inventory:GiveItem(source, {
				item = "Screwdriver",
				durability = starter < 0.99 and starter or nil,
			}))

			if gaveItem then
				success = true

				vehicle:Set("starter", nil)
			end
		end
	end

	if success then
		TriggerClientEvent("vehicles:toggleEngine", source, netId, value)
	end
end

function Main:GiveKey(source, netId)
	local vehicle = self.vehicles[netId]
	if not vehicle then return false end

	local vin = vehicle:Get("vin") or ""
	if vin == "" then return false end

	return table.unpack(exports.inventory:GiveItem(source, {
		item = "Vehicle Key",
		fields = { vin },
	}))
end

--[[ Events: Net ]]--
RegisterNetEvent("vehicles:toggleEnigne", function(netId)
	local source = source

	if PlayerUtil:CheckCooldown(source, 1.0) then
		PlayerUtil:UpdateCooldown(source)
		Main:ToggleEngine(source, netId)
	end
end)

RegisterNetEvent("vehicles:toggleLock", function(netId, status)
	local source = source

	-- Check input.
	if type(netId) ~= "number" or type(status) ~= "boolean" then return end
	
	-- Check cooldown.
	if not PlayerUtil:CheckCooldown(source, 1.0) then return end
	PlayerUtil:UpdateCooldown(source)

	-- Check vehicle.
	local entity = NetworkGetEntityFromNetworkId(netId)
	if not entity or not DoesEntityExist(entity) then return end

	local target = NetworkGetEntityOwner(entity)
	if not target then return end

	-- Log it.
	exports.log:Add({
		source = source,
		verb = status and "locked" or "unlocked",
		noun = "vehicle",
	})

	-- Tell owner to toggle lock.
	TriggerClientEvent("vehicles:toggleLock", target, netId, status)

	-- Notify source.
	TriggerClientEvent("chat:notify", source, status and "Locked vehicle!" or "Unlocked vehicle!", "inform")

	-- Play lock sound.
	exports.sound:PlaySoundPlayer(source, "carlock")
end)