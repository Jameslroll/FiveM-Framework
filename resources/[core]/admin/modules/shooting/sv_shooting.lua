Shooting = {
	players = {},
}

--[[ Functions ]]--
function Shooting:Dispatch(coords, hitCoords)
	for source, _ in pairs(self.players) do
		TriggerClientEvent(Admin.event.."shot", source, coords, hitCoords)
	end
end

--[[ Events: Net ]]--
RegisterNetEvent(Admin.event.."toggleShooting", function(value)
	local source = source
	
	if type(value) ~= "boolean" or not exports.user:IsMod(source) then return end

	Shooting.players[source] = value or nil
end)

RegisterNetEvent("shoot", function(didHit, coords, hitCoords, entity, weapon)
	local source = source

	if type(coords) ~= "vector3" or type(coords) ~= "vector3" or not didHit then return end

	Shooting:Dispatch(coords, hitCoords)
end)

--[[ Events ]]--
AddEventHandler("playerDropped", function(reason)
	local source = source
	Shooting.players[source] = nil
end)