Spectate = {}

local cams = {}
local lastUpdate = 0
local lineSize = 100.0

--[[ Functions: Local ]]--
local function fromRotation(x, y, z)
	local pitch, yaw = (x % 360.0) / 180.0 * math.pi, (z % 360.0) / 180.0 * math.pi

	return
		math.cos(yaw) * math.cos(pitch),
		math.sin(yaw) * math.cos(pitch),
		math.sin(pitch)
end

local function drawText(x, y, z, offsetX, offsetY, textInput, fontId, scale, padding, offset)
	if not offset then
		offset = vector2(0.0, 0.0)
	end

	SetTextColour(255, 255, 255, 255)
	SetTextScale(scale, scale)
	SetTextFont(fontId)
	SetTextCentre(true)

	SetDrawOrigin(x, y, z, 0)
	SetScriptGfxAlignParams(offsetX, offsetY, 1.0, 1.0)

	BeginTextCommandWidth("STRING")
	AddTextComponentString(textInput)
	
	local height = GetTextScaleHeight(scale, fontId)
	local width = EndTextCommandGetWidth(4)
	padding = (padding or 0.0) * scale
	
	SetTextEntry("STRING")
	AddTextComponentString(textInput)
	EndTextCommandDisplayText(0.0, 0.0)
	DrawRect(0.0, height * 0.6, width + padding, height + padding, 0, 255, 255, 64)

	ClearDrawOrigin()
	ResetScriptGfxAlign()
end

--[[ Functions ]]--
function Spectate:Activate(target)
	self.target = target
	self.active = true
end

function Spectate:Deactivate(fromServer)
	self.target = nil
	self.active = false

	if self.camera then
		ClearFocus()

		self.camera:Destroy()
		self.camera = nil
	end

	if not fromServer then
		ExecuteCommand("a:s")
	end
end

--[[ Threads ]]--
Citizen.CreateThread(function()
	while true do
		local pos = GetFinalRenderedCamCoord()
		local rot = GetFinalRenderedCamRot()

		SendNUIMessage({
			cam = { pos.x, pos.y, pos.z, rot.x, rot.y, rot.z + 90.0 }
		})

		Citizen.Wait(100)
	end
end)

Citizen.CreateThread(function()
	local lastFrame

	while true do
		local deltaTime = lastFrame and (GetGameTimer() - lastFrame) / 1000.0 or 0

		if GetGameTimer() - lastUpdate < 1000 then
			for serverId, data in pairs(cams) do
				local x0, y0, z0 = data[1], data[2], data[3]
				local rx, ry, rz = data[4], data[5], data[6]

				local nx, ny, nz = fromRotation(rx, ry, rz)
				local x1, y1, z1 = x0 + nx * lineSize, y0 + ny * lineSize, z0 + nz * lineSize
	
				if serverId == Spectate.target then
					local coords = vector3(x0, y0, z0)
					local rotation = vector3(rx, ry, rz - 90)

					local camera = Spectate.camera
					if camera then
						camera.coords = coords
						camera.rotation = rotation

						SetFocusPosAndVel(x0, y0, z0, 0, 0, 0)
					else
						if Freecam.active then
							Freecam:Deactivate()
						end

						camera = Camera:Create({
							coords = coords,
							rotation = rotation,
							fov = 60.0,
						})

						camera:Activate()
						
						Spectate.camera = camera
					end
				else
					if #data >= 9 then
						data[10] = (data[10] or x0) + data[7] * deltaTime
						data[11] = (data[11] or y0) + data[8] * deltaTime
						data[12] = (data[12] or z0) + data[9] * deltaTime
	
						x0 = data[10]
						y0 = data[11]
						z0 = data[12]
					end

					DrawLine(x0, y0, z0, x1, y1, z1, 0, 255, 255, 200)
					drawText(x0, y0, z0 + 0.2, 0, -0.01, serverId, 2, 0.3, 0.01)
				end
			end
		end

		lastFrame = GetGameTimer()

		Citizen.Wait(0)
	end
end)

--[[ Events: Net ]]--
RegisterNetEvent(Admin.event.."spectate", function(target)
	if target then
		Spectate:Activate(target)
	else
		Spectate:Deactivate(true)
	end
end)

--[[ NUI Callbacks ]]--
RegisterNUICallback("draw", function(data, cb)
	cb(true)

	local newCams = {}
	local deltaTime = lastUpdate and (GetGameTimer() - lastUpdate) / 1000.0 or 0

	for serverId, cam in pairs(data) do
		serverId = tonumber(serverId)
		
		local x0, y0, z0 = cam[1], cam[2], cam[3]
		local x1, y1, z1 = cam[4], cam[5], cam[6]
		local x2, y2, z2

		local lastCam = cams[serverId]
		if lastCam and deltaTime > 0 then
			x2 = (x0 - lastCam[1]) / deltaTime
			y2 = (y0 - lastCam[2]) / deltaTime
			z2 = (z0 - lastCam[3]) / deltaTime
		end

		newCams[serverId] = {
			x0, y0, z0,
			x1, y1, z1,
			x2, y2, z2
		}
	end
	
	cams = newCams
	lastUpdate = GetGameTimer()
end)