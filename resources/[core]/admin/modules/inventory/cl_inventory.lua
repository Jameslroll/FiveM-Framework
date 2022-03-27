local window

Admin:AddHook("select", "viewContainers", function()
	Navigation:Close()
	TriggerServerEvent(Admin.event.."requestContainers")
end)

Admin:AddHook("select", "viewItems", function()
	Navigation:Close()

	if window then
		window:Destroy()
	end

	local data = {}
	local items = exports.inventory:GetItems()

	for id, item in pairs(items) do
		local icon = item.name:gsub("%s+", "")
		
		data[#data + 1] = {
			id = item.id,
			name = item.name,
			weight = item.weight,
			stack = item.stack,
			category = item.category,
			nested = item.nested,
			model = item.model,
			icon = "nui://inventory/icons/"..icon..".png",
		}
	end

	table.sort(data, function(a, b)
		return (a.name or "") > (b.name or "")
	end)

	window = Window:Create({
		type = "window",
		title = "Containers",
		class = "compact",
		style = {
			["width"] = "100vmin",
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
			},
		},
		defaults = {
			filter = "",
			spawning = false,
			data = data,
			columns = {
				{
					name = "id",
					label = "ID",
					field = "id",
					align = "left",
					sortable = true,
				},
				{
					name = "icon",
					label = "Icon",
					field = "icon",
					align = "left",
					sortable = false,
				},
				{
					name = "name",
					label = "Name",
					field = "name",
					align = "left",
					sortable = true,
				},
				{
					name = "category",
					label = "Category",
					field = "category",
					align = "left",
					sortable = true,
				},
				{
					name = "weight",
					label = "Weight",
					field = "weight",
					align = "left",
					sortable = true,
				},
				{
					name = "stack",
					label = "Stack",
					field = "stack",
					align = "left",
					sortable = true,
				},
				{
					name = "model",
					label = "Model",
					field = "model",
					align = "left",
					sortable = true,
				},
				{
					name = "nested",
					label = "Nested",
					field = "nested",
					align = "left",
					sortable = true,
				},
			},
		},
		components = {
			{
				type = "div",
				template = [[
					<q-table
						style="overflow: hidden; max-height: 90vh"
						@row-click="(evt, row, index) => $invoke('spawn', row)"
						:columns="$getModel('columns')"
						:data="$getModel('data')"
						:rows-per-page-options="[0]"
						:filter="$getModel('filter')"
						row-key="id"
						dense
						virtual-scroll
					>
						<template v-slot:top-right>
							<q-toggle
								label="Spawning"
								:value="$getModel('spawning')"
								@input="$setModel('spawning', $event)"
								class="q-mr-sm"
							/>
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
						</template>
						<template v-slot:body-cell-icon="props">
							<q-td :props="props">
								<div style="width: 3vmin; height: 3vmin; display: flex; justify-content: center; align-items: center">
									<img
										:src="props.row.icon"
										style="max-width: 100%; max-height: 100%; object-fit: contain"
										width="auto"
										height="auto"
									/>
								</div>
							</q-td>
						</template>
					</q-table>
				]]
			},
		},
	})

	window:OnClick("close", function(self)
		self:Destroy()

		UI:Focus(false)
	end)

	window:AddListener("spawn", function(self, row)
		if not self.models["spawning"] then return end
		ExecuteCommand(("a:giveitem \"%s\""):format(row.name))
	end)

	UI:Focus(true)
end)

RegisterNetEvent(Admin.event.."receiveContainers", function(data)
	if window then
		window:Destroy()
	end

	window = Window:Create({
		type = "window",
		title = "Containers",
		class = "compact",
		style = {
			["width"] = "50vmin",
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
				clicks = {
					["row-click"] = {
						callback = "this.$invoke('openContainer', arguments[0]?.id)",
					},
				},
				binds = {
					rowKey = "id",
					dense = true,
					wrapCells = true,
					data = data,
					rowsPerPageOptions = { 20 },
					columns = {
						{
							name = "id",
							label = "ID",
							field = "id",
							align = "left",
							sortable = true,
						},
						{
							name = "type",
							label = "Type",
							field = "type",
							align = "left",
							sortable = true,
						},
						{
							name = "protected",
							label = "Protected",
							field = "protected",
							align = "left",
							sortable = true,
						},
						{
							name = "owner",
							label = "Owner",
							field = "owner",
							align = "left",
							sortable = true,
						},
					},
				},
			}
		}
	})

	window:OnClick("close", function(self)
		self:Destroy()

		UI:Focus(false)
	end)

	window:AddListener("openContainer", function(self, id)
		TriggerServerEvent(Admin.event.."viewContainer", id)
	end)

	UI:Focus(true, true)
end)