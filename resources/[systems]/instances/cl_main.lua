Main = {}

--[[ Exports ]]--
function IsInstanced()
	return Main.instance ~= nil
end
exports("IsInstanced", IsInstanced)

function GetInstance()
	return Main.instance
end
exports("GetInstance", GetInstance)

--[[ Events ]]--
RegisterNetEvent("instances:inform", function(...)
	print(...)
end)

RegisterNetEvent("instances:join", function(id)
	Main.instance = id
end)

RegisterNetEvent("instances:leave", function(id)
	if Main.instance == id then
		Main.instance = nil
	end
end)