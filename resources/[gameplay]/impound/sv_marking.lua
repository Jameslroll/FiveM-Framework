Marking = Marking or {}
Marking.objects = {}

--[[ Functions ]]--
function Marking:Register(entity)
	-- Check exists already.
	if self.objects[entity] ~= nil then return end

	-- Check entity.
	local _entity = Entity(entity)
	if not _entity or _entity.state.shouldImpound then return end

	-- Update entity.
	_entity.state.shouldImpound = true

	-- Create marked.
	local marked = Marked:Create(entity)
	self.objects[entity] = marked

	-- Inform all.
	self:InformAll({
		add = {
			netId = marked.netId,
			coords = marked.coords,
		}
	})
end

function Marking:Update()
	local payload = {}

	for entity, marked in pairs(self.objects) do
		if DoesEntityExist(entity) then
			local coords = GetEntityCoords(entity)
			local moveDist = #(marked.coords - coords)

			if moveDist > 6.0 then
				-- marked:Destroy() -- Can't destroy, would make flatbeds pointless.
				-- Update position and payload.
				marked.coords = coords
				payload[#payload + 1] = {
					netId = marked.netId,
					coords = coords,
				}
			end
		end
	end

	self:InformAll({
		update = payload
	})
end

function Marking:Mark(source, entity)
	-- Check target.
	if self.objects[entity] then
		return false
	end

	-- Check source.
	if not self:CanMark(source) then
		return false
	end

	-- Check item.
	local playerContainer = exports.inventory:GetPlayerContainer(source)
	if playerContainer == nil or not exports.inventory:HasItem(playerContainer, Config.Marking.Item) then
		return false
	end

	-- Take item.
	exports.inventory:TakeItem(source, Config.Marking.Item, 1)

	-- Register entity.
	self:Register(entity)

	-- Return.
	return true
end

function Marking:Unmark(source, entity)
	-- Get marked.
	local marked = self.objects[entity]
	if marked == nil then
		return false
	end

	-- Destroy marked.
	marked:Destroy()

	-- Give item.
	exports.inventory:GiveItem(source, Config.Marking.Item, 1)

	-- Return.
	return true
end

function Marking:InformAll(payload)
	local activeDuty = exports.jobs:GetActiveDuty(Config.Marking.Faction)
	if activeDuty == nil then return end
	
	for player, _ in pairs(activeDuty) do
		TriggerClientEvent("impound:inform", player, payload)
	end
end

--[[ Events ]]--
AddEventHandler("impound:stop", function()
	for entity, marked in pairs(Marking.objects) do
		if DoesEntityExist(entity) then
			local _entity = Entity(entity)
			_entity.state.shouldImpound = nil
		end
	end
end)

AddEventHandler("jobs:clock", function(source, name, message)
	if name ~= Config.Marking.Faction then return end
	local payload = {}

	if message then
		payload.bulk = {}
		local i = 1
		for entity, marked in pairs(Marking.objects) do
			payload.bulk[i] = {
				netId = marked.netId,
				coords = marked.coords,
			}

			i = i + 1
		end
	else
		payload.clear = true
	end

	TriggerClientEvent("impound:inform", source, payload)
end)

AddEventHandler("entityRemoved", function(entity)
	local marked = Marking.objects[entity]
	if marked ~= nil then
		marked:Destroy()
	end
end)

RegisterNetEvent("impound:mark")
AddEventHandler("impound:mark", function(netId)
	local source = source

	-- Check input.
	if type(netId) ~= "number" then return end

	-- Check entity.
	local entity = NetworkGetEntityFromNetworkId(netId)
	if not DoesEntityExist(entity) then return end

	-- Mark.
	if Marking:Mark(source, entity) then
		exports.log:Add({
			source = source,
			verb = "marked",
			noun = "vehicle for impound",
			extra = ("net id: %s"):format(netId),
		})
	end
end)

RegisterNetEvent("impound:unmark")
AddEventHandler("impound:unmark", function(netId)
	local source = source

	-- Check input.
	if type(netId) ~= "number" then return end

	-- Check entity.
	local entity = NetworkGetEntityFromNetworkId(netId)
	if not DoesEntityExist(entity) then return end

	-- Unmark.
	if Marking:Unmark(source, entity) then
		exports.log:Add({
			source = source,
			verb = "unmarked",
			noun = "vehicle for impound",
			extra = ("net id: %s"):format(netId),
		})
	end
end)

--[[ Threads ]]--
Citizen.CreateThread(function()
	while true do
		Marking:Update()
		Citizen.Wait(5000)
	end
end)