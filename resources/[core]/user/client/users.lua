function User:Create(data)
	return setmetatable(data, User)
end