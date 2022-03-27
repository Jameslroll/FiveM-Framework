Casino = {
	games = {}
}

function Casino:Init()
	for _, game in ipairs(self.games) do
		if game.Init then
			game:Init()
		end
	end
end

function Casino:Register(game)
	table.insert(self.games, game)
end

--[[ Events ]]--
AddEventHandler("casino:start", function()
	Casino:Init()
end)