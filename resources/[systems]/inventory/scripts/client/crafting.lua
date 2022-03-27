--[[ Hooks ]]--
Inventory:AddHook("init", function()
	local recipes = {}

	for name, recipe in pairs(Inventory.recipes) do
		recipes[#recipes + 1] = recipe
	end

	Menu:SetData("recipes", recipes)
end)

--[[ Functions: Inventory ]]--
function Inventory:RegisterRecipe(recipe)
	local name = FormatName(recipe.name)
	if name == nil then
		error("recipe missing name", json.encode(recipe))
	elseif self.recipes[name] then
		error("recipe name already exists: "..tostring(name))
	end

	self.recipes[name] = recipe
end

function Inventory:ToggleStation(id, _type, crafting, storage)
	self.station = _type and id

	Menu:SetData("station", _type)
	Menu:Focus(_type and true or false)

	self:SetStorage(storage)
	
	if crafting then
		Menu:Commit("beginCrafting", crafting)
	end
end

function Inventory:SetStorage(storage)
	if not storage then
		Menu:SetData("storage", nil)
		return
	end

	for slotId, slot in pairs(storage) do
		local item = self:GetItem(slot.item_id)
		if item then
			slot.name = item.name
		end
	end

	Menu:SetData("storage", storage)
end

--[[ NUI Callbacks ]]--
RegisterNUICallback("beginCrafting", function(recipe)
	local name = recipe.name
	if not name then return end

	TriggerServerEvent(EventPrefix.."beginCrafting", name)
end)

RegisterNUICallback("closeStation", function(recipe)
	Menu:Focus(false)
end)

--[[ Events: Net ]]--
RegisterNetEvent(EventPrefix.."toggleStation", function(id, _type, crafting, storage)
	Inventory:ToggleStation(id, _type, crafting, storage)
end)

RegisterNetEvent(EventPrefix.."beginCrafting", function(recipe)
	Menu:Commit("beginCrafting", recipe)
end)

RegisterNetEvent(EventPrefix.."clearCrafting", function()
	Menu:Commit("clearCrafting")
end)

RegisterNetEvent(EventPrefix.."updateStorage", function(storage)
	Inventory:SetStorage(storage)
end)

--[[ NUI Callbacks ]]--
RegisterNUICallback("moveSlot", function(data, cb)
	cb(true)
	
	local container = data.from and data.from.container
	if container ~= "station" then return end
	
	TriggerServerEvent(EventPrefix.."moveStorage", data.from.slot, data.to)
end)

RegisterNUICallback("clearCrafting", function(data, cb)
	cb(true)
	
	TriggerServerEvent(EventPrefix.."clearCrafting")
end)