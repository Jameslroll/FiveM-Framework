Npcs = Npcs or {}
Npcs.client = true
Npcs.grids = {}
Npcs.cached = {}

--[[ Templates ]]--
Npcs.NEVERMIND = {
	text = "Nevermind.",
	dialogue = "Alright.",
	back = true,
	callback = function(self)
		self:SetState("idle")
	end,
}

--[[ Functions ]]--
function Npcs:_Register(npc)
	npc:CacheGrid()
end

function Npcs:Update()
	for gridId, _ in pairs(self.cached) do
		local grid = self.grids[gridId]
		if grid then
			for npcId, _ in pairs(grid) do
				local npc = self.npcs[npcId]
				if npc then
					npc:_Update()
				end
			end
		end
	end
end

function Npcs:UpdateGrid(grids)
	local cached = {}
	for _, gridId in ipairs(grids) do
		if not self.cached[gridId] then
			self.cached[gridId] = true
			self:LoadGrid(gridId)
		end
		cached[gridId] = true
	end

	for gridId, _ in pairs(self.cached) do
		if not cached[gridId] then
			self.cached[gridId] = nil
			self:UnloadGrid(gridId)
		end
	end
end

function Npcs:LoadGrid(gridId)
	local grid = self.grids[gridId]
	if not grid then return end
	
	for npcId, _ in pairs(grid) do
		local npc = self.npcs[npcId]
		if npc then
			npc:Load()
		end
	end
end

function Npcs:UnloadGrid(gridId)
	local grid = self.grids[gridId]
	if not grid then return end

	for npcId, _ in pairs(grid) do
		local npc = self.npcs[npcId]
		if npc then
			npc:Unload()
		end
	end
end

function Npcs:OpenWindow(data)
	local window = Window:Create(data, true)
	
	function window:OnDestroy()
		Npcs.window = nil
	end
	
	self.window = window
	UI:Focus(true, true)

	return window
end

function Npcs:CloseWindow()
	if not self.window then
		return false
	end

	self.window:Destroy()
	self.window = nil

	UI:Focus(false)

	return true
end

--[[ Events: Net ]]--
RegisterNetEvent("instances:join", function(id)
	Npcs.instanced = true
	Npcs:UpdateGrid({ id })
end)

RegisterNetEvent("instances:leave", function(id)
	Npcs.instanced = nil

	local ped = PlayerPedId()
	local coords = GetEntityCoords(ped)

	Npcs:UpdateGrid(Grids:GetNearbyGrids(coords, Npcs.Config.GridSize))
end)

--[[ Events ]]--
AddEventHandler(Npcs.event.."start", function()
	local ped = PlayerPedId()
	local coords = GetEntityCoords(ped)

	Npcs:UpdateGrid(GetResourceState("instances") == "started" and exports.instances:GetInstance() or Grids:GetNearbyGrids(coords, Npcs.Config.GridSize))
end)

AddEventHandler("grids:enter"..Npcs.Config.GridSize, function(grid, nearby)
	if Npcs.instanced then return end

	Npcs:UpdateGrid(nearby)
end)

AddEventHandler("interact:on_npc", function(interactable)
	local id = interactable.npc
	local npc = id and Npcs.npcs[id]
	if not npc then return end

	npc:Interact()

	TriggerServerEvent(Npcs.event.."interact", id)
end)

--[[ Threads ]]--
Citizen.CreateThread(function()
	while true do
		Npcs:Update()

		Citizen.Wait(200)
	end
end)