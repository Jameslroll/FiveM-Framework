local Users = {}
local Viewing = {}

--[[ Functions ]]--
local function Inform(id, event, ...)
	local cached = Users[id]
	if not cached then return end

	for source, _ in pairs(cached) do
		TriggerClientEvent(Admin.event..event, source, ...)
	end
end

--[[ Events ]]--
RegisterNetEvent(Admin.event.."lookupUser", function(data)
	local source = source

	if not data or not exports.user:IsMod(source) then return end

	-- Get query and values.
	local query, values
	local userId = tonumber(data)

	if userId then
		query = "`id`=@userId"
		values = {
			["@userId"] = userId,
		}
	else
		local key, value = data:match("([^:]+):([^:]+)")
		if not value then return end
		
		query = ("`%s`=@value"):format(key)
		values = {
			["@value"] = value
		}
	end

	-- Check query.
	if not query then
		TriggerClientEvent("chat:notify", source, {
			class = "error",
			text = "Invalid input!",
		})

		return
	end

	-- Get user.
	local user = exports.GHMattiMySQL:QueryResult("SELECT * FROM `users` WHERE "..query, values)[1]
	if not user then
		TriggerClientEvent("chat:notify", source, {
			class = "error",
			text = "User not found!",
		})

		return
	end

	-- Update user.
	user.endpoint = nil
	user.tokens = nil
	user.first_joined = DateFromTime(user.first_joined)
	user.last_played = DateFromTime(user.last_played)
	
	-- Get characters.
	local characters = {}
	local characters = exports.GHMattiMySQL:QueryResult("SELECT * FROM `characters` WHERE `user_id`="..user.id)
	
	for k, character in ipairs(characters) do
		local dob, age = DateFromTime(character.dob)
		character.dob = dob
		character.age = age
	end

	-- Get warnings.
	-- local warnings = exports.GHMattiMySQL:QueryResult("SELECT * FROM `warnings` WHERE `user_id`=@userId".., {
	-- 	["@userId"] = user.id
	-- })

	local warnings = {}

	-- Send user.
	TriggerClientEvent(Admin.event.."receiveUser", source, user, characters, warnings)

	-- Update cache.
	Viewing[source] = user.id

	local cached = Users[user.id]
	if not cached then
		cached = {}
		Users[user.id] = cached
	end
	cached[source] = true
end)

RegisterNetEvent(Admin.event.."unsubscribeUser", function()
	local source = source
	local target = Viewing[source]
	if not target then return end

	Viewing[source] = nil
	
	local cached = Users[target]
	if cached then
		cached[source] = nil
		local next = next
		if next(cached) == nil then
			Users[target] = nil
		end
	end
end)

RegisterNetEvent(Admin.event.."setFlag", function(flag, value)
	local source = source

	if type(flag) ~= "number" or type(value) ~= "boolean" or not exports.user:IsAdmin(source) then return end

	-- Get target.
	local targetId = Viewing[source]
	if not targetId then return end

	-- Check flags.
	local flagEnums = exports.user:GetFlags()
	if flag == flagEnums["IS_OWNER"] or (flag == flagEnums["IS_ADMIN"] and not exports.user:IsOwner(source)) then return end

	-- Get user.
	local target = exports.user:GetPlayer(targetId)

	-- Get flags.
	local flags = target and exports.user:Get(target, "flag") or exports.GHMattiMySQL:QueryScalar("SELECT `flags` FROM `users` WHERE `id`=@id LIMIT 1", {
		["@id"] = targetId,
	}) or 0

	-- Update flags.
	local mask = 1 << flag

	if value then
		flags = flags | mask
	else
		flags = flags & (~mask)
	end

	print(flags)

	-- Log event.
	exports.log:Add({
		source = source,
		verb = "updated",
		noun = "flags",
		extra = ("%s->%s (%s)"):format(flag, value, targetId),
		channel = "admin",
	})

	-- Update user.
	if target then
		exports.user:Set(target, "flags", flags)
	else
		exports.GHMattiMySQL:QueryAsync("UPDATE `users` SET `flags`=@flags WHERE `id`=@id", {
			["@id"] = targetId,
			["@flags"] = flags,
		})
	end

	-- Sync changes.
	Inform(targetId, "updateFlags", flags)
end)