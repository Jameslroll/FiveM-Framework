Items = Items or {}

--[[ Events ]]--
AddEventHandler("inventory:use", function(source, item, slot)
	local treatment = Items.items[item.name]
	if treatment then
		exports.inventory:TakeItem(source, item.name, 1, slot.slot_id)
	end
end)

AddEventHandler("health:start", function()
	Items:Cache()
end)