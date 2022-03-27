AddEventHandler(EventPrefix.."use", function(item, slot, cb)
	-- Check item.
	if item.nested == nil then return end

	-- Check container is already opened.
	if slot ~= nil and slot.nested_container_id ~= nil and Inventory:GetContainer(slot.nested_container_id) ~= nil then
		return
	end
	
	-- Get emote.
	local emote = (Config.Containers[item.nested] or {}).emote or Config.Containers["default"].emote

	-- Callback.
	cb(0, emote)
end)

function Slot:GetNestedContainer()
	return self.nested_container_id and Inventory:GetContainer(self.nested_container_id)
end