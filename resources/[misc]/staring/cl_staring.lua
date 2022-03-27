Main = {
	peds = {},
}

function Main:Toggle(value)
	self.isActive = value

	if value then
		self:Update()
	else
		self:Destroy()
	end
end

function Main:Update()
	local coords = GetFinalRenderedCamCoord()

	for ped, text in pairs(self.peds) do
		if not DoesEntityExist(ped) or not IsEntityVisible(ped) or #(GetEntityCoords(ped) - coords) > Config.Distance then
			exports.interact:RemoveText(text)
			self.peds[ped] = nil
		end
	end

	for _, player in ipairs(GetActivePlayers()) do
		local ped = GetPlayerPed(player)
		local serverId = GetPlayerServerId(player)
		
		if not self.peds[ped] and IsEntityVisible(ped) and #(GetEntityCoords(ped) - coords) < Config.Distance then
			self.peds[ped] = exports.interact:AddText({
				id = "stare-"..ped,
				text = ("<span style='font-size: 2em'>%s:%s</span>"):format(serverId, Player(serverId).state.userId),
				entity = ped,
				offset = vector3(0, 0, 1.5),
				bone = 0,
			})
		end
	end

	if GetGameTimer() - (self.lastNotify or 0) > 1000 * Config.Cooldown then
		TriggerEvent("chat:notify", "You stare into the world, and it stares back.")
		TriggerServerEvent("stare")
		self.lastNotify = GetGameTimer()
	end
end

function Main:Destroy()
	for ped, text in pairs(self.peds) do
		exports.interact:RemoveText(text)
	end

	self.peds = {}
end

function Main:Input()
	local isActive = IsDisabledControlPressed(0, 243)
	if self.isActive ~= isActive then
		self:Toggle(isActive)
	end
end

--[[ Threads ]]--
Citizen.CreateThread(function()
	while true do
		Main:Input()
		Citizen.Wait(0)
	end
end)

Citizen.CreateThread(function()
	while true do
		if Main.isActive then
			Main:Update()
		end
		Citizen.Wait(200)
	end
end)