exports.chat:RegisterCommand("a:goto", function(source, args, rawCommand, cb)
	local target = args[1]
	if target == "*" then
		target = -1
	else
		target = tonumber(target)
	end

	-- Self check.
	if source == target then
		cb("error", "You cannot goto yourself!")
		return
	end

	-- Check target.
	if type(target) ~= "number" or target <= 0 or not DoesEntityExist(GetPlayerPed(target)) then
		cb("error", "Target does not exist!")
		return
	end

	local ped = GetPlayerPed(target)
	if not DoesEntityExist(ped) then return end

	exports.log:Add({
		source = source,
		target = target,
		verb = "teleported to",
		channel = "admin",
	})

	TriggerClientEvent(Admin.event.."goto", source, GetEntityCoords(ped), exports.instances:Get(target) or false, target)
end, {
	description = "Go to another player.",
	parameters = {
		{ name = "Target", description = "Person to go to." },
	}
}, "Mod")

exports.chat:RegisterCommand("a:bring", function(source, args, rawCommand, cb)
	local target = args[1]
	if target == "*" then
		target = -1
	else
		target = tonumber(target)
	end
	
	-- Self check.
	if source == target then
		cb("error", "You cannot bring yourself!")
		return
	end

	-- Check target.
	if type(target) ~= "number" or target == 0 or (target ~= -1 and not DoesEntityExist(GetPlayerPed(target))) then
		cb("error", "Target does not exist!")
		return
	end

	local ped = GetPlayerPed(source)
	if not DoesEntityExist(ped) then return end

	exports.log:Add({
		source = source,
		target = target,
		verb = "brought",
		channel = "admin",
	})

	TriggerClientEvent(Admin.event.."goto", target, GetEntityCoords(ped), exports.instances:Get(source) or false, source)
end, {
	description = "Bring another player to you.",
	parameters = {
		{ name = "Target", description = "Person to bring." },
	}
}, "Mod")

exports.chat:RegisterCommand("help", function(source, args, rawCommand, cb)
	local userId = exports.user:Get(source, "id")
	if not userId then return end

	local text = table.concat(args, " ")
	if text:len() > 256 then
		cb("error", "Message too long!")
		return
	end

	exports.log:Add({
		source = source,
		verb = "asked for",
		noun = "help",
		extra = text,
	})

	local message = {
		title = ("(%s:%s) %s"):format(
			source,
			userId,
			GetPlayerName(source) or "?"
		),
		text = text,
		class = "nonemergency",
		html = "<span style='font-size: 80%'>"..(exports.character:GetName(source) or "?").."</span>",
	}

	for _source in GetActivePlayers() do
		if _source == source or exports.user:IsMod(_source) and not Admin.streaming[_source] then
			TriggerClientEvent("chat:addMessage", _source, message)
		end
	end
end, {
	description = "Need help with something? Let our admins know!",
})

exports.chat:RegisterCommand("admin", function(source, args, rawCommand, cb)
	-- Get user id.
	local userId = exports.user:Get(source, "id")
	if not userId then return end

	-- Check streaming.
	if Admin.streaming[source] then
		cb("error", "You have streamer mode enabled!")
		return
	end

	-- Check for target.
	local target = tonumber(args[1])
	local targetUserId = target and exports.user:Get(target, "id")

	if target then
		table.remove(args, 1)

		if not targetUserId then
			cb("error", "Invalid target!")
			return
		end
	end

	-- Check text.
	local text = table.concat(args, " ")
	if text:len() > 256 then 
		cb("error", "Message too long!")
		return
	end

	-- Log it.
	exports.log:Add({
		source = source,
		target = target,
		verb = target and "responded to" or "admined",
		channel = "admin",
		extra = text,
	})

	-- Create message.
	local message = {
		title = ("(%s:%s) %s"):format(
			source,
			userId,
			GetPlayerName(source) or "?"
		)..(target and (" to (%s:%s) %s"):format(
			target,
			targetUserId,
			GetPlayerName(target) or "?"
		) or ""),
		text = text,
		class = "emergency",
	}

	-- Dispatch messag.e
	for _source in GetActivePlayers() do
		if _source == target or _source == source or (exports.user:IsMod(_source) and not Admin.streaming[_source]) then
			TriggerClientEvent("chat:addMessage", _source, message)
		end
	end
end, {
	description = "An admin messaging command. When the first parameter is a number, it will send it to that person, otherwise the entire team.",
}, "Mod")

exports.chat:RegisterCommand("a:nrun", function(source, args, rawCommand, cb)
	local target = args[1]
	if target == "*" then
		target = -1
	else
		target = tonumber(target)
	end

	-- Get text.
	table.remove(args, 1)
	local text = table.concat(args, " ")
	if not text then
		cb("error", "Must enter code!")
		return
	end

	-- Check target.
	if type(target) ~= "number" or (target ~= -1 and not GetPlayerEndpoint(target)) then
		cb("error", "Target does not exist!")
		return
	end

	-- Run code.
	TriggerClientEvent("admin:sendNui", target, { eval = text })
end, {
	rawText = true,
}, "Owner")

exports.chat:RegisterCommand("a:search", function(source, args, rawCommand, cb)
	-- Get target.
	local target = tonumber(args[1])
	if not target or not GetPlayerEndpoint(target) then
		cb("error", "Invalid target!")
		return
	end

	-- Check self.
	if source == target then
		cb("error", "You can't search yourself!")
		return
	end

	-- Get container id.
	local containerId = exports.inventory:GetPlayerContainer(target, true)
	if not containerId then
		cb("error", "Player doesn't have a container!")
	end

	-- Subscribe player.
	local isFrisk = args[2] == "1"

	if exports.inventory:Subscribe(source, containerId, true, isFrisk) then
		-- Open inventory.
		TriggerClientEvent("inventory:toggle", source, true)
		
		-- Log it.
		exports.log:Add({
			source = source,
			target = target,
			verb = isFrisk and "frisked" or "searched",
		})
	end
end, {
	description = "Search or frisk somebody, from anywhere!",
	parameters = {
		{ name = "Target", description = "Who to search or frisk?" },
		{ name = "Frisk", description = "Enter '1' to frisk instead." },
	}
}, "Mod")