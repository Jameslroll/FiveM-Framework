RegisterCommand("voip:channelhud", function()
	Voip.hideFrequencies = not Voip.hideFrequencies

	TriggerEvent("chat:addMessage", ("You will now %ssee channels on the HUD."):format(Voip.hideFrequencies and "NOT " or ""))
	
	SendNUIMessage({ channels = channels })

	SetResourceKvpInt(Config.ChannelHudKey, Voip.hideFrequencies and 1 or 0)
end)

RegisterCommand("voip:reset", function()
	Voip:Reset()
end)

RegisterCommand("+roleplay_voipRange", function()
	if Voip.amplified then return end

	local range = (Voip.range or 2) + 1
	if range > Config.CycleRanges then
		range = 1
	end
	
	Voip:SetRange(range)
end)

RegisterKeyMapping("+roleplay_voipRange", "Voip - Change Range", "keyboard", "z")

--[[ Debug ]]--
exports.chat:RegisterCommand("voip:debug", function(source, args, command, cb)
	Voip.debug = not Voip.debug

	if not Voip.debug then
		SendNUIMessage({ debug = "" })
	end

	Voip:UpdateDebugText()
	
	cb("inform", "Voip debug set: "..tostring(Voip.debug))
end, {
	description = "Enable debug mode to see current channels."
}, "Dev")

exports.chat:RegisterCommand("voip:joinchannel", function(source, args, command, cb)
	local channel = args[1]
	if not channel then
		cb("error", "Invalid channel!")
		return
	end

	local _type = args[2]
	if not _type then
		cb("error", "Invalid type!", json.encode(Config.Types))
		return
	end

	Voip:JoinChannel(channel, _type)

	cb("inform", "Attempting to join channel: "..channel.." (".._type..")")
end, {
	description = "Join a channel.",
	parameters = {
		{ name = "Channel", description = "Channel to join. If it's a radio, make sure to include decimals." },
		{ name = "Type", description = "What type to join? The types are: 'Automatic', 'Manual', and 'Receiver'." },
	}
}, "Dev")

exports.chat:RegisterCommand("voip:leavechannel", function(source, args, command, cb)
	local channel = args[1]
	if not channel then
		cb("error", "Invalid channel!")
		return
	end

	Voip:LeaveChannel(channel)

	cb("inform", "Attempting to leave channel: "..channel)
end, {
	description = "Leave a channel.",
	parameters = {
		{ name = "Channel", description = "Channel to leave." },
	}
}, "Dev")