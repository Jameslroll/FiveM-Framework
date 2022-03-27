Main = {}

--[[ Functions: Main ]]--
function Main:Export(name)
	exports(name, function(...)
		return Main[name](Main, ...)
	end)
end