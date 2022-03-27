--[[ Functions ]]--
function Main:Set(key, value)
	if self.user == nil then
		self.user = User:Create()
	end
	self.user[key] = value
end
Export(Main, "Set")

function Main:Get(key)
	return self.user ~= nil and self.user[key]
end
Export(Main, "Get")

function Main:GetUser()
	return self.user
end
Export(Main, "GetUser")

function Main:GetIdentifier(identifier)
	local identifiers = self:Get("identifiers")
	return identifiers ~= nil and identifiers[identifier]
end
Export(Main, "GetIdentifier")

--[[ Events ]]--
RegisterNetEvent(Main.event.."sync")
AddEventHandler(Main.event.."sync", function(user)
	Main.user = User:Create(user)
	TriggerEvent(Main.event.."created", user)
end)

RegisterNetEvent(Main.event.."set")
AddEventHandler(Main.event.."set", function(key, value)
	Main:Set(key, value)
	TriggerEvent(Main.event.."updated", key, value)
end)