Main = {
	options = {},
}

--[[ Functions: Main ]]--
function Main:GetPlayer()
	-- Test.
	-- if true then
	-- 	return PlayerId(), PlayerPedId(), 0.0
	-- end

	local ped = PlayerPedId()
	local player, playerPed, playerDist

	if not IsPedInAnyVehicle(ped) then
		player, playerPed, playerDist = GetNearestPlayer()
	end

	return player, playerPed, playerDist
end

function Main:Update()
	if not self.open then return end

	local player, playerPed, playerDist = self:GetPlayer()
	if not player or playerDist > Config.MaxDist then
		self:ClearNavigation()
	elseif player ~= self.player then
		self:BuildNavigation()
	end
end

function Main:ClearNavigation()
	if not self.open then
		return
	end

	exports.interact:RemoveOption("players")
	
	self.open = nil
	self.player = nil
	self.ped = nil
	self.serverId = nil
end

function Main:BuildNavigation()
	Ped = PlayerPedId()

	self:ClearNavigation()

	-- Get player.
	local player, playerPed, playerDist
	if Carry.player and NetworkIsPlayerActive(Carry.player) then
		player, ped, playerDist = Carry.player, Carry.ped, #(GetEntityCoords(Ped) - GetEntityCoords(Carry.ped))
	else
		player, playerPed, playerDist = self:GetPlayer()
	end

	-- Check player.
	if not player or not NetworkIsPlayerActive(player) or playerDist > Config.MaxDist then return end

	-- Get server id.
	local serverId = GetPlayerServerId(player)
	if not serverId then return end

	-- Build sub options.
	local sub = {}
	for id, option in pairs(self.options) do
		if not option.condition or option.condition(player, playerPed, playerDist, serverId) then
			sub[#sub + 1] = option.data
		end
	end
	
	-- Add options.
	exports.interact:AddOption({
		id = "players",
		text = ("Player [%s]"):format(serverId or "?"),
		icon = "group",
		sub = sub,
	})

	-- Cache player.
	self.player = player
	self.ped = playerPed
	self.serverId = serverId
	self.open = true
end

function Main:AddOption(data, condition, cb)
	data.players = true
	
	self.options[data.id] = {
		data = data,
		condition = condition,
		cb = cb,
	}

	if self.open then
		self:BuildNavigation()
	end
end

function Main:RemoveOption(id)
	local option = self.options[id]
	if not option then return false end

	-- Remove option.
	self.options[id] = nil

	-- Update menu.
	self:BuildNavigation()

	return true
end

--[[ Exports ]]--
exports("AddOption", function(data, condition, cb)
	data.resource = GetInvokingResource()

	Main:AddOption(data, condition, cb)
end)

--[[ Threads ]]--
Citizen.CreateThread(function()
	while true do
		Main:Update()
		Citizen.Wait(200)
	end
end)

--[[ Events ]]--
AddEventHandler("onClientResourceStop", function(resourceName)
	local shouldUpdate = false
	for i = #Main.options, 1, -1 do
		local option  = Main.options[i]
		if option and option.resource == resourceName then
			table.remove(Main.options, i)
			shouldUpdate = true
		end
	end

	if shouldUpdate and Main.open then
		Main:BuildNavigation()
	end
end)

AddEventHandler("interact:navigate", function(value)
	if value then
		Main:BuildNavigation()
	else
		Main:ClearNavigation()
	end
end)

AddEventHandler("interact:onNavigate", function(id, data)
	if data.players then
		-- Check player.
		if not Main.player then
			return
		end

		-- Trigger events.
		TriggerEvent("players:on_"..id, Main.player, Main.ped)
		TriggerServerEvent("players:on_"..id, Main.player, Main.ped)
		
		-- Trigger callbacks.
		local option = Main.options[id]
		if option and option.cb then
			option.cb(Main.player, Main.ped, Main.serverId)
		end
	end
end)