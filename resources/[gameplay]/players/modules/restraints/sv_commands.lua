exports.chat:RegisterCommand("a:cuff", function(source, args, command, cb)
	local target = tonumber(args[1]) or source
	if not target or target <= 0 then cb("error", "Invalid target!") return end

	exports.log:Add({
		source = source,
		target = target,
		verb = "cuffed (admin)",
		channel = "admin",
	})

	Restraints:Finish(target, "Handcuffs")

	cb("success", "Cuffed!")
end, {
	description = "Force somebody into cuffs.",
	parameters = {
		{ name = "Target", description = "Who to place into cuffs?" },
	}
}, "Mod")

exports.chat:RegisterCommand("a:uncuff", function(source, args, command, cb)
	local target = tonumber(args[1]) or source
	if not target or target <= 0 then cb("error", "Invalid target!") return end

	exports.log:Add({
		source = source,
		target = target,
		verb = "uncuffed (admin)",
		channel = "admin",
	})

	Restraints:Finish(target)

	cb("success", "Uncuffed!")
end, {
	description = "Free somebody from cuffs.",
	parameters = {
		{ name = "Target", description = "Who to remove from cuffs?" },
	}
}, "Mod")