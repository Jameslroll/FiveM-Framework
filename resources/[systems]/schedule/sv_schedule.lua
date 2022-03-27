GracePeriod = 600 -- In seconds, time after a restart another restart is possible.
TimeFrame = 1 -- In minutes, time within an hour a restart is possible.
Times = { 13 } -- In hours, times to restart.
WarningPrepend = 300
RestartAnnounced = false

Announcements = {
	{ "“Everyone, deep in their hearts, is waiting for the end of the world to come.” ― Haruki Murakami, 1Q84" },
	{ "“Don't wake me for the end of the world unless it has very good special effects.” ― Roger Zelazny, Prince of Chaos" },
	{ "“It's the end of the world every day, for someone.” ― Margaret Atwood, The Blind Assassin" },
	{ "“Just in case the world ends tomorrow, we might as well enjoy today.” ― Susan Beth Pfeffer, Life As We Knew It" },
	{ "“But if there must be an end, let it be loud. Let it be bloody. Better to burn than to wither away in the dark.” ― Mike Mignola, Hellboy, Vol. 6: Strange Places", "fight" },
	{ "“I couldn't think of anything cool to say.” ― James Roll, Visual Studio Code", "james" },
	{ "“I fell asleep to the sounds of the end of the world.” ― Michael Douglas" },
	{ "“Pandora's box had been opened and monsters had come out. But there had been something hidden at the bottom of Pandora's box. Something wonderful. Hope.” ― Lisa Marie Rice, Breaking Danger" },
	{ "“Life isn't about waiting for the storm to pass... It's about learning to dance in the rain.” ― Vivian Greene" },
	{ "“Clouds, leaves, soil, and wind all offer themselves as signals of changes in the weather. However, not all the storms of life can be predicted.” ― David Petersen" },
	{ "“I do not know with what weapons World War III will be fought, but World War IV will be fought with sticks and stones.” – Albert Einstein." },
}

Citizen.CreateThread(function()
	while true do
		if os.clock() > GracePeriod then
			local time, hour, minutes = GetTime(os.time())

			if not RestartAnnounced and minutes > 50 then
				for _, restart in ipairs(Times) do
					if restart == 0 then
						restart = 23
					end
					if hour == restart - 1 then
						RestartAnnounced = true
						WarnEnd()
					end
				end
			end

			if minutes < TimeFrame then
				for _, restart in ipairs(Times) do
					if restart == hour then
						for i = 1, GetNumPlayerIndices() do
							DropPlayer(GetPlayerFromIndex(i - 1), "Server restart.")
						end
						Citizen.Wait(1000)
						Restart()
					end
				end
			end
		end

		Citizen.Wait(1000)
	end
end)

function GetTime(time)
	if not time then time = os.time() end
	return time, tonumber(os.date("%H", time)), tonumber(os.date("%M", time))
end

function WarnEnd()
	math.randomseed(math.floor(os.clock() * 1000))
	local text, special = table.unpack(Announcements[math.random(1, #Announcements)])

	if text then
		TriggerClientEvent("chat:addMessage", -1, text, "server")
	end
	
	TriggerEvent("schedule:warn", special)
	TriggerClientEvent("schedule:warn", -1, special)
end

function Restart()
	os.exit()
end
exports("Restart", Restart)