Editor = {
	up = vector3(0.0, 0.0, 1.0),
	tabs = {
		{
			name = "shape",
			label = "Shape",
			icon = "face",
			padding = true,
			random = true,
			filter = {
				["plastic"] = true,
			},
		},
		{
			name = "features",
			label = "Features",
			icon = "palette",
			padding = true,
			random = true,
			filter = {
				["plastic"] = true,
			},
		},
		{
			name = "hair",
			label = "Hair",
			icon = "content_cut",
			padding = true,
			random = true,
			filter = {
				["plastic"] = true,
				["barber"] = true,
			},
		},
		{
			name = "makeup",
			label = "Makeup",
			icon = "brush",
			padding = true,
			random = true,
			filter = {
				["plastic"] = true,
				["barber"] = true,
			},
		},
		{
			name = "tattoos",
			label = "Tattoos",
			icon = "favorite",
			padding = false,
			random = true,
			filter = {
				["tattoo"] = true,
			},
			onselect = function(controller)
				local map = controller.map
				if not map then return end

				for k, v in pairs ({
					[0] = -1, -- Face
					[1] = -1, -- Mask
					-- [2] = -1, -- Hair
					[3] = 15, -- Torso
					[4] = { 15, 145 }, -- Leg
					[5] = -1, -- Parachute / bag
					[6] = { 119, 118 }, -- Shoes
					[7] = -1, -- Accessory
					[8] = -1, -- Undershirt
					[9] = -1, -- Kevlar
					[10] = -1, -- Badge
					[11] = 15, -- Jacket
				}) do
					if type(v) == "table" then
						v = v[map.bodyType == "Masculine" and 2 or 1]
					end

					SetPedComponentVariation(Ped, k, v, 0, 0)
				end
			end,
			ondeselect = function(controller)
				controller:SetMap("components", controller.map["components"])
			end,
		},
		{
			name = "clothes",
			label = "Clothes",
			icon = "checkroom",
			padding = true,
			random = true,
			filter = {
				["plastic"] = true,
				["clothing"] = true,
			},
		},
		{
			name = "accessories",
			label = "Accessories",
			icon = "watch",
			padding = true,
			random = true,
			filter = {
				["plastic"] = true,
				["clothing"] = true,
			},
		},
		{
			name = "tools",
			label = "Tools",
			icon = "construction",
			padding = true,
			random = false,
			onselect = function(controller)
				controller.window:SetModel("export", json.encode(controller:GetData()))
			end,
		}
	},
	targets = {
		["default"] = {
			bone = 0x2E28,
		},
		["head"] = {
			bone = 0x796E,
			distance = 1.0,
			hShift = 0.18,
			vShift = 0.0,
			fov = 30.0,
		},
		["chest"] = {
			bone = 0x60f1,
			distance = 1.0,
			hShift = 0.2,
			vShift = 0.0,
			fov = 50.0,
		},
		["lleg"] = {
			bone = 0xf9bb,
			distance = 1.15,
			hShift = 0.15,
			vShift = 0.2,
			fov = 45.0,
		},
		["rleg"] = {
			bone = 0x9000,
			distance = 1.15,
			hShift = 0.15,
			vShift = 0.2,
			fov = 45.0,
		},
		["larm"] = {
			bone = 0xeeeb,
			distance = 1.1,
			hShift = 0.15,
			vShift = 0.2,
			fov = 45.0,
		},
		["rarm"] = {
			bone = 0x6e5c,
			distance = 1.1,
			hShift = 0.15,
			vShift = 0.2,
			fov = 45.0,
		},
		["lhand"] = {
			bone = 0x49d9,
			distance = 0.5,
			hShift = 0.15,
			vShift = 0.0,
			fov = 40.0,
		},
		["rhand"] = {
			bone = 0xdead,
			distance = 0.5,
			hShift = 0.15,
			vShift = 0.0,
			fov = 40.0,
		},
		["feet"] = {
			bone = 0x0,
			distance = 1.0,
			hShift = 0.23,
			vShift = 0.2,
			fov = 40.0,
		},
	},
	anims = {
		["head"] = { Dict = "mp_head_ik_override", Name = "mp_creator_headik", Flag = 1 },
		["lhand"] = { Dict = "anim@random@shop_clothes@watches", Name = "base", Flag = 1 },
	}
}

function Editor:Build(filter)
	while not IsUiReady do
		Citizen.Wait(0)
	end

	-- Get character info.
	local appearance = exports.character:Get("appearance")
	local features = exports.character:Get("features")
	local isLoading = appearance ~= nil and features ~= nil

	-- Create window.
	local window = Window:Create({
		type = "window",
		title = "Appearance",
		class = "compact",
		prepend = {
			type = "q-icon",
			name = "cancel",
			style = {
				["font-size"] = "1.3em",
			},
			binds = {
				color = "red",
			},
			click = {
				callback = "this.$setModel('closing', true)",
			},
			components = {
				{
					type = "q-dialog",
					model = "closing",
					components = {
						{
							type = "q-card",
							components = {
								{
									type = "q-card-section",
									class = "row items-center",
									template = [[
										<div>
											Are you done editing your character?
											<div v-if="$getModel('cost')"><br>Saving will cost $<span class="text-red">{{$getModel('cost')}}</span>!</div>
										</div>
									]],
								},
								{
									type = "q-card-actions",
									binds = {
										["align"] = "right",
									},
									components = {
										{
											type = "q-btn",
											text = "Save and Exit",
											binds = {
												color = "green",
											},
											click = {
												event = "save",
												callback = "this.$setModel('saving', true)",
											},
										},
										{
											type = "q-btn",
											text = "Exit without Saving",
											binds = {
												color = "red",
												disabled = not isLoading,
											},
											click = {
												event = "discard",
											},
										},
									},
								},
								{
									type = "q-inner-loading",
									condition = "this.$getModel('saving')",
									template = "<q-spinner size='30px' />",
									binds = {
										showing = true,
									},
								},
							},
						},
					},
				},
			},
		},
		style = {
			["width"] = "55vmin",
			["height"] = "90vmin",
			["top"] = "50%",
			["right"] = "2vmin",
			["transform"] = "translate(0%, -50%)",
			["overflow"] = "visible !important",
		},
	})
	
	self.window = window

	-- Create elements.
	local cardComponent = window:AddComponent({
		class = "flex row justify-center",
		type = "q-card",
	})

	local panelsComponent = window:AddComponent({
		type = "q-item-list",
		style = {
			["height"] = "100%",
			["overflow"] = "auto",
		},
	})
	
	local tabComponents = {}
	local tabPanels = {}

	for _, tab in ipairs(self.tabs) do
		if filter and tab.filter and not tab.filter[filter] then goto skipTab end

		tabComponents[tab.name] = cardComponent:AddComponent({
			type = "q-item",
			class = "flex column justify-center",
			style = {
				["flex-grow"] = 1,
				["min-width"] = "25%",
				["align-items"] = "center",
			},
			binds = {
				clickable = true,
			},
			click = {
				callback = "this.$setModel('tab', '"..tab.name.."')",
			},
			components = {
				{
					type = "q-icon",
					name = tab.icon,
					style = {
						["font-size"] = "2vmin",
					}
				},
				{
					text = tab.label,
				},
				{
					condition = "this.$getModel('tab') == '"..tab.name.."'",
					style = {
						["position"] = "absolute",
						["width"] = "100%",
						["height"] = "100%",
						["border"] = "2px solid white",
					},
				},
			}
		})

		local tabPanel = panelsComponent:AddComponent({
			type = "q-form",
			condition = ("this.$getModel('tab') == '%s'"):format(tab.name),
			class = tab.padding and "q-pa-md" or "",
			binds = {
				label = tab.label,
				icon = tab.icon,
			},
		})

		tabPanel.onselect = tab.onselect
		tabPanel.ondeselect = tab.ondeselect

		tabPanels[tab.name] = tabPanel

		::skipTab::
	end

	self.tabPanels = tabPanels

	-- Create import/export options.
	tabPanels.tools:AddComponent({
		template = [[
			<q-btn-group style="min-width: 100%">
				<q-input
					filled
					label="Import"
					style="flex-grow: 1"
					@input="$setModel('import', $event)"
					:value="$getModel('import')"
				></q-input>
				<q-btn
					color="red"
					style="min-width: 20%"
					@click="$invoke('import')"
				>Update</q-btn>
			</q-btn-group>
		]],
	})

	-- Create import/export options (old).
	tabPanels.tools:AddComponent({
		template = [[
			<q-btn-group style="min-width: 100%">
				<q-input
					filled
					label="Import (OLD)"
					style="flex-grow: 1"
					@input="$setModel('importOld', $event)"
					:value="$getModel('importOld')"
				></q-input>
				<q-btn
					color="red"
					style="min-width: 20%"
					@click="$invoke('importOld')"
				>Update</q-btn>
			</q-btn-group>
		]],
	})
	
	-- Create import/export options.
	tabPanels.tools:AddComponent({
		template = [[
			<q-btn-group style="min-width: 100%">
				<q-input
					filled
					readonly
					label="Export"
					style="flex-grow: 1"
					:value="$getModel('export')"
					ref="export"
				></q-input>
				<q-btn
					color="blue"
					style="min-width: 20%"
					@click="$copyToClipboard($refs['export'].value)"
				>Copy</q-btn>
			</q-btn-group>
		]],
	})

	-- Create seperator.
	tabPanels.tools:AddComponent({ type = "q-separator", binds = { spaced = true } })

	-- Create random options.
	tabPanels.tools:AddComponent({
		template = [[
			<q-list class="flex column">
				<q-btn
					v-for="tab in $getModel('tabs')"
					:key="tab.name"
					v-if="tab.random"
					class="q-mb-sm"
					color="blue"
					align="left"
					@click="$invoke('randomize', tab.name)"
				>
					Randomize {{tab.label}}
				</q-btn>
				<q-btn
					color="red"
					align="left"
					@click="$invoke('randomize')"
				>
					Randomize All
				</q-btn>
			</q-list>
		]],
	})

	window:SetModel("tabs", Editor.tabs)

	-- Create controller.
	local controller = Controller:Create()
	local data = nil

	if isLoading then
		data = controller:ConvertData({
			appearance = appearance or {},
			features = features or {},
		})
	else
		data = controller:GetData({
			bodyType = (exports.character:Get("gender") == "Male" and "Masculine") or "Feminine",
		})
	end

	controller:SetWindow(window)
	controller:SetData(data)
	controller.defaults = json.encode(data)

	self:ClearTarget()

	-- Create camera.
	local camera = Camera:Create({})

	camera:Activate()

	self.camera = camera
end

function Editor:GetGroup(target, group)
	local tab = self.tabPanels[target]
	if not tab then return end
	
	if tab.groups == nil then
		tab.groups = {}
	end

	local component = tab.groups[group]

	if component == nil then
		component = tab:AddComponent({
			type = "div",
			class = "row",
			style = {
				["width"] = "100%",
				["flex-wrap"] = "nowrap",
			},
		})

		tab.groups[group] = component
	end

	return component
end

function Editor:Update()
	local camera = self.camera
	if not camera then return end

	local ped = PlayerPedId()
	local pedCoords = GetEntityCoords(ped)

	-- Get target.
	local settings = self.targets[self.target or "default"]
	local target = GetPedBoneCoords(ped, settings.bone)
	
	local distance = settings.distance or 3.0
	local hShift = settings.hShift or 0.6
	local vShift = settings.vShift or 0.6
	local fov = settings.fov or 40.0

	if self.target == "feet" then
		target = pedCoords

		local retval, groundZ = GetGroundZFor_3dCoord(target.x, target.y, target.z)
		if retval then
			target = vector3(target.x, target.y, groundZ + 0.1)
		else
			print("Trying to look at feet, but no ground! Try moving somewhere else?")
		end
	end

	-- Cache ped info.
	local heading = GetEntityHeading(ped)
	local targetHeading = ((self.initialHeading or 0.0) + (self.headingOffset or 0.0)) % 360.0

	-- Calculations.
	local forwardRad = math.rad((self.initialHeading or 0.0) + 90.0)
	local forward = vector3(math.cos(forwardRad), math.sin(forwardRad), 0)
	local right = Cross(forward, self.up)

	target = target - right * hShift

	local coords = target + forward * distance + right * hShift + self.up * vShift
	
	-- High heels.
	local hasHighHeels = GetPedConfigFlag(ped, 322)
	if hasHighHeels then
		target = target + vector3(0.0, 0.0, 0.088)
		coords = coords + vector3(0.0, 0.0, 0.088)
	end

	-- Get rotations.
	local direction = Normalize(target - coords)
	local rotation = ToRotation(direction)
	
	-- Set ped heading.
	if math.abs(heading - targetHeading) > 1.0 then
		SetEntityHeading(ped, targetHeading)
	end

	-- Update camera.
	camera.coords = coords
	camera.rotation = rotation
	camera.fov = fov

	-- Render light.
	local lightCoords = pedCoords + forward * 5.0 + right * 1.0 + self.up * 4.0
	local lightDirection = Normalize(pedCoords - lightCoords)

	DrawSpotLight(lightCoords.x, lightCoords.y, lightCoords.z, lightDirection.x, lightDirection.y, lightDirection.z, 255, 255, 255, 20.0, 0.5, 0.0, 12.0, 6.0)

	-- Hide other players.
	local localPlayer = PlayerId()
	for _, player in ipairs(GetActivePlayers()) do
		if player ~= localPlayer then
			SetPlayerInvisibleLocally(player)
		else
			SetPlayerVisibleLocally(player)
		end
	end
end

function Editor:Destroy()
	if self.camera then
		self.camera:Destroy()
		self.camera = nil
	end

	if self.window then
		self.window:Destroy()
		self.window = nil
	end
end

function Editor:Toggle(value, filter)
	local ped = PlayerPedId()

	if not value and self.open then
		if self.initialHeading then
			SetEntityHeading(ped, self.initialHeading)
		end

		self:Destroy()
		exports.emotes:Stop()
	elseif value and not self.open then
		self.initialHeading = GetEntityHeading(ped)
		self.headingOffset = 0.0
		
		self:Build(filter)

		ped = PlayerPedId()
	end
	
	self.open = value
	UI:Focus(value)

	SetEntityVisible(ped, not value)
	FreezeEntityPosition(ped, value)
	SetEntityCollision(ped, not value, not value)
end

function Editor:SetTarget(target)
	if self.target == target then return end
	local emote

	if target and self.targets[target] then
		self.target = target
		emote = self.anims[target]
	else
		self.target = nil
	end

	if emote then
		exports.emotes:Play(emote)
	else
		exports.emotes:Stop(true)
	end
end

function Editor:ClearTarget()
	self.target = nil

	exports.emotes:Stop(true)
end

--[[ Events ]]--
AddEventHandler("ui:keydown", function(key)
	local window = Editor.window
	if not window then return end

	local turnAngle

	if key == "a" then
		turnAngle = -45.0
	elseif key == "d" then
		turnAngle = 45.0
	end

	if turnAngle then
		Editor.headingOffset = ((Editor.headingOffset or 0.0) + turnAngle) % 360.0
	end
end)

--[[ Threads ]]--
Citizen.CreateThread(function()
	while true do
		if Editor.window then
			Editor:Update()
			Citizen.Wait(0)
		else
			Citizen.Wait(200)
		end
	end
end)

--[[ Commands ]]--
exports.chat:RegisterCommand("a:appearance", function(source, args, command)
	local value = args[1]

	if value == "false" then
		Editor:Toggle(false)
	else
		Editor:Toggle(true)
	end
end, {
	description = "Open the appearance editor for your character.",
	parameters = {
		{ name = "Value", description = "True or false; should the menu open or close?" },
	},
}, "Mod")