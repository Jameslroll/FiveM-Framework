Main = {
	players = {},
	grids = {},
}

--[[ Functions ]]--
function Sanitize(str)
	return str:gsub('[&<>\n]', {
		['&' ] = '&amp;',
		['<' ] = '&lt;',
		['>' ] = '&gt;',
		['\n'] = '<br/>',
	}):gsub(' +', function(_str) return ' '..('&nbsp;'):rep(#_str - 1) end)
end

--[[ Functions: Main ]]--
function Main:Broadcast(p1, event, ...)
	local coords

	if type(p1) == "number" then
		local ped = GetPlayerPed(p1)
		coords = ped and DoesEntityExist(ped) and GetEntityCoords(ped)
	elseif type(p1) ~= "vector4" then
		coords = vector3(p1.x, p1.y, p1.z)
	elseif type(p1) ~= "vector3" then
		coords = nil
	end

	if not coords then return end

	local nearbyGrids = Grids:GetImmediateGrids(coords, Config.GridSize)
	for _, gridId in ipairs(nearbyGrids) do
		local grid = self.grids[gridId]
		if grid then
			for player, _ in pairs(grid) do
				TriggerClientEvent(event, player, ...)
			end
		end
	end
end

function Main:SetGrid(source, gridId)
	local playerGrid = self.players[source]
	if playerGrid then
		self:RemoveFromGrid(playerGrid, source)
	end

	self:AddToGrid(gridId, source)

	self.players[source] = gridId
end

function Main:UncachePlayer(source)
	local playerGrid = self.players[source]
	if not playerGrid then return end

	self:RemoveFromGrid(playerGrid, source)

	self.players[source] = nil
end

function Main:AddToGrid(gridId, source)
	local grid = self.grids[gridId]
	if not grid then
		grid = {}
		self.grids[gridId] = grid
	end

	grid[source] = true
end

function Main:RemoveFromGrid(gridId, source)
	local grid = self.grids[gridId]
	if not grid then return end

	grid[source] = nil

	local next = next
	if next(grid) == nil then
		self.grids[gridId] = nil
	end
end

--[[ Events ]]--
AddEventHandler("players:start", function()
	for i = 1, GetNumPlayerIndices() do
		local source = tonumber(GetPlayerFromIndex(i - 1))
		local ped = GetPlayerPed(source)
		local coords = ped and DoesEntityExist(ped) and GetEntityCoords(ped)

		if coords then
			Main:SetGrid(source, Grids:GetGrid(coords, Config.GridSize))
		end
	end
end)

AddEventHandler("playerDropped", function(reason)
	local source = source

	Main:UncachePlayer(source)
end)

--[[ Events: Net ]]--
RegisterNetEvent("grids:enter"..Config.GridSize, function(gridId, nearbyGrids)
	local source = source

	if type(gridId) ~= "number" then return end

	Main:SetGrid(source, gridId)
end)

--[[ Exports ]]--
exports("Broadcast", function(...)
	Main:Broadcast(...)
end)