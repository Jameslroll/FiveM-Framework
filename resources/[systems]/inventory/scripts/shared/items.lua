Item = {}
Item.__index = Item

--[[ Functions: Item ]]--
function Item:Create(data)
	if not data.name then
		error("item missing name")
	end

	data.weight = data.weight or 0.0
	data.consumable = data.consumable or 0
	data.category = data.category or "None"

	return setmetatable(data, Item)
end

--[[ Functions: Inventory ]]--
function Inventory:GetItemId(name)
	if name == nil then return end

	local item = self.items[FormatName(name)]
	if item == nil then return end

	return item.id
end
Inventory:Export("GetItemId")

function Inventory:GetItem(info)
	if info == nil then return end

	if type(info) == "number" then
		info = self.ids[info]
	else
		info = FormatName(info)
	end

	return self.items[info or ""]
end
Inventory:Export("GetItem")

function Inventory:GetItems()
	return self.items
end
Inventory:Export("GetItems")

function Inventory:GetCategories()
	return self.categories
end
Inventory:Export("GetCategories")