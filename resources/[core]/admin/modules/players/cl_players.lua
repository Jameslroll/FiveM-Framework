Players = {}

--[[ Functions ]]--
function Players:OpenMenu(data)
	local window = Window:Create({
		type = "Window",
		title = "Players",
		class = "compact",
		style = {
			["width"] = "50vmin",
			["height"] = "auto",
			["right"] = "5vmin",
			["top"] = "50%",
			["transform"] = "translate(0%, -50%)",
		},
		prepend = {
			type = "q-icon",
			name = "cancel",
			binds = {
				color = "red",
			},
			click = {
				event = "close"
			},
		},
		defaults = {
			data = data,
			columns = {
				{
					name = "serverId",
					field = "serverId",
					label = "Server ID",
					align = "left",
					sortable = true,
					style = "width: 15%",
				},
				{
					name = "userId",
					field = "userId",
					label = "User ID",
					align = "left",
					sortable = true,
					style = "width: 15%",
				},
				{
					name = "characterName",
					field = "characterName",
					label = "Character Name",
					align = "left",
					sortable = true,
					style = "width: 35%",
				},
				{
					name = "steamName",
					field = "steamName",
					label = "Steam Name",
					align = "left",
					sortable = true,
					style = "width: 35%",
				},
			}
		},
		components = {
			{
				template = [[
					<q-input
						filled
						dense
						placeholder="Search"
						:value="$getModel('filter')"
						@input="$setModel('filter', $event)"
					>
						<template v-slot:append>
							<q-icon name="search" />
						</template>
					</q-input>
				]]
			},
			{
				type = "div",
				style = {
					["display"] = "flex",
					["flex-direction"] = "column",
					["height"] = "100%",
				},
				template = [[
					<q-table
						dense
						@row-click="(evt, row, index) => $invoke('viewPlayer', row.userId)"
						@row-contextmenu="(evt, row, index) => $invoke('spectatePlayer', row.serverId)"
						:data="$getModel('data')"
						:columns="$getModel('columns')"
						:rows-per-page-options="[30]"
						:filter="$getModel('filter')"
					></q-table>
				]],
			},
		},
	})

	window:OnClick("close", function(self)
		self:Destroy()

		TriggerServerEvent(Admin.event.."requestPlayers", false)

		UI:Focus(false)
	end)

	window:AddListener("viewPlayer", function(self, id)
		TriggerServerEvent(Admin.event.."lookupUser", id)
	end)

	window:AddListener("spectatePlayer", function(self, id)
		ExecuteCommand("a:spectate "..id)
	end)

	UI:Focus(true, true)

	self.window = window
end

--[[ Events ]]--
RegisterNetEvent(Admin.event.."receivePlayers", function(data)
	Navigation:Close()
	Players:OpenMenu(data)
end)

--[[ Hooks ]]--
Admin:AddHook("select", "viewPlayers", function(option)
	TriggerServerEvent(Admin.event.."requestPlayers", true)
end)