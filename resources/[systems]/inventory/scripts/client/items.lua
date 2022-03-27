--[[ Functions: Inventory ]]
function Inventory:RegisterItem(item)
	local name = FormatName(item.name)
	if name == nil then
		error("item missing name", json.encode(item))
	elseif self.items[name] then
		error("item name already exists: "..tostring(name))
	end

	
	item = Item:Create(item)
	
	self.items[name] = item
	
	-- Cache category.
	local categoryName = FormatName(item.category)
	local category = self.categories[categoryName]
	if not category then
		category = {}
		self.categories[categoryName] = category
	end

	category[name] = item
end

function Inventory:RequestItems()
	TriggerServerEvent(EventPrefix.."requestItems")
end

function Inventory:ReceiveItems(items)
	for id, name in pairs(items) do
		local item = self.items[name]
		if item then
			item.id = id
			self.ids[id] = name
		else
			print(("Received non-existent item: %s (%s)"):format(name, id))
		end
	end

	self.initialized = true
	
	Menu:Commit("cacheItems", self.items)
end

--[[ Events ]]--
RegisterNetEvent(EventPrefix.."receiveItems", function(items)
	Inventory:ReceiveItems(items)
end)