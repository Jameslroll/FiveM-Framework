--[[ Keys ]]--
RegisterCommand("+roleplay_inventory", function()
	local value = not Menu.hasFocus
	if value and not IsControlEnabled(0, 51) then
		return
	end

	-- Toggle menu.
	Menu:Focus(value)

	-- Emote.
	local ped = PlayerPedId()
	if value and not exports.emotes:IsPlaying() and not IsPedArmed(ped, 1 | 2 | 4) then
		exports.emotes:Play(Config.Toggle.Anim)
	end
end, true)

RegisterKeyMapping("+roleplay_inventory", "Inventory - Toggle", "keyboard", "tab")

--[[ Binds ]]--
for k, v in ipairs(Config.Binds) do
	local bind = "+roleplay_quickSlot"..tostring(k)

	RegisterCommand(bind, function()
		if
			not IsControlEnabled(0, 51) or
			not IsControlEnabled(0, 52)
		then
			return
		end

		Binds:Invoke(k)
	end, true)

	RegisterKeyMapping(bind, "Inventory - Quick Slot "..tostring(k), "keyboard", v.key)
end

--[[ Other ]]--
for _, command in ipairs({
	"cash",
	"money",
	"wallet",
}) do
	exports.chat:RegisterCommand(command, function(source, args, command)
		local container = Inventory:GetPlayerContainer()
		local amount = container and container:CountMoney(true) or 0.0
	
		local dollars = tostring(math.floor(amount)):reverse():gsub("%d%d%d", "%1,"):reverse():gsub("^,", "")
		local cents = math.floor((amount % 1.0) * 100.0)
	
		TriggerEvent("chat:notify", {
			class = "inform",
			text = ("$%s %s¢"):format(dollars, cents),
			duration = 15000,
		})
	end, {
		description = "Count up your money."
	})
end