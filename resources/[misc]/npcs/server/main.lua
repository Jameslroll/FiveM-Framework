Npcs = Npcs or {}
Npcs.server = true

--[[ Functions ]]--
function Npcs:_Register(npc)
	
end

--[[ Events: Net ]]--
RegisterNetEvent(Npcs.event.."interact", function(id)
	local source = source
	
	local npc = id and Npcs.npcs[id]
	if npc and npc.Interact then
		npc:Interact(source)
	end
end)