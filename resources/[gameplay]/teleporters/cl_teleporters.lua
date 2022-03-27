Main = {
	teleports = {},
}

--[[ Functions: Main ]]--
function Main:Register(info)
	local id = (self.lastId or 0) + 1
	local _type = Config.Types[info.Type or false]
	
	self.lastId = id
	self.teleports[id] = info

	for i = 1, 2 do
		local _info = info[i == 1 and "From" or "To"]
		if type(_info) ~= "table" then
			_info = { Coords = _info }
		end

		local __type = Config.Types[_info.Type or false] or _type

		exports.entities:Register({
			id = ("teleport_%s-%s"):format(id, i),
			name = "Teleporter",
			coords = _info.Coords,
			radius = _info.Radius or info.Radius or Config.Defaults.Radius,
			instance = _info.Instance or info.Instance,
			navigation = {
				id = "teleport-"..id,
				text = (__type and __type.Text) or _info.Text or info.Text or Config.Defaults.Text,
				icon = (__type and __type.Icon) or _info.Icon or info.Icon or Config.Defaults.Icon,
				teleport = {
					id = id,
					index = i,
				},
			},
		})
	end

	return id
end

function Main:TeleportTo(coords, instance)
	if self.teleporting then return end
	self.teleporting = true
	
	DoScreenFadeOut(Config.FadeTime)
	Citizen.Wait(Config.FadeTime)
	
	local ped = PlayerPedId()
	local wasVisible = IsEntityVisible(ped)

	local currentInstance = GetResourceState("instances") == "started" and exports.instances:GetInstance()
	if instance and currentInstance ~= instance then
		TriggerServerEvent("instances:join", instance)
	elseif not instance and currentInstance then
		TriggerServerEvent("instances:leave")
	end

	FreezeEntityPosition(ped, true)
	SetEntityCoords(ped, coords.x, coords.y, coords.z)
	SetEntityHeading(ped, type(coords) == "vector4" and coords.w or 0.0)

	if wasVisible then
		SetEntityVisible(ped, false)
	end

	local hasGround, groundZ = false, nil
	local startTime = GetGameTimer()


	while not hasGround and GetGameTimer() - startTime < 5000 do
		Citizen.Wait(1)
		hasGround, groundZ = GetGroundZFor_3dCoord(coords.x, coords.y, coords.z)
	end

	ped = PlayerPedId()

	DoScreenFadeIn(Config.FadeTime)
	SetEntityCoords(ped, coords.x, coords.y, hasGround and groundZ or coords.z)
	FreezeEntityPosition(ped, false)
	ClearPedTasksImmediately(ped)

	if wasVisible then
		SetEntityVisible(ped, true)
	end

	self.teleporting = false
end

function Main:TeleportToWithType(coords, instance, _type)
	if self.teleporting then return end
	self.teleporting = true

	-- Play emote.
	if _type.Anim then
		self.emote = exports.emotes:Play(_type.Anim)
	end

	-- Do message.
	if _type.Message then
		TriggerEvent("chat:notify", {
			class = "inform",
			text = _type.Message,
			duration = _type.Duration,
		})
	end

	-- Wait for duration.
	local startTime = GetGameTimer()
	local startCoords = GetEntityCoords(PlayerPedId())

	while GetGameTimer() - startTime < _type.Duration do
		if self.cancel or #(GetEntityCoords(PlayerPedId()) - startCoords) > (_type.MaxDistance or 1.0) then
			self.teleporting = false
			self.cancel = nil
			self:StopEmote()

			return
		end

		Citizen.Wait(20)
	end

	-- Teleport!
	self.teleporting = false
	self:TeleportTo(coords, instance)
	
	-- Cancel emote.
	self:StopEmote()
end

function Main:StopEmote()
	if self.emote then
		exports.emotes:Stop(self.emote)
		self.emote = nil
	end
end

--[[ Exports ]]--
exports("TeleportTo", function(...)
	Main:TeleportTo(...)
end)

--[[ Events ]]--
AddEventHandler("teleporters:clientStart", function()
	for k, teleporter in ipairs(Config.Teleporters) do
		Main:Register(teleporter)
	end
end)

AddEventHandler("interact:onNavigate", function(id, option)
	local teleport = option.teleport
	if not teleport then return end

	local teleporter = Main.teleports[teleport.id]
	if not teleporter then print("no teleporter") return end

	local target = teleporter[teleport.index == 1 and "To" or "From"]
	if not target then print("no target") return end

	local source = teleporter[teleport.index == 1 and "From" or "To"]
	if not source then print("no source") return end

	local isSourceTable = type(source) == "table"
	local isTargetTable = type(target) == "table"

	local _type = Config.Types[(isSourceTable and source.Type) or teleporter.Type or false]

	local func = _type and Main.TeleportToWithType or Main.TeleportTo
	func(Main, isTargetTable and target.Coords or target, isTargetTable and target.Instance, _type)
end)

AddEventHandler("emotes:cancel", function(id)
	if Main.emote == id and Main.teleporting then
		Main.cancel = true
		Main.emote = nil
	end
end)