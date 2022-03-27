Main = {
	groups = {},
	cached = {},
}

--[[ Functions: Main ]]--
function Main:CreateGroup(id, info)
	print("create group", id, info)
	local group = Group:Create(id, info)
	group.resource = GetInvokingResource()

	Citizen.CreateThread(function()
		while group.active do
			group:Update()
			Citizen.Wait(group.info.delay or 2000)
		end
	end)

	return group
end

function Main:DestroyGroup(id)
	local group = self.groups[id]
	if not group then return end

	self.groups[id] = nil
end

function Main:JoinGroup(id, source, state, mask)
	local group = self.groups[id]
	if group then
		print("join group", source, id, state, mask)
		return group:AddPlayer(source, state, mask)
	end
	return false
end

function Main:LeaveGroup(id, source)
	local group = self.groups[id]
	if group then
		print("leave group", source, id)
		return group:RemovePlayer(source)
	end
	return false
end

function Main:AddEntity(id, entity, data)
	local group = self.groups[id]
	if group then
		return group:AddEntity(entity, data)
	end
	return false
end

function Main:RemoveEntity(id, entity)
	local group = self.groups[id]
	if group then
		return group:RemoveEntity(entity)
	end
	return false
end

--[[ Exports ]]--
for k, v in pairs(Main) do
	if type(v) == "function" then
		exports(k, function(...)
			return Main[k](Main, ...)
		end)
	end
end

--[[ Events: Net ]]--
-- RegisterNetEvent("trackers:join", function(id, state)
-- 	local source = source

-- 	Main:JoinGroup(id, state)
-- end)

-- RegisterNetEvent("trackers:leave", function(id)
-- 	local source = source

-- 	Main:LeaveGroup(id)
-- end)

--[[ Events ]]--
AddEventHandler("onResourceStop", function(resourceName)
	for groupId, group in pairs(Main.groups) do
		if group.resource == resourceName then
			group:Destroy()
		end
	end
end)

AddEventHandler("entityRemoved", function(entity)
	for groupId, group in pairs(Main.groups) do
		if group.entities[entity] then
			group:RemoveEntity(entity)
		end
	end
end)

AddEventHandler("playerDropped", function(reason)
	local source = source
	for groupId, group in pairs(Main.groups) do
		if group.players[source] then
			group:RemovePlayer(source)
		end
	end
end)

--[[ Test ]]--
-- Citizen.CreateThread(function()
-- 	Main:CreateGroup("test", {
-- 		states = {
-- 			[1] = { -- Peds.
-- 				["default"] = {
-- 					Colour = 0,
-- 				},
-- 				["police"] = {
-- 					Colour = 3,
-- 				},
-- 			},
-- 		},
-- 	})

-- 	Main:AddEntity("test", NetworkGetEntityFromNetworkId(135))
-- end)

-- RegisterNetEvent("trackers:ready", function()
-- 	local source = source
	
-- 	Main:JoinGroup("test", source, "default", 6)
-- end)