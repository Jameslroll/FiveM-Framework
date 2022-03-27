Chat.isClient = true

--[[ Functions ]]--
function Chat:Init()
	-- local commands = GetRegisteredCommands()
	-- for k, command in ipairs(commands) do
	-- 	local name = command.name or ""
	-- 	local firstChar = name:sub(1, 1)
	-- 	if name ~= "" and firstChar ~= "+" and firstChar ~= "-" then
	-- 		Menu:Commit("addSuggestion", { name = command.name or ""})
	-- 	end
	-- end
end

function Chat:Update()
	if Menu.hasFocus then
		Menu:Update()
	elseif IsControlJustPressed(0, 245) then
		Menu:Focus(true)
	end
end

function Chat:_RegisterCommand(command, isServer)
	-- Register command (native).
	if not isServer then
		RegisterCommand(command.name, InvokeCommand, false)
	end
	
	-- Update suggestions.
	if Menu.hasLoaded then
		self:AddSuggestion(command)
	else
		Citizen.CreateThread(function()
			while not Menu.hasLoaded do
				Citizen.Wait(0)
			end
			Chat:AddSuggestion(command)
		end)
	end
end

function Chat:AddSuggestion(command)
	local settings = command.settings or {}
	
	Menu:Commit("addSuggestion", {
		name = command.name,
		description = settings.description,
		parameters = settings.parameters,
	})
end

function Chat:AddMessage(message)
	if type(message) == "string" then
		message = {
			text = message,
			class = "system",
		}
	end

	Menu:Commit("addMessage", message)
end

function Chat:AddToast(toast, class)
	if type(toast) == "string" then
		toast = {
			text = toast,
			class = class or "inform",
		}
	end

	Menu:Commit("addToast", toast)
end

function Chat:Submit(text)
	-- Remove delimiters.
	local firstChar = text:sub(1, 1)
	
	local firstByte = firstChar:byte()
	if not firstByte then return end

	if (firstByte < 97 and firstByte > 90) or firstByte < 65 or firstByte > 122 then
		text = text:sub(2)
	end

	-- Check empty.
	if text == "" or text == " " then return end

	-- Execute command.
	ExecuteCommand(text)
end

Chat:ExportAll()

--[[ NUI Callbacks ]]
RegisterNUICallback("submit", function(data, cb)
	cb(true)

	Menu:Focus(false)
	Chat:Submit(data.text)
end)

RegisterNUICallback("close", function(data, cb)
	cb(true)

	Menu:Focus(false)
end)

--[[ Commands ]]--
RegisterCommand("chat", function(source, args, command)
	Menu:Focus(false)
end)

--[[ Events ]]--
AddEventHandler("chat:clientStart", function()
	Chat:Init()
end)

RegisterNetEvent("chat:addMessage", function(...)
	Chat:AddMessage(...)
end)

RegisterNetEvent("chat:notify", function(...)
	Chat:AddToast(...)
end)

RegisterNetEvent("chat:registerCommands", function(commands)
	for name, settings in pairs(commands) do
		Chat:_RegisterCommand({
			name = name,
			settings = settings,
		}, true)
	end
end)

RegisterNetEvent("chat:registerCommand", function(name, settings)
	Chat:_RegisterCommand({
		name = name,
		settings = settings,
	}, true)
end)

--[[ Threads ]]--
Citizen.CreateThread(function()
	while true do
		Chat:Update()
		Citizen.Wait(0)
	end
end)