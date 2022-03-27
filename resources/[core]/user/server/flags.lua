function User:SetFlag(flag, value)
	if type(flag) == "string" then
		flag = FlagEnums[flag]
	end

	if type(flag) ~= "number" then return end

	local flags = self.flags
	local mask = 1 << flag

	if not flags then
		flags = 0
	end

	if value and value ~= 0 then
		flags = flags | mask
	else
		flags = flags & (~mask)
	end

	self:Set("flags", flags)
end

for _, funcName in ipairs({
	"SetFlag",
	"HasFlag",
	"IsDev",
	"IsMod",
	"IsAdmin",
	"IsOwner",
}) do
	local func = User[funcName]
	Main[funcName] = function(self, source, ...)
		local user = self:GetUser(source)
		if not user then return end
	
		return func(user, ...)
	end
	Export(Main, funcName)
end