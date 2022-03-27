--[[ Functions: Container ]]--
function Container:Create(data)
	if data.id == nil then
		if data.temporary then
			Inventory.containerId = (Inventory.containerId or 0) + 1
			data.id = "t"..tostring(Inventory.containerId)
		else
			local setters, values = GetQuerySetters(Server.Containers.Properties, data, {})
			if setters == "" then
				setters = "id=DEFAULT"
			end

			data.id = exports.GHMattiMySQL:QueryScalar(([[
				INSERT INTO `%s` SET %s;
				SELECT LAST_INSERT_ID();
			]]):format(Server.Tables.Containers, setters), values)

			if data.id == nil then
				error("failed creating container ("..json.encode(data)..")")
			end
		end
	end
	
	Debug("Container created: %s (temporary: %s)", data.id, data.temporary == true)

	local slots = data.slots
	
	data.weight = 0.0
	data.slots = {}
	data.viewers = {}

	if type(data.coords) == "vector4" then
		data.heading = data.coords.w
		data.coords = vector3(data.coords.x, data.coords.y, data.coords.z)
	end

	local container = setmetatable(data, Container)

	if slots then
		for slotId, info in pairs(slots) do
			info.slot = slotId - 1
			container:AddItem(info)
		end
	end

	return container
end

function Container:Destroy(save)
	-- Hooks.
	local result, message = Inventory:InvokeHook("destroyContainer", self)
	if result == false then
		return false, message
	end

	-- Unsubscribe.
	for viewer, _ in pairs(self.viewers) do
		self:Subscribe(viewer, false)
	end

	-- Uncache.
	Inventory.containers[self.id] = nil

	-- Run query.
	if save then
		exports.GHMattiMySQL:QueryAsync("DELETE FROM `containers` WHERE `id`=@id", {
			["@id"] = self.id
		})
	end

	-- Debug.
	Debug("Container destroyed: %s", self.id)

	return true
end

function Container:Subscribe(source, value, frisk)
	-- Get player.
	local player = Inventory.players[source]
	if player == nil then
		return false, "no player"
	end

	-- Hooks.
	local result, message = Inventory:InvokeHook("subscribe", self, player, value)
	if result == false then
		return false, message
	end

	-- Get settings.
	local settings = self:GetSettings()
	if not settings then
		return false, "no container settings"
	end

	-- Check user group.
	if settings.user then
		local funcName = "Is"..settings.user
		local func = exports.user[funcName]
		if func and not func(exports.user, source) then
			print(("[%s] missing user group '%s'"):format(source, settings.user))
			return false, "invalid user group"
		end
	end

	-- Set player.
	player.views[self.id] = value or nil

	-- Set container.
	self.viewers[source] = value or nil

	-- Inform player.
	if value then
		self:Inform(source, frisk)
	else
		TriggerClientEvent(EventPrefix.."sync", source, { id = self.id })
	end

	-- Result.
	return true
end

function Container:IsSubscribed(source)
	return self.viewers[source] ~= nil
end

function Container:Inform(target, frisk)
	if self.viewers == nil then return end

	Debug("Container inform: %s", self.id)

	-- Create payload.
	local payload = {
		-- Self values.
		coords = self.coords,
		id = self.id,
		owner = self.owner,
		type = self.type,
		width = self.width,
		height = self.height,
		name = self.name,
		settings = self.settings,
		frisk = frisk,
		
		-- Arbitrary data.
		set = slots == nil,
		slots = {},
	}

	-- Convert slots for JSON transaction.
	for slot, info in pairs(self.slots) do
		payload.slots[tostring(slot)] = info
	end

	-- Send payload.
	TriggerClientEvent(EventPrefix.."sync", target, payload)
end

function Container:InformAll(payload)
	if self.viewers == nil then return end

	Debug("Container inform all: %s", self.id)

	-- Send payload.
	for source, player in pairs(self.viewers) do
		TriggerClientEvent(EventPrefix.."inform", source, self.id, payload)
	end
end

function Container:InvokeSlot(slotId, funcName, ...)
	print(slotId, funcName, ...)
	local slot = self:GetSlot(slotId)
	if not slot then return false end

	local func = slot[funcName]
	if not func then return false end

	return func(slot, ...)
end

function Container:CheckFilter(item)
	-- Get settings.
	local settings = self:GetSettings()
	if not settings then return false end

	-- Get filters.
	local filters = self.filters or settings.filters

	-- Check filters exist.
	if not filters then
		return true
	end

	-- Check all filters.
	if filters.category and filters.category[item.category] then
		return true
	elseif filters.item and filters.item[item.name] then
		return true
	end
	
	return false
end

function Container:GetCoords()
	if self.coords then
		return self.coords
	end

	if self.owner then
		local ped = GetPlayerPed(self.owner)
		if DoesEntityExist(ped) then
			return GetEntityCoords(ped) - vector3(0.0, 0.0, 1.0)
		end
	end
end

--[[ Functions: Inventory ]]--
function Inventory:LoadContainer(data, create)
	local container

	-- Check cache.
	if data.id then
		container = self:GetContainer(data.id)
		if container then
			return container, true
		end
	end

	-- Get query.
	local setters, values = GetQuerySetters(Server.Containers.Properties, data, {})
	if setters == "" then
		return create and self:RegisterContainer(data)
	end

	-- Get container.
	local result = exports.GHMattiMySQL:QueryResult(("SELECT * FROM `%s` WHERE %s LIMIT 1"):format(Server.Tables.Containers, setters), values)[1]
	if not result and create then
		return self:RegisterContainer(data)
	elseif not result then
		return
	end
	
	-- Assign parameterized options.
	for k, v in pairs(data) do
		result[k] = v
	end
	
	-- Register container from result.
	container = self:RegisterContainer(result)

	-- Load slots into container.
	container:LoadSlots()

	return container
end
Inventory:Export("LoadContainer")

function Inventory:DestroyContainer(id, save)
	local container = self.containers[id or false]
	if not container then return false end
	
	return container:Destroy(save)
end
Inventory:Export("DestroyContainer")

function Inventory:RegisterContainer(data)
	data.resource = GetInvokingResource()
	
	local container = Container:Create(data)

	self.containers[data.id] = container

	self:InvokeHook("registerContainer", container)

	return container
end
Inventory:Export("RegisterContainer")

function Inventory:Subscribe(source, id, value, frisk)
	-- Check input.
	if not id or type(value) ~= "boolean" then return false end
	
	-- Get container.
	local container = Inventory:GetContainer(id)
	if not container then return false end

	-- Subscribe container.
	container:Subscribe(source, value, frisk)

	return true
end
Inventory:Export("Subscribe")

--[[ Events ]]--
RegisterNetEvent(EventPrefix.."subscribe", function(id, value)
	local source = source

	-- Check input.
	if id == nil or type(value) ~= "boolean" then return end
	
	-- Get container.
	local container = Inventory:GetContainer(id)
	if container == nil then return end

	-- Check impossible containers.
	if value and container.protected then
		exports.log:Add({
			source = source,
			verb = "accessed",
			noun = "protected container",
			extra = ("id: %s"):format(id),
			channel = "cheat",
		})

		return
	end

	-- Subscribe.
	local success, reason = container:Subscribe(source, value)
	if not success then
		print(("[%s] failed subscribing to container: %s"):format(source, reason or ""))
	end
end)