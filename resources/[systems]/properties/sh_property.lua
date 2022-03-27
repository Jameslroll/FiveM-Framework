Property = {}
Property.__index = Property

function Property:Create(info)
	if not info or not info.id then
		error("invalid property definition (no info or id)")
	end

	local property = setmetatable(info, Property)

	return property
end

function Property:HasKey(id)
	if not self.keys then return false end
	return self.keys[id]
end