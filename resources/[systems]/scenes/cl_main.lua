Main = Main or {}
Main.grids = {}
Main.queue = {}
Main.queueCache = {}

function Main:Init()
	for name, _type in pairs(Config.Items) do
		local event = "inventory:use_"..name:gsub(" ", "")

		RegisterNetEvent(event)
		AddEventHandler(event, function(item, slotId)
			if Main.placing then
				Main:StopPlacing()
			else
				self.item = name
				self.slotId = tonumber(slotId)

				Main:BeginPlacing(_type)
			end
		end)
	end
end

function Main:Update()
	-- Disable controls.
	for k, control in pairs(Config.Controls) do
		DisableControlAction(0, control)
	end

	-- Try cancel.
	if IsDisabledControlJustPressed(0, Config.Controls.Cancel) then
		self:StopPlacing()
		return
	end

	-- Update preview.
	Preview:Update()

	-- Update editor.
	if IsDisabledControlJustPressed(0, Config.Controls.Edit) then
		Editor:Open()
	end

	-- Finish placing.
	if Preview.canPlace and IsDisabledControlJustPressed(0, Config.Controls.Place) then
		Main:FinishPlacing()
	end
end

function Main:UpdateScenes()
	local coords = GetFinalRenderedCamCoord()

	for grid, scenes in pairs(self.grids) do
		for id, scene in pairs(scenes) do
			if not scene.coords or not scene.interactable then goto skipScene end
	
			local direction = Normalize(scene.coords - coords)
			local target = coords + direction * 100.0
	
			local shapeTestHandle = StartShapeTestRay(coords.x, coords.y, coords.z, target.x, target.y, target.z, -1)
			local retval, didHit, hitCoords, surfaceNormal, entityHit = GetShapeTestResult(shapeTestHandle)
	
			if retval and didHit then
				local hitDist = #(hitCoords - scene.coords)
				local isVisible = hitDist < 0.02

				if isVisible ~= scene.visible then
					scene.visible = isVisible
					exports.interact:SetVisible(scene.interactable, isVisible)
				end
			end
	
			::skipScene::
		end
	end
end

function Main:BeginPlacing(_type)
	if self.placing ~= nil then return end

	-- Cache placing.
	self.placing = _type
	Editor.modelCache = nil

	-- Destroy old scene.
	if Preview.scene then
		Preview.scene:Destroy()
		Preview.scene = nil
	end

	-- Create preview.
	Preview:Create()

	-- Create hint.
	local hintText = ([[
		<div class="column">
			<div class="row justify-center">
				<img src="nui://inventory/html/icons/%s.png" width=32 height=32 />
			</div>
			<q-separator spaced />
	]]):format(self.item:gsub(" ", ""))

	for k, v in pairs(Config.Controls) do
		hintText = hintText..([[
			<div style="display: flex; justify-content: space-between">
				<span>%s</span>
				<span>%s</span>
			</div>
		]]):format(k, GetControlInstructionalButton(0, v, true):gsub("._", ""))
	end

	hintText = hintText.."</div>"

	self.hint = Window:Create({
		template = hintText,
		style = {
			["right"] = "10vmin",
			["top"] = "20vmin",
			["width"] = "15vmin",
		}
	})
end

function Main:StopPlacing()
	if self.placing == nil then return end
	
	-- Clear cache.
	self.placing = nil

	-- Destroy hint.
	if self.hint then
		self.hint:Destroy()
	end

	-- Destroy preview.
	Preview:Destroy()
end

function Main:FinishPlacing()
	local scene = Preview.scene
	if not scene then return end

	TriggerServerEvent(self.event.."place", {
		type = self.placing,
		text = Preview.text,
		coords = Preview.coords,
		rotation = Preview.rotation,
		lifetime = Preview.lifetime,
		width = math.min(math.max(scene.width, 0.0), 1.0),
		height = math.min(math.max(scene.height, 0.0), 1.0),
		item = self.item,
		slot = self.slotId
	})

	self:StopPlacing()
end

function Main:ClearAll()
	for grid, scenes in pairs(self.grids) do
		for id, scene in pairs(scenes) do
			if scene.interactable then
				exports.interact:RemoveText(scene.interactable)
			end
		end
	end

	self.grids = {}
end

function Main:AddToQueue(data)
	if self.queueCache[data.id] then
		return
	end

	local grid = self.grids[data.grid]
	if grid and grid[data.id] then
		return
	end

	self.queueCache[data.id] = true
	table.insert(self.queue, data)
end

function Main:UpdateQueue(gridCache, instance)
	-- Get data.
	local data = self.queue[1]

	-- Remove from queue.
	self.queueCache[data.id] = nil
	table.remove(self.queue, 1)

	-- Check grid.
	if data.instance and data.instance ~= instance then
		return
	elseif not data.instance and data.grid and not gridCache[data.grid] then
		return
	end

	-- Create scene.
	local scene = Scene:Create(data)
	scene:CreateInteractable()
end

function Main:UpdateGrids(grids, instance)
	for grid, scenes in pairs(self.grids) do
		if instance ~= grid and not grids[grid] then
			for id, scene in pairs(scenes) do
				if scene.interactable then
					exports.interact:RemoveText(scene.interactable)
				end
			end
			self.grids[grid] = nil
		end
	end
end

--[[ Events ]]--
AddEventHandler(Main.event.."clientStart", function()
	Main:Init()
end)

AddEventHandler(Main.event.."stop", function()
	Main:ClearAll()
	Main:StopPlacing()
end)

RegisterNetEvent(Main.event.."updateScenes")
AddEventHandler(Main.event.."updateScenes", function(data)
	Main.queueCache = {}
	Main.queue = {}

	for _, scene in ipairs(data) do
		Main:AddToQueue(scene)
	end
end)

RegisterNetEvent(Main.event.."addScene")
AddEventHandler(Main.event.."addScene", function(data)
	Main:AddToQueue(data)
end)

RegisterNetEvent(Main.event.."removeScene")
AddEventHandler(Main.event.."removeScene", function(gridId, id)
	local grid = Main.grids[gridId]
	if not grid then return end

	local scene = grid[id or false]
	if not scene then return end

	scene:Destroy()
end)

RegisterNetEvent(Main.event.."failed")
AddEventHandler(Main.event.."failed", function(reason)
	exports.mythic_notify:SendAlert("error", "Couldn't place scene: "..(tostring(reason) or "no reason specified"), 7000)
end)

--[[ Threads ]]--
Citizen.CreateThread(function()
	while true do
		if Main.placing then
			Main:Update()

			Citizen.Wait(0)
		else
			Citizen.Wait(200)
		end
	end
end)

Citizen.CreateThread(function()
	while true do
		Main:UpdateScenes()
		
		Citizen.Wait(200)
	end
end)

Citizen.CreateThread(function()
	while true do
		local ped = PlayerPedId()
		local coords = GetEntityCoords(ped)
		local grids = Grids:GetNearbyGrids(coords, Config.GridSize)
		local instance = (exports.instances:GetPlayerInstance() or {}).id
		local gridCache = {}

		for _, grid in ipairs(grids) do
			gridCache[grid] = true
		end

		Main:UpdateGrids(gridCache, instance)

		if #Main.queue > 0 then
			Main:UpdateQueue(gridCache, instance)

			Citizen.Wait(200)
		else
			Citizen.Wait(400)
		end
	end
end)

--[[ Commands ]]--
RegisterCommand("scenes", function(source, args, command)
	local data = {}
	local ped = PlayerPedId()
	local coords = GetEntityCoords(ped)

	for grid, scenes in pairs(Main.grids) do
		for id, scene in pairs(scenes) do
			table.insert(data, {
				id = scene.id,
				user_id = scene.user_id,
				text = scene.text,
				distance = ("%.2f"):format(#(scene.coords - coords)),
			})
		end
	end

	local menu = Window:Create({
		type = "window",
		title = "Scenes",
		class = "compact",
		style = {
			["width"] = "60vmin",
			["top"] = "50%",
			["left"] = "50%",
			["transform"] = "translate(-50%, -50%)",
		},
		prepend = {
			type = "q-icon",
			name = "cancel",
			binds = {
				color = "red",
			},
			click = {
				event = "close"
			}
		},
		components = {
			{
				type = "q-table",
				style = {
					["overflow"] = "hidden",
					["max-height"] = "90vh",
				},
				tableStyle = {
					["overflow-y"] = "auto",
				},
				binds = {
					rowKey = "id",
					dense = true,
					wrapCells = true,
					data = data,
					columns = {
						{
							name = "id",
							label = "ID",
							field = "id",
							align = "left",
							sortable = true,
							style = "user-select: all",
						},
						{
							name = "user",
							label = "User ID",
							field = "user_id",
							align = "left",
							sortable = true,
							style = "user-select: all",
						},
						{
							name = "distance",
							label = "Distance",
							field = "distance",
							align = "left",
							sortable = true,
						},
						{
							name = "text",
							label = "Text",
							field = "text",
							align = "left",
							style = "max-width: 30vmin; word-break: break-all; user-select: all",
						},
					},
				},
			},
		}
	})

	menu:OnClick("close", function(self)
		self:Destroy()
		UI:Focus(false)
	end)

	UI:Focus(true)
end)