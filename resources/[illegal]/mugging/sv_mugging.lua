Main = {
	peds = {},
	players = {},
	cooldowns = {},
}

--[[ Functions ]]--
function Main:SetState(source, ped, state)
	-- Check entity.
	if not DoesEntityExist(ped) then return end

	-- Get entity.
	local entity = Entity(ped)
	if not entity or entity.mugged then return end

	-- Get player.
	local player = self.players[source]
	if player == nil then
		player = {}
		self.players[source] = player
	end
	
	-- Check player.
	local playerState = player[ped]
	if (state and playerState) or (not state and not playerState) then return end
	
	-- Get state.
	local mugging = self.peds[ped]
	if mugging == nil then
		mugging = { count = 0, players = {} }
		self.peds[ped] = mugging
	end

	-- Set state.
	if state then
		mugging.count = mugging.count + 1
		mugging.players[source] = true

		player[ped] = true

		entity.state.mugging = mugging.count
	else
		mugging.count = mugging.count - 1
		mugging.players[source] = nil

		player[ped] = nil
		
		if mugging.count <= 0 then
			self.peds[ped] = nil

			entity.state.mugging = nil
			entity.state.action = nil
		else
			entity.state.mugging = mugging.count
		end
	end
end

function Main:Destroy(ped)
	-- Check entity.
	if not DoesEntityExist(ped) then return end

	-- Get entity.
	local entity = Entity(ped)
	if not entity then return end

	-- Set state.
	entity.state.mugged = true
end

function Main:GetPedFromNetId(netId)
	-- Check input.
	if type(netId) ~= "number" then return end

	-- Get entity.
	local entity = NetworkGetEntityFromNetworkId(netId)

	-- Check entity.
	if
		not entity or
		not DoesEntityExist(entity) or
		GetEntityType(entity) ~= 1 or
		IsPedAPlayer(entity)
	then
		return
	end

	-- Return ped.
	return entity
end

--[[ Events ]]--
RegisterNetEvent("mugging:interact")
AddEventHandler("mugging:interact", function(netId, state)
	local source = source
	if type(state) ~= "boolean" then return end

	local ped = Main:GetPedFromNetId(netId)
	if not ped then return end

	Main:SetState(source, ped, state)
end)

RegisterNetEvent("mugging:performAction")
AddEventHandler("mugging:performAction", function(netId, action)
	local source = source
	if type(action) ~= "string" then return end

	local ped = Main:GetPedFromNetId(netId)
	if not ped then return end

	Main:PerformAction(ped, action)
end)

RegisterNetEvent("mugging:cancelAction")
AddEventHandler("mugging:cancelAction", function(netId, action)
	local source = source
	if type(action) ~= "string" then return end

	local ped = Main:GetPedFromNetId(netId)
	if not ped then return end

	Main:CancelAction(ped, action)
end)

RegisterNetEvent("mugging:destroy")
AddEventHandler("mugging:destroy", function(netId)
	local source = source

	local ped = Main:GetPedFromNetId(netId)
	if not ped then return end

	Main:Destroy(ped)
end)

RegisterNetEvent("mugging:rob")
AddEventHandler("mugging:rob", function(netId)
	local source = source

	local ped = Main:GetPedFromNetId(netId)
	if not ped then return end

	Main:Rob(source, ped)
end)

AddEventHandler("mugging:stop", function()
	for ped, mugging in pairs(Main.peds) do
		if DoesEntityExist(ped) then
			local entity = Entity(ped)
			if entity then
				entity.state.mugging = nil
			end
		end
	end
end)

AddEventHandler("entityRemoved", function(entity)
	if not entity or not DoesEntityExist(entity) then return end

	local mugging = Main.peds[entity]
	if mugging == nil then return end

	for id, _ in pairs(mugging.players) do
		local player = Main.players[id]
		if player ~= nil then
			player[entity] = nil
		end
	end

	Main.peds[entity] = nil
end)

AddEventHandler("playerDropped", function(reason)
	local source = source
	local player = Main.players[source]

	-- Clear states.
	if player ~= nil then
		for ped, _ in pairs(player) do
			Main:SetState(source, ped, false)
			print("set state", source, ped, false)
		end
	end

	-- Clear cooldowns.
	Main.cooldowns[source] = nil
end)