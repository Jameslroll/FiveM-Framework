function Main:ViewHistory(serverId, data)
	for k, v in ipairs(data) do
		local bone = Config.Bones[v.bone or false]

		v.bone = bone.Label or bone.Name or "?"
		v.amount = ("%.2f"):format(v.amount * 100.0).."%"
		v.time = ("%ss"):format(math.floor((GetNetworkTime() - v.time) / 1000.0))
	end

	local window = Window:Create({
		type = "Window",
		title = ("Damage [%s]"):format(serverId),
		class = "compact",
		style = {
			["width"] = "30vmin",
			["height"] = "auto",
			["top"] = "50%",
			["right"] = "5vmin",
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
			}
		},
		defaults = {
			data = data,
			columns = {
				{
					field = "bone",
					label = "Bone",
					align = "left",
				},
				{
					field = "name",
					label = "Name",
					align = "left",
				},
				{
					field = "amount",
					label = "Amount",
					align = "right",
				},
				{
					field = "time",
					label = "Time",
					align = "right",
				},
			}
		},
		components = {
			{
				type = "div",
				style = {
					["display"] = "flex",
					["flex-direction"] = "column",
					["height"] = "100%",
				},
				template = [[
					<q-table
						:data="$getModel('data')"
						:columns="$getModel('columns')"
						:rows-per-page-options="[30]"
						dense
					></q-table>
				]],
			},
		},
	})

	window:OnClick("close", function(self)
		UI:Focus(false)
		self:Destroy()
		Main.historyWindow = nil
	end)

	self.historyWindow = window
	
	UI:Focus(true)
end

--[[ Commands ]]--
RegisterNetEvent("health:checkHistory", function(...)
	Main:ViewHistory(...)
end)