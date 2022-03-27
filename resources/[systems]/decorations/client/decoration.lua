Decoration = {}
Decoration.__index = Decoration

function Decoration:Create(data)
	-- Create instance.
	self = setmetatable(data, Decoration)

	-- Get item.
	local item = data.item_id and exports.inventory:GetItem(data.item_id)

	-- Cache grid id.
	local gridId = data.instance or data.grid
	
	-- Debug.
	Debug("Created decoration: %s in %s", item and item.name or data.id, gridId)

	-- Cache settings.
	self.settings = (item and Decorations[item.name]) or self.settings or {}

	-- Create model.
	self:CreateModel()

	-- Cache instance.
	Main.decorations[data.id] = self
	
	-- Add to grid.
	local grid = Main.grids[gridId]
	if not grid then
		grid = {}
		Main.grids[gridId] = grid
	end

	grid[data.id] = self

	-- Return instance.
	return self
end

function Decoration:Destroy()
	local gridId = self.instance or self.grid

	Debug("Destroyed decoration: %s in %s", self.id, gridId)

	-- Delete entity.
	local entity = self.entity
	if entity and DoesEntityExist(entity) then
		DeleteEntity(entity)
	end

	-- Uncache instance.
	Main.decorations[self.id] = nil

	-- Remove from grid.
	local grid = Main.grids[gridId]
	if grid then
		grid[self.id] = nil
	end

	-- Clean grid.
	local next = next
	if next(grid) == nil then
		Main.grids[gridId] = nil
	end

	-- Remove container.
	if self.container_id then
		exports.interact:Destroy("decoration-"..tostring(self.id))
	end
end

function Decoration:Update(dist)
	if self.isSelected and dist > Config.Pickup.MaxDistance then
		self:OnDeselect()
	end
end

function Decoration:OnSelect()
	-- Get settings.
	local settings = self:GetSettings()
	if not settings then return end

	local hasOptions = false

	-- Add navigation.
	if not self.temporary and not self.persistent and self.item_id then
		hasOptions = true
		exports.interact:AddOption({
			id = "decorationPickup",
			text = "Pickup",
			icon = "gavel",
		})
	end

	if settings.Station then
		hasOptions = true
		exports.interact:AddOption({
			id = "decorationCrafting",
			text = settings.Station.Type,
			icon = "construction",
		})
	end

	-- Visual effects.
	if hasOptions then
		self.isSelected = true
		SetEntityAlpha(self.entity, 192)
	end

	return hasOptions
end

function Decoration:OnDeselect()
	self.isSelected = false
	
	-- Visual effects.
	SetEntityAlpha(self.entity, 255)

	-- Clear main selection.
	if Main.selection == self then
		Main.selection = nil
	end
	
	-- Remove navigation.
	exports.interact:RemoveOption("decorationPickup")
	exports.interact:RemoveOption("decorationCrafting")
end

function Decoration:OnNavigate(id)
	if id == "decorationPickup" then
		Main:Pickup(self)
	elseif id == "decorationCrafting" then
		self:EnterStation()
	end
end

function Decoration:CreateModel()
	local settings = self.settings
	if not settings then return end

	-- Remove old entity.
	if self.entity then
		if DoesEntityExist(self.entity) then
			DeleteEntity(self.entity)
		end
		Main.entities[self.entity] = nil
	end

	-- Get coords.
	local coords = self.coords
	local rotation = self.rotation or vector3(0.0, 0.0, self.heading or 0.0)

	-- Get model.
	local model = self.model or Main:GetModel(settings, self.variant)
	if type(model) == "table" then
		model = model.Name
	end

	-- Request model.
	if not WaitForRequestModel(model) then
		print(("decoration '%s' failed to load model '%s'"):format(self.id, model))
		return
	end

	-- Create object.
	local entity = CreateObject(model, coords.x, coords.y, coords.z, false, true)

	SetEntityCoords(entity, coords.x, coords.y, coords.z)
	SetEntityRotation(entity, rotation.x, rotation.y, rotation.z)
	SetEntityDynamic(entity, false)
	SetEntityInvincible(entity, true)
	FreezeEntityPosition(entity, true)
	SetEntityLodDist(entity, 200)

	SetModelAsNoLongerNeeded(model)

	if self.invisible then
		SetEntityVisible(entity, false, 0)
	end

	self.entity = entity
	Main.entities[entity] = self

	-- Containers.
	if self.container_id then
		local interactId = "decoration-"..tostring(self.id)

		exports.interact:Register({
			id = interactId,
			event = "decorationContainer",
			text = "Open",
			entity = entity,
			-- coords = self.coords,
			-- radius = settings.Container.Radius,
			decoration = self.id,
		})
	end
end

function Decoration:GetSettings()
	return Decorations[self.item] or self.settings or {}
end