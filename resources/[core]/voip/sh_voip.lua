Voip = {}
Voip.debug = false

--[[ Functions ]]--
function Voip:Debug(str, ...)
	if not self.debug then return end

	if #{...} > 0 then
		print(str:format(...))
	else
		print(str)
	end
end

function Voip:Export(name)
	exports(name, function(...)
		return self[name](self, ...)
	end)
end