RegisterNetEvent("hotwire:setStage", function(netId, stage, slotId, itemName)
	local source = source

	if type(netId) ~= "number" or type(stage) ~= "number" or type(netId) ~= "number" or type(itemName) ~= "string" then return end

	local entity = NetworkGetEntityFromNetworkId(netId)
	if not DoesEntityExist(entity) then return end
	
	local state = (Entity(entity) or {}).state
	if not state then return end

	-- Check item.
	if not Config.Items[itemName] then return end

	-- Get player container id.
	local containerId = exports.inventory:GetPlayerContainer(source, true)
	if not containerId then return end

	-- Get item in slot.
	local item = exports.inventory:ContainerInvokeSlot(containerId, slotId, "GetItem")
	if not item or item.name ~= itemName then return end

	-- Decay item.
	if not exports.inventory:ContainerInvokeSlot(containerId, slotId, "Decay", GetRandomFloatInRange(table.unpack(Config.Decay))) then
		return
	end

	-- Set stage.
	state.stage = stage

	-- Finish hotwire.
	if stage == Config.FinalStage then
		state.hotwired = true

		exports.log:Add({
			source = source,
			verb = "hotwired",
			noun = "vehicle",
		})
	end
end)