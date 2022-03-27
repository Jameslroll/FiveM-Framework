Main = {
	peds = {},
}

function Main:SetData(ped, data)
	local controller = Controller:Create()

	if not data then
		data = ped
	elseif ped and ped ~= PlayerPedId() then
		controller.ped = ped
	end

	controller:SetData(controller:ConvertData(data))
end
exports("SetData", function(...) Main:SetData(...) end)

function Main:CreatePed(data, coords)
	local resource = GetInvokingResource()
	local appearance = data.appearance
	local features = data.features

	if (not appearance or not features) and not data.model then
		return
	end

	local model = GetHashKey(
		(type(data.model) == "string" and data.model)
		or ((Models[(BodyTypes.Index[features.bodyType or false] or false)] or {})[features.model] or {}).name
		or 0
	)
	
	if not model or not IsModelValid(model) then return end

	while not HasModelLoaded(model) do
		RequestModel(model)
		Citizen.Wait(0)
	end
	
	local ped = CreatePed(2, model, coords.x, coords.y, coords.z, coords.w, false, true)

	self:SetData(ped, data)

	if resource then
		self.peds[ped] = resource
	end

	return ped
end
exports("CreatePed", function(...) return Main:CreatePed(...) end)

--[[ Events ]]--
RegisterNetEvent("customization:saved", function(retval, result)
	local window = Editor.window
	if window then
		window:SetModel("saving", false)
	end

	if retval then
		Editor:Toggle(false)
	else
		UI:Notify({
			color = "red",
			message = result or "Error"
		})
	end
end)

AddEventHandler("character:selected", function(character)
	if not character then return end

	if character.appearance or character.features then
		Main:SetData({
			appearance = character.appearance,
			features = character.features,
		})
	else
		Editor:Toggle(true)
	end
end)

AddEventHandler("onResourceStop", function(resourceName)
	for ped, resource in pairs(Main.peds) do
		if resource == resourceName then
			DeleteEntity(ped)
			Main.peds[ped] = nil
		end
	end
end)

--[[ Threads ]]--
Citizen.CreateThread(function()
	while true do
		for ped, resource in pairs(Main.peds) do
			if not DoesEntityExist(ped) then
				Main.peds[ped] = nil
			end
		end
		Citizen.Wait(2000)
	end
end)

-- local c = GetEntityCoords(PlayerPedId()) + vector3(GetRandomFloatInRange(-2.0, 2.0), GetRandomFloatInRange(-2.0, 2.0), 0.0)
-- local ped = CreatePed(2, GetEntityModel(PlayerPedId()), c.x, c.y, c.z, 0, true, true)

-- Main:SetData(ped, {
-- 	appearance = character.appearance,
-- 	features = character.features,
-- })