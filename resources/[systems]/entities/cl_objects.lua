Object = {}
Object.__index = Object

function Object:Create(data)
	-- Default id.
	if not data.id then
		data.id = (Main.lastId or 0) + 1
		Main.lastId = data.id
	end

	-- Other defaults.
	data.root = data.root or data.parent or data
	data.depth = data.depth or 0
	data.resource = data.resource or GetInvokingResource()

	-- Create instance.
	local instance = setmetatable(data or {}, Object)

	-- Cache instance.
	Main.objects[instance.id] = instance

	-- Update coords.
	if instance.coords then
		if type(instance.coords) == "vector4" then
			instance.heading = instance.coords.z
			instance.coords = vector3(instance.coords.x, instance.coords.y, instance.coords.z)
		end

		instance:SetCoords(instance.coords)
	end

	-- Trigger event.
	TriggerEvent("entities:created", instance)

	-- Instance children.
	if instance.children then
		for k, child in pairs(instance.children) do
			child.depth = (instance.depth or 0) + 1
			child.parent = instance
			child.root = instance.root or instance
			child = Object:Create(child)

			instance.children[k] = child
		end
	end

	-- Return instance.
	return instance
end

function Object:Destroy()
	-- Uncache instance.
	Main.objects[self.id] = nil
	
	-- Unload.
	self:Unload()

	-- Get grid.
	local grid = self:GetGrid()
	if grid then
		-- Uncache from grid.
		grid[self.id] = nil
	end

	-- Trigger event.
	TriggerEvent("entities:destroyed", instance)

	-- Destroy children.
	if self.children then
		for k, child in pairs(self.children) do
			child:Destroy()
		end
	end
end

function Object:Load()
	self.isLoaded = true

	if self.model then
		while not HasModelLoaded(self.model) do
			RequestModel(self.model)
			Citizen.Wait(0)
		end

		local entity = CreateObject(self.model, self.coords.x, self.coords.y, self.coords.z, false, true)

		if self.rotation then
			SetEntityRotation(entity, self.rotation.x, self.rotation.y, self.rotation.z, true)
		end

		FreezeEntityPosition(entity, true)

		self.entity = entity
	end

	if self.floor then
		local hasGround, groundZ = GetGroundZFor_3dCoord(self.coords.x, self.coords.y, self.coords.z)
		if hasGround then
			self.coords = vector3(self.coords.x, self.coords.y, groundZ)
		end
	end
end

function Object:Unload()
	self.isLoaded = nil

	if self.isInside then
		self.isInside = false
		self:OnExit()
	end

	if self.entity and DoesEntityExist(self.entity) then
		DeleteObject(self.entity)
	end
end

function Object:Update(pedCoords)
	if not self.coords then return end
	local distance = #(self.coords - pedCoords)
	local isInside = distance < (self.radius or 0.5)

	if isInside ~= (self.isInside or false) then
		if isInside then
			self:OnEnter()
		else
			self:OnExit()
		end

		self.isInside = isInside
	end
end

function Object:OnEnter()
	if self.condition and not self:condition() then
		return
	end

	TriggerEvent("entities:onEnter", self.id, self.event)

	self.entered = true
	
	if self.navigation then
		self.navigation.id = self.id

		exports.interact:AddOption(self.navigation)
	end
end

function Object:OnExit()
	if not self.entered then return end

	TriggerEvent("entities:onExit", self.id, self.event)

	self.entered = false

	if self.navigation and self.navigation.id then
		exports.interact:RemoveOption(self.navigation.id)
	end
end

function Object:OnInteract()
	TriggerEvent("entities:onInteract", self)
end

function Object:SetCoords(coords)
	-- Remove from last grid.
	local lastGrid = self:GetGrid()
	if lastGrid then
		lastGrid[self.id] = nil
	end

	-- Get grid.
	local gridId = Grids:GetGrid(coords, Config.GridSize)
	local grid = Main.grids[gridId]
	if not grid then
		grid = {}
		Main.grids[gridId] = grid
	end

	-- Set grid.
	grid[self.id] = self
	self.grid = gridId

	-- Load if active.
	if Main.cached[gridId] then
		self:Load()
	end
end

function Object:GetGrid()
	return self.grid and Main.grids[self.grid]
end

function Object:DrawDebug()
	local size = self.radius or 0.5
	local isSelected = self.id == Debug.selected
	local r, g, b = 255, 255, 0

	if isSelected then
		r, g, b = 0, 255, 0
	elseif not self.isLoaded then
		r, g, b = 255, 64, 64
	end

	DrawMarker(
		28, -- type
		self.coords.x, -- posX
		self.coords.y, -- posY
		self.coords.z, -- posZ
		0.0, -- dirX
		0.0, -- dirY
		1.0, -- dirZ
		self.rotation and self.rotation.x or 0.0, -- rotX
		self.rotation and self.rotation.y or 0.0, -- rotY
		self.rotation and self.rotation.z or 0.0, -- rotZ
		size, -- scaleX
		size, -- scaleY
		size, -- scaleZ
		r, -- red
		g, -- green
		b, -- blue
		128, -- alpha
		false, -- bobUpAndDown
		false, -- faceCamera
		2, -- p19
		false, -- rotate
		nil, -- textureDict
		nil, -- textureName
		false-- drawOnEnts
	)

	if self.children then
		for k, child in pairs(self.children) do
			if child.coords then
				DrawLine(self.coords.x, self.coords.y, self.coords.z, child.coords.x, child.coords.y, child.coords.z, 255, 255, 0, 128)
			end
		end
	end
end