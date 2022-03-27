Group = {}
Group.__index = Group

function Group:Create(site, id, data)
	local group = setmetatable({}, Group)
	for k, v in pairs(data) do
		group[k] = v
	end

	group.id = id
	group.cameras = {}
	group.site = site

	return group
end

function Group:Activate()
	local camera = Main.camera
	if camera == nil then return end

	-- Set UI.
	Menu:Commit("selectGroup", self.id - 1)
	
	-- Fade out.
	DoScreenFadeOut(0)
	Menu:SetLoading(true)

	-- Proxy camera.
	local coords = self.Center
	Main:UpdateCamera(coords)

	-- Wait to load.
	local hasGround, groundZ
	while not hasGround do
		if not self:IsActive() then return end

		hasGround, groundZ = GetGroundZFor_3dCoord(coords.x, coords.y, coords.z)
		Citizen.Wait(20)
	end

	-- Force interiors load.
	local interior = GetInteriorAtCoords(coords.x, coords.y, coords.z)
	if interior then
		local roomCount = GetInteriorRoomCount(interior)
		print("Interior", interior, "Rooms", roomCount)

		for i = 0, roomCount - 1 do
			local room = GetInteriorRoomName(interior, i)
			RequestModelsInRoom(interior, room)
			print("Room", i, room)
		end
	end

	-- Force discovery.
	local rotation = vector3(0.0, 0.0, 0.0)
	local offset = vector3(0.0, 0.0, 0.0)

	-- DoScreenFadeIn(0)

	while #self.cameras == 0 do
		if not self:IsActive() then return end

		self.site:Discover()

		Main:UpdateCamera(coords + offset, rotation)
		
		local rad = GetGameTimer() / 5000.0 * 3.14
		local dist = math.cos(rad) * 10.0

		offset = vector3(math.cos(rad) * dist, math.sin(rad) * dist, math.cos(5.0 * rad))
		rotation = rotation + vector3(0.0, 0.0, 15.0)

		Citizen.Wait(200)
	end

	-- Load first camera.
	self:SetCamera(1)
end

function Group:Deactivate()
	
end

function Group:Update()
	if self.camera ~= nil then
		self.camera:Update()
	end
end

function Group:RegisterCamera(entity)
	local camera = Camera:CreateFromObject(entity)

	table.insert(self.cameras, camera)

	Menu:Commit("addCamera", {
		groupIndex = self.id - 1,
		camera = {
			name = camera.hash % 10000
		},
	})

	return camera
end

function Group:SetCamera(index)
	local camera = self.cameras[index]
	if camera == nil then return end

	self.index = index
	self.camera = camera

	Menu:Commit("selectCamera", {
		groupIndex = self.id - 1,
		cameraIndex = index,
	})

	camera:Activate()
end

function Group:NextCamera(dir)
	local index = self.index or 1
	if dir > 0 then
		index = index + 1
		if index > #self.cameras then
			index = 1
		end
	else
		index = index - 1
		if index < 1 then
			index = #self.cameras
		end
	end
	if self.index ~= index then
		self:SetCamera(index)
	end
end

function Group:IsActive()
	return self.site and self.site.group == self
end