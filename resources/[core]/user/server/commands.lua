local targetDescription = "There are several methods to ban somebody: server ID (<number>), user ID (:<number>), Steam (steam:<hex>, <hex>, or <binary>), or other identifier (identifier:<value>). Other identifiers include license, license2, discord, endpoint, xbl, live, and tokens."

exports.chat:RegisterCommand("a:ban", function(source, args, command, cb)
	local target, duration = args[1], tonumber(args[2])

	table.remove(args, 1)
	table.remove(args, 1)

	local reason = table.concat(args, " ")
	
	if reason == "" then
		reason = nil
	end
	
	local retval, result = Main:Ban(target, duration, reason)
	if retval then
		cb("success", ("Banned %s!"):format(result))

		exports.log:Add({
			source = source,
			verb = "banned",
			extra = ("%s - %s"):format(result, reason or "No reason specified"),
			channel = "admin"
		})
	else
		cb("error", ("Couldn't ban: %s (%s)"):format(target, result))
	end
end, {
	description = "Pull out the hammer.",
	parameters = {
		{ name = "Target", description = targetDescription },
		{ name = "Duration", description = "How long, in hours, their ban is (default = 0). Zero is permanent." },
		{ name = "Reason", description = "What is the reason (default = 'No reason specified')?" },
	},
}, "Mod")

exports.chat:RegisterCommand("a:unban", function(source, args, command, cb)
	local target = args[1]
	local retval, result = Main:Unban(target)

	if retval then
		cb("success", ("Unbanned %s!"):format(result))

		exports.log:Add({
			source = source,
			verb = "unbanned",
			extra = ("%s"):format(result),
			channel = "admin"
		})
	else
		cb("error", ("Couldn't unban: %s (%s)"):format(target, result))
	end
end, {
	description = "Lift a ban tied to a certain identifier.",
	parameters = {
		{ name = "Target", description = targetDescription },
	},
}, "Mod")

exports.chat:RegisterCommand("a:kick", function(source, args, command, cb)
	local target = tonumber(args[1])
	local guid = target and target > 0 and GetPlayerGuid(target)

	if not guid then
		cb("error", ("Player not found: [%s]"):format(target or "None"))
		return
	end

	table.remove(args, 1)

	local reason = table.concat(args, " ")
	
	cb("success", ("Kicked [%s]!"):format(target))
	
	exports.log:Add({
		source = source,
		target = target,
		verb = "kicked",
		extra = reason and "reason: "..reason,
		channel = "admin"
	})

	DropPlayer(target, Server.Kicked.Default..(reason and Server.Kicked.Reason:format(reason) or ""))
end, {
	description = "Pull out the hammer.",
	parameters = {
		{ name = "Target", description = "Enter the server id of the player being kicked." },
		{ name = "Reason", description = "Your reason for the kick (default = None)." },
	},
}, "Mod")

RegisterCommand("mimic", function(source, args, command)
	if source ~= 0 then return end

	local endpoint, user = args[1], tonumber(args[2])

	Main:Mimic(endpoint, user)
end, true)

RegisterCommand("whitelist", function(source, args, command)
	if source ~= 0 then return end

	local action = args[1]
	local hex = GetHex(args[2])

	local toAdd = action == "add"
	local toRemove = not toAdd and action == "remove"

	if hex and (toAdd or toRemove) then
		if Main:Whitelist(hex, toAdd) then
			print(("steam:%s %s whitelist"):format(hex, toAdd and "added to" or "removed from"))
		else
			print(("%s is already %s"):format(hex, toAdd and "whitelisted" or "unwhitelisted"))
		end
	else
		print("Invalid format: whitelist <add/remove> <Steam hex or decimal>")
	end
end)

RegisterCommand("status", function(source, args, command)
	if source ~= 0 then return end

	local numPlayers = GetNumPlayerIndices()
	local maxPlayers = GetConvarInt("sv_maxClients", 32)
	
	print(numPlayers.."/"..maxPlayers.." players")

	for i = 1, numPlayers do
		local player = tonumber(GetPlayerFromIndex(i - 1))
		local user = Main.users[player]

		print(player..":"..(user and user.id or "?"), GetPlayerName(player), GetPlayerLastMsg(player).."ms")
	end
end, true)