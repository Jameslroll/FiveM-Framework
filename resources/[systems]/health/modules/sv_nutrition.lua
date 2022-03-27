AddEventHandler("inventory:use", function(source, item, slot)
	if item.hunger or item.thirst then
		exports.inventory:TakeItem(source, item.name, 1, slot.slot_id)
	end
end)