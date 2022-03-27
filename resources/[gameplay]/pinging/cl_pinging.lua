Main = {
	pings = {},
}

--[[ Functions ]]--
function Main:Add(coords)
	-- Create blip.
	local blip = AddBlipForCoord(coords.x, coords.y, coords.z)
	SetBlipSprite(blip, 126)
	SetBlipColour(blip, 46)
	SetBlipScale(blip, 1.0)

	-- Blip label.
	if not self.label then
		self.label = "PING"
		AddTextEntry(self.label, "Ping")
	end

	BeginTextCommandSetBlipName(self.label)
	EndTextCommandSetBlipName(blip)

	-- Cache ping.
	table.insert(self.pings, {
		blip = blip,
		startTime = GetGameTimer()
	})
end

function Main:Remove(index)
	local ping = self.pings[index]
	if not ping then return end

	if ping.blip and DoesBlipExist(ping.blip) then
		RemoveBlip(ping.blip)
	end

	table.remove(self.pings, index)
end

function Main:Update()
	for index, ping in ipairs(self.pings) do
		local lifetime = (GetGameTimer() - (ping.startTime or 0)) / (1000.0 * Config.MaxLifetime)
		if lifetime > 1.0 then
			self:Remove(index)
			break
		else
			SetBlipAlpha(ping.blip, math.floor((1.0 - lifetime) * 255))
		end
	end
end

function Main:CanPing()
	return not exports.interaction:IsHandcuffed() and not exports.health:IsPedDead(PlayerPedId())
end

function Main:TryPing()
	if self:CanPing() then
		return true
	else
		exports.mythic_notify:SendAlert("error", "Can't do that right now...", 7000)
		return false
	end
end

--[[ Events ]]--
RegisterNetEvent("ping:receive")
AddEventHandler("ping:receive", function(coords)
	exports.mythic_notify:SendAlert("success", "Pong!", 7000)
	Main:Add(coords)
end)

--[[ Commands ]]--
RegisterCommand("ping", function(source, args, command)
	local target = tonumber(args[1])
	if not target then return end

	if not Main:TryPing() then return end

	TriggerServerEvent("ping:send", target)
end)

--[[ Threads ]]--
Citizen.CreateThread(function()
	while true do
		if #Main.pings > 0 then
			Main:Update()
			Citizen.Wait(100)
		else
			Citizen.Wait(1000)
		end
	end
end)