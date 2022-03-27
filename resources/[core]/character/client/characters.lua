function Character:Create(data)
	if not data.id then return end

	data = setmetatable(data, self)

	Main.ids[data.id] = data
	
	return data
end