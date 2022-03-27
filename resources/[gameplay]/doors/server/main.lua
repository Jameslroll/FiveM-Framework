Main.players = {}

--[[ Functions: Main ]]--
function Main:Subscribe(source, groupId)
	local group = self.groups[groupId or false]
	if not group then
		groupId = nil
	end

	local lastGroup = self.players[source]
	if lastGroup == group then return end
	
	-- Cache player group.
	self.players[source] = group

	-- Remove from last group.
	if lastGroup then
		lastGroup:RemovePlayer(source)
	end

	-- Add player to group.
	if group then
		group:AddPlayer(source)
	end
end

function Main:SetState(groupId, coords, state)
	local group = self.groups[groupId or false]
	if not group then return false end
	
	return group:SetState(coords, state)
end

--[[ Events: Net ]]--
RegisterNetEvent("doors:subscribe", function(groupId)
	local source = source

	-- Check cooldown.
	if not PlayerUtil:CheckCooldown(source, 1.0, true, "subscribe") then return end
	
	-- Subscribe player to group.
	Main:Subscribe(source, groupId)
end)

RegisterNetEvent("doors:toggle", function(groupId, coords, state)
	local source = source

	-- Check input.
	if type(coords) ~= "vector3" or (state ~= nil and type(state) ~= "boolean") then return end

	-- Check cooldown.
	if not PlayerUtil:CheckCooldown(source, 1.0, true, "toggle") then return end

	-- Check active group.
	local group = Main.players[source]
	if not group or group.id ~= groupId then return end

	-- Set state and log.
	if Main:SetState(groupId, coords, state) then
		exports.log:Add({
			source = source,
			verb = state and "locked" or "unlocked",
			noun = "door",
			extra = ("%.2f %.2f %.2f"):format(coords.x, coords.y, coords.z),
		})
	end
end)

--[[ Events ]]--
AddEventHandler("doors:start", function()
	Main:Init()
end)

AddEventHandler("playerDropped", function(reason)
	local source = source

	if Main.players[source] then
		Main:Subscribe(source, nil)
	end
end)