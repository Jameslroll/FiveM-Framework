AddEventHandler("inventory:use", function(source, item, slot)
	-- Check item.
	local pack = item.pack
	if pack == nil then return end

	-- Get settings.
	local settings = Config.Packs[pack]
	if settings == nil then return end

	-- Check space.
	if not exports.inventory:HasSpace(source) then return end

	-- Take item.
	exports.inventory:TakeItem(source, item.name, 1, slot.id)

	-- Give from name.
	if settings.Suffix ~= nil then
		local itemName = item.name:gsub(settings.Suffix, "")

		-- Take/give item.
		if itemName ~= item.name then
			exports.inventory:GiveItem(source, itemName, item.count or 1)
		end
	end

	-- Give from loot table.
	if settings.Random ~= nil then
		for i = 1, (item.count or 1) do
			local item = settings.Random[Inventory:Random(1, #settings.Random)]
			exports.inventory:GiveItem(source, item.name, item.amount or 1)
		end
	end
end)