exports.chat:RegisterCommand("a:stockshop", function(source, args, command, cb)
	local ped = GetPlayerPed(source)
	local coords = GetEntityCoords(ped)
	
	local stocked
	for id, shop in pairs(Main.shops) do
		local storage = shop.info.Storage
		if storage and #(coords - storage.Coords) < storage.Radius then
			if shop:StockContainer() then
				cb("success", "Stocked up!")
				stocked = id
			else
				cb("error", "Failed to stock.")
				stocked = false
			end
			break
		end
	end

	if stocked == nil then
		cb("error", "No shop to stock.")
	elseif stocked then
		exports.log:Add({
			source = source,
			verb = "stocked",
			noun = "storage",
			extra = stocked,
			channel = "admin",
		})
	end
end, {
	description = "Fill a shop with compatible items.",
}, "Admin")