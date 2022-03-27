local function Reply(source, message)
	if source == 0 then
		print(message)
	else
		TriggerClientEvent("chat:notify", source, {
			class = "inform",
			text = message,
		})
	end
end

local function DropItemsInCategory(source, ...)
	local args = {...}
	if #args == 0 then
		return false, "No category!"
	end

	local ped = GetPlayerPed(source) or 0
	if not DoesEntityExist(ped) then return false end

	local items = {}
	local extra = ""

	for _, category in ipairs(args) do
		local _items = Inventory.categories[category]
		if not _items then
			return false, "Category '"..category.."' does not exist!"
		end

		for name, item in pairs(_items) do
			items[name] = item
		end

		if extra ~= "" then
			extra = extra..", "
		end
		extra = extra..category
	end
	
	local container = Inventory:RegisterContainer({
		temporary = true,
		type = "debug",
		coords = GetEntityCoords(ped) - vector3(0.0, 0.0, 1.0),
		heading = (GetEntityHeading(ped) + 180.0) % 360.0,
	})

	for name, item in pairs(items) do
		container:AddItem(item.name, item.stack or 1)
	end

	exports.log:Add({
		source = source,
		verb = "spawned",
		noun = "drop",
		extra = extra,
	})

	return true
end

exports.chat:RegisterCommand("a:giveitem", function(source, args, command, cb)
	-- Item.
	local item = Inventory:GetItem(FormatName(args[1] or ""))
	if item == nil then
		Reply(source, "Invalid item!")
		return
	end

	-- Quantity.
	local quantity = tonumber(args[2] or 1)
	if quantity == nil then
		quantity = 1
	end
	
	-- Player.
	local player = Inventory.players[tonumber(args[3] or source)]
	if player == nil then
		Reply(source, "Invalid player!")
		return
	end
	
	-- Get fields.
	local fields = args[4]
	if fields ~= nil and item.fields ~= nil then
		fields = fields:gsub("'", "\"")
		fields = json.decode(fields)

		for key, value in pairs(fields) do
			if item.fields[key] == nil then
				fields[key] = nil
			end
		end
	else
		fields = nil
	end

	-- Give item.
	local retval, message = table.unpack(Inventory:GiveItem(source, item.id, quantity, fields))
	if retval then
		Reply(source, ("Gave %sx %s!"):format(quantity, item.name))
	else
		Reply(source, ("Couldn't give item! (%s)"):format(message or "error"))
	end
end, {
	description = "Give an item!",
	parameters = {
		{ name = "Item", help = "Name of the item" },
		{ name = "Quantity", help = "How much to give" },
		{ name = "Source", help = "Who to give it to (optional)" },
		{ name = "Fields", help = "" },
	}
}, "Admin")

exports.chat:RegisterCommand("a:givemoney", function(source, args, command, cb)
	-- Quantity.
	local quantity = tonumber(args[1] or 1)
	if quantity == nil then
		quantity = 100
	else
		quantity = math.min(quantity, 2147483647)
	end

	if quantity <= 0 then
		return
	end
	
	-- Player.
	local player = Inventory.players[tonumber(args[2] or source)]
	if not player or not player.container then
		Reply(source, "Invalid player!")
		return
	end
	
	-- Give money.
	local retval, message = player.container:AddMoney(quantity, true)
	if type(retval) == "number" and retval > 0.001 then
		Reply(source, ("Gave $%s"):format(retval))
	else
		Reply(source, ("Couldn't give money! (%s)"):format(message or "error"))
	end
end, {
	description = "Give some money!",
	parameters = {
		{ name = "Amount", help = "How much money to give" },
		{ name = "Source", help = "Who to give it to (optional)" },
	}
}, "Admin")

exports.chat:RegisterCommand("a:droprandom", function(source, args, command, cb)
	local ped = GetPlayerPed(source) or 0
	if not DoesEntityExist(ped) then return end

	local containerType = "debug"
	local container = Inventory:RegisterContainer({
		temporary = true,
		type = containerType,
		coords = GetEntityCoords(ped) - vector3(0.0, 0.0, 1.0),
		heading = (GetEntityHeading(ped) + 180.0) % 360.0,
	})

	local settings = Config.Containers[containerType]
	for i = 0, settings.width * settings.height do
		local item = Inventory:GetRandomItem()
		local quantity = Inventory:Random(1, item.stack or 1)

		container:AddItem(item.name, quantity)
	end
end, {}, "Admin")

local categories = ""
for name, items in pairs(Inventory.categories) do
	if categories ~= "" then
		categories = categories..", "
	end
	categories = categories..name
end

exports.chat:RegisterCommand("a:drop", function(source, args, command, cb)
	for k, v in ipairs(args) do
		args[k] = v:lower()
	end

	local retval, result = DropItemsInCategory(source, table.unpack(args))
	if retval then
		cb("success", "Good work, monkey!")
	else
		cb("error", result or "Failed.")
	end
end, {
	description = "Drop all items given a specific category.",
	parameters = {
		{ name = "Category", description = "The category or categories to generate. Separate multiple categories with a space. Valid categories: "..categories },
	}
}, "Admin")