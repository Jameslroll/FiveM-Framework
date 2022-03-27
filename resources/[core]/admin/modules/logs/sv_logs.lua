LogViewer = {
	viewers = {},
	gridSize = 4,
}

--[[ Hooks ]]--
Admin.logViewers = {}
Admin:AddHook("toggle", "logViewer", function(source, value)
	LogViewer:Toggle(source, value)
end)

--[[ Functions ]]--
function LogViewer:Toggle(source, value)
	self.viewers[source] = value or nil
end

function LogViewer:Update(source)

end

function LogViewer:AddLog(data)
	if not data.source or not data.pos_x or not data.pos_y or not data.pos_z then return end
	
	local coords = vector3(data.pos_x, data.pos_y, data.pos_z)
	local grid = Grids:GetGrid(coords, self.gridSize)

	for viewer, state in pairs(self.viewers) do
		
	end
end

--[[ Events ]]--
AddEventHandler("log", function(data)
	LogViewer:AddLog(data)
end)