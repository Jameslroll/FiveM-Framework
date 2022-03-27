--[[ Hooks ]]--
Admin:AddHook("toggle", "playerBlips", function(value)
	TriggerServerEvent(Admin.event.."toggleBlips", value)
end)