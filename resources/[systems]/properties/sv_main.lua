Main = {}

function Main:Init()
	Main:LoadDatabase()
	Main:LoadProperties()
end

function Main:LoadDatabase()
	WaitForTable("characters")
	
	RunQuery("sql/properties.sql")
end

function Main:LoadProperties()
	-- Load property info from database.
	local result = exports.GHMattiMySQL:QueryResult("SELECT * FROM `properties`")
	local cache = {}
	for k, property in ipairs(result) do
		cache[property.id] = property
	end

	-- Create property instances.
	local count = 0
	self.properties = {}

	for k, property in ipairs(Properties) do
		if property.id then
			local info = cache[property.id]
			if info then
				info.characterId = info.character_id
				info.character_id = nil

				info.keys = json.decode(info.keys)
			end

			self.properties[property.id] = Property:Create(info or { id = property.id })
			count = count + 1
		end
	end

	-- Debug.
	print(("%s properties loaded!"):format(count))

	-- Remove property definitions from cache.
	Properties = nil
end

function Main:RequestProperty(source, id)
	TriggerClientEvent("properties:receive", source, self.properties[id])
end

--[[ Events ]]--
AddEventHandler("properties:start", function()
	Main:Init()
end)

--[[ Events: Net ]]--
RegisterNetEvent("properties:request", function(id)
	local source = source
	Main:RequestProperty(source, id)
end)