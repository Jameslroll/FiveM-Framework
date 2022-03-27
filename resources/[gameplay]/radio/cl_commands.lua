--[[ Opening the radio. ]]--
RegisterCommand("+roleplay_toggleRadio", function()
	if not IsDisabledControlPressed(0, Config.Controls.Modifier) then return end

	Radio:Toggle(not Radio.isOpen)
end)

RegisterKeyMapping("+roleplay_toggleRadio", "Radio - Open", "keyboard", "g")

--[[ Using the radio. ]]--
RegisterCommand("+roleplay_useRadio", function()
	Radio:SetActive(true)
end)

RegisterCommand("-roleplay_useRadio", function()
	Radio:SetActive(false)
end)

RegisterKeyMapping("+roleplay_useRadio", "Radio - Use", "keyboard", "capital")

--[[ Changing clicks. ]]--
RegisterCommand("radio:clickvariant", function(source, args, command)
	local index = tonumber(args[1]) or 0

	if index < 1 or index > Config.Clicks.Variations then
		TriggerEvent("chat:addMessage", ("Click does not exist, pick a number between 1-%s!"):format(Config.Clicks.Variations))
		return
	end

	Radio.clickVariant = index

	SetResourceKvpInt(Config.Clicks.Key.."Variant", index)
	
	TriggerEvent("chat:addMessage", ("Radio click variant set to %s!"):format(index))
end)

RegisterCommand("radio:clickvolume", function(source, args, command)
	local volume = tonumber(args[1]) or -1

	if volume < 1 or volume > 100 then
		TriggerEvent("chat:addMessage", "Invalid range, enter a number between 1-100!")
		return
	end

	volume = volume / 100.0

	Radio.clickVolume = volume

	SetResourceKvpFloat(Config.Clicks.Key.."Volume", volume)

	TriggerEvent("chat:addMessage", "Radio click volume set to "..math.floor(volume * 100).."%!")
end)