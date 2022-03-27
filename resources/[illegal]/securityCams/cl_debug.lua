if not Config.Debug then return end

--[[ Functions ]]--
function DebugObject(object)
	for k, v in pairs(object) do
		if type(v) == "table" then
			print(k, v)
			-- DebugObject(v)
		else
			print(k, v)
		end
	end
end

--[[ Threads ]]--
Citizen.CreateThread(function()
	local test = {}
	while true do
		local objects = exports.oldutils:GetObjects()
		for k, entity in ipairs(objects) do
			if not Main:IsObjectACamera(entity) then goto skip end
			
			local camera = test[entity] or Camera:CreateFromObject(entity)
			test[entity] = camera

			local coords = camera.coords
			local rotation = camera.rotation + vector3(0.0, 0.0, 90.0)
			local target = coords + exports.misc:FromRotation(rotation)
			
			DrawLine(coords.x, coords.y, coords.z, target.x, target.y, target.z, 0, 255, 0, 255)

			local targets = {}
			local min, max = camera.settings.Min or vector3(-90.0, 0.0, -180.0), camera.settings.Max or vector3(90.0, 0.0, 180.0)
			
			if min then
				table.insert(targets, coords + exports.misc:FromRotation(rotation + vector3(min.x, 0.0,0.0)))
				table.insert(targets, coords + exports.misc:FromRotation(rotation + vector3(0.0, 0.0, min.z)))
			end
			
			if max then
				table.insert(targets, coords + exports.misc:FromRotation(rotation + vector3(max.x, 0.0, 0.0)))
				table.insert(targets, coords + exports.misc:FromRotation(rotation + vector3(0.0, 0.0, max.z)))
			end

			for _k, target in ipairs(targets) do
				DrawLine(coords.x, coords.y, coords.z, target.x, target.y, target.z, 255, 0, 0, 255)
			end

			::skip::
		end
		Citizen.Wait(0)
	end
end)

--[[ Commands ]]--
RegisterCommand("createCams", function(source, args, command)
	local ped = PlayerPedId()
	local coords = GetEntityCoords(ped)
	local forward = GetEntityForwardVector(ped)
	local i = 1

	for model, settings in pairs(Config.Cameras) do
		local hash = GetHashKey(model)
		while IsModelValid(hash) and not HasModelLoaded(hash) do
			RequestModel(hash)
			Citizen.Wait(0)
		end

		local coords = coords + forward * i * 3.0 + vector3(0.0, 0.0, 1.5)
		local entity = CreateObject(hash, coords, false, true, false)
		SetEntityCoords(entity, coords)

		exports.interact:AddText({
			id = "debugCamera-"..model,
			entity = entity,
			text = model,
			offset = vector3(0.0, 0.0, -1.5)
		})
		
		i = i + 1
	end
end)

RegisterCommand("debugCams", function()
	for k, v in pairs(Main.sites) do
		print("site", k, v)
	end

	print("current site", Main.site)
end)