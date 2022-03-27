RegisterNetEvent("admin:delete", function(netId)
	local source = source

	if not exports.user:IsMod(source) or type(netId) ~= "number" then return end

	local entity = NetworkGetEntityFromNetworkId(netId)
	if not entity then return end

	DeleteEntity(entity)
	
	exports.log:Add({
		source = source,
		verb = "deleted",
		noun = "entity",
		extra = netId,
	})
end)