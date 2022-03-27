Npcs.event = GetCurrentResourceName()..":"
Npcs.npcs = {}

--[[ Functions: Npcs ]]--
function Npcs:Register(data)
	while not IsNpcsReady do
		Citizen.Wait(0)
	end

	return Npc:Create(data)
end

function Npcs:Destroy(id)
	local npc = self.npcs[id]
	if not npc then return false end

	npc:Destroy()

	return true
end

--[[ Exports ]]--
-- exports("Register", function(data)
-- 	data.resource = GetInvokingResource()

-- 	local npc = Npcs:Register(data)

-- 	return {
-- 		Set = function(key, value)
-- 			npc:Set(key, value)
-- 		end,
-- 		Get = function(key)
-- 			return npc[key]
-- 		end
-- 	}
-- end)

--[[ Events ]]--
-- AddEventHandler(Npcs.event.."stop", function()
-- 	for id, npc in pairs(Npcs.npcs) do
-- 		npc:Destroy()
-- 	end
-- end)

AddEventHandler("onResourceStop", function(resourceName)
	if resourceName ~= GetCurrentResourceName() then return end

	for id, npc in pairs(Npcs.npcs) do
		npc:Destroy()
	end
end)