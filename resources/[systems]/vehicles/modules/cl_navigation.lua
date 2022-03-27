--[[ Functions ]]--
local function GetVehicle()
	local vehicle = IsDriver and CurrentVehicle or NearestVehicle
	if vehicle and DoesEntityExist(vehicle) then
		return vehicle
	end
	return false
end

--[[ Functions: Main ]]--
function Main:BuildNavigation()
	local navigation = {}
	self.navigation = navigation

	local options = {}
	local vehicle = nil
	local ped = PlayerPedId()
	local coords = GetEntityCoords(ped)

	local door = nil
	local hood = false
	local trunk = false
	local check = false

	if CurrentVehicle and DoesEntityExist(CurrentVehicle) then
		local seat = FindSeatPedIsIn(ped) or 0
		door = seat + 1
		vehicle = CurrentVehicle

		-- Engine.
		if IsDriver then
			options[#options + 1] = {
				id = "vehicleEngine",
				text = "Ignition",
				icon = "car_rental",
			}

			check = true
		end

		-- Doors.
		if IsDriver and ClassSettings and ClassSettings.InsideDoors then
			hood = true
			trunk = true

			-- Cargo bays!
			if DoesVehicleHaveBone(CurrentVehicle, "cargo_node") then
				options[#options + 1] = {
					id = "vehicleBay",
					text = "Cargo Bay",
					icon = "archive",
				}
			end
		end

		-- Update seats.
		local seats = GetVehicleModelNumberOfSeats(Model)
		local seatOptions = {}

		for seat = -1, seats - 2 do
			if self:CanGetInSeat(CurrentVehicle, seat) then
				seatOptions[#seatOptions + 1] = {
					id = "vehicleSeat"..seat,
					text = SeatNames[seat] or "Passenger "..(seat - 2),
					icon = "chair",
					seatIndex = seat,
				}
			end
		end

		options[#options + 1] = {
			id = "vehicleSeat",
			text = "Seat",
			icon = "airline_seat_recline_normal",
			sub = seatOptions,
		}
	elseif NearestVehicle and DoesEntityExist(NearestVehicle) then
		vehicle = NearestVehicle
		
		local nearestDoor, nearestDoorDist, nearestDoorCoords = GetClosestDoor(coords, vehicle, false, true)
		if not nearestDoor then
			local handleBars = GetEntityBoneIndexByName(vehicle, "handlebars")
			if handleBars ~= -1 then
				local handleBarCoords = GetWorldPositionOfEntityBone(vehicle, handleBars)
				local offset = GetOffsetFromEntityGivenWorldCoords(vehicle, handleBarCoords)

				if #(coords - handleBarCoords) < Config.Navigation.Doors.Distances[-1] then
					navigation.nearestDoor = -1
					navigation.doorOffset = offset
	
					check = true
				end
			end
			
			goto skipDoor
		end

		local doorIndex = Doors[nearestDoor]
		if not GetIsDoorValid(vehicle, doorIndex) then
			goto skipDoor
		end

		local doorOffset = GetOffsetFromEntityGivenWorldCoords(vehicle, nearestDoorCoords)
		local doorNormal = #doorOffset > 0.001 and Normalize(vector3(doorOffset.x, doorOffset.y, 0.0)) or vector3(0.0, 0.0, 0.0)

		if doorIndex == 4 or doorIndex == 5 then
			doorOffset = doorOffset + doorNormal * 1.0
		end

		-- Citizen.CreateThread(function()
		-- 	for i = 1, 100 do
		-- 		local c = GetOffsetFromEntityInWorldCoords(vehicle, doorOffset)
		-- 		DrawLine(c.x, c.y, c.z, coords.x, coords.y, coords.z, 255, 255, 0, 255)

		-- 		Citizen.Wait(0)
		-- 	end
		-- end)

		if #(GetOffsetFromEntityInWorldCoords(vehicle, doorOffset) - coords) > (Config.Navigation.Doors.Distances[doorIndex] or Config.Navigation.Doors.Distances[-1]) then
			doorIndex = nil
			goto skipDoor
		end

		hood = doorIndex == 4
		trunk = doorIndex == 5
		door = not hood and not trunk and doorIndex

		navigation.nearestDoor = doorIndex
		navigation.doorOffset = doorOffset

		if door == 0 then
			check = true
		end

		::skipDoor::
	end

	-- Clear options.
	if not vehicle then
		self:CloseNavigation()
		return
	end

	-- Get settings.
	local model = GetEntityModel(vehicle)
	local settings = self:GetSettings(model)
	
	-- Check distance.
	local vehicleCoords = GetEntityCoords(vehicle)
	local vehicleDist = #(vehicleCoords - coords)

	-- Add check option.
	if check then
		options[#options + 1] = {
			id = "vehicleCheck",
			text = "Check",
			icon = "info",
		}
	end

	-- Carrying.
	if not IsInVehicle and GetVehicleClass(vehicle) == 13 and vehicleDist < 3.0 then
		options[#options + 1] = {
			id = "vehicleCarry",
			text = "Carry",
			icon = "back_hand",
		}
	end

	-- Doors!
	if trunk and GetIsDoorValid(vehicle, 5) then
		options[#options + 1] = {
			id = "vehicleTrunk",
			text = "Trunk",
			icon = "inventory_2",
			doorIndex = 5,
		}
	end

	if hood and GetIsDoorValid(vehicle, 4) then
		options[#options + 1] = {
			id = "vehicleHood",
			text = "Hood",
			icon = "home_repair_service",
			doorIndex = 4,
		}
	end

	if door then
		options[#options + 1] = {
			id = "vehicleDoor",
			text = "Door",
			icon = "door_back",
			doorIndex = door,
		}
	end

	-- Stretchers.
	if Stretcher:GetSettings(vehicle) then
		local targetVehicle = GetNearestVehicle(coords, nil, vehicle)
		local _model = targetVehicle and GetEntityModel(targetVehicle)
		local _settings = _model and self:GetSettings(_model)
		local offset = ((_settings or {}).Stretcher or {}).Unload or vector3(0.0, 0.0, 0.0)
		local coords = _settings and GetOffsetFromEntityInWorldCoords(targetVehicle, offset)

		if _settings and #(vehicleCoords - coords) < 3.0 and _settings.Type == "Ambulance" then
			options[#options + 1] = {
				id = "loadStretcher",
				text = "Load",
				icon = "local_hospital",
				stretcher = vehicle,
				vehicle = targetVehicle,
			}
		end
	elseif settings and settings.Stretcher then
		local stretcher = Stretcher:GetVehicleStretcherAttached(vehicle)
		if stretcher then
			options[#options + 1] = {
				id = "unloadStretcher",
				text = "Unload",
				icon = "local_hospital",
				stretcher = stretcher,
				vehicle = vehicle,
			}
		end
	end

	-- Update navigation.
	if #options > 0 then
		exports.interact:AddOption({
			id = "vehicle",
			icon = "drive_eta",
			text = "Vehicle",
			sub = options,
		})
	else
		self:CloseNavigation()
	end
end

function Main:CloseNavigation()
	self.navigation = nil

	exports.interact:RemoveOption("vehicle")
end

function Main.update:Navigation()
	local navigation = self.navigation
	if not navigation then return end

	local ped = PlayerPedId()
	local coords = GetEntityCoords(ped)

	-- Check nearest door.
	local door = navigation.nearestDoor
	local doorOffset = navigation.doorOffset

	if doorOffset and #(GetOffsetFromEntityInWorldCoords(NearestVehicle, doorOffset) - coords) > (Config.Navigation.Doors.Distances[door] or Config.Navigation.Doors.Distances[-1]) then
		self:BuildNavigation()
	end
end

function Main:CheckInfo(vehicle)
	if self.infoEntity ~= vehicle then print("diff vehicle for info") return end

	local state = (Entity(vehicle) or {}).state
	if not state then print("no state for vehicle") return end

	-- Check vehicle.
	if CurrentVehicle ~= vehicle then
		
	end
	
	-- Update text.
	local text = "<div style='max-width: 40vmin'>"
	
	-- Vin number.
	if self.info and self.info.vin then
		text = text..("<div style='background: rgb(20, 20, 20); color: white; padding: 8px; border-radius: 8px; display: inline-block'>%s</div>"):format(self.info.vin)
	end

	-- Ignition.
	if self.info.key then
		text = text..("<br>• Key in the ignition.")
	elseif self.info.starter then
		text = text..("<br>• Screwdriver in the ignition.")
	end
	
	-- Hotwired.
	if state.hotwired then
		text = text..("<br>• Wires hanging loose wrapped with electrical tape.")
	elseif state.stage == 1 then
		text = text..("<br>• Wires hanging loose.")
	elseif state.stage == 2 then
		text = text..("<br>• Wires hanging loose are stripped.")
	end

	text = text.."</div>"

	-- Get bone.
	local bone
	local steeringWheel = GetEntityBoneIndexByName(vehicle, "steeringwheel")
	local handleBars = GetEntityBoneIndexByName(vehicle, "handlebars")

	if steeringWheel ~= -1 then
		bone = steeringWheel
	elseif handleBars ~= -1 then
		bone = handleBars
	end

	-- Remove text.
	if self.text then
		exports.interact:RemoveText(self.text)
		self.text = nil
	end
	
	-- Add text.
	self.text = exports.interact:AddText({
		id = "checkVehicle",
		text = text,
		bone = bone,
		entity = vehicle,
		offset = vector3(0.0, 0.1, 0.1),
		transparent = true,
		duration = 16000,
		distance = 20.0,
	})

	-- -- Chat messsage.
	-- TriggerEvent("chat:addMessage", {
	-- 	html = text,
	-- 	class = "system",
	-- })
end

--[[ Listeners ]]--
Main:AddListener("Enter", function(vehicle)
	Main:BuildNavigation()
end)

Main:AddListener("Update", function()
	if not IsInVehicle then return end

	local func
	if IsDisabledControlJustPressed(0, 187) then
		func = RollDownWindow
	elseif IsDisabledControlJustPressed(0, 188) then
		func = RollUpWindow
	end

	if func then
		local windowIndex = FindSeatPedIsIn(Ped) + 1
		func(CurrentVehicle, windowIndex)
	end
end)

--[[ Events ]]--
AddEventHandler("interact:onNavigate", function(id, option)
	if not option.doorIndex and not option.seatIndex then return end

	local vehicle = GetVehicle()
	if not vehicle then return end

	if option.doorIndex then
		Main:ToggleDoor(vehicle, option.doorIndex)
		exports.emotes:Play(Config.Navigation.Doors.Anim)
	elseif option.seatIndex then
		SetPedIntoVehicle(PlayerPedId(), vehicle, option.seatIndex)
	end
end)

AddEventHandler("interact:onNavigate_vehicleEngine", function(option)
	Main:ToggleEngine()
end)

AddEventHandler("interact:onNavigate_vehicleBay", function(option)
	local vehicle = GetVehicle()
	if not vehicle then return end

	Main:ToggleBay(vehicle)
end)

AddEventHandler("interact:onNavigate_vehicleCheck", function(option)
	local vehicle = GetVehicle()
	if not vehicle then return end

	Main:CheckInfo(vehicle)
end)

AddEventHandler("interact:onNavigate_vehicleCarry", function(option)
	local vehicle = GetVehicle()
	if not vehicle or IsInVehicle then return end

	Carry:Start(vehicle)
end)

AddEventHandler("interact:navigate", function(value)
	if not value then
		Main:CloseNavigation()
		return
	end

	Main:BuildNavigation()
end)