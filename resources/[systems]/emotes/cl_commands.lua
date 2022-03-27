--[[ Debug ]]--
exports.chat:RegisterCommand("a:animations", function(source, args, command, cb)
	Animations:ToggleMenu()
end, {
	description = "Open an animation menu for testing purposes.",
}, "Mod")

exports.chat:RegisterCommand("a:playanim", function(source, args, command, cb)
	local dict, name, flag = table.unpack(args)

	flag = tonumber(flag)

	if not DoesAnimDictExist(dict) then
		cb("error", "Invalid animation dictionary!")
		return
	end

	Main:Play({
		Dict = dict,
		Name = name,
		Flag = flag,
	})
end, {
	description = "Play any animation.",
	parameters = {
		{ name = "Dict", description = "Animation's dictionary." },
		{ name = "Name", description = "Animation's name." },
		{ name = "Flag", description = "Flag to play on the animation" },
	},
}, "Mod")

--[[ Emotes ]]--
exports.chat:RegisterCommand("e", function(source, args, command)
	-- Check states.
	local state = LocalPlayer.state
	if
		state.restrained or
		state.immobile or
		not IsControlEnabled(0, 52)
	then
		return
	end

	-- Convert name.
	local name  = tostring(args[1]):lower()
	if name == "c" or name == "cancel" then
		Main:Stop()
		return
	end

	-- Check emote.
	if not Main.emotes[name] then
		TriggerEvent("chat:notify", {
			text = "That emote doesn't exist!",
			class = "error",
		})
		return
	end
	
	-- Play emote.
	Main:Play(name)
end, {
	description = "Play an emote.",
	parameters = {
		{ name = "Name", description = "Which emote to play." },
	},
})

--[[ Walkstyles ]]--
exports.chat:RegisterCommand("walkstyle", function(source, args, command)
	local name  = tostring(args[1]):lower()

	if not name or not Config.Walkstyles[name] then
		TriggerEvent("chat:notify", {
			text = "That walkstyle doesn't exist!",
			class = "error",
		})
		return
	end

	Main:SetWalkstyle(name)
end, {
	description = "Play an emote.",
	parameters = {
		{ name = "Name", description = "Which emote to play." },
	},
})