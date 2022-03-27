Main = {
	grids = {},
	nearby = {},
}

--[[ Functions: Main ]]--
function Main:Update()
	local ped = PlayerPedId()
	if not ped or not DoesEntityExist(ped) then return end

	local coords = GetEntityCoords(ped)
	if self.lastCoords and #(self.lastCoords - coords) < 1.0 then return end

	for id, size in ipairs(Grids.Sizes) do
		local grid = Grids:GetGrid(coords, size, true)
		local lastGrid = self.grids[id]
		
		if lastGrid ~= grid then
			self.grids[id] = grid
			local nearbyGrids = Grids:GetNearbyGrids(coords, size, true)
			
			if self.nearby[id] then
				TriggerEvent("grids:exit"..id, lastGrid, self.nearby[id] or {})
			end

			TriggerEvent("grids:enter"..id, grid, nearbyGrids)
			TriggerServerEvent("grids:enter"..id, grid)

			self.nearby[id] = nearbyGrids
		else
			break
		end
	end

	self.lastCoords = coords
end

--[[ Threads ]]--
Citizen.CreateThread(function()
	while true do
		Main:Update()

		Citizen.Wait(20)
	end
end)