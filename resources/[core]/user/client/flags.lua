for _, funcName in ipairs({
	"HasFlag",
	"IsDev",
	"IsMod",
	"IsAdmin",
	"IsOwner",
}) do
	local func = User[funcName]
	Main[funcName] = function(self, ...)
		local user = self:GetUser()
		if not user then return false end
	
		return func(user, ...)
	end
	Export(Main, funcName)
end