Main = {
	event = GetCurrentResourceName()..":",
	factions = {},
}

--[[ Functions ]]--
function Main:Load(factions)
	self.factions = {}

	for _, info in ipairs(factions) do
		local faction = self.factions[info.name]
		if not faction then
			faction = {}
			self.factions[info.name] = faction
		end

		faction[info.group or ""] = {
			level = info.level,
			fields = info.fields or {},
		}
	end
end

function Main:JoinFaction(name, groupName, level, fields)
	local faction = self.factions[name]
	if not faction then
		faction = {}
		self.factions[name] = faction
	end

	faction[groupName or ""] = {
		level = level or 0,
		fields = fields or {},
	}

	return true
end

function Main:LeaveFaction(name, groupName)
	local faction = self.factions[name]
	if not faction then return false end

	faction[groupName or ""] = nil

	return true
end

function Main:UpdateFaction(name, groupName, key, value)
	local faction = self.factions[name]
	if not faction then return false end

	local group = faction[groupName or ""]
	if not group then return false end

	if key == "fields" then
		group = group.fields
	end

	group[key] = value
end

function Main:Unload()
	self.factions = {}
end

function Main:Has(...)
	return self:Get(...) ~= nil
end

function Main:Get(name, group)
	group = group or ""

	local faction = self.factions[name]
	if not faction then return end

	return faction[group]
end

function Main:GetFactions()
	return self.factions
end

--[[ Exports ]]--
for k, v in pairs(Main) do
	if type(v) == "function" then
		exports(k, function(...)
			return Main[k](Main, ...)
		end)
	end
end

--[[ Events: Net ]]--
RegisterNetEvent(Main.event.."load", function(factions)
	print("Loading factions...")
	Main:Load(factions)
end)

RegisterNetEvent(Main.event.."join", function(...)
	Main:JoinFaction(...)
end)

RegisterNetEvent(Main.event.."leave", function(...)
	Main:LeaveFaction(...)
end)

RegisterNetEvent(Main.event.."update", function(...)
	print("update", Main:UpdateFaction(...))
end)

--[[ Events ]]--
AddEventHandler("character:selected", function(character)
	if not character then
		Main:Unload()
	end
end)