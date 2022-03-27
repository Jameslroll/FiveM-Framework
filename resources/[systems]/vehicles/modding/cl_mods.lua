Mods = {
	types = {
		[0] = { Name = "Spoiler" }, -- VMT_SPOILER
		[1] = { Name = "Front Bumper" }, -- VMT_BUMPER_F
		[2] = { Name = "Rear Bumper" }, -- VMT_BUMPER_R
		[3] = { Name = "Side Skirt" }, -- VMT_SKIRT
		[4] = { Name = "Exhaust" }, -- VMT_EXHAUST
		[5] = { Name = "Chassis" }, -- VMT_CHASSIS
		[6] = { Name = "Grill" }, -- VMT_GRILL
		[7] = { Name = "Hood" }, -- VMT_BONNET
		[8] = { Name = "Fender" }, -- VMT_WING_L
		[9] = { Name = "Fender 2" }, -- VMT_WING_R
		[10] = { Name = "Roof" }, -- VMT_ROOF
		[11] = { Name = "Engine", Hidden = true }, -- VMT_ENGINE
		[12] = { Name = "Brakes", Hidden = true }, -- VMT_BRAKES
		[13] = { Name = "Transmission", Hidden = true }, -- VMT_GEARBOX
		[14] = { Name = "Horn", OnChange = function(vehicle, value)
			Citizen.CreateThread(function()
				Mods.horn = value
				
				Citizen.Wait(20)
				
				local startTime = GetGameTimer()
				while GetGameTimer() - startTime < 1200 and Mods.horn == value do
					SoundVehicleHornThisFrame(vehicle)
					Citizen.Wait(0)
				end
			end)
		end }, -- VMT_HORN
		[15] = { Name = "Suspension" }, -- VMT_SUSPENSION
		[16] = { Name = "Armor", Hidden = true }, -- VMT_ARMOUR
		[17] = { Name = "Nitrous", Hidden = true }, -- VMT_NITROUS
		[18] = { Name = "Turbo", Hidden = true }, -- VMT_TURBO
		[19] = { Name = "Subwoofer" }, -- VMT_SUBWOOFER
		[20] = { Name = "Tire Smoke" }, -- VMT_TYRE_SMOKE
		[21] = { Name = "Hydraulics" }, -- VMT_HYDRAULICS
		[22] = { Name = "Xenon Lights" }, -- VMT_XENON_LIGHTS
		[23] = { Name = "Wheels" }, -- VMT_WHEELS
		[24] = { Name = "Wheels 2" }, -- VMT_WHEELS_REAR_OR_HYDRAULICS
		[25] = { Name = "Plate Holder" }, -- VMT_PLTHOLDER
		[26] = { Name = "Plate Vanity" }, -- VMT_PLTVANITY
		[27] = { Name = "Interior" }, -- VMT_INTERIOR1
		[28] = { Name = "Ornaments" }, -- VMT_INTERIOR2
		[29] = { Name = "Dashboard" }, -- VMT_INTERIOR3
		[30] = { Name = "Dial" }, -- VMT_INTERIOR4
		[31] = { Name = "Door Speaker" }, -- VMT_INTERIOR5
		[32] = { Name = "Seats" }, -- VMT_SEATS
		[33] = { Name = "Steering Wheel" }, -- VMT_STEERING
		[34] = { Name = "Shifter Leavers" }, -- VMT_KNOB
		[35] = { Name = "Plaques" }, -- VMT_PLAQUE
		[36] = { Name = "Speakers" }, -- VMT_ICE
		[37] = { Name = "Trunk" }, -- VMT_TRUNK
		[38] = { Name = "Hydraulics" }, -- VMT_HYDRO
		[39] = { Name = "Engine Block" }, -- VMT_ENGINEBAY1
		[40] = { Name = "Air Filter" }, -- VMT_ENGINEBAY2
		[41] = { Name = "Struts" }, -- VMT_ENGINEBAY3
		[42] = { Name = "Arch Cover" }, -- VMT_CHASSIS2
		[43] = { Name = "Aerials" }, -- VMT_CHASSIS3
		[44] = { Name = "Trim" }, -- VMT_CHASSIS4
		[45] = { Name = "Tank" }, -- VMT_CHASSIS5
		[46] = { Name = "Windows" }, -- VMT_DOOR_L
		[47] = { Name = "Windows 2" }, -- VMT_DOOR_R
		[48] = { Name = "Livery" }, -- VMT_LIVERY_MOD
		[49] = { Name = "Lightbar" }, -- VMT_LIGHTBAR
	},
}

--[[ Functions: Mods ]]--
function Mods:Enable(vehicle)
	local defaults = {
		mods = {},
	}

	self.defaults = {}
	
	WaitForAccess(vehicle)
	SetVehicleModKit(vehicle)

	for modType, mod in pairs(self.types) do
		local numMods = not mod.Hidden and GetNumVehicleMods(vehicle, modType)
		if mod.Name == "Livery" then
			print(numMods)
		end
		if numMods and numMods > 0 then
			local options = {}

			for modIndex = -1, numMods - 1 do
				local text = modIndex == -1 and "Stock" or GetLabelText(GetModTextLabel(vehicle, modType, modIndex))
				if text == "NULL" then
					text = mod.Name.." "..modIndex
				end

				options[modIndex + 2] = {
					label = text,
					value = modIndex,
				}
			end

			local currentModIndex = GetVehicleMod(vehicle, modType)

			self.defaults[modType] = currentModIndex

			defaults["mod-"..modType] = currentModIndex

			table.insert(defaults.mods, {
				name = mod.Name,
				index = modType,
				options = options,
			})
		end
	end

	local window = Window:Create({
		type = "window",
		title = "Mods",
		class = "compact",
		defaults = defaults,
		style = {
			["width"] = "40vmin",
			["height"] = "90vmin",
			["top"] = "8vmin",
			["left"] = "2vmin",
			["overflow"] = "visible !important",
		},
		prepend = Modding.prepend,
		components = {
			{
				type = "q-list",
				template = [[
					<div>
						<q-expansion-item
							v-for="mod in $getModel('mods')"
							:key="mod.index"
							:label="mod.name"
							group="mods"
							dense
							expand-separator
						>
							<q-option-group
								:options="mod.options"
								:value="$getModel('mod-' + mod.index)"
								@input="$invoke('setMod', mod.index, $event)"
							/>
						</q-expansion-item>
					</div>
				]],
			},
		},
	})

	-- Window buttons.
	window:OnClick("save", function(window)
		Modding:Exit()
	end)

	window:OnClick("discard", function(window)
		Modding:Exit(true)
	end)

	-- Window events.
	window:AddListener("setMod", function(window, modType, modIndex)
		local settings = Mods.types[modType]
		if not settings or settings.Hidden then return end

		WaitForAccess(vehicle)
		SetVehicleMod(vehicle, modType, modIndex)
		window:SetModel("mod-"..modType, modIndex)

		if settings.OnChange then
			settings.OnChange(vehicle, modIndex)
		end
	end)

	-- Return the window.
	return window
end

function Mods:Disable(vehicle, discard)
	if discard and self.defaults then
		
	end

	self.defaults = nil
end

--[[ Functions: Modding ]]--
Modding:RegisterItem("Mod Kit", Mods)

-- type = "window",
-- title = "Paint",
-- class = "compact",
-- style = {
-- 	["width"] = "40vmin",
-- 	["height"] = "50vmin",
-- 	["top"] = "8vmin",
-- 	["left"] = "2vmin",
-- 	["overflow"] = "visible !important",
-- },
-- defaults = {
-- 	mods = {
-- 		{ Name = "Test 1", index = 0, options = {
-- 			{ label = "Option 1", value = 0 },
-- 			{ label = "Option 2", value = 1 },
-- 			{ label = "Option 3", value = 2 },
-- 		} },	
-- 		{ Name = "Test 2", index = 1 },	
-- 		{ Name = "Test 3", index = 2 },	
-- 	},
-- },
-- components = {
-- 	{
-- 		type = "q-list",
-- 		template = [[
-- 			<div>
-- 				<q-expansion-item
-- 					v-for="mod in $getModel('mods')"
-- 					:key="mod.Index"
-- 					:label="mod.Name"
-- 					group="mods"
-- 				>
-- 					<q-option-group
-- 						:options="mod.options"
-- 					/>
-- 				</q-expansion-item>
-- 			</div>
-- 		]],
-- 	},
-- },