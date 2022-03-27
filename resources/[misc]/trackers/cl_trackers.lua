Main = {
	groups = {},
}

--[[ Functions: Main ]]--
function Main:JoinGroup(data)
	if not data.id then
		return false
	end

	self.groups[data.id] = Group:Create(data)

	return true
end

function Main:LeaveGroup(id)
	local group = self.groups[id]
	if not group then
		return false
	end

	-- Remove blips.
	for netId, data in pairs(group.entities) do
		group:RemoveEntity(netId)
	end

	-- Uncache group.
	self.groups[id] = nil

	return true
end

function Main:AddEntity(groupId, data)
	local group = self.groups[groupId]
	if not group then
		return false
	end

	return group:AddEntity(data)
end

function Main:RemoveEntity(groupId, netId)
	local group = self.groups[groupId]
	if not group then
		return false
	end

	return group:RemoveEntity(netId)
end

--[[ Events ]]--
RegisterNetEvent("trackers:update", function(id, data)
	local group = Main.groups[id]
	if group then
		group:UpdateAll(data)
	end
end)

RegisterNetEvent("trackers:join", function(group)
	print("join group", group.id)
	Main:JoinGroup(group)
end)

RegisterNetEvent("trackers:leave", function(id)
	print("leave group", id)
	Main:LeaveGroup(id)
end)

RegisterNetEvent("trackers:addEntity", function(groupId, data)
	print("add entity", groupId, json.encode(data))
	Main:AddEntity(groupId, data)
end)

RegisterNetEvent("trackers:removeEntity", function(groupId, ...)
	print("remove entity", groupId, ...)
	Main:RemoveEntity(groupId, ...)
end)

--[[ Threads ]]--
Citizen.CreateThread(function()
	while true do
		for groupId, group in pairs(Main.groups) do
			group:UpdateActive()
		end

		Citizen.Wait(50)
	end
end)