RegisterNetEvent("iamafk")
AddEventHandler("iamafk", function()
	local source = source
	DropPlayer(source, "AFK")
end)