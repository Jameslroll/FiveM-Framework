Chat = {
	commands = {}
}

--[[ Functions ]]--
function InvokeCommand(...) Chat:InvokeCommand(...) end
function Chat:InvokeCommand(source, args, text)
	local name = text:match("([^%s]+)")
	if not name then return end

	local command = self.commands[name:lower()]
	if command == nil then return end

	local settings = command.settings or {}

	-- Check user group.
	if source ~= 0 and settings.group and not exports.user["Is"..settings.group](exports.user, self.isServer and source or nil) then
		local toast = {
			class = "error",
			text = ("Incorrect user group (%s)!"):format(settings.group),
		}

		if self.isClient then
			Chat:AddToast(toast)
		else
			TriggerClientEvent("chat:notify", source, toast)
		end
		
		return
	end

	-- Execute callback.
	if command.callback ~= nil then
		command.callback(source, args, text, function(class, message)
			local toast = {
				class = class,
				text = message,
			}
	
			if self.isClient then
				Chat:AddToast(toast)
			else
				if source == 0 then
					print(message)
				else
					TriggerClientEvent("chat:notify", source, toast)
					print(("[%s] /%s: %s (%s)"):format(source, name, message, class))
				end
			end
		end)
	end
end

function Chat:RegisterCommand(name, callback, settings, group)
	if type(name) ~= "string" then return end

	settings = settings or {}

	if type(group) == "string" then
		settings.group = group
	end

	local command = {
		name = name,
		callback = callback,
		settings = settings,
	}

	self.commands[name] = command

	self:_RegisterCommand(command)
end

function Chat:ExportAll()
	for k, v in pairs(Chat) do
		if type(v) == "function" then
			exports(k, function(...)
				return Chat[k](Chat, ...)
			end)
		end
	end
end

Chat:ExportAll()