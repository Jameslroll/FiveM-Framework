RegisterNetEvent(Admin.event.."viewContainer", function(id)
	local source = source
	
	if not id or not exports.user:IsMod(source) then return end

	exports.inventory:ContainerSubscribe(id, source, true)
end)

RegisterNetEvent(Admin.event.."requestContainers", function()
	local source = source
	
	if not exports.user:IsMod(source) then return end

	TriggerClientEvent(Admin.event.."receiveContainers", source, exports.inventory:GetContainers())
end)