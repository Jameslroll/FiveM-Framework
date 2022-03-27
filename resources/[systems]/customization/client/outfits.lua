Outfits = {
	navigation = {
		{
			id = "saveOutfit",
			text = "Save Outfit",
			icon = "file_download",
		},
		{
			id = "loadOutfit",
			text = "Load Outfit",
			icon = "file_upload",
		},
		{
			id = "deleteOutfit",
			text = "Delete Outfit",
			icon = "delete",
		}
	}
}

--[[ Functions: Outfits ]]--
function Outfits:SetWindow(data)
	if data then
		for k, v in ipairs(data) do
			if type(v.age) == "number" then
				local minutes = v.age / 60
				local hours = minutes / 60
				local days = hours / 24
				local months = days / 30
				
				v.age =
					months > 1.0 and math.floor(months).." months ago" or
					days > 1.0 and math.floor(days).." days ago" or
					hours > 1.0 and math.floor(hours).." hours ago" or
					minutes > 1.0 and math.floor(minutes).." minutes ago" or
					"Just now"
			end
		end
	else
		TriggerServerEvent("customization:requestOutfits")
	end

	local isDelete = self.type == "delete"
	local component = {
		type = "window",
		title = (isDelete and "Delete" or "Select").." Outfit",
		class = "compact",
		style = {
			["width"] = "40vmin",
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
				event = "close",
			},
		},
		components = {
			{
				type = "q-table",
				binds = {
					rowKey = "name",
					data = data,
					dense = true,
					rowsPerPageOptions = { 20 },
					noDataLabel = "No outfits",
					tableClass = isDelete and "bg-red-10",
					columns = {
						{ name = "name", field = "name", label = "Name", align = "left", sortable = true },
						{ name = "age", field = "age", label = "Age", align = "left", sortable = true },
					},
				},
				clicks = {
					["row-click"] = {
						callback = [[
							this.$setModel('waiting', true);
							this.$invoke('selectOutfit', arguments[0]?.name);
						]],
					},
				},
			},
			{
				template = [[<q-inner-loading :showing="$getModel('waiting')" />]]
			},
		}
	}

	local window = self.window

	if window then
		self.window:Update(component)
	else
		window = Window:Create(component)
		self.window = window

		window:OnClick("close", function(self)
			self:Destroy()
			UI:Focus(false)
			Outfits.window = nil
		end)

		window:AddListener("selectOutfit", function(self, name)
			TriggerServerEvent(isDelete and"customization:deleteOutfit" or "customization:selectOutfit", name)
		end)
	
		UI:Focus(true)
	end

	self.data = data
	window:SetModel("waiting", data == nil)
end

--[[ Events ]]--
AddEventHandler("interact:onNavigate_saveOutfit", function()
	UI:Dialog({
		title = "Save Outfit",
		message = "What is your outfit's name?",
		prompt = {
			model = "",
			type = "text",
		},
		cancel = true,
	}, function(name)
		TriggerServerEvent("customization:saveOutfit", name)
	end)
end)

AddEventHandler("interact:onNavigate_loadOutfit", function()
	Outfits.type = "load"
	Outfits:SetWindow()
end)

AddEventHandler("interact:onNavigate_deleteOutfit", function()
	Outfits.type = "delete"
	Outfits:SetWindow()
end)

--[[ Events: Net ]]--
RegisterNetEvent("customization:receiveOutfits", function(data)
	Outfits:SetWindow(data)
end)

RegisterNetEvent("customization:switchOutfit", function(name, retval, result)
	if Outfits.window then
		Outfits.window:SetModel("waiting", false)
	end
	
	UI:Notify({
		color = retval and "green" or "red",
		message = retval and ("Selected outfit '%s'"):format(name) or result or "Error"
	})
end)

RegisterNetEvent("customization:deletedOutfit", function(name, retval, result)
	if Outfits.window then
		Outfits.window:SetModel("waiting", false)

		if retval then
			local data = Outfits.data
			for k, v in ipairs(data) do
				if v.name == name then
					table.remove(data, k)
					break
				end
			end

			Outfits:SetWindow(data)
		end
	end
	
	UI:Notify({
		color = retval and "orange" or "red",
		message = retval and ("Deleted outfit '%s'"):format(name) or result or "Error"
	})
end)

RegisterNetEvent("character:update", function(args)
	local appearance = args.appearance
	if not appearance then return end

	local features = exports.character:Get("features")
	local data = {
		features = features,
		appearance = appearance,
	}

	local controller = Controller:Create()
	controller:SetData(controller:ConvertData(data))
end)