--[[
	https://gtaxscripting.blogspot.com/2016/04/gta-v-peds-component-and-props.html
	
	SetPedDefaultComponentVariation(ped)
	ClearPedDecorations(ped)
	
	Appearance.
	
	Props (0: Hat\ 1: Glass\ 2: Ear\ 6: Watch\ 7: Bracelet):
	*GetNumberOfPedPropTextureVariations(ped, propId, drawableId)
	*GetNumberOfPedPropDrawableVariations(ped, propId)
	*ClearPedProp(ped, propId)
	*SetPedPropIndex(ped, componentId, drawableId, textureId, attach)
	
	*Components (0: Face\ 1: Mask\ 2: Hair\ 3: Torso\ 4: Leg\ 5: Parachute / bag\ 6: Shoes\ 7: Accessory\ 8: Undershirt\ 9: Kevlar\ 10: Badge\ 11: Torso 2):
	*GetNumberOfPedDrawableVariations(ped, componentId)
	*GetNumberOfPedTextureVariations(ped, componentId, drawableId)
	*SetPedComponentVariation(ped, componentId, drawableId, textureId, paletteId)
	
	Features.
	
	*SetPedHeadBlendData(ped, shapeFirstID, shapeSecondID, shapeThirdID, skinFirstID, skinSecondID, skinThirdID, shapeMix, skinMix, thirdMix, isParent)
	*SetPedFaceFeature(ped, index, scale)
	*SetPedHeadOverlay(ped, overlayID, index, opacity)
	*SetPedHeadOverlayColor(ped, overlayID, colorType, colorID, secondColorID)
		0: Blemishes (0 - 23, 255)			Makeup
		1: Facial Hair (0 - 28, 255)		Hair
		2: Eyebrows (0 - 33, 255)			Hair
		3: Ageing (0 - 14, 255)				Makeup
		4: Makeup (0 - 74, 255)				Makeup
		5: Blush (0 - 6, 255)				Makeup
		6: Complexion (0 - 11, 255)			Makeup
		7: Sun Damage (0 - 10, 255)			Makeup
		8: Lipstick (0 - 9, 255)			Makeup
		9: Moles/Freckles (0 - 17, 255)		Makeup
		10: Chest Hair (0 - 16, 255)		Hair
		11: Body Blemishes (0 - 11, 255)	Makeup
		12: Add Body Blemishes (0 - 1, 255)	Makeup
	*SetPedHairColor(ped, colorID, highlightColorID)
	*SetPedEyeColor(ped, index)
	*AddPedDecorationFromHashes(ped, collection, overlay)

	Data
	{
		appearance = {
			props = {
				-- component, drawable, texture
				{ 0, 0, 0 }, -- 0: head.
				{ 0, 0, 0 }, -- 1: face.
				{ 0, 0, 0 }, -- 2: ear.
				{ 0, 0, 0 }, -- 3: watch.
				{ 0, 0, 0 }, -- 4: bracelet.
			},
			components = {
				
			},
		},
		features = {
			bodyType = 1,
			model = 1,
			blendData = {
				shape1 = 0,
				shape2 = 0,
				skinMix = 0.0,
				shapeMix = 0.0,
				...
			},
		},
	}

	Nodes
	{
		tab = "", -- Goes to a specific tab.
		group = "", -- Creates a horizontal group.
		model = "", -- Holds data assigned in the map and window model.
		watchers = { "" }, -- Watches for changes in the model.
		default = "", -- Default value to represent.
		condition = function(controller)
			
		end,
		component = function(controller)
			
		end,
		value = function(controller, value)

		end,
		randomize = function(controller)
			
		end,
		update = function(controller, trigger, value, lastValue, isMenu, bind)
			
		end,
	},
]]

-- WARNING: changing table order is extremely volatile.

Map = {
	appearance = {
		{ -- Clothes
			tab = "clothes",
			model = "components",
			watchers = { "model" },
			component = function(controller)
				local components = {}
				local n = #PedComponents

				local map = controller.map or {}
				local componentsModel = map.components or {}

				for k, v in ipairs(PedComponents) do
					if v.index == 0 and map.model == 1 then goto skipComponent end

					local max = GetNumberOfPedDrawableVariations(Ped, v.index)
					if max <= 0 then goto skipComponent end
					
					local componentModel = componentsModel[k] or 1
					local textureModel = componentsModel[k + n] or 1
					local textures = componentModel == 1 and 1 or GetNumberOfPedTextureVariations(Ped, v.index, componentModel - (v.emptySlot and 2 or 1))
					local model = "component-"..k

					components[#components + 1] = {
						style = "width: 100%; margin-bottom: 1vmin",
						class = "flex row",
						components = {
							{
								type = "slider-item",
								name = v.name,
								input = true,
								minIcon = "chevron_left",
								maxIcon = "chevron_right",
								style = "min-width: 100%",
								slider = {
									model = model,
									default = 1,
									min = 1,
									max = max + (v.emptySlot and 1 or 0),
									step = 1,
									snap = true,
								},
							},
							{
								type = "slider-item",
								condition = tostring(textures > 1),
								input = true,
								minIcon = "chevron_left",
								maxIcon = "chevron_right",
								style = "min-width: 100%",
								slider = {
									model = model.."_v",
									default = 1,
									min = 1,
									max = textures,
									step = 1,
									snap = true,
								},
							},
						}
					}

					controller:BindModel(model, "components", k)
					controller:BindModel(model.."_v", "components", k + n)

					if textureModel > textures then
						controller.window:SetModel(model.."_v", textures)
						controller.map.components[k + n] = textures
					end

					::skipComponent::
				end

				return {
					type = "div",
					class = "flex row",
					components = components,
				}
			end,
			randomize = function(controller)
				return {
					1, -- Face
					1, -- Mask
					1, -- Accessory
					1, -- Badge
					1, -- Bag
					1, -- Kevlar
					4, -- Jacket
					1, -- Undershirt
					4, -- Torso
					4, -- Leg
					5, -- Shoes

					1, -- Face
					1, -- Mask
					1, -- Accessory
					1, -- Badge
					1, -- Bag
					1, -- Kevlar
					1, -- Jacket
					1, -- Undershirt
					1, -- Torso
					1, -- Leg
					1, -- Shoes
				}
			end,
			update = function(controller, trigger, value, lastValue, isMenu, bind)
				local map = controller.map
				if not map then return end

				local n = #PedComponents

				if isMenu and bind then
					local component = PedComponents[((bind.index - 1) % n) + 1]

					if component and component.focus then
						Editor:SetTarget(component.focus)
					else
						Editor:ClearTarget()
					end
				end

				local components = map.components
				if not components then return end

				for k, v in ipairs(PedComponents) do
					local value = components[k] or 1
					local offset = v.emptySlot and 2 or 1
					local texture = components[k + n] or 1

					local value = value == 1 and v.emptySlot or value - offset
					if type(value) == "table" then
						local bodyType = controller.map["bodyType"]
						local isMale = bodyType == "Masculine"

						value = value[isMale and 2 or 1]
					end
					
					SetPedComponentVariation(Ped, v.index, value, math.max(texture - 1, 0), 0)
				end
			end,
		},
		{ -- Accessories
			tab = "accessories",
			model = "props",
			watchers = { "model" },
			component = function(controller)
				local components = {}
				local n = #PedProps

				local map = controller.map or {}
				local propsModel = map.props or {}

				for k, v in ipairs(PedProps) do
					local max = GetNumberOfPedPropDrawableVariations(Ped, v.index)
					if max <= 0 then goto skipComponent end
					
					local propModel = propsModel[k] or 1
					local textureModel = propsModel[k + n] or 1
					local textures = propModel == 1 and 1 or GetNumberOfPedPropTextureVariations(Ped, v.index, propModel - 2)

					local model = "prop-"..k

					components[#components + 1] = {
						style = "width: 100%; margin-bottom: 1vmin",
						class = "flex row",
						components = {
							{
								type = "slider-item",
								name = v.name,
								input = true,
								minIcon = "chevron_left",
								maxIcon = "chevron_right",
								style = "min-width: 100%",
								slider = {
									model = model,
									default = 1,
									min = 1,
									max = max + 1,
									step = 1,
									snap = true,
								},
							},
							{
								type = "slider-item",
								condition = tostring(textures > 1),
								input = true,
								minIcon = "chevron_left",
								maxIcon = "chevron_right",
								style = "min-width: 100%",
								slider = {
									model = model.."_v",
									default = 1,
									min = 1,
									max = textures,
									step = 1,
									snap = true,
								},
							},
						}
					}

					controller:BindModel(model, "props", k)
					controller:BindModel(model.."_v", "props", k + n)

					if textureModel > textures then
						controller.window:SetModel(model.."_v", textures)
						controller.map.props[k + n] = textures
					end

					::skipComponent::
				end

				return {
					type = "div",
					class = "flex row",
					components = components,
				}
			end,
			randomize = function(controller)
				return {
					1,
					1,
					1,
					1,

					1,
					1,
					1,
					1,
				}
			end,
			update = function(controller, trigger, value, lastValue, isMenu, bind)
				local map = controller.map
				if not map then return end

				local n = #PedProps

				if isMenu and bind then
					local prop = PedProps[((bind.index - 1) % n) + 1]

					if prop and prop.onchange then
						prop.onchange()
					end

					if prop and prop.focus then
						Editor:SetTarget(prop.focus)
					else
						Editor:ClearTarget()
					end
				end

				local props = map.props
				if not props then return end

				ClearAllPedProps(Ped)

				for k, v in ipairs(PedProps) do
					local value = props[k] or 1
					local texture = props[k + n] or 1

					if value > 1 then
						SetPedPropIndex(Ped, v.index, value - 2, math.max(texture - 1, 0), true)
					end
				end
			end,
		},
		{ -- Head Hair
			tab = "hair",
			model = "hair",
			watchers = { "model" },
			component = function(controller)
				local max = GetNumberOfPedDrawableVariations(Ped, 2) - 16
				local model = "hairComponent"

				local slider = {
					type = "slider-item",
					name = "Hair",
					input = true,
					minIcon = "chevron_left",
					maxIcon = "chevron_right",
					style = "min-width: 100%",
					slider = {
						model = model,
						default = 1,
						min = 1,
						max = max + 1,
						step = 1,
						snap = true,
					},
				}

				local colors = {}
				for i = 1, GetNumHairColors() do
					local r, g, b = GetPedHairRgbColor(i - 1)
					colors[i] = { r = r, g = g, b = b }
				end

				local palettes = {}
				for i = 1, 2 do
					palettes[i] = {
						type = "div",
						class = "flex row text-caption q-mb-sm q-mt-sm",
						style = "width: 100%",
						template = ([[
							<div>
								<q-chip size="sm" dense color="blue" class="q-mb-sm">%s</q-chip>
								<div class="flex row" style="background: rgba(0, 0, 0, 0.4); outline: 1px solid rgba(0, 0, 0, 0.6); width: 50vmin;">
									<div
										v-for="(color, key) in %s"
										:style="{
											background: `rgb(${color.r}, ${color.g}, ${color.b})`,
											width: '2.5vmin', height: '2.5vmin',
											border: $getModel('%s') == key ? '2px solid yellow' : 'none'
										}"
										@click="$setModel('%s', key)"
									>
										<q-tooltip>
											rgb({{color.r}}, {{color.g}}, {{color.b}})
										</q-tooltip>
									</div>
								</div>
							</div>
						]]):format(
							i == 1 and "Primary" or "Secondary",
							json.encode(colors):gsub("\"", "'"),
							model.."_c"..i,
							model.."_c"..i
						),
					}
				end

				controller:BindModel(model, "hair", 1)
				controller:BindModel(model.."_c1", "hair", 2)
				controller:BindModel(model.."_c2", "hair", 3)

				return {
					type = "div",
					class = "flex row",
					components = {
						{
							style = "width: 100%; margin-bottom: 1vmin",
							class = "flex row",
							components = {
								slider,
								table.unpack(palettes)
							}
						}
					},
				}
			end,
			randomize = function(controller)
				local bodyType = controller.map["bodyType"]
				local isMale = bodyType == "Masculine"
				local isNeon = GetRandomFloatInRange(0.0, 1.0) < 0.25
				local color = GetRandomIntInRange(isNeon and 20 or 1, isNeon and GetNumHairColors() or 20)
				
				return {
					GetRandomIntInRange(2, isMale and 23 or 74), -- Hair component id (male or female).
					color, -- Primary color.
					isNeon and GetRandomIntInRange(21, GetNumHairColors()) or math.max(color + GetRandomIntInRange(-1, 1), 1), -- Secondary color (highlights).
				}
			end,
			update = function(controller, trigger, value, lastValue, isMenu, bind)
				local map = controller.map
				if not map then return end

				if isMenu and bind and trigger == "hair" then
					Editor:SetTarget("head")
				end

				local hair = map.hair
				if not hair then return end

				local componentId = hair[1] or 1
				local color = hair[2] or 1
				local highlight = hair[3] or 1

				SetPedComponentVariation(Ped, 2, componentId == 1 and -1 or componentId + 14, 0, 0)
				SetPedHairColor(Ped, color, highlight)
			end,
		},
		{ -- Makeup
			tab = "makeup",
			model = "makeupOverlays",
			watchers = { "model" },
			component = function(controller)
				local components = {}

				for k, v in ipairs(Overlays.Head.Makeup) do
					local model = "makeupOverlays-"..k
					local max = GetPedHeadOverlayNum(v.index)

					local slider = {
						type = "slider-item",
						name = v.name,
						input = true,
						minIcon = "chevron_left",
						maxIcon = "chevron_right",
						style = "min-width: 100%",
						slider = {
							model = model,
							default = 1,
							min = 1,
							max = max + 1,
							step = 1,
							snap = true,
						},
						secondary = {
							model = model.."_a",
							min = 0.0,
							max = 1.0,
							default = 0.0,
							step = 0.05,
							snap = true,
						}
					}

					local colors = {}
					for i = 1, GetNumHairColors() do
						local r, g, b = GetPedMakeupRgbColor(i - 1)
						colors[i] = { r = r, g = g, b = b }
					end

					local palettes = {}
					for i = 1, 2 do
						palettes[i] = {
							type = "div",
							class = "flex row text-caption q-mb-sm q-mt-sm",
							style = "width: 100%",
							template = ([[
								<div>
									<q-chip size="sm" dense color="blue" class="q-mb-sm">%s</q-chip>
									<div class="flex row" style="background: rgba(0, 0, 0, 0.4); outline: 1px solid rgba(0, 0, 0, 0.6); width: 50vmin;">
										<div
											v-for="(color, key) in %s"
											:style="{
												background: `rgb(${color.r}, ${color.g}, ${color.b})`,
												width: '2.5vmin', height: '2.5vmin',
												border: $getModel('%s') == key ? '2px solid yellow' : 'none'
											}"
											@click="$setModel('%s', key)"
										>
											<q-tooltip>
												rgb({{color.r}}, {{color.g}}, {{color.b}})
											</q-tooltip>
										</div>
									</div>
								</div>
							]]):format(
								i == 1 and "Primary" or "Secondary",
								json.encode(colors):gsub("\"", "'"),
								model.."_c"..i,
								model.."_c"..i
							),
						}
					end

					components[k] = {
						style = "width: 100%; margin-bottom: 1vmin",
						class = "flex row",
						components = {
							slider,
							table.unpack(palettes)
						}
					}

					local n = #Overlays.Head.Makeup

					controller:BindModel(model, "makeupOverlays", k)
					controller:BindModel(model.."_a", "makeupOverlays", k + n)
					controller:BindModel(model.."_c1", "makeupOverlays", k + n * 2)
					controller:BindModel(model.."_c2", "makeupOverlays", k + n * 3)
				end

				return {
					type = "div",
					class = "flex row",
					components = components,
				}
			end,
			randomize = function(controller)
				local bodyType = controller.map["bodyType"]
				local isMale = bodyType == "Masculine"
				local color1 = GetRandomIntInRange(1, GetNumMakeupColors())
				local color2 = GetRandomIntInRange(1, GetNumMakeupColors())
				local makeupIntensity = isMale and 0.0 or GetRandomFloatInRange(0.0, 1.0)

				return {
					isMale and 1 or GetRandomIntInRange(1, 17), -- Makeup
					isMale and 1 or GetRandomIntInRange(1, 7), -- Blush
					GetRandomIntInRange(1, 10), -- Lipstick

					makeupIntensity, -- Makeup
					math.pow(GetRandomFloatInRange(0.0, 1.0) * makeupIntensity, 2.0), -- Blush
					makeupIntensity, -- Lipstick

					color1,
					color1,
					color1,

					color2,
					color2,
					color2,
				}
			end,
			update = function(controller, trigger, value, lastValue, isMenu, bind)
				local map = controller.map
				if not map then return end

				if isMenu and bind and trigger == "makeupOverlays" then
					Editor:SetTarget("head")
				end

				local makeupOverlays = map.makeupOverlays
				if not makeupOverlays then return end

				local n = #Overlays.Head.Makeup
				for k, v in ipairs(Overlays.Head.Makeup) do
					local value = makeupOverlays[k] or 255
					local opacity = makeupOverlays[k + n] or 0.0
					local color1 = makeupOverlays[k + n * 2] or 1
					local color2 = makeupOverlays[k + n * 3] or 1

					SetPedHeadOverlay(Ped, v.index, (value == 1 and 255) or value - 2, opacity + 0.0)
					SetPedHeadOverlayColor(Ped, v.index, 2, color1, color2)
				end
			end,
		},
	},
	features = {
		{ -- Body Type
			tab = "shape",
			group = "model",
			model = "bodyType",
			default = "Masculine",
			component = function(controller)
				local bodyTypes = {
					"Masculine",
					"Feminine",
				}

				if exports.user:HasFlag("CAN_PLAY_ANIMAL") then
					bodyTypes[3] = "Animal"
				end

				return {
					type = "q-select",
					style = {
						["flex-grow"] = 1,
					},
					binds = {
						label = "Body Type",
						filled = true,
						options = bodyTypes,
					},
				}
			end,
			value = function(controller, value)
				if type(value) == "string" then
					return BodyTypes.Key[value]
				else
					return BodyTypes.Index[value]
				end
			end,
			update = function(controller, trigger, value, lastValue, isMenu, bind)
				local bodyType = controller.map["bodyType"]
				local models = Models[bodyType] or {}

				for k, v in ipairs(models) do
					v.id = k
				end

				if isMenu then
					if trigger == "bodyType" and lastValue and lastValue ~= value then
						controller:SetMap("overlays", {})
					end

					controller.window:SetModel("modelsData", models)
					controller.window:SetModel("modelsColumns", {
						{ field = "preview", name = "preview", label = "", align = "left" },
						{ field = "name", name = "model", label = "Model", align = "left" },
						{ field = "allowed", name = "allowed", label = "Allowed", align = "right" },
					})
				end

				controller:SetMap("model", 1)

				if isMenu then
					-- if not controller.map["blendData"] then
					-- 	controller:Randomize()
					-- end

					Editor:ClearTarget()
				end
			end,
		},
		{ -- Model
			tab = "shape",
			group = "model",
			model = "model",
			default = 1,
			condition = function(controller)
				return exports.user:HasFlag("CAN_PLAY_PEDS")
			end,
			component = function(controller)
				local bodyType = controller.map["bodyType"]
				local models = (bodyType and Models[bodyType]) or {}

				return {
					type = "q-input",
					class = "no-shadow",
					binds = {
						filled = true,
					},
					prepend = {
						icon = "accessibility",
						class = "text-primary",
						click = {
							callback = "this.$setModel('selectModel', true)",
						},
					},
					components = {
						{
							type = "q-dialog",
							model = "selectModel",
							template = [[
								<q-card style="width: 90vmin !important; overflow-x: hidden">
									<q-table
										grid
										title="Models"
										:data="$getModel('modelsData')"
										:columns="$getModel('modelsColumns')"
										row-key="id"
										:rows-per-page-options="[20]"
										:filter="$getModel('modelsFilter')"
										hide-pagination=true
										hide-header
									>
										<template v-slot:top-right>
											<q-input
												borderless
												dense
												debounce="300"
												@input="$setModel('modelsFilter', $event)"
												:value="$getModel('modelsFilter')"
												placeholder="Search"
											>
												<q-icon name="search" />
											</q-input>
										</template>
										<template v-slot:item="props">
											<q-item
												class="flex column justify-between items-center"
												style="width: 18%; margin: 1%"
												@click="$invoke('setPed', props.row.id)"
												clickable
												ripple
											>
												<q-img
													:src="`https://docs.fivem.net//peds/${props.row.name}.webp`"
													style="width: 50px"
												/>
												<span style="font-size: 0.8em">{{props.row.name}}</span>
											</q-item>
										</template>
									</q-table>
								</q-card>
							]]
						},
					},
				}
			end,
			update = function(controller, trigger, value, lastValue, isMenu, bind)
				if controller.ped then return end

				local bodyType = controller.map["bodyType"] or "Masculine"
				local index = controller.map["model"] or 1
				
				local models = (bodyType and Models[bodyType])
				if not models then
					error(("no models for bodyType '%s'"):format(bodyType))
				end

				local model = models[index]
				local name = model.name

				if not name or not IsModelValid(name) then
					return
				end

				while not HasModelLoaded(name) do
					RequestModel(name)
					Citizen.Wait(20)
				end

				if (controller.map["model"] or 1) ~= index then
					return
				end

				SetPlayerModel(Player, name)

				Ped = PlayerPedId()

				SetPedDefaultComponentVariation(Ped)
				SetModelAsNoLongerNeeded(name)

				if isMenu then
					SetEntityVisible(ped, false)
					FreezeEntityPosition(ped, true)
					SetEntityCollision(ped, false, false)

					Editor:ClearTarget()
				end
			end,
		},
		{ -- Face Blends
			tab = "shape",
			model = "blendData",
			watchers = { "model" },
			condition = function(controller)
				return tonumber(controller.map["model"]) == 1
			end,
			component = function(controller)
				local components = {}

				for k, v in ipairs({
					{ index = 1, name = "First Shape", min = 1, max = 46 },
					{ index = 2, name = "Second Shape", min = 1, max = 46 },
					{ index = 4, name = "First Skin", min = 1, max = 46 },
					{ index = 5, name = "Second Skin", min = 1, max = 46 },
					{ index = 7, name = "Shape Mix", min = 0.0, max = 1.0, step = 0.05, default = 0.5 },
					{ index = 8, name = "Skin Mix", min = 0.0, max = 1.0, step = 0.05, default = 0.5 },
					{ index = 6, name = "Third Skin", min = 1, max = 46 },
					{ index = 3, name = "Third Shape", min = 1, max = 46 },
					{ index = 9, name = "Third Mix", min = 0.0, max = 1.0, step = 0.05, default = 0.0 },
				}) do
					local model = "blendData-"..v.index

					components[k] = {
						type = "slider-item",
						name = v.name,
						input = true,
						minIcon = "chevron_left",
						maxIcon = "chevron_right",
						-- style = "min-width: 50%; padding-"..(k % 2 == 0 and "left" or "right")..": 1vmin",
						style = "min-width: 100%",
						slider = {
							model = model,
							default = v.default or 1,
							min = v.min,
							max = v.max,
							step = v.step or 1,
							snap = true,
						}
					}

					controller:BindModel(model, "blendData", v.index)
				end

				return {
					type = "div",
					class = "flex row",
					components = components,
				}
			end,
			randomize = function(controller)
				local masculine = { 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15, 16, 17, 18, 19, 20, 21, 23, 25, 27, 31, 36, 43, 44, 45 }
				local feminine = { 22, 24, 26, 28, 29, 30, 32, 33, 34, 35, 37, 38, 39, 40, 41, 42, 46 }
				local bodyType = controller.map["bodyType"]
				local shapeMin, shapeMax = 0.0, 1.0

				if bodyType == "Masculine" then
					shapeMin = 0.5
				else
					shapeMax = 0.5
				end

				local function getRandomFace(table)
					return table[GetRandomIntInRange(1, #table)]
				end

				return {
					getRandomFace(feminine), -- shape1
					getRandomFace(masculine), -- shape2
					getRandomFace((bodyType == "Masculine" and masculine) or feminine), -- shape3
					GetRandomIntInRange(1, 46), -- skin1
					GetRandomIntInRange(1, 46), -- skin2
					GetRandomIntInRange(1, 46), -- skin3
					math.floor(GetRandomFloatInRange(shapeMin, shapeMax) * 100.0) / 100.0, -- shapeMix
					math.floor(GetRandomFloatInRange(0.0, 1.0) * 100.0) / 100.0, -- skinMix
					math.floor(GetRandomFloatInRange(0.0, 1.0) * 100.0) / 100.0, -- thirdMix
				}
			end,
			update = function(controller, trigger, value, lastValue, isMenu, bind)
				local map = controller.map
				if not map then return end

				if isMenu and bind and trigger == "blendData" then
					Editor:SetTarget("head")
				end

				local blendData = map.blendData
				if not blendData then return end
				
				SetPedHeadBlendData(
					Ped,
					(blendData[1] or 1) - 1, -- shape1
					(blendData[2] or 1) - 1, -- shape2
					(blendData[3] or 1) - 1, -- shape3
					(blendData[4] or 1) - 1, -- skin1
					(blendData[5] or 1) - 1, -- skin2
					(blendData[6] or 1) - 1, -- skin3
					(blendData[7] or 0.5) + 0.0, -- shapeMix
					(blendData[8] or 0.5) + 0.0, -- skinMix
					(blendData[9] or 0.0) + 0.0, -- thirdMix
					true
				)
			end,
		},
		{ -- Face Features
			tab = "shape",
			model = "faceFeatures",
			watchers = { "model" },
			condition = function(controller)
				return tonumber(controller.map["model"]) == 1
			end,
			component = function(controller)
				local components = {}

				for k, v in ipairs({
					{ name = "Nose Width" },
					{ name = "Nose Height" },
					{ name = "Nose Length" },
					{ name = "Nose Bridge Length" },
					{ name = "Nose Tip Height" },
					{ name = "Nose Bridge Broken" },
					{ name = "Eye Brow Height" },
					{ name = "Eye Brow Forward" },
					{ name = "Cheeks Bone Height" },
					{ name = "Cheeks Bone Width" },
					{ name = "Cheeks Width" },
					{ name = "Eyes Squint" },
					{ name = "Lips Thickness" },
					{ name = "Jaw Bone Width" },
					{ name = "Jaw Bone Back Length" },
					{ name = "Chin Bone Height" },
					{ name = "Chin Bone Length" },
					{ name = "Chin Bone Width" },
					{ name = "Chin Crease" },
					{ name = "Neck Thickness" },
				}) do
					local model = "features"..k

					components[k] = {
						type = "slider-item",
						name = v.name,
						input = true,
						minIcon = "chevron_left",
						maxIcon = "chevron_right",
						style = "min-width: 50%; padding-"..(k % 2 == 0 and "left" or "right")..": 1vmin",
						-- style = "min-width: 100%;",
						slider = {
							model = model,
							default = 0.0,
							min = -1.0,
							max = 1.0,
							step = 0.1,
							snap = true,
						}
					}

					controller:BindModel(model, "faceFeatures", k)
				end

				return {
					type = "div",
					class = "flex row",
					components = components,
				}
			end,
			randomize = function(controller)
				local faceFeatures = {}
				for i = 1, 20 do
					faceFeatures[i] = math.floor(math.pow(GetRandomFloatInRange(-0.5, 0.5), 4.0) * 10.0) / 10.0
				end
				return faceFeatures
			end,
			update = function(controller, trigger, value, lastValue, isMenu, bind)
				local map = controller.map
				if not map then return end
				
				if isMenu and bind and trigger == "faceFeatures" then
					Editor:SetTarget("head")
				end

				local faceFeatures = map.faceFeatures
				if not faceFeatures then return end

				local inverted = { false, true, true, true, true, false, true, false, true, false, true, false, true, false, false, true, false, false, false, false }
				for i = 1, 20 do
					local value = faceFeatures[i] or 0.0
					if inverted[i] then
						value = value * -1.0
					end
					SetPedFaceFeature(Ped, i - 1, value + 0.0)
				end
			end,
		},
		{ -- Eye Color
			tab = "features",
			model = "eyeColor",
			watchers = { "model" },
			component = function(controller)
				return {
					type = "slider-item",
					name = "Eye Color",
					input = true,
					minIcon = "chevron_left",
					maxIcon = "chevron_right",
					style = "min-width: 100%",
					slider = {
						model = "eyeColor",
						default = 1,
						min = 1,
						max = 32,
						step = 1,
						snap = true,
					},
				}
			end,
			randomize = function(controller)
				return GetRandomIntInRange(1, 8)
			end,
			update = function(controller, trigger, value, lastValue, isMenu, bind)
				local map = controller.map
				if not map then return end

				local color = map.eyeColor or 1
				
				if isMenu and bind and trigger == "eyeColor" then
					Editor:SetTarget("head")
				end

				SetPedEyeColor(Ped, color - 1)
			end,
		},
		{ -- Blemishes
			tab = "features",
			model = "otherOverlays",
			watchers = { "model" },
			component = function(controller)
				local components = {}

				for k, v in ipairs(Overlays.Head.Other) do
					local model = "otherOverlays-"..k
					local max = GetPedHeadOverlayNum(v.index)

					components[k] = {
						type = "slider-item",
						name = v.name,
						input = true,
						minIcon = "chevron_left",
						maxIcon = "chevron_right",
						style = "min-width: 100%",
						slider = {
							model = model,
							default = 1,
							min = 1,
							max = max + 1,
							step = 1,
							snap = true,
						},
						secondary = {
							model = model.."_a",
							min = 0.0,
							max = 1.0,
							default = 0.0,
							step = 0.05,
							snap = true,
						}
					}

					controller:BindModel(model, "otherOverlays", k)
					controller:BindModel(model.."_a", "otherOverlays", k + #Overlays.Head.Other)
				end

				return {
					type = "div",
					class = "flex row",
					components = components,
				}
			end,
			randomize = function(controller)
				local bodyType = controller.map["bodyType"]
				local isMale = bodyType == "Masculine"

				return {
					GetRandomIntInRange(1, 25), -- Blemishes
					GetRandomIntInRange(1, 16), -- Ageing
					GetRandomIntInRange(1, 13), -- Complexion
					GetRandomIntInRange(1, 12), -- Sun Damage
					GetRandomIntInRange(1, 19), -- Moles/Freckles
					GetRandomIntInRange(1, 13), -- Body Blemishes

					math.pow(GetRandomFloatInRange(0.0, 1.0), 6.0), -- Blemishes
					math.pow(GetRandomFloatInRange(0.0, 0.5), 4.0), -- Ageing
					math.pow(GetRandomFloatInRange(0.0, 1.0), 6.0), -- Complexion
					math.pow(GetRandomFloatInRange(0.0, 1.0), 4.0), -- Sun Damage
					GetRandomFloatInRange(0.0, 1.0), -- Moles/Freckles
					GetRandomFloatInRange(0.0, 1.0), -- Chest Hair
					GetRandomFloatInRange(0.0, 1.0), -- Body Blemishes
				}
			end,
			update = function(controller, trigger, value, lastValue, isMenu, bind)
				local map = controller.map
				if not map then return end

				if isMenu and bind and trigger == "otherOverlays" then
					Editor:SetTarget("head")
				end

				local otherOverlays = map.otherOverlays
				if not otherOverlays then return end

				for k, v in ipairs(Overlays.Head.Other) do
					local value = otherOverlays[k] or 255
					local opacity = otherOverlays[k + #Overlays.Head.Other] or 0.0

					SetPedHeadOverlay(Ped, v.index, (value == 1 and 255) or value - 2, opacity + 0.0)
				end
			end,
		},
		{ -- Other Hair
			tab = "hair",
			model = "hairOverlays",
			watchers = { "model" },
			component = function(controller)
				local components = {}

				for k, v in ipairs(Overlays.Head.Hair) do
					local model = "hairOverlays-"..k
					local max = GetPedHeadOverlayNum(v.index)

					local slider = {
						type = "slider-item",
						name = v.name,
						input = true,
						minIcon = "chevron_left",
						maxIcon = "chevron_right",
						style = "min-width: 100%",
						slider = {
							model = model,
							default = 1,
							min = 1,
							max = max + 1,
							step = 1,
							snap = true,
						},
						secondary = {
							model = model.."_a",
							min = 0.0,
							max = 1.0,
							default = 0.0,
							step = 0.05,
							snap = true,
						}
					}

					local colors = {}
					for i = 1, GetNumHairColors() do
						local r, g, b = GetPedHairRgbColor(i - 1)
						colors[i] = { r = r, g = g, b = b }
					end

					local palette = {
						type = "div",
						class = "flex row text-caption q-mb-sm q-mt-sm",
						style = "width: 100%",
						template = ([[
							<div>
								<div class="flex row" style="background: rgba(0, 0, 0, 0.4); outline: 1px solid rgba(0, 0, 0, 0.6); width: 50vmin;">
									<div
										v-for="(color, key) in %s"
										:style="{
											background: `rgb(${color.r}, ${color.g}, ${color.b})`,
											width: '2.5vmin', height: '2.5vmin',
											border: $getModel('%s') == key ? '2px solid yellow' : 'none'
										}"
										@click="$setModel('%s', key)"
									>
										<q-tooltip>
											rgb({{color.r}}, {{color.g}}, {{color.b}})
										</q-tooltip>
									</div>
								</div>
							</div>
						]]):format(
							json.encode(colors):gsub("\"", "'"),
							model.."_c",
							model.."_c"
						),
					}

					components[k] = {
						style = "width: 100%; margin-bottom: 1vmin",
						class = "flex row",
						components = {
							slider,
							palette,
						}
					}

					local n = #Overlays.Head.Hair

					controller:BindModel(model, "hairOverlays", k)
					controller:BindModel(model.."_a", "hairOverlays", k + n)
					controller:BindModel(model.."_c", "hairOverlays", k + n * 2)
				end

				return {
					type = "div",
					class = "flex row",
					components = components,
				}
			end,
			randomize = function(controller)
				local bodyType = controller.map["bodyType"]
				local isMale = bodyType == "Masculine"
				local color = GetRandomIntInRange(1, 9)
				local masculine = { 2, 3, 4, 6, 7, 10, 11, 12, 13, 14, 15, 16, 18, 19, 20, 21, 22, 23, 24, 25, 26, 27, 28, 30, 31, 32, 33, 34, 35 }
				local feminine = { 2, 3, 4, 5, 6, 7, 8, 9, 10, 12, 13, 15, 16, 17, 18, 25, 30, 31, 32, 33, 34, 35 }

				return {
					isMale and GetRandomIntInRange(1, 29) or 1, -- Facial Hair
					isMale and masculine[GetRandomIntInRange(1, #masculine)] or feminine[GetRandomIntInRange(1, #feminine)], -- Eyebrows
					isMale and GetRandomIntInRange(1, 17) or 1, -- Chest Hair

					math.pow(GetRandomFloatInRange(0.0, 1.0), 0.5), -- Facial Hair
					math.pow(GetRandomFloatInRange(0.5, 1.0), 0.5), -- Eyebrows
					GetRandomFloatInRange(0.0, 1.0), -- Chest Hair

					color,
					color,
					color,
				}
			end,
			update = function(controller, trigger, value, lastValue, isMenu, bind)
				local map = controller.map
				if not map then return end

				if isMenu and bind and trigger == "hairOverlays" then
					local hair = bind.index and Overlays.Head.Hair[bind.index]
					Editor:SetTarget(hair and hair.target or "head")

					if hair and hair.onchange then
						hair.onchange()
					end
				end

				local hairOverlays = map.hairOverlays
				if not hairOverlays then return end

				local n = #Overlays.Head.Hair
				for k, v in ipairs(Overlays.Head.Hair) do
					local value = hairOverlays[k] or 255
					local opacity = hairOverlays[k + n] or 0.0
					local color = hairOverlays[k + n * 2] or 1

					SetPedHeadOverlay(Ped, v.index, (value == 1 and 255) or value - 2, opacity + 0.0)
					SetPedHeadOverlayColor(Ped, v.index, 1, color, 0)
				end
			end,
		},
		{ -- Tattoos
			tab = "tattoos",
			model = "overlays",
			watchers = { "model" },
			-- condition = function(controller)
				
			-- end,
			default = {},
			component = function(controller)
				local map = controller.map
				if not map then return end
				
				local overlayZones = {}
				local bodyType = map.bodyType == "Masculine" and "male" or "female"

				for collection, overlays in pairs(Overlays.Tattoos) do
					for k, overlay in ipairs(overlays) do
						local zone = Overlays.Zones[overlay.zone]
						local overlayId = overlay[bodyType]
						if zone and overlayId ~= 0 then
							local zoneGroup = overlayZones[zone.index]
							if not zoneGroup then
								zoneGroup = {
									name = zone.name,
									overlays = {},
								}
								overlayZones[zone.index] = zoneGroup
							end
							zoneGroup.overlays[#zoneGroup.overlays + 1] = {
								id = overlayId,
								name = overlay.name,
								collection = collection,
								target = zone.target,
							}
						end
					end
				end

				for k, v in pairs(overlayZones) do
					table.sort(v.overlays, function(a, b)
						return a.name < b.name
					end)
				end

				if controller.window then
					controller.window:SetModel("overlayZones", overlayZones)
				end

				return {
					template = [[
						<div>
							<q-badge class="q-ma-sm" :label="($getModel('overlays')?.length ?? 0) / 2 + '/16 tattoos'"></q-badge>
							<q-list dense>
								<q-expansion-item
									v-for="(zone, key) in $getModel('overlayZones')"
									:key="key"
									:label="zone.name"
									icon="menu"
									group="overlayExpansion"
									dense
								>
									<q-item
										v-for="overlay in zone.overlays"
										:key="overlay.name"
										:class="[ $getModel('overlays')?.includes(overlay.id) ? 'text-blue' : 'text-grey' ]"
										clickable
										dense
										@click="
											var overlays = $getModel('overlays') ?? [];
											var index = overlays.indexOf(overlay.id);
	
											if (index == -1 && overlays.length / 2 >= 16)
												return;

											if (index == -1)
												overlays.push(overlay.id, overlay.collection);
											else
												overlays.splice(index, 2);
	
											$setModel('overlays', overlays);
											$invoke('setTarget', overlay.target)
										"
									>
										{{overlay.name}}
									</q-item>
								</q-expansion-item>
							</q-list>
						</div>
					]],
				}
			end,
			update = function(controller, trigger, value, lastValue, isMenu, bind)
				local map = controller.map
				if not map or not map.overlays then return end

				ClearPedDecorations(Ped)

				for i = 1, #map.overlays / 2 do
					local overlayId = map.overlays[i * 2 - 1] or 0
					local collectionId = map.overlays[i * 2] or 0

					if overlayId ~= 0 and collectionId ~= 0 then
						AddPedDecorationFromHashes(Ped, collectionId, overlayId)
					end
				end
			end,
		},
	},
}

function MapIter()
	local index = 1
	local targets = { "features", "appearance" }
	local tIndex = 1
	
	return function()
		local target = targets[tIndex]
		local map = Map[target]
		
		if index > #map then
			tIndex = tIndex + 1
			index = 1

			if tIndex > #targets then
				return
			end

			target = targets[tIndex]
			map = Map[target]
		end

		index = index + 1

		return map, map[index - 1], target
	end
end