--[[ Functions: Inventory ]]--
function Inventory:LoadItems()
	-- Load items from the database.
	self.dbItems = exports.GHMattiMySQL:QueryResult(("SELECT * FROM `%s`"):format(Server.Tables.Items))
	self.dbItemsCache = {}

	for k, item in ipairs(self.dbItems) do
		self.dbItemsCache[item.name:lower()] = k
	end
	
	-- Initialize registered items.
	local count, added  = 0, 0
	for name, item in pairs(self.items) do
		count = count + 1
		if self:LoadItem(item) then
			added = added + 1
		end
	end

	-- Check for redundant items.
	local redundancies = {}
	
	for k, item in ipairs(self.dbItems) do
		if not self:GetItem(item.name) then
			Print("Redundant item: %s (%s)", item.name, item.id)
			table.insert(redundancies, item.name)
		end
	end

	if #redundancies > 0 then
		Print("%s redundancies (items registered in the database but not script)", #redundancies)
		Print("Type 'inventory:clearRedundancies delete' to clear references to redundant items")

		RegisterCommand("inventory:clearRedundancies", function(source, args, command)
			if source ~= 0 then return end

			for _, name in ipairs(redundancies) do
				Print("Deleting item %s", name)
				exports.GHMattiMySQL:Query(("DELETE FROM `%s` WHERE `name`=@name"):format(Server.Tables.Items), {
					["@name"] = name
				})
			end

			Print("%s redundant items deleted", #redundancies)
		end, true)
	end

	-- Print output.
	Print("%s items loaded (%s added)", count, added)

	-- Trigger event.
	TriggerEvent(EventPrefix.."itemsLoaded", self.items)
end

function Inventory:LoadItem(item)
	local dbItemId = self.dbItemsCache[item.name:lower()]
	local result = false

	-- Add item to database.
	if dbItemId then
		local dbItem = self.dbItems[dbItemId]
		item.id = dbItem.id
	else
		item.id = exports.GHMattiMySQL:QueryScalar(("INSERT INTO `%s` SET `name`=@name; SELECT LAST_INSERT_ID();"):format(Server.Tables.Items), {
			["@name"] = item.name,
		})

		-- Update result.
		result = true
	end
	
	-- Update cache.
	self.ids[item.id] = FormatName(item.name)

	-- Return result.
	return result
end

function Inventory:RegisterItem(item)
	item = Item:Create(item)

	if self.initialized then
		error("NOT YET IMPLEMENTED: Registering items post initialization")
	end

	local name = FormatName(item.name)
	local categoryName = FormatName(item.category)

	self.items[name] = item
	self.list[#self.list + 1] = item.name

	-- Cache category.
	local category = self.categories[categoryName]
	if not category then
		category = {}
		self.categories[categoryName] = category
	end

	category[name] = item
end

function Inventory:RequestItems(source)
	while not self.initialized do
		Citizen.Wait(200)
	end
	
	if os.clock() - (self.requests[source] or 0.0) < 3.0 then return end

	Debug("Request items: [%s]", source)

	TriggerClientEvent(EventPrefix.."receiveItems", source, self.ids)
end

function Inventory:GetRandomItem()
	local index = self:Random(1, #self.list)
	local name = self.list[index]
	local item = self.items[FormatName(name)]

	return item
end

--[[ Events ]]--
RegisterNetEvent(EventPrefix.."requestItems", function()
	local source = source
	Inventory:RequestItems(source)
end)