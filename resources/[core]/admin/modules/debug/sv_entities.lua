Entities = {
	entities = {},
	players = {},
	blacklist = {},
}

--[[ Functions ]]--
function Entities:Update()
	for entity, info in pairs(self.entities) do
		
	end
end

function Entities:CacheObject(entity)
	local owner = NetworkGetEntityOwner(entity)

	-- Cache entity.
	self.entities[entity] = {
		owner = owner,
	}

	-- Set state bag.
	local _entity = Entity(entity)

	if _entity then
		_entity.state.origin = owner
	end
end

function Entities:CacheAll()
	for k, entity in ipairs(GetAllObjects()) do
		self:CacheObject(entity)
	end

	for k, vehicle in ipairs(GetAllVehicles()) do
		self:CacheObject(vehicle)
	end

	for k, ped in ipairs(GetAllPeds()) do
		self:CacheObject(ped)
	end
end

function Entities:UncacheObject(entity)
	local cached = self.entities[entity]
	if not cached then return end

	local count = self.players[cached.owner] or 0

	-- Update player owned count.
	self.players[cached.owner] = math.max(count - 1, 0)

	-- Uncache entity.
	self.entities[entity] = nil
end

function Entities:RemoveAll()
	for entity, info in pairs(self.entities) do
		DeleteEntity(entity)
	end
	
	self.entities = {}
	self.players = {}

	TriggerClientEvent("chat:notify", -1, {
		class = "inform",
		text = "Cleaning the streets!",
		duration = 14000,
	})
end

--[[ Threads ]]--
Citizen.CreateThread(function()
	while true do
		Entities:Update()
		Citizen.Wait(200)
	end
end)

--[[ Events ]]--
AddEventHandler(Admin.event.."start", function()
	Entities:CacheAll()
end)

AddEventHandler("entityCreating", function(entity)
	local owner = NetworkGetEntityOwner(entity)
	if not owner then
		return
	end
	
	local count = Entities.players[owner] or 0

	if count > 200 then
		CancelEvent()
		return
	end

	Entities.players[owner] = count + 1
end)

AddEventHandler("entityCreated", function(entity)
	if not entity or not DoesEntityExist(entity) then return end

	Entities:CacheObject(entity)
end)

AddEventHandler("entityRemoved", function(entity)
	if not entity then return end

	Entities:UncacheObject(entity)
end)

AddEventHandler("playerDropped", function(reason)
	local source = source

	Entities.players[source] = nil
end)

--[[ Commands ]]--
RegisterCommand("deleteAll", function(source, args, command)
	if source ~= 0 then return end

	Entities:RemoveAll()
end, true)