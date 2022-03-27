Main = {}

function Main:Init()
	self.instances = {}

	for k, teleporter in ipairs(Config.Teleporters) do
		self:Register(teleporter.From)
		self:Register(teleporter.To)
	end
end

function Main:Register(info)
	local isTable = type(info) == "table"
	if isTable and info.Instance then
		exports.instances:Create(info.Instance, {
			persistent = true,
		})
	end
end

AddEventHandler("teleporters:start", function()
	Main:Init()
end)