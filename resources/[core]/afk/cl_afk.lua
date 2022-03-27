local LastActivity = GetGameTimer()
local WaitingFor = 0
local WaitingForInput = false
local Characters = "abcdefghijklmnopqrstuvwxyz"

--[[ Threads ]]--
Citizen.CreateThread(function()
	while true do
		local hasPressed = false
		for _, control in ipairs(Config.Controls) do
			if IsDisabledControlJustPressed(0, control) then
				hasPressed = true
				LastActivity = GetGameTimer()
				break
			end
		end
		local idleTime = GetGameTimer() - LastActivity
		if WaitingForInput then
			WaitingFor = WaitingFor + GetFrameTime()
			if WaitingFor > Config.ConfirmTime then
				TriggerServerEvent("iamafk")

				LastActivity = GetGameTimer()
				WaitingFor = 0.0
				WaitingForInput = false
			end
		elseif idleTime > Config.IdleTime * 1000 then
			ActivateConfirmation()
		end
		Citizen.Wait(0)
	end
end)

--[[ Functions ]]--
function ActivateConfirmation()
	if WaitingForInput then return end
	WaitingForInput = true

	local text = ""
	local eventData

	for i = 1, GetRandomIntInRange(4, 6) do
		local offset = GetRandomIntInRange(1, Characters:len() + 1)
		local char = Characters:sub(offset, offset)
		local isUpper = GetRandomFloatInRange(0.0, 1.0) > 0.5

		if isUpper then
			char = char:upper()
		end
		text = text..char
	end

	eventData = AddEventHandler("_chat:messageEntered", function(message)
		if message == text then
			RemoveEventHandler(eventData)
			SendNUIMessage({
				setInput = false
			})

			LastActivity = GetGameTimer()
			WaitingFor = 0
			WaitingForInput = false
		end
	end)

	SendNUIMessage({
		setInput = text
	})
end