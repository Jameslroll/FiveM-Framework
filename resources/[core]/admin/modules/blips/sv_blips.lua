Blips = {}

local function GetTrackerGroup(source)
	return (
		(exports.user:IsMod(source) and "admin") or
		(exports.user:HasFlag(source, "POOR_ROLEPLAY") and "bad") or
		(exports.user:HasFlag(source, "POSSIBLE_CHEATER") and "cheater") or
		"default"
	)
end

local function JoinTrackerGroup(source)
	if not source then return end

	local group = GetTrackerGroup(source)
	exports.trackers:JoinGroup("admin", source, group, Blips[source] and 6 or 2)
end

--[[ Events: Net ]]--
RegisterNetEvent(Admin.event.."ready", function()
	local source = source
	JoinTrackerGroup(source)
end)

RegisterNetEvent(Admin.event.."toggleBlips", function(value)
	local source = source
	
	if type(value) ~= "boolean" or not exports.user:IsMod(source) then return end

	exports.log:Add({
		verb = "toggled",
		noun = "blips",
		extra = value and "on" or "off",
	})

	Blips[source] = value or nil

	JoinTrackerGroup(source)
end)

--[[ Events ]]--
AddEventHandler(Admin.event.."start", function()
	exports.trackers:CreateGroup("admin", {
		delay = 3000,
		states = {
			[1] = { -- Peds.
				["default"] = {
					Colour = 0,
				},
				["admin"] = {
					Colour = 8,
				},
				["police"] = {
					Colour = 3,
				},
				["bad"] = {
					Colour = 1,
				},
				["cheater"] = {
					Colour = 40,
				},
			},
		},
	})
end)

AddEventHandler("character:selected", function(source, character, wasActive)
	JoinTrackerGroup(source)
end)

AddEventHandler("user:set", function(source, key, value)
	print(source, key, value)
	if key == "flags" then
		JoinTrackerGroup(source)
	end
end)