Restraints = Restraints or {}
Restraints.players = {}

--[[ Functions: Restraints ]]--
function Restraints:UseItem(source, target, slotId)
	-- Get player container id.
	local containerId = exports.inventory:GetPlayerContainer(source, true)
	if not containerId then return false end

	-- Get item in slot.
	local item = exports.inventory:ContainerInvokeSlot(containerId, slotId, "GetItem")
	if not item then return false end

	local name = item.name

	-- Get info.
	local info = self.items[name]
	if not info then return false end

	-- Check state.
	local state = self.players[target]
	local stateInfo = state and self.items[state]

	if (info.Restraint and state) or (not info.Restraint and (not stateInfo or not stateInfo.Counters[name])) then return false end
	
	-- Play emote.
	if info.Anim and info.Shared then
		exports.emotes:PlayShared(source, target, Restraints.anims[info.Anim])
	end

	-- Inform target of usage.
	TriggerClientEvent("players:restrainBegin", target, name)

	-- Cache player.
	self.players[target] = name
	
	-- Timeout to finish usage.
	Citizen.SetTimeout(info.Duration or 0, function()
		Restraints:Finish(target, name)
	end)

	return info.Restraint and 1 or 2
end

function Restraints:Finish(target, name)
	local info = name and self.items[name]
	local state = self.players[target]

	-- Check resisting.
	if state == "resist" then
		self.players[target] = nil
		return
	end

	-- Reset state.
	if not info or not info.Restraint then
		self.players[target] = nil
	end

	-- Tell target to restrain/unrestrain.
	TriggerClientEvent("players:restrainFinish", target, name)
end

--[[ Events: Net ]]--
RegisterNetEvent("players:restrain", function(slotId, target)
	local source = source

	if type(slotId) ~= "number" or type(target) ~= "number" or target <= 0 then return end

	local success, item = Restraints:UseItem(source, target, slotId)
	if success then
		exports.log:Add({
			source = source,
			target = target,
			verb = success == 2 and "freed" or "restrained",
			extra = item,
		})
	end
end)

RegisterNetEvent("players:restrainResist", function()
	local source = source
	local state = Restraints.players[source]
	
	if not state or state == "resist" then return end
	
	Restraints.players[source] = "resist"

	exports.log:Add({
		source = source,
		verb = "resisted",
		noun = "restraints",
	})
end)