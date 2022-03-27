LabelCount = 0
Labels = {}
Threads = {}
Id = 0

CamCoords = nil
CamRotation = nil
CamForward = nil

--[[ Threads ]]--
Citizen.CreateThread(function()
	while true do
		CamCoords = GetFinalRenderedCamCoord()
		CamRotation = GetFinalRenderedCamRot(0)
		CamForward = FromRotation(CamRotation + vector3(0, 0, 90))

		if LabelCount > 0 then
			local fov = GetFinalRenderedCamFov()
			local target = CamCoords + CamForward

			SendNUIMessage({
				camera = {
					coords = CamCoords,
					fov = fov,
					target = target,
				}
			})
		end

		Citizen.Wait(0)
	end
end)

Citizen.CreateThread(function()
	while true do
		for id, data in pairs(Labels) do
			if data.entity then
				if DoesEntityExist(data.entity) then
					local coords = GetEntityCoords(data.entity)
					if data.bone then
						coords = data.entityType == 1 and GetPedBoneCoords(data.entity, data.bone) or GetWorldPositionOfEntityBone(data.entity, data.bone)
					end
					if data.offset then
						coords = GetOffsetFromEntityInWorldCoords(data.entity, GetOffsetFromEntityGivenWorldCoords(data.entity, coords) + data.offset)
					end
					SetCoords(id, coords)
				else
					RemoveText(id)
				end
			end
		end

		Citizen.Wait(0)
	end
end)

--[[ Functions: Text ]]--
function AddText(data)
	-- Set id.
	local id
	if data.id == nil then
		id = Id
		Id = Id + 1
	else
		id = data.id
	end

	(data or {}).id = id

	-- Cache resource.
	local resource = GetInvokingResource()
	if not data.resource and resource then
		data.resource = resource
	end

	-- Default coords.
	if not data.coords then
		data.coords = { x = 0, y = 0, z = 0 }
	end

	-- Entity defaults.
	if data.entity then
		data.entityType = GetEntityType(data.entity)
	end

	-- Temporary options.
	if data.duration then
		local snowflake = GetGameTimer()
		Threads[data.id] = snowflake
		
		Citizen.SetTimeout(data.duration, function()
			if Threads[data.id] ~= snowflake then
				return
			end
			
			RemoveText(data.id)
			Threads[data.id] = nil
		end)
	end

	-- Update NUI.
	SendNUIMessage({
		method = "addText",
		data = data
	})

	-- Cache label.
	Labels[id] = data
	LabelCount = LabelCount + 1

	return id
end
exports("AddText", AddText)

function RemoveText(id)
	if not Labels[id] then return end

	SendNUIMessage({
		method = "removeText",
		data = {
			id = id
		}
	})

	LabelCount = LabelCount - 1
	Labels[id] = nil
end
exports("RemoveText", RemoveText)

function SetText(id, text)
	SendNUIMessage({
		method = "updateText",
		data = {
			id = id,
			text = text,
		}
	})
end
exports("SetText", SetText)

function SetCoords(id, coords, rotation)
	SendNUIMessage({
		method = "updateText",
		data = {
			id = id,
			coords = coords,
			rotation = rotation,
		}
	})
end
exports("SetCoords", SetCoords)

function SetVisible(id, value)
	SendNUIMessage({
		method = "updateText",
		data = {
			id = id,
			visible = value,
		}
	})
end
exports("SetVisible", SetVisible)

--[[ Events ]]--
AddEventHandler("onClientResourceStart", function(resourceName)
	for id, label in pairs(Labels) do
		if label.resource == resourceName then
			RemoveText(id)
		end
	end
end)