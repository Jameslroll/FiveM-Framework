Main = {
	cooldowns = {},
	bombs = {},
	entities = {},
}

--[[ Functions ]]--
function Main:Init()
	GlobalState.powerDisabled = false
end

function Main:Update()
	if self.lastUpdate == nil then return end

	if os.clock() - self.lastUpdate > 60.0 * Config.Bombs.ResetTime then
		Main:Clear()
	end
end

function Main:Plant(id)
	local placement = Config.Bombs.Placements[id or false]
	if placement == nil then return false end

	if self.bombs[id] ~= nil then return false end
	self.bombs[id] = true
	self.lastUpdate = os.clock()

	return true
end

function Main:Detonate()
	-- Check placements.
	for id, placement in ipairs(Config.Bombs.Placements) do
		if self.bombs[id] == nil then
			return false
		end
	end
	
	-- Detonate.
	TriggerClientEvent(EventPrefix.."detonate", -1)

	-- Clear cache.
	self:Clear()

	-- Wait and dispatch.
	Citizen.CreateThread(function()
		Citizen.Wait(5000)
		
		exports.dispatch:Add({
			coords = Config.Center,
			group = "Emergency",
			hasBlip = true,
			message = "10-31",
			subMessage = "Terror",
			messageType = 0,
		})

		-- States and events.
		self.lastUpdate = os.clock()
	
		GlobalState.powerDisabled = true
	
		TriggerClientEvent("powerDeactivated", -1)
	end)

	-- Return result.
	return true
end

function Main:Clear()
	for _, entity in ipairs(self.entities) do
		if DoesEntityExist(entity) then
			DeleteEntity(entity)
		end
	end

	self.bombs = {}
	self.entities = {}
	self.lastUpdate = nil

	if GlobalState.powerDisabled then
		GlobalState.powerDisabled = false

		TriggerClientEvent("powerActivated", -1)
	end
end

--[[ Threads ]]--
Citizen.CreateThread(function()
	while true do
		Main:Update()
		Citizen.Wait(5000)
	end
end)

--[[ Events ]]--
AddEventHandler(EventPrefix.."start", function()
	Main:Init()
end)

AddEventHandler(EventPrefix.."stop", function()
	Main:Clear()
end)

RegisterNetEvent(EventPrefix.."check")
AddEventHandler(EventPrefix.."check", function(id)
	local source = source
	TriggerClientEvent(EventPrefix.."plant", source, id, Main.bombs[id])
end)

RegisterNetEvent(EventPrefix.."plant")
AddEventHandler(EventPrefix.."plant", function(id)
	local source = source

	-- Check cooldown.
	if os.clock() - (Main.cooldowns[source] or 0.0) < 3.0 then return end
	Main.cooldowns[source] = os.clock()

	-- Check item.
	if not exports.inventory:HasItem(exports.inventory:GetPlayerContainer(source) or 0, Config.Bombs.Item) then return end
	
	-- Plant bomb.
	if Main:Plant(id) then
		exports.inventory:TakeItem(source, Config.Bombs.Item)

		exports.log:Add({
			source = source,
			verb = "planted",
			noun = "bomb",
			extra = ("site: %s"):format(id)
		})

		TriggerClientEvent(EventPrefix.."planted", source, id)
	end
end)

RegisterNetEvent(EventPrefix.."detonate")
AddEventHandler(EventPrefix.."detonate", function(id)
	local source = source

	-- Check cooldown.
	if os.clock() - (Main.cooldowns[source] or 0.0) < 3.0 then return end
	Main.cooldowns[source] = os.clock()

	-- Check range.
	local ped = GetPlayerPed(source)
	if not DoesEntityExist(ped or 0) then return end
	
	local coords = GetEntityCoords(ped)
	if #(coords - Config.Center) > Config.Bombs.MaxDistance then return end

	-- Detonate.
	if Main:Detonate() then
		exports.log:Add({
			source = source,
			verb = "detonated",
			noun = "bombs",
		})
	else
		TriggerClientEvent("notify:sendAlert", source, "error", "Nothing...", 7000)
	end
end)

AddEventHandler("entityCreated", function(entity)
	if
		DoesEntityExist(entity or 0) and
		GetEntityModel(entity) == GetHashKey(Config.Bombs.Model) and
		#(GetEntityCoords(entity) - Config.Center)
	then
		table.insert(Main.entities, entity)
	end
end)

--[[ Exports ]]--
exports("Detonate", function()
	Main:Detonate()
end)

exports("Plant", function(id)
	Main:Plant(id)
end)

exports("Clear", function()
	Main:Clear()
end)