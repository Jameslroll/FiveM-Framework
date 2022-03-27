Debug = {
	objects = {},
	labels = {},
}

--[[ Functions: Debug ]]--
function Debug:Enable(value)
	if value then
		local window = Window:Create({
			title = "Entities",
			class = "compact",
			defaults = {
				entities = {},
			},
			style = {
				["width"] = "30vmin",
				["height"] = "auto",
				["right"] = "2vmin",
				["top"] = "15vmin",
				["bottom"] = "10vmin",
				["z-index"] = 100,
			},
			template = [[
				<q-list>
					<q-item
						v-for="(entity, key) in $getModel('entities')"
						:key="key"
						:class="[ $getModel('selected') == key ? 'bg-blue-5' : '' ]"
						dense
						clickable
						@click="$invoke('select', key)"
					>
						<q-item-section>{{entity.name}}</q-item-section>
						<q-item-section>{{entity.id}}</q-item-section>
					</q-item>
				</q-list>
			]],
		})

		window:AddListener("select", function(self, value)
			self:SetModel("selected", value)
			Debug.selected = value
		end)

		self.window = window
	else
		self.window:Destroy()
		self.window = nil

		for id, object in pairs(self.objects) do
			local label = self.labels[id]
			if label then
				exports.interact:RemoveText(label)
				self.labels[id] = nil
			end
		end
	end

	self.objects = {}
	self.enabled = value
end

function Debug:Update()
	local updateWindow = false
	local temp = {}

	-- Draw objects.
	for gridId, grid in pairs(Main.cached) do
		for id, object in pairs(grid) do
			object:DrawDebug()
			temp[id] = true
			if not self.objects[id] then
				updateWindow = true
				
				self.objects[id] = object
				self.labels[id] = exports.interact:AddText({
					coords = object.coords,
					text = tostring(id),
				})
			end
		end
	end

	-- Check objects cache.
	for id, object in pairs(self.objects) do
		if not temp[id] then
			self.objects[id] = nil
			updateWindow = true

			local label = self.labels[id]
			if label then
				exports.interact:RemoveText(label)
				self.labels[id] = nil
			end
		end
	end

	-- Set model.
	if self.window and updateWindow then
		self.window:SetModel("entities", self.objects)
	end

	-- Input.
	if IsDisabledControlJustPressed(0, 243) then
		UI:Focus(true, true)
	elseif IsDisabledControlJustReleased(0, 243) then
		UI:Focus(false)
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
exports.chat:RegisterCommand("entities:debug", function(source, args, command)
	Debug:Enable(not Debug.enabled)

	TriggerEvent("chat:notify", {
		class = "inform",
		text = ("%s debugging entities!"):format(Debug.enabled and "Started" or "Stopped")
	})
end, {}, "Dev")

-- TEST.
-- Citizen.CreateThread(function()
-- 	Main:Register({
-- 		id = "atest-root",
-- 		name = "Custom Robbery",
-- 		coords = vector3(102.4376449584961, -1359.858642578125, 29.34237098693847),
-- 		rotation = vector3(0.0, 0.0, 55.06447982788086),
-- 		children = {
-- 			{
-- 				id = "test-1",
-- 				name = "Keypad",
-- 				coords = vector3(86.16974639892578, -1355.211669921875, 29.2707405090332),
-- 				rotation = vector3(0,0,0),
-- 				model = `prop_ld_keypad_01`,
-- 				interactable = {
-- 					id = "parent-id",
-- 					text = "Parent 1",
-- 					embedded = {
-- 						{
-- 							id = "child-1",
-- 							text = "Child 1",
-- 							items = {
-- 								{ name = "Bills", amount = 100 },
-- 							},
-- 							factions = { "some faction" }
-- 						},
-- 						{
-- 							id = "child-2",
-- 							text = "Child 2",
-- 							items = {
-- 								{ name = "Crowbar", amount = 1, hidden = true },
-- 							}
-- 						},
-- 					},
-- 					coords = coords,
-- 					radius = radius,
-- 					entity = self,
-- 				},
-- 				navigation = {
	
-- 				},
-- 				items = {
	
-- 				},
-- 				callback = function()
	
-- 				end,
-- 			},
-- 			{
-- 				id = "abc",
-- 				coords = vector3(86.16974639892578, -1355.211669921875, 30.2707405090332),
-- 				children = {
-- 					{
-- 						id = "llllll",
-- 						coords = vector3(86.16974639892578, -1356.211669921875, 30.2707405090332),
-- 					}
-- 				}
-- 			},
-- 			{
-- 				id = "zdioqpwe",
-- 				coords = vector3(86.16974639892578, -1355.211669921875, 31.2707405090332),
-- 			},
-- 			{
-- 				id = "dqwepow",
-- 				coords = vector3(86.16974639892578, -1355.211669921875, 32.2707405090332),
-- 			},
-- 		},
-- 	})
-- end)