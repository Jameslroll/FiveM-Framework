Inventory.requests = {}
Inventory.players = {}

--[[ Functions ]]--
function GetQuerySetters(properties, object, compare)
	local setters = ""
	local values = {}

	for _, prop in ipairs(properties) do
		-- Check the value with the database.
		local value = object[prop]
		if compare == nil or not Equals(value, compare[prop]) then
			-- Appending setters.
			if setters ~= "" then
				setters = setters..","
			end
			if value == nil then
				-- Null values are explicit.
				setters = setters..("`%s`=NULL"):format(prop)
			else
				-- Encode tables to a string.
				if type(value) == "table" then
					value = json.encode(value)
				end
				-- Set the values/setters.
				values["@"..prop] = value
				setters = setters..("`%s`=@%s"):format(prop, prop)
			end
		end
	end

	return setters, values
end

--[[ Functions: Inventory ]]--
function Inventory:Initialize()
	-- local resourceName = GetCurrentResourceName()
	-- local itemsCheck = exports.GHMattiMySQL:QueryResult(LoadResourceFile(resourceName, "queries/check_items.sql"))

	-- Load tables.
	self:LoadDatabase()

	-- Load items.
	self:LoadItems()

	-- Finish.
	self.initialized = true

	-- Hooks.
	self:InvokeHook("init")

	-- Trigger event.
	TriggerEvent(EventPrefix.."loaded")
end

function Inventory:LoadDatabase()
	WaitForTable("characters")

	for _, path in ipairs({
		"sql/items.sql",
		"sql/containers.sql",
		"sql/slots.sql",
	}) do
		RunQuery(path)
	end
	
	self.columns = DescribeTable("characters")
end

function Inventory:IsLoaded()
	return self.initialized
end
Inventory:Export("IsLoaded")

function Inventory:GetContainers()
	local data = {}

	for id, container in pairs(self.containers) do
		data[#data + 1] = {
			id = id,
			type = container.type,
			owner = container.owner,
			protected = container.protected,
		}
	end

	return data
end
Inventory:Export("GetContainers")

--[[ Events ]]--
AddEventHandler(EventPrefix.."start", function()
	Inventory:Initialize()
end)

AddEventHandler("onResourceStop", function(resourceName)
	for id, container in pairs(Inventory.containers) do
		if container.resource == resourceName then
			container:Destroy()
		end
	end
end)

--[[ Commands ]]--
RegisterCommand(EventPrefix.."debug", function(source, args, command)
	if source ~= 0 then return end

	print("Containers")

	for id, container in pairs(Inventory.containers) do
		Print("- id: %s, weight: %s, viewers: %s", id, container:GetWeight(), json.encode(container.viewers))
	end
	
	print("Players")

	for source, player in pairs(Inventory.players) do
		Print("- source: %s, views: %s, last action: %s", source, json.encode(player.views), player:GetTimeSinceLastAction())
	end

	print("Grids")

	for id, grid in pairs(Drops.grids) do
		Print("- id: %s (players: %s, containers: %s)", id, json.encode(grid.players), json.encode(grid.containers))
	end
end, true)