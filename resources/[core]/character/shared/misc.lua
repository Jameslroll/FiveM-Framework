function CheckName(name)
	if name:match("[^%a]") ~= nil then
		return false
	end

	local len = name:len()
	if len < 3 or len > 32 then
		return false
	end

	return true
end