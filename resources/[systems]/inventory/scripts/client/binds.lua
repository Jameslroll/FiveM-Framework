Binds = { binds = {} }

--[[ Hooks ]]--
Inventory:AddHook("init", function()
	Binds:Load()
end)

--[[ Functions: Inventory ]]--
function Binds:Set(id, slot)
	local bind = self.binds[id]
	if bind == nil then return end

	-- Set bind.
	bind.slot = slot

	-- Save bind.
	self:Save(id, slot)

	-- Update NUI.
	Menu:SetData("binds", self.binds)
end

function Binds:Get(id)
	return self.binds[id]
end

function Binds:Invoke(id)
	local bind = self:Get(id - 1)
	if bind == nil then return end

	local slot = bind.slot
	if slot == nil then return end

	local container = Inventory.selfContainer
	if container == nil then return end

	Inventory:UseItem(container, slot)
end

function Binds:Load(id)
	-- Get character id.
	id = id or exports.character:Get("id")
	if id == nil then return end

	-- Cache binds.
	self.binds = {}
	
	-- Get save key prefix.
	local keyPrefix =  "roleplay_inv_bind-"..tostring(id).."-"

	-- Loop allowed binds.
	for k, v in ipairs(Config.Binds) do
		local id = k - 1
		local saveKey = keyPrefix..id
		local slot = GetResourceKvpInt(saveKey) - 1

		if slot == -1 then
			slot = nil
		end

		print(id, ksaveKey, slot)

		-- Cache bind.
		self.binds[id] = { key = tostring(k), slot = slot }
	end

	-- Update NUI.
	Menu:SetData("binds", self.binds)
end

function Binds:Save(id, slot)
	-- Get character id.
	local characterId = exports.character:Get("id")
	if characterId == nil then return end

	-- Get save key.
	local saveKey =  "roleplay_inv_bind-"..tostring(characterId).."-"..tostring(id)

	-- Save it.
	if slot == nil then
		DeleteResourceKvp(saveKey)
	else
		SetResourceKvpInt(saveKey, slot + 1)
	end
end

--[[ Events ]]--
AddEventHandler("character:selected", function(character)
	if character ~= nil then
		Binds:Load(character.id)
	end
end)

--[[ NUI Events ]]--
RegisterNUICallback("bind", function(data, cb)
	Binds:Set(tonumber(data.bind) or -1, tonumber(data.slot))
	cb(true)
end)