--[[ Functions: Decorations ]]--
function Decoration:OpenStation()
	-- Get settings.
	local settings = self:GetSettings()
	if not settings then return end
	
	local station = settings.Station
	if not station then return end

	-- Cache station.
	Main.station = self

	-- Create camera.
	if station.Camera then
		local offset = station.Camera.Offset or vector3(0, 0, 0)
		local coords = GetOffsetFromEntityInWorldCoords(self.entity, offset.x, offset.y, offset.z)
		local rotation = ToRotation(Normalize((self.coords + (station.Camera.Target or vector3(0, 0, 0))) - coords))

		local camera = Camera:Create({
			coords = coords,
			rotation = rotation,
			fov = station.Camera.Fov or 60.0,
			shake = {
				type = "HAND_SHAKE",
				amount = 0.1,
			}
		})

		camera:Activate()

		Main.camera = camera
	end
end

function Decoration:EnterStation()
	-- Check occupied.
	if self.player then
		TriggerEvent("chat:notify", {
			class = "error",
			text = "It's occupied!",
		})
		return
	end

	-- Get settings.
	local settings = self:GetSettings()
	if not settings then return end

	local station = settings.Station
	if not station then return end

	local entity = self.entity
	if not entity then return end

	-- Move to magnet.
	if station.Magnet then
		local coords = GetOffsetFromEntityInWorldCoords(entity, station.Magnet.Offset)
		local heading = GetEntityHeading(entity) + station.Magnet.Heading

		if not MoveToCoords(coords, heading, true, 5000) then return end
	end

	-- Play anim.
	local anim = station.Anim
	if anim and anim.In then
		self.emote = exports.emotes:Play(anim.In)
	end

	-- Check occupied, again.
	if self.player then
		return
	end

	-- Events.
	TriggerServerEvent(Main.event.."enterStation", self.id)
end

function Decoration:LeaveStation(skipEvent)
	local settings = self:GetSettings()
	local station = settings and settings.Station

	-- Play anim.
	local anim = station and station.Anim
	if anim and anim.Out then
		exports.emotes:Play(anim.Out)
	end

	-- Destroy camera.
	if Main.camera then
		Main.camera:Destroy()
		Main.camera = nil
	end

	-- Clear cache.
	Main.station = nil

	-- Events.
	if not skipEvent then
		TriggerServerEvent(Main.event.."exitStation")
	end

	-- Cancel emote.
	if self.emote then
		exports.emotes:Stop(self.emote)
		self.emote = nil
	end
end

--[[ Functions: Main ]]--
function Main:UpdateStation()

end

--[[ Events ]]--
AddEventHandler("inventory:focused", function(value)
	if not value and Main.station then
		Main.station:LeaveStation()
	end
end)

--[[ Events: Net ]]--
RegisterNetEvent(Main.event.."enterStation", function(id, success)
	local decoration = Main.decorations[id or false]
	if not decoration then return end

	if success then
		decoration:OpenStation()
	else
		decoration:LeaveStation(true)
	end
end)

--[[ Threads ]]--
Citizen.CreateThread(function()
	while true do
		if Main.station then
			Main:UpdateStation()
			Citizen.Wait(0)
		else
			Citizen.Wait(200)
		end
	end
end)