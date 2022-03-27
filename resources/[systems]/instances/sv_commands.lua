exports.chat:RegisterCommand("a:joininstance", function(source, args, command, cb)
	local id = args[1]
	if not id then
		cb("error", "Must provide an instance id!")
		return
	end

	Instances:Join(source, id, true)
end, {
	description = "Join an existing instance.",
	parameters = {
		{ name = "ID", description = "The ID of the instance to join." },
	},
}, "Mod")

exports.chat:RegisterCommand("a:leaveinstance", function(source, args, command, cb)
	if not Instances:Get(source) then
		cb("error", "You are not instanced!")
		return
	end

	Instances:Leave(source)
end, {
	description = "Immediately leave your instance.",
}, "Mod")