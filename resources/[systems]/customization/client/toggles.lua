Main.Toggles = {
	["gloves"] = {
		Sub = 1,
		Anims = {
			Off = { Dict = "nmt_3_rcm-10", Name = "cs_nigel_dual-10", Duration = 1200, Flag = 48 },
			On = { Dict = "nmt_3_rcm-10", Name = "cs_nigel_dual-10", Duration = 1200, Flag = 48 },
		},
		Delay = 800,
		Navigation = {
			text = "Gloves",
			icon = "visibility",
		},
		Components = {
			[3] = 15,
		},
	},
	["mask"] = {
		Sub = 2,
		Anims = {
			Off = { Dict = "missfbi4", Name = "takeoff_mask", Flag = 48 },
			On =  { Dict = "mp_masks@on_foot", Name = "put_on_mask", Flag = 48 },
		},
		Delay = 800,
		Navigation = {
			text = "Mask",
			icon = "visibility",
		},
		Components = {
			[1] = -1,
		},
	},
	["glasses"] = {
		Sub = 2,
		Anims = {
			Off = { Dict = "clothingspecs", Name = "take_off", Flag = 48, Duration = 1300 },
			On = { Dict = "clothingspecs", Name = "put_on", Flag = 48, Rate = 0.4 },
		},
		Delay = 1000,
		Navigation = {
			text = "Glasses",
			icon = "visibility",
		},
		Props = {
			[1] = -1,
		},
	},
	["hat"] = {
		Sub = 2,
		Anims = {
			Off = { Dict = "missfbi4", Name = "takeoff_mask", Flag = 48 },
			On =  { Dict = "mp_masks@on_foot", Name = "put_on_mask", Flag = 48 },
		},
		Delay = 1000,
		Navigation = {
			text = "Hat",
			icon = "visibility",
		},
		Props = {
			[0] = -1,
		},
	},
	["bag"] = {
		Sub = 3,
		Anims = {
			Off = { Dict = "anim@heists@money_grab@duffel", Name = "enter", Duration = 1200, Flag = 48 },
			On = { Dict = "anim@heists@money_grab@duffel", Name = "exit", Rate = 0.25, Duration = 1200, Flag = 48 },
		},
		Delay = 1000,
		Navigation = {
			text = "Bag",
			icon = "visibility",
		},
		Components = {
			[5] = -1,
		},
	},
	["shirt"] = {
		Sub = 1,
		Anims = {
			Off = { Dict = "clothingtie", Name = "try_tie_negative_a", Flag = 48, Duration = 2400 },
			On = { Dict = "clothingtie", Name = "try_tie_negative_a", Flag = 48, Duration = 2400 },
		},
		Delay = 1000,
		Navigation = {
			text = "Shirt",
			icon = "visibility",
		},
		Components = {
			[3] = 15, -- Torso
			[8] = 15, -- Undershirt
			[10] = -1, -- Badge
			[11] = 15, -- Jacket
		},
	},
	["vest"] = {
		Sub = 1,
		Anims = {
			Off = { Dict = "clothingtie", Name = "try_tie_negative_a", Flag = 48, Duration = 2400 },
			On = { Dict = "clothingtie", Name = "try_tie_negative_a", Flag = 48, Duration = 2400 },
		},
		Delay = 1000,
		Navigation = {
			text = "Vest",
			icon = "visibility",
		},
		Components = {
			[9] = -1,
		},
	},
	["pants"] = {
		Sub = 1,
		Anims = {
			Off = { Dict = "mp_safehouseshower@male@", Name = "male_shower_undress_&_turn_on_water", Rate = 0.34, Duration = 1300, BlendOut = 0.6, Flag = 0 },
			On = { Dict = "mp_safehouseshower@male@", Name = "male_shower_undress_&_turn_on_water", Rate = 0.34, Duration = 1300, BlendOut = 0.6, Flag = 0 },
		},
		Delay = 1000,
		Navigation = {
			text = "Pants",
			icon = "visibility",
		},
		Components = {
			[4] = { 15, 145 },
		},
	},
	["shoes"] = {
		Sub = 1,
		Anims = {
			Off = { Dict = "clothingshoes", Name = "try_shoes_positive_d", Rate = 0.1, Duration = 1800, BlendOut = 0.6, Flag = 0 },
			On = { Dict = "clothingshoes", Name = "try_shoes_positive_d", Rate = 0.1, Duration = 1800, BlendOut = 0.6, Flag = 0 },
		},
		Delay = 1000,
		Navigation = {
			text = "Shoes",
			icon = "visibility",
		},
		Components = {
			[6] = { 119, 118 },
		},
	},
	["lwrist"] = {
		Sub = 3,
		Anims = {
			Off = { Dict = "nmt_3_rcm-10", Name = "cs_nigel_dual-10", Duration = 1200, Flag = 48 },
			On = { Dict = "nmt_3_rcm-10", Name = "cs_nigel_dual-10", Duration = 1200, Flag = 48 },
		},
		Delay = 800,
		Navigation = {
			text = "Left Wrist",
			icon = "visibility",
		},
		Props = {
			[6] = -1,
		},
	},
	["rwrist"] = {
		Sub = 3,
		Anims = {
			Off = { Dict = "nmt_3_rcm-10", Name = "cs_nigel_dual-10", Duration = 1200, Flag = 48 },
			On = { Dict = "nmt_3_rcm-10", Name = "cs_nigel_dual-10", Duration = 1200, Flag = 48 },
		},
		Delay = 800,
		Navigation = {
			text = "Right Wrist",
			icon = "visibility",
		},
		Props = {
			[7] = -1,
		},
	},
	["accessory"] = {
		Sub = 3,
		Anims = {
			Off = { Dict = "clothingtie", Name = "try_tie_negative_a", Flag = 48, Duration = 2400 },
			On = { Dict = "clothingtie", Name = "try_tie_negative_a", Flag = 48, Duration = 2400 },
		},
		Delay = 1000,
		Navigation = {
			text = "Accessory",
			icon = "visibility",
		},
		Components = {
			[7] = -1,
		},
	},
}

Main.Toggled = {
	Components = {},
	Props = {},
}

--[[ Functions ]]--
function Main:ToggleOption(toggle)
	local ped = PlayerPedId()
	local model = GetEntityModel(ped)
	local isMale = model == `mp_m_freemode_01`
	
	-- Toggle state.
	local active = not toggle.active
	toggle.active = active

	-- Do animation.
	if toggle.Anims then
		local anim = toggle.Anims[active and "Off" or "On"]
		local flag = anim.Flag

		if IsPedInAnyVehicle(ped) then
			anim.Flag = 48
		end

		exports.emotes:Play(anim)

		anim.Flag = flag
	end

	if toggle.Delay then
		Citizen.Wait(toggle.Delay)
	end

	local function update(name, setter, drawableGetter, textureGetter, ...)
		for componentId, variation in pairs(toggle[name]) do
			if type(variation) == "table" then
				variation = variation[isMale and 2 or 1] or {}
			end

			local drawableId, textureId
			local toggleCache = self.Toggled[name]

			if active then
				toggleCache[componentId] = { drawableGetter(ped, componentId), textureGetter(ped, componentId) }

				drawableId, textureId = variation, 0
			else
				drawableId, textureId = table.unpack(toggleCache[componentId])
			end
			
			if drawableId then
				if drawableId == -1 and name == "Props" then
					ClearPedProp(ped, componentId)
				else
					setter(ped, componentId, drawableId, textureId or 0, ...)
				end
			end
		end
	end
	
	if toggle.Components then
		update("Components", SetPedComponentVariation, GetPedDrawableVariation, GetPedTextureVariation, 0)
	end

	if toggle.Props then
		update("Props", SetPedPropIndex, GetPedPropIndex, GetPedPropTextureIndex, not active)
	end
end

function Main:AddToggleOptions()
	local sub = {
		{
			id = "customization-1",
			text = "Clothes",
			icon = "sell",
			sub = {},
		},
		{
			id = "customization-2",
			text = "Head",
			icon = "face",
			sub = {},
		},
		{
			id = "customization-3",
			text = "Accessories",
			icon = "earbuds",
			sub = {},
		},
	}

	for id, toggle in pairs(self.Toggles) do
		local _sub = sub[toggle.Sub or 1].sub
		local option = toggle.Navigation
		option.id = "customization-"..id
		_sub[#_sub + 1] = option

		AddEventHandler("interact:onNavigate_"..option.id, function()
			self:ToggleOption(toggle)
		end)

		exports.chat:RegisterCommand(id, function()
			self:ToggleOption(toggle)
		end, {
			description = "Toggle your "..(toggle.Navigation.text or id).."."
		})
	end

	exports.interact:AddOption({
		id = "customization",
		text = "Dressing",
		icon = "sports_kabaddi",
		sub = sub
	})
end

function Main:ResetToggles()
	for k, v in pairs(self.Toggled) do
		self.Toggled[k] = {}
	end
	for id, toggle in pairs(self.Toggles) do
		toggle.active = nil
	end
end

--[[ Commands ]]--
AddEventHandler("customization:clientStart", function()
	Main:AddToggleOptions()
end)