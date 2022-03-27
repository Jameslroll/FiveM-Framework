Main = {}
Main.groups = {}

function Main:Init()
	-- Cache groups.
	for id, data in ipairs(Config.Groups) do
		data.id = "DEFAULT_"..id
		self:RegisterGroup(data)
	end
end

function Main:RegisterGroup(data)
	return Group:Create(data)
end