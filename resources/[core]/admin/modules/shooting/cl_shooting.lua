Shooting = {
	lines = {},
}

--[[ Functions ]]--
function Shooting:Draw()
	for _, line in ipairs(self.lines) do
		DrawLine(table.unpack(line))
	end
end

--[[ Events ]]--
RegisterNetEvent(Admin.event.."shot", function(coords, hitCoords)
	-- Create the line.
	table.insert(Shooting.lines, {
		coords.x, coords.y, coords.z,
		hitCoords.x, hitCoords.y, hitCoords.z,
		255, 0, 0, 220
	})

	-- Create the blip.
	local blipCoords = (coords + hitCoords) / 2.0
	local blip = AddBlipForArea(blipCoords.x, blipCoords.y, blipCoords.z, #(hitCoords - coords), 5.0)

	SetBlipRotation(blip, math.floor(math.deg(math.atan2(hitCoords.y - coords.y, hitCoords.x - coords.x))))
	SetBlipColour(blip, 1)
	SetBlipAlpha(blip, 255)

	Citizen.SetTimeout(30000, function()
		-- Remove the line.
		table.remove(Shooting.lines, 1)
	
		-- Remove the blip.
		if DoesBlipExist(blip) then
			RemoveBlip(blip)
		end
	end)
end)

--[[ Hooks ]]--
Admin:AddHook("toggle", "viewShooting", function(value)
	TriggerServerEvent(Admin.event.."toggleShooting", value)
end)

--[[ Threads ]]--
Citizen.CreateThread(function()
	while true do
		Shooting:Draw()
		Citizen.Wait(0)
	end
end)