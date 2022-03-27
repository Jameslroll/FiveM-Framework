_Player = _Player or {}
_Player.__index = _Player

--[[ Functions: Player ]]--
function _Player:LoadContainer()
	local data = {
		character_id = self.id,
		protected = true,
		type = "player",
		owner = self.source,
	}
	
	-- Load container.
	local container = Inventory:LoadContainer(data)

	-- Create container if doesn't exist.
	if container == nil then
		-- Register container.
		Debug("Create player container: [%s]", self.id)
		container = Inventory:RegisterContainer(data)

		-- Setup default items.
		for k, v in ipairs(Server.Players.Default) do
			-- Get item.
			local item = Inventory:GetItem(v.Name)
			if item ~= nil then
				-- Create slot.
				local slot = container:SetSlot(k - 1, {
					item_id = item.id,
					quantity = v.Quantity,
					fields = v.Fields ~= nil and v.Fields(self),
				})

				-- Save slot.
				slot:Save()
			end
		end
	end

	-- Subscribe player to it.
	container:Subscribe(self.source, true)
	
	-- Cache container.
	self.container = container
end

function _Player:Create(data)
	data.views = {}
	data.lastAction = os.clock()

	return setmetatable(data, _Player)
end

function _Player:GetTimeSinceLastAction()
	return os.clock() - self.lastAction
end

function _Player:UpdateLastAction()
	self.lastAction = os.clock()
end

function _Player:UseItem(containerId, slotId)
	-- Get container.
	local container = Inventory:GetContainer(containerId)
	if container == nil then return end

	-- Check self.
	if self.container == nil or self.container ~= container then return end

	-- Check subscription.
	if not container:IsSubscribed(self.source) then return end
	
	-- Get slot.
	local slot = container.slots[slotId]
	if slot == nil then return false end

	-- Get item.
	local item = Inventory:GetItem(slot.item_id)
	if item == nil then return false end

	-- Hooks.
	local result, message = Inventory:InvokeHook("use", source, item, slot)

	-- Log.
	exports.log:Add({
		source = self.source,
		verb = "used",
		noun = item.name,
		channel = "misc",
		extra = ("container: %s - slot: %s"):format(containerId, slotId),
	})

	-- Trigger events.
	TriggerEvent(EventPrefix.."use", source, item, slot)

	-- Return result.
	return true
end

--[[ Functions: Inventory ]]--
function Inventory:RegisterPlayer(source, id)
	-- Check redundancy.
	if self.players[source] ~= nil then return end
	
	-- Debug.
	Debug("Register player: [%s] (id: %s)", source, id)

	-- Create player.
	local player = _Player:Create({
		source = source,
		id = id,
	})

	-- Cache player.
	self.players[source] = player

	-- Load their container.
	player:LoadContainer()

	-- Hooks.
	Inventory:InvokeHook("registerPlayer", player)
end

function Inventory:DestroyPlayer(source)
	-- Get player.
	local player = self.players[source]
	if player == nil then return end

	-- Debug.
	Debug("Destroy player: [%s]", source)

	-- Destroy player container.
	if player.container then
		player.container:Destroy()
	end

	-- Unsubscribe containers.
	for containerId, _ in pairs(player.views) do
		local container = self.containers[containerId]
		if container then
			container:Subscribe(source, false)
		end
	end

	-- Uncache player.
	self.players[source] = nil

	-- Hooks.
	Inventory:InvokeHook("destroyPlayer", player)
end

function Inventory:GetPlayerContainer(source, onlyId)
	-- Get player.
	local player = self.players[source or false]
	if player == nil then return end

	-- Return container.
	return player.container and (onlyId and player.container.id or player.container)
end
Inventory:Export("GetPlayerContainer")

function Inventory:HasItem(source, ...)
	local container = self:GetPlayerContainer(source)
	if container == nil then return false end

	return container:HasItem(...)
end
Inventory:Export("HasItem")

function Inventory:CountItem(source, name)
	local container = self:GetPlayerContainer(source)
	if container == nil then return false end

	return container:CountItem(name)
end
Inventory:Export("CountItem")

function Inventory:TakeItem(source, ...)
	local container = self:GetPlayerContainer(source)
	if container == nil then return false end

	return { container:RemoveItem(...) }
end
Inventory:Export("TakeItem")

function Inventory:GiveItem(source, ...)
	local container = self:GetPlayerContainer(source)
	if container == nil then return false end

	return { container:AddItem(...) }
end
Inventory:Export("GiveItem")

function Inventory:HasSpace(source)
	local container = self:GetPlayerContainer(source)
	if container == nil then return false end

	return container:GetFirstEmptySlot() ~= false
end
Inventory:Export("HasSpace")

--[[ Events ]]
RegisterNetEvent(EventPrefix.."init", function()
	local source = source
	
	-- Wait for initialization.
	while not Inventory.initialized do
		Citizen.Wait(200)
	end

	-- Get character id.
	local id = exports.character:Get(source, "id")
	if id == nil then return end

	-- Load them.
	Inventory:RegisterPlayer(source, id)
end)

RegisterNetEvent(EventPrefix.."slotUse", function(containerId, slotId)
	local source = source
	local player = Inventory.players[source]
	if player == nil then return end

	player:UseItem(containerId, slotId)
end)

AddEventHandler("character:selected", function(source, character)
	if character == nil or character.id == nil then
		Inventory:DestroyPlayer(source)
	else
		Inventory:RegisterPlayer(source, character.id)
	end
end)

AddEventHandler("playerDropped", function()
	local source = source
	Inventory:DestroyPlayer(source)
end)