Main = {
	bones = {},
	listeners = {},
	effectsCached = {},
	effects = {},
	update = {},
	snowflake = 0,
	snowflakeSynced = 0,
}

_Player = Player

--[[ Functions ]]--
function Main:Init()
	-- Cache bones.
	self.boneIds = {}

	for boneId, settings in pairs(Config.Bones) do
		if settings.Name and not settings.Fallback then
			self.bones[boneId] = Bone:Create(boneId, settings.Name)
			self.boneIds[#self.boneIds + 1] = boneId
		end
	end

	-- Build navigation.
	self:BuildNavigation()

	-- Add player navigation.
	exports.players:AddOption({
		id = "healthExaminePlayer",
		text = "Examine",
		icon = "visibility",
	}, false, function(player, playerPed)
		TriggerEvent("health:examine", player)
	end)

	exports.players:AddOption({
		id = "healthHelp",
		text = "Help Up",
		icon = "front_hand",
	}, function(player, playerPed, dist)
		local serverId = GetPlayerServerId(player)
		local state = _Player(serverId).state

		return state.immobile
	end, function(player, playerPed)
		TriggerEvent("health:help", player)
	end)
end

function Main:Update()
	Player = PlayerId()
	Ped = PlayerPedId()

	if self.ped ~= Ped then
		self.ped = Ped

		SetPedMaxHealth(Ped, 1000)
		SetEntityHealth(Ped, 1000)
		SetPedDiesInWater(Ped, false)
		SetPedDiesInstantlyInWater(Ped, false)
		SetPedConfigFlag(Ped, 3, false)
	end
end

function Main:Sync()
	local payload = {
		effects = {},
		history = {},
		info = {},
	}

	-- Get effects.
	for _, effect in ipairs(Config.Effects) do
		local value = self.effects[effect.Name] or effect.Default or 0.0
		if math.abs(value - effect.Default) > 0.001 then
			payload.effects[effect.Name] = value
		end
	end
	
	-- Get bone info.
	local next = next
	for boneId, bone in pairs(self.bones) do
		if next(bone.info) ~= nil then
			payload.info[boneId] = bone.info
		end
		if next(bone.history) ~= nil then
			payload.history[boneId] = bone.history
		end
	end

	-- Update cache.
	self.snowflakeSynced = self.snowflake
	self.lastSync = GetGameTimer()

	-- Check payload.
	local result, retval = IsPayloadValid(payload)
	if not result then
		print(("Ignoring invalid payload (%s)"):format(retval))
		return
	end
	
	-- Sync to server.
	TriggerServerEvent("health:sync", payload)
	
	-- Debug.
	print("Updating snowflake", self.snowflake, json.encode(payload))
end

function Main:Restore(data)
	for _, effect in pairs(Config.Effects) do
		self:SetEffect(effect.Name, data.effects and data.effects[effect.Name] or effect.Default or 0.0)
	end
	
	for boneId, bone in pairs(self.bones) do
		bone.info = data.info and (data.info[boneId] or data.info[tostring(boneId)]) or {}
		bone.history = data.history and (data.history[boneId] or data.history[tostring(boneId)]) or {}
		bone:UpdateInfo()
	end
end

function Main:AddListener(_type, cb)
	local listeners = self.listeners[_type]
	if not listeners then
		listeners = {}
		self.listeners[_type] = listeners
	end

	listeners[cb] = true
end

function Main:InvokeListener(_type, ...)
	if not self.isLoaded then return end

	local listeners = self.listeners[_type]
	if not listeners then return false end

	for func, _ in pairs(listeners) do
		func(...)
	end

	return true
end

function Main:GetBone(boneId)
	local settings = Config.Bones[boneId or false]
	return self.bones[settings and settings.Fallback or boneId]
end

function Main:UpdateInfo()
	local info = {}

	for boneId, bone in pairs(self.bones) do
		info[bone.name] = bone.info
	end

	Menu:Invoke("main", "updateInfo", info)
end

function Main:SetEffect(name, value)
	if not self.isLoaded then return end

	value = math.min(math.max(value, 0.0), 1.0)
	
	self.effects[name] = value
	
	Menu:Invoke("main", "updateEffect", name, value)
	Menu:Invoke(false, "setOverlay", name, value)

	local cachedValue = self.effectsCached[name]
	if cachedValue and math.abs(cachedValue - value) < 0.01 then
		return
	end

	self.effectsCached[name] = value

	print("updating", name, value)

	Main:UpdateSnowflake()
end
Export(Main, "SetEffect")

function Main:GetEffect(name)
	return self.effects[name] or 0.0
end
Export(Main, "GetEffect")

function Main:AddEffect(name, amount)
	local effect = self.effects[name]
	if not effect then return end
	
	self:SetEffect(name, effect + amount)
end
Export(Main, "AddEffect")

function Main:ResetEffects()
	for _, effect in ipairs(Config.Effects) do
		self:SetEffect(effect.Name, effect.Default or 0.0)
	end
end
Export(Main, "ResetEffects")


function Main:GetHealth()
	return self.effects["Health"] or 1.0
end
Export(Main, "GetHealth")

function Main:ResetInfo()
	ClearPedBloodDamage(Ped)

	for boneId, bone in pairs(self.bones) do
		bone.info = {}
		bone.history = {}
	end

	self:UpdateInfo()
	self:InvokeListener("ResetInfo")
end

function Main:GetUp()
	if self:GetHealth() then
		self:SetEffect("Health", 0.1)
	end
end

function Main:UpdateSnowflake()
	self.snowflake = self.snowflake + 1

	Menu:Focus()
	self:InvokeListener("UpdateSnowflake")
end

function Main:GetRandomBone()
	return self.bones[self.boneIds[GetRandomIntInRange(1, #self.boneIds + 1)]]
end

function Main:BuildNavigation()
	local options = {
		{
			id = "healthExamine",
			text = "Examine",
			icon = "visibility",
		},
		{
			id = "healthStatus",
			text = "Quick Status",
			icon = "accessibility",
		},
	}

	self:InvokeListener("BuildNavigation", options)

	exports.interact:AddOption({
		id = "health",
		text = "Self",
		icon = "spa",
		sub = options,
	})
end

function Main:IsInjuryPresent(name, group)
	local lookupTable = type(name) == "table"
	for id, bone in pairs(self.bones) do
		if bone.history and (not group or group == bone:GetGroup()) then
			for k, event in ipairs(bone.history) do
				if (lookupTable and name[event.name]) or (not lookupTable and event.name == name) then
					return true
				end
			end
		end
	end
	return false
end

--[[ Events ]]--
AddEventHandler("health:clientStart", function()
	Main:Init()
end)

AddEventHandler("health:start", function()
	Main.isLoaded = true

	while not Menu.isLoaded do
		Citizen.Wait(0)
	end

	local data = exports.character:Get("health")
	if data then
		Main:Restore(data)
	end
end)

AddEventHandler("character:selected", function(character)
	if not character then
		if Treatment.ped then
			Treatment:End()
		end

		Main:ResetInfo()
		Main:ResetEffects()
		Main.isLoaded = nil

		Ped = nil
		Player = nil

		return
	end

	Main.isLoaded = true

	if character.health then
		Main:Restore(character.health)
	end
end)

AddEventHandler("onEntityDamaged", function(data)
	if data.victim ~= Ped or not data.weapon then return end
	
	local maxHealth = GetPedMaxHealth(Ped)
	local health = GetEntityHealth(Ped)
	local rawDamage = maxHealth - health

	SetEntityHealth(Ped, maxHealth)

	-- local weaponDamage = GetWeaponDamage(data.weapon)
	-- local damageRatio = (weaponDamage or rawDamage or 0) / Config.MaxHealth
	local bone = data.pedBone or 11816

	print("entity damage", data.weapon, bone)
	
	Main:InvokeListener("TakeDamage", data.weapon, bone, data)
end)

--[[ Events: Net ]]--
RegisterNetEvent("health:revive", function(resetEffects)
	Main:ResetInfo()
	
	if resetEffects then
		Main:ResetEffects()
	end
end)

RegisterNetEvent("health:getup", function(resetEffects)
	Main:GetUp()
end)

RegisterNetEvent("health:slay", function()
	Main:SetEffect("Health", 0.0)
end)

RegisterNetEvent("health:damage", function(weapon, bone)
	Main:InvokeListener("TakeDamage", weapon, bone, {})
end)

RegisterNetEvent("health:addEffect", function(name, amount)
	if name then
		Main:AddEffect(name, amount)
	else
		for _, effect in ipairs(Config.Effects) do
			Main:AddEffect(effect.Name, 1.0)
		end
	end
end)

RegisterNetEvent("health:resetEffects", function()
	Main:ResetEffects()
end)

RegisterNetEvent("health:sync", function(serverId, data, status)
	local player = GetPlayerFromServerId(serverId)
	local ped = GetPlayerPed(player)
	if ped == PlayerPedId() then return end

	local bones = {}
	for boneId, settings in pairs(Config.Bones) do
		local info = data.info and (data.info[boneId] or data.info[tostring(boneId)])
		local history = data.history and (data.history[boneId] or data.history[tostring(boneId)])

		if info or history then
			local bone = Bone:Create(boneId, settings.Name)
			bone.info = info or {}
			bone.history = history or {}

			bones[boneId] = bone
		end
	end

	if Treatment.ped == ped then
		Treatment:SetBones(bones)
	else
		Treatment:Begin(ped, bones, serverId, status)
	end
end)

RegisterNetEvent("health:updateStatus", function(serverId, status)
	if Treatment.serverId == serverId and Treatment.window then
		Treatment.window:SetModel("status", status)
	end
end)

--[[ NUI Callbacks ]]--
RegisterNUICallback("init", function(data, cb)
	Menu:Init()
	Main:ResetEffects()

	cb(true)
end)

--[[ Threads ]]--
Citizen.CreateThread(function()
	while true do
		if Main.isLoaded then
			Main:Update()
		end

		Citizen.Wait(0)
	end
end)

Citizen.CreateThread(function()
	local lastUpdate = GetGameTimer()
	
	while true do
		-- Wait to loading.
		while not Main.isLoaded do
			Citizen.Wait(0)
		end

		-- Cache walkstyle.
		local walkstyle = Main.walkstyle
		Main.walkstyle = nil

		-- Update delta.
		DeltaTime = GetGameTimer() - lastUpdate
		MinutesToTicks = 1.0 / 60000.0 * DeltaTime

		-- Update effects.
		for _, effect in ipairs(Config.Effects) do
			if effect.Passive then
				local value = Main.effects[effect.Name]
				if value then
					Main:SetEffect(effect.Name, value + MinutesToTicks / effect.Passive)
				end
			end
		end

		-- Update functions.
		for name, func in pairs(Main.update) do
			func(Main)
		end

		-- Update time.
		lastUpdate = GetGameTimer()

		-- Update walkstyle.
		if walkstyle ~= Main.walkstyle then
			exports.emotes:OverrideWalkstyle(Main.walkstyle)
		end

		Citizen.Wait(TickRate)
	end
end)

Citizen.CreateThread(function()
	while true do
		if Main.isLoaded and Main.snowflake ~= Main.snowflakeSynced then
			Main:Sync()
		end

		Citizen.Wait(Config.Saving.Cooldown)
	end
end)