function Site:UpdateDoors()
	if Main.camera == nil then return end
	
	-- Create labels.
	if self.labels == nil then
		self.labels = {}
	end

	-- Get doors.
	if self.lastDoorsUpdate == nil or GetGameTimer() - self.lastDoorsUpdate > 500 then
		self.lastDoorsUpdate = GetGameTimer()
		self.doors = exports.doors:GetDoors()
	end

	-- Get cursor stuff.
	local camCoords = GetFinalRenderedCamCoord()
	local mouseX, mouseY = GetNuiCursorPosition()
	local width, height = GetActiveScreenResolution()
	local activeDoor = nil

	-- Check doors.
	for entity, door in pairs(self.doors) do
		if not door or not door.settings or not door.settings.Electronic then goto skip end

		door.state = exports.doors:GetDoorState(door.coords)

		local coords = door.coords
		local retval, screenX, screenY = GetScreenCoordFromWorldCoord(coords.x, coords.y, coords.z)
		local label = self.labels[entity]

		if retval and #(coords - camCoords) < Config.DoorDistance then
			screenX = screenX * width
			screenY = screenY * height

			local screenDist = ((screenX - mouseX)^2 + (screenY - mouseY)^2)^0.5
			local isActive = Menu.hasFocus and screenDist < 100.0
			local currentDoor = self.doors[activeDoor]

			if isActive and (currentDoor == nil or #(currentDoor.coords - camCoords) > #(coords - camCoords)) then
				activeDoor = entity
			end

			self:UpdateDoor(entity, door)
		else
			self:RemoveDoor(entity)
		end

		::skip::
	end

	-- Select door.
	if activeDoor ~= self.activeDoor then
		if self.activeDoor ~= nil then
			ResetEntityAlpha(self.activeDoor)
		end

		if activeDoor ~= nil then
			SetEntityAlpha(activeDoor, 192)
		end

		self.activeDoor = activeDoor
	end

	-- Toggle door.
	if activeDoor ~= nil and IsDisabledControlJustPressed(0, 24) then
		local currentDoor = self.doors[activeDoor]
		if currentDoor then exports.doors:SetDoorState(currentDoor.coords) end
	end
end

function Site:UpdateDoor(entity, door)
	local label = self.labels[entity]
	if label ~= nil and label.state == door.state then return end

	local texture
	if door.state then
		texture = "locked"
	else
		texture = "unlocked"
	end

	if label ~= nil then
		exports.interact:RemoveText(label.id)
	end

	local id = exports.interact:AddText({
		text = "<img src='assets/"..texture..".png' width=16 height=16/>",
		entity = entity,
		transparent = true,
	})

	self.labels[entity] = {
		id = id,
		state = door.state,
	}
end

function Site:RemoveDoor(object)
	label = self.labels[object]
	if label == nil then return end

	exports.interact:RemoveText(label.id)
	self.labels[object] = nil
end

function Site:ClearDoors()
	if self.labels == nil then return end

	for entity, label in pairs(self.labels) do
		exports.interact:RemoveText(label.id)
	end
	self.labels = nil
end