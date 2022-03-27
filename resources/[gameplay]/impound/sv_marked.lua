Marked = {}
Marked.__index = Marked

function Marked:Create(entity)
	if not entity or not DoesEntityExist(entity) then return end

	return setmetatable({
		startLifetime = os.clock(),
		coords = GetEntityCoords(entity),
		entity = entity,
		netId = NetworkGetNetworkIdFromEntity(entity),
	}, Marked)
end

function Marked:Destroy()
	-- Check entity.
	local entity = self.entity
	if DoesEntityExist(entity) then
		local _entity = Entity(entity)
		_entity.state.shouldImpound = nil
	end

	-- Inform all.
	Marking:InformAll({
		remove = self.netId
	})
	
	-- Uncache.
	Marking.objects[entity] = nil
end