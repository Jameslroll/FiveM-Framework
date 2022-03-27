Debug = {}

--[[ Functions: Debug ]]--
function Debug:Update()
	local ped = PlayerPedId()
	if not ped or not DoesEntityExist(ped) then return end

	local coords = GetEntityCoords(ped)
	local size = 10.0
	
	for id, size in ipairs(Grids.Sizes) do
		local grid = Grids:GetGrid(coords, size, true)
		local _coords = Grids:GetCoords(grid, size, true)
		
		DrawBox(_coords.x - size / 2, _coords.y - size / 2, coords.z, _coords.x + size / 2, _coords.y + size / 2, coords.z, 255, 255, 0, 64)
	end
end

--[[ Threads ]]--
Citizen.CreateThread(function()
	while true do
		if Debug.enabled then
			Debug:Update()
			Citizen.Wait(0)
		else
			Citizen.Wait(200)
		end
	end
end)

--[[ Commands ]]--
exports.chat:RegisterCommand("grids:debug", function(source, args, command)
	Debug.enabled = not Debug.enabled

	TriggerEvent("chat:notify", {
		class = "inform",
		text = ("%s debugging grids!"):format(Debug.enabled and "Started" or "Stopped")
	})
end, {
	description = "Display the grids around your ped."
}, "Dev")