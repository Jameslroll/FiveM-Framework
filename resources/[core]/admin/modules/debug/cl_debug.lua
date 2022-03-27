Debugger = { texts = {} }

--[[ Functions ]]--
function Debugger:Init()
	self.active = self.showEntities or self.showPlayers
	if not self.active then
		self:Destroy()
	end
end

function Debugger:Destroy()
	for entity, id in pairs(self.texts) do
		exports.interact:RemoveText(id)
	end
	self.texts = {}
end

function Debugger:Update()
	local coords = GetFinalRenderedCamCoord()
	self.tempCache = {}

	for ped, _ in EnumeratePeds() do
		local isPlayer = IsPedAPlayer(ped)
		if isPlayer and self.showPlayers then
			self:RegisterPlayer(ped)
		elseif not isPlayer and self.showEntities and #(coords - GetEntityCoords(ped)) < 50.0 then
			self:RegisterEntity(ped)
		end
	end

	if self.showEntities then
		for object, _ in EnumerateObjects() do
			if #(coords - GetEntityCoords(object)) < 50.0 then
				self:RegisterEntity(object)
			end
		end

		for vehicle, _ in EnumerateVehicles() do
			if #(coords - GetEntityCoords(vehicle)) < 50.0 then
				self:RegisterEntity(vehicle)
			end
		end
	end

	for entity, id in pairs(self.texts) do
		if self.tempCache[entity] == nil then
			exports.interact:RemoveText(id)
			self.texts[entity] = nil
		end
	end
end

function Debugger:RegisterEntity(entity, text)
	if not NetworkGetEntityIsNetworked(entity) then
		return
	end

	self.tempCache[entity] = true
	if self.texts[entity] then return end
	
	local id = "d"..entity
	local type = GetEntityType(entity)
	local _entity = Entity(entity)
	local offset = vector3(0, 0, 0)

	if type == 1 then
		text = text or "Ped"
		offset = vector3(0, 0, 1)
	elseif type == 2 then
		text = text or "Vehicle"
		offset = vector3(0, 0, -1)
	elseif type == 3 then
		text = text or "Object"
	else
		text = text or ""
	end

	local owner = NetworkGetEntityOwner(entity)
	if owner == PlayerId() then
		owner = "You"
	else
		owner = "["..GetPlayerServerId(owner).."]"
	end
	
	text = text.."<br>ID: "..NetworkGetNetworkIdFromEntity(entity)
	
	if not IsEntityAPed(entity) or not IsPedAPlayer(entity) then
		local origin = _entity and _entity.state.origin or "Unknown"

		if origin == GetPlayerServerId(PlayerId()) then
			origin = "You"
		end

		text = text.."<br>Owner: "..owner
		text = text.."<br>Orign: "..origin
	end

	exports.interact:AddText({
		id = id,
		text = text,
		entity = entity,
		offset = offset,
		bone = type == 1 and 0 or nil,
	})

	self.texts[entity] = id
end

function Debugger:RegisterPlayer(ped)
	local serverId = GetPlayerServerId(NetworkGetEntityOwner(ped))
	local player = Admin:GetPlayer(serverId)

	local text = ("%s [%s]"):format(player.name, serverId)

	self:RegisterEntity(ped, text)
end

--[[ Threads ]]--
Citizen.CreateThread(function()
	while true do
		if Debugger.active then
			Debugger:Update()
		end

		Citizen.Wait(1000)
	end
end)

--[[ Hooks ]]--
Admin:AddHook("toggle", "debuggerEntity", function(value)
	Debugger.showEntities = value
	Debugger:Init()
end)

Admin:AddHook("toggle", "debuggerPlayer", function(value)
	Debugger.showPlayers = value
	Debugger:Init()
end)

Admin:AddHook("select", "spawnEntity", function()
	local isDynamic = Navigation.window.models.entityDynamic
	
	Navigation:Close()

	Citizen.Wait(200)

	UI:Dialog({
		title = "Spawn Entity",
		message = "Model for entity:",
		prompt = {
			model = "",
			type = "text",
		},
		cancel = true,
	}, function(name)
		local hash = GetHashKey(name)
		print(name, hash)
		if not IsModelValid(hash) then
			TriggerEvent("chat:notify", { class = "error", text = "Invalid model!" })
			return
		end

		while not HasModelLoaded(hash) do
			RequestModel(hash)
			Citizen.Wait(0)
		end

		local ped = PlayerPedId()
		local coords = GetEntityCoords(ped)
		local entity = CreateObject(hash, coords.x, coords.y, isUnderMap and -500.0 or coords.z, true, true, false)

		SetEntityDynamic(entity, isDynamic or false)
	end)
end)

--[[ Events ]]--
AddEventHandler(Admin.event.."stop", function()
	Debugger:Destroy()
end)