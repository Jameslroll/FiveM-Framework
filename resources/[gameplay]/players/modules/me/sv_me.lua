--[[ Functions ]]--
function AddText(source, text, distance)
	-- Get ped.
	local ped = GetPlayerPed(source)
	if not ped or not DoesEntityExist(ped) then return end
	
	-- Check text.
	if type(text) ~= "string" then return end

	-- Sanitize text.
	text = Sanitize(text)

	-- Check length.
	if text:len() > 256 then
		TriggerClientEvent("chat:notify", source, {
			class = "error",
			text = "Too many characters (256 characters).",
		})

		return
	end

	-- Log it.
	exports.log:Add({
		source = source,
		verb = "did",
		extra = text,
	})

	-- Broadcast message.
	Main:Broadcast(source, "players:me", NetworkGetNetworkIdFromEntity(ped), text, distance)
end

--[[ Commands ]]--
exports.chat:RegisterCommand("me", function(source, args, command)
	-- Check cooldown.
	if not PlayerUtil:CheckCooldown(source, 3.0) then return end
	PlayerUtil:UpdateCooldown(source)
	
	-- Add text.
	AddText(source, table.concat(args, " "), 30.0)
end, {
	description = "Perform an action. If the first letter is a part of your body, it will attach it to that limb.",
})

exports.chat:RegisterCommand("meshort", function(source, args, command)
	-- Check cooldown.
	if not PlayerUtil:CheckCooldown(source, 3.0) then return end
	PlayerUtil:UpdateCooldown(source)
	
	-- Add text.
	AddText(source, table.concat(args, " "), 5.0)
end, {
	description = "Perform an action, but with a smaller range. If the first letter is a part of your body, it will attach it to that limb.",
})