local window
local user

--[[ Functions ]]--
local function GetFlagToggles(flags)
	local toggles = {}
	local flagEnums = exports.user:GetFlags()

	for enum, flag in pairs(flagEnums) do
		local mask = 1 << flag
		toggles[#toggles + 1] = {
			label = enum.." ("..flag..")",
			value = (flags or 0) & mask ~= 0,
			flag = flag,
			disabled = flag == flagEnums["IS_OWNER"] or (flag == flagEnums["IS_ADMIN"] and not exports.user:IsOwner()),
		}
	end

	table.sort(toggles, function(a, b)
		return a.flag < b.flag
	end)

	return toggles
end

--[[ Hooks ]]--
Admin:AddHook("select", "lookupUser", function()
	Citizen.Wait(100)

	UI:Dialog({
		title = "Lookup User",
		message = "Enter a User ID (number) or identifier (key:value).",
		prompt = {
			model = "",
			type = "text",
		},
		cancel = true,
	}, function(...)
		TriggerServerEvent(Admin.event.."lookupUser", ...)
	end)
end)

--[[ Events ]]--
RegisterNetEvent(Admin.event.."receiveUser", function(user, characters, warnings)
	-- Conert user fields.
	local fields = {}
	for key, value in pairs(user) do
		local copy = nil
		if key == "discord" then
			copy = ("<@%s>"):format(value)
		elseif key == "steam" or key == "license" or key == "license2" then
			copy = key..":"..value
		end

		fields[#fields + 1] = {
			key = key,
			value = value,
			copy = copy,
		}
	end

	table.sort(fields, function(a, b)
		return (a.key or "") > (b.key or "")
	end)

	-- Convert characters.
	for k, character in ipairs(characters) do
		character.name = ("%s %s"):format(character.first_name, character.last_name)
		character.time_played = math.floor(character.time_played / 3600.0).." hours"
		character.deleted = character.deleted == 1 and "Yes" or "No"
	end

	-- Create window.
	window = Window:Create({
		type = "window",
		title = "User",
		class = "compact",
		defaults = {
			tab = "info",
			flags = GetFlagToggles(user.flags),
		},
		style = {
			["width"] = "80vmin",
			["top"] = "50%",
			["left"] = "5vmin",
			["max-height"] = "80vh",
			["transform"] = "translate(0%, -50%)",
		},
		prepend = {
			type = "q-icon",
			name = "cancel",
			binds = {
				color = "red",
			},
			click = {
				event = "close",
			},
		},
		components = {
			{
				type = "q-card",
				template = [[
					<q-tabs
						:value="$getModel('tab')"
						@input="$setModel('tab', $event)"
					>
						<q-tab name="info" label="Info" />
						<q-tab name="characters" label="Characters" />
						<q-tab name="warnings" label="Warnings" />
					</q-tabs>
				]]
			},
			{
				type = "div",
				condition = "this.$getModel('tab') == 'info'",
				template = [[
					<q-card class="q-pa-sm">
						<q-checkbox
							v-for="(option, key) in $getModel('flags')"
							:key="key"
							:label="option.label"
							:value="option.value"
							:disable="option.disabled"
							@input="$invoke('setFlag', option.flag, $event)"
						/>
					</q-card>
				]]
			},
			{
				type = "q-table",
				condition = "this.$getModel('tab') == 'info'",
				binds = {
					rowKey = "key",
					data = fields,
					dense = true,
					rowsPerPageOptions = { -1 },
					wrapCells = true,
					columns = {
						{ name = "key", field = "key", label = "Key", align = "left" },
						{ name = "value", field = "value", label = "Value", align = "right" },
					},
				},
				clicks = {
					["row-click"] = {
						callback = "this.$copyToClipboard(arguments[0]?.copy ?? arguments[0]?.value)",
					},
				},
			},
			{
				type = "q-table",
				condition = "this.$getModel('tab') == 'characters'",
				binds = {
					rowKey = "id",
					data = characters,
					dense = true,
					rowsPerPageOptions = { 5 },
					wrapCells = true,
					columns = {
						{ name = "id", field = "id", label = "ID", align = "left", sortable = true },
						{ name = "name", field = "name", label = "Name", align = "left", sortable = true },
						{ name = "dob", field = "dob", label = "DOB", align = "left", sortable = true },
						{ name = "bank", field = "bank", label = "Bank", align = "left", sortable = true },
						{ name = "paycheck", field = "paycheck", label = "Paycheck", align = "left", sortable = true },
						{ name = "time_played", field = "time_played", label = "Time Played", align = "left", sortable = true },
						{ name = "deleted", field = "deleted", label = "Dead", align = "left", sortable = true },
					},
				},
			},
			{
				type = "q-table",
				condition = "this.$getModel('tab') == 'warnings'",
				binds = {
					rowKey = "id",
					data = warnings,
					dense = true,
					rowsPerPageOptions = { 5 },
					wrapCells = true,
					columns = {
						{ name = "id", field = "key", label = "Key", align = "left", sortable = true },
						{ name = "points", field = "points", label = "Points", align = "left", sortable = true },
						{ name = "info", field = "info", label = "Info", align = "left" },
					},
				},
			},
		}
	})

	window:OnClick("close", function(self)
		self:Destroy()
		UI:Focus(false)

		TriggerServerEvent(Admin.event.."unsubscribeUser")
	end)

	window:AddListener("setFlag", function(self, flag, value)
		TriggerServerEvent(Admin.event.."setFlag", flag, value)
	end)

	UI:Focus(true)
end)

RegisterNetEvent(Admin.event.."updateFlags", function(flags)
	if not window then return end

	window:SetModel("flags", GetFlagToggles(flags))
end)