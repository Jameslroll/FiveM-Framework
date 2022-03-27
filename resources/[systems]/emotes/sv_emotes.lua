Main = {
	players = {},
	emotes = {},
}

--[[ Functions ]]--
function Main:Init()
	for _, group in ipairs(Config.Groups) do
		for name, emote in pairs(group.Emotes) do
			self.emotes[name] = emote
		end
	end
end

function Main:PlayShared(source, target, data)
	-- Schedule the time.
	local delay = math.max(GetPlayerPing(source) or 200, GetPlayerPing(target) or 200) + 100
	local time = GetGameTimer() + delay

	-- Update server id.
	data.Target.ServerId = source

	-- Send the anims.
	TriggerClientEvent("emotes:playData", source, data.Source, false, time)
	TriggerClientEvent("emotes:playData", target, data.Target, false, time)
end

function Main:Invite(source, name)
	-- Check emote.
	local emote = self.emotes[name]
	if not emote or not emote.Source or not emote.Target then return end

	-- Check cache.
	if self.players[source] then
		return false
	end

	-- Cache.
	self.players[source] = name

	Citizen.SetTimeout(12000, function()
		self.players[source] = nil
	end)
	
	-- Broadcast invite.
	exports.players:Broadcast(source, "emotes:invite", source, name)

	return true
end

function Main:Accept(source, target, name)
	if self.players[target] ~= name then
		return false
	end

	local emote = self.emotes[name]
	if not emote then
		return false
	end

	-- Play emote.
	self:PlayShared(target, source, emote)

	-- Uncache.
	self.players[target] = nil

	-- Broadcast.
	exports.players:Broadcast(target, "emotes:expire", target)

	return true
end

--[[ Events: Net ]]--
RegisterNetEvent("emotes:invite", function(name)
	local source = source

	-- Check cooldown.
	if not PlayerUtil:CheckCooldown(source, 14.0) then return end
	PlayerUtil:UpdateCooldown(source)

	-- Check name.
	if type(name) ~= "string" then return end
	
	-- Send invite.
	if Main:Invite(source, name) then
		exports.log:Add({
			source = source,
			verb = "invited",
			noun = "emote",
			extra = name,
		})
	end
end)

RegisterNetEvent("emotes:accept", function(target, name)
	local source = source

	if type(target) ~= "number" or type(name) ~= "string" then return end

	if Main:Accept(source, target, name) then
		exports.log:Add({
			source = source,
			target = target,
			verb = "accepted",
			noun = "emote",
			extra = name,
		})
	end
end)

--[[ Events ]]--
AddEventHandler("emotes:start", function()
	Main:Init()
end)

--[[ Exports ]]--
exports("PlayShared", function(...)
	Main:PlayShared(...)
end)

exports("Invite", function(...)
	Main:Invite(...)
end)