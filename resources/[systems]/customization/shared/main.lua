IsDebug = false

function Debug(...)
	if not IsDebug then return end
	print(...)
end