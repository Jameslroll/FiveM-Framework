Main = Main or {}
Main.event = GetCurrentResourceName()..":"

--[[ Events ]]--
AddEventHandler("onResourceStart", function(resourceName)
	TriggerEvent(resourceName..":start")
end)

AddEventHandler("onResourceStop", function(resourceName)
	TriggerEvent(resourceName..":stop")
end)