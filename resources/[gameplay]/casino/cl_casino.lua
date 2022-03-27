--[[ Functions ]]--
function Casino:Activate(name, ...)
	local game = _G[name]
	if not game or not game.Activate then
		error(("invalid game (global: %s, name: %s)"):format(tostring(game), name))
	end

	game:Activate(...)
	self.game = game
end

function Casino:Deactivate(game, ...)
	if not self.game then return end

	self.game:Deactivate(...)
	self.game = nil
end

--[[ Threads ]]--
Citizen.CreateThread(function()
	while true do
		local game = Casino.game
		if game and game.Update then
			game:Update()
		end
		
		Citizen.Wait(0)
	end
end)

--[[ Events ]]--
AddEventHandler("casino:clientStart", function()
	Casino:Init()
end)