Instances = {
	players = {},
	rooms = {},
}

--[[ Functions ]]--
function Instances:Create(id, data)
	if self.rooms[id] then
		return false
	end

	local room = Room:Create(id, data)

	return room
end

function Instances:Destroy(id)
	local room = self.rooms[id]
	if not room then return false end

	return room:Destroy()
end

function Instances:Join(source, id, create)
	local room = self.rooms[id]
	if not room and create then
		room = self:Create(id)
	elseif not room then
		return false
	end

	TriggerClientEvent("instances:join", source, id)
	TriggerEvent("instances:join", source, id)

	return room:AddPlayer(source)
end

function Instances:Leave(source)
	local id = self.players[source]
	if not id then return false end

	local room = self.rooms[id]
	if not room then return false end

	TriggerClientEvent("instances:leave", source, id)
	TriggerEvent("instances:leave", source, id)
	
	return room:RemovePlayer(source)
end

function Instances:Get(source)
	return self.players[source]
end

function Instances:IsInstanced(source)
	return self.players[source] ~= nil
end

--[[ Exports ]]--
for k, v in pairs(Instances) do
	if type(v) == "function" then
		exports(k, function(...)
			return Instances[k](Instances, ...)
		end)
	end
end

--[[ Events ]]--
RegisterNetEvent("instances:join", function(id)
	local source = source
	if type(id) ~= "string" then return end
	Instances:Join(source, id)
end)

RegisterNetEvent("instances:leave", function()
	local source = source
	Instances:Leave(source)
end)

AddEventHandler("playerDropped", function()
	local source = source
	Instances:Leave(source)
end)