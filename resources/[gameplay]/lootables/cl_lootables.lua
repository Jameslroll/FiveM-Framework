Main = {
	entities = {},
}

--[[ Functions ]]--
function Main:Init()
	for model, _type in pairs(Config.Models) do
		exports.interact:Register({
			id = "lootable-"..model,
			text = "Loot",
			event = "loot",
			model = model,
		})
	end
end

function Main:HasLooted(coords)
	-- Ask server if lootable.
	local snowflake = (self.snowflake or 0) + 1
	self.snowflake = snowflake

	TriggerServerEvent("lootables:check", snowflake, coords)

	-- Handle response.
	local event = nil
	local response = nil

	event = RegisterNetEvent("lootables:check-"..snowflake, function(_isValid)
		response = _isValid
		RemoveEventHandler(event)
	end)
	
	-- Wait for response.
	local startTime = GetGameTimer()
	while response == nil and (GetGameTimer() - startTime) < 5000 do
		Citizen.Wait(0)
	end

	-- Return response.
	return response
end

function Main:CheckEntity(entity)
	local coords = GetEntityCoords(entity)
	local initialCoords = self.entities[entity] or vector3(0.0, 0.0, 0.0)
	local isValid = GetEntityUprightValue(entity) > 0.95 and #(initialCoords - coords) < 1.0

	if not isValid then
		TriggerEvent("chat:notify", { class = "error", text = "Something's not right here..." })
	end

	return isValid
end

function Main:Update()
	-- Suppress interact.
	if GetResourceState("interact") == "started" then
		TriggerEvent("interact:suppress")
	end
end

function Main:Begin(entity)
	if not entity or not DoesEntityExist(entity) then return end

	local model = GetEntityModel(entity) or 0
	local modelType = Config.Models[model or false]
	local _type = Config.Types[modelType or false]

	if not _type then return end

	-- Check entity.
	if not self:CheckEntity(entity) then
		return
	end

	-- Get entity info.
	local ped = PlayerPedId()
	local pedCoords = GetEntityCoords(ped)
	local coords = GetEntityCoords(entity)
	
	-- Get entity direction/heading.
	local dir = Normalize(coords - pedCoords)
	local target = coords - dir * _type.Radius
	local heading = GetHeadingFromVector_2d(dir.x, dir.y)

	-- Look at the entity.
	if not MoveToCoords(target, heading, false, 3000) then
		return
	end

	-- Check entity.
	if not self:CheckEntity(entity) then
		return
	end

	-- Begin looting.
	self.looting = entity
	
	-- Play emote.
	_type.Anim.Locked = true
	local emote = exports.emotes:Play(_type.Anim)

	-- Check if it's been looted.
	local shouldOpen = false

	if self:HasLooted(coords) then
		shouldOpen = true

		-- Done looting.
		self.looting = nil
	else
		if _type.Energy and not exports.health:CheckEnergy(_type.Energy, true) then
			return
		end

		-- Wait a little.
		Citizen.Wait(GetRandomIntInRange(1500, 2000))

		-- Take energy.
		exports.health:TakeEnergy(_type.Energy)
		
		-- Wait for QTE.
		local success = exports.quickTime:Begin(_type.QuickTime)

		-- Done looting.
		self.looting = nil

		-- Check success.
		if success and self:CheckEntity(entity) then
			shouldOpen = true
			TriggerServerEvent("lootables:loot", model, coords)
		end
	end

	if shouldOpen then
		-- Open inventory.
		exports.inventory:Focus(true)

		-- Wait for inventory.
		while exports.inventory:HasFocus() do
			Citizen.Wait(200)
		end

		-- Unsubscribe.
		-- exports.inventory:Unsubscribe()
	end

	-- Stop emote.
	exports.emotes:Stop(emote)
end

function Main:UpdateEntities()
	local temp = {}
	for entity, _ in EnumerateObjects() do
		temp[entity] = true
		if self.entities[entity] == nil then
			self.entities[entity] = Config.Models[GetEntityModel(entity) or false] and GetEntityCoords(entity) or false
		end
	end

	for entity, coords in pairs(self.entities) do
		if not temp[entity] then
			self.entities[entity] = nil
		end
	end
end

--[[ Events ]]--
AddEventHandler("lootables:clientStart", function()
	Main:Init()
end)

AddEventHandler("interact:on_loot", function(interactable)
	Main:Begin(interactable.entity)
end)

--[[ Threads ]]--
Citizen.CreateThread(function()
	while true do
		if Main.looting then
			Main:Update()
		end
		Citizen.Wait(200)
	end
end)

Citizen.CreateThread(function()
	while true do
		Main:UpdateEntities()
		Citizen.Wait(2000)
	end
end)