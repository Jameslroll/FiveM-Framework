Job = {
	viewing = {
		jobs = {},
		users = {},
	},
	update = {},
	statuses = {
		["Active"] = true,
		["Semi-active"] = true,
		["Inactive"] = true,
		["LOA"] = true,
		["ICU"] = true,
	},
}

function Jobs:GetPayload(id)
	local job = exports.jobs:GetJob(id or false)
	if not job then return end

	local roster = exports.GHMattiMySQL:QueryResult(([[
		SELECT
			`characters`.id,
			CONCAT(`characters`.first_name, ' ', `characters`.last_name) AS 'name',
			`factions`.level as 'rank',
			`factions`.fields,
			`factions`.join_time,
			`factions`.update_time
		FROM
			`factions`
		LEFT JOIN
			`characters` ON `characters`.id=`factions`.character_id
		WHERE
			`name`=@name AND
			`group`=%s
	]]):format(
		job.Group and "@group" or "NULL"
	), {
		["@name"] = job.Faction,
		["@group"] = job.Group,
	})

	-- Return payload.
	return {
		rosterData = roster,
	}
end

function Jobs:GetUserPayload(id, characterId)
	-- Get job.
	local job = exports.jobs:GetJob(id or false)
	if not job then return end

	-- Check target.
	if exports.GHMattiMySQL:QueryScalar(([[
		SELECT 1
		FROM
			`factions`
		WHERE
			`character_id`=@characterId AND
			`name`=@name AND
			`group`=%s
		LIMIT 1
	]]):format(
		job.Group and "@group" or "NULL"
	), {
		["@characterId"] = characterId,
		["@name"] = job.Faction,
		["@group"] = job.Group,
	}) ~= 1 then
		return
	end

	-- Query info.
	local phoneNumber = exports.GHMattiMySQL:QueryScalar("SELECT `phone_number` FROM `phones` WHERE `character_id`=@characterId", {
		["@characterId"] = characterId,
	}) or "?"

	local totalTime = exports.GHMattiMySQL:QueryScalar("SELECT SUM(end_time - start_time) FROM `jobs_sessions` WHERE `character_id`=@characterId AND `job_id`=@jobId", {
		["@characterId"] = characterId,
		["@jobId"] = id,
	})

	local times = exports.GHMattiMySQL:QueryResult([[
		SELECT
			`level`,
			SUM(end_time - start_time) AS `sum`
		FROM
			`jobs_sessions`
		WHERE
			`character_id`=@characterId AND
			`job_id`=@jobId
		GROUP BY
			`level`
	]], {
		["@characterId"] = characterId,
		["@jobId"] = id,
	})

	local monthlyTime = exports.GHMattiMySQL:QueryScalar([[
		SELECT
			SUM(end_time - start_time)
		FROM
			`jobs_sessions`
		WHERE
			`character_id`=@characterId AND
			`job_id`=@jobId AND
			`start_time` > CURRENT_TIMESTAMP() - INTERVAL 30 DAY
	]], {
		["@characterId"] = characterId,
		["@jobId"] = id,
	})

	local history = exports.GHMattiMySQL:QueryResult([[
		SELECT
			start_time,
			end_time,
			was_cached
		FROM
			`jobs_sessions`
		WHERE
			`character_id`=@characterId AND
			`job_id`=@jobId
		ORDER BY start_time DESC
		LIMIT 10
	]], {
		["@characterId"] = characterId,
		["@jobId"] = id,
	})

	-- Return payload.
	return {
		phoneNumber = phoneNumber,
		times = times,
		monthlyTime = monthlyTime,
		history = history,
	}
end

function Job:UpdateUser(id, ...)
	for source, _id in pairs(self.viewing.jobs) do
		if id == _id then
			TriggerClientEvent("devices:updateJob", source, ...)
		end
	end
end

--[[ Functions: Jobs (Update) ]]--
function Job.update:Status(source, job, characterId, faction, value)
	if not self.statuses[value] then return end

	print("set status!", value)

	exports.factions:UpdateFaction(characterId, job.Faction, job.Group or false, "status", value, true)

	self:UpdateUser(job.id, characterId, "status", value)

	return true
end

function Job.update:Rank(source, job, characterId, faction, value)
	if not job.Ranks then return end

	-- Get source rank.
	local sourceRank = exports.jobs:GetRank(source, job.id)
	if not sourceRank then return end
	
	-- Check ranks.
	local isRankValid = false
	for k, v in ipairs(job.Ranks) do
		print(k, v.Name, sourceRank.Level, sourceRank.Name)
		if k == sourceRank.Level then
			print("can't promote same rank or higher")
			break
		end

		if v.Name == value then
			isRankValid = true
			break
		end
	end

	if not isRankValid then return end

	-- Update rank.
	exports.factions:UpdateFaction(characterId, job.Faction, job.Group or false, "level", GetHashKey(value), true)

	self:UpdateUser(job.id, characterId, "rank", value)
end

--[[ Functions: Main ]]--
function Main.events:LoadJob(source, id)
	-- Check input.
	if not id or not PlayerUtil:WaitForCooldown(source, 2.0, true, "load") then return end
	
	-- Check player's job.
	if not exports.jobs:IsHired(source, id) then return end

	-- Get payload.
	local payload = Jobs:GetPayload(id)

	-- Cache view.
	if payload then
		Job.viewing.jobs[source] = id
	end

	-- Return payload.
	return Jobs:GetPayload(id)
end

function Main.events:GetJobInfo(source, id, characterId)
	-- Check input.
	if not id or type(characterId) ~= "number" or not PlayerUtil:WaitForCooldown(source, 0.5, true, "load") then return end

	-- Check player's job.
	if not exports.jobs:IsHired(source, id) then return end

	-- Get payload.
	local payload = Jobs:GetUserPayload(id, characterId)
	
	-- Cache view.
	if payload then
		Job.viewing.users[source] = id
	end

	-- Return payload.
	return payload
end

function Main.events:UpdateJobUser(source, id, characterId, key, ...)
	print(source, id, characterId, key, ...)

	-- Check input.
	if type(characterId) ~= "number" or type(key) ~= "string" then return end

	-- Check cooldown.
	if not PlayerUtil:CheckCooldown(source, 1.0, false, "save") then return end
	PlayerUtil:UpdateCooldown("save")

	-- Get job.
	local job = exports.jobs:GetJob(id or false)
	if not job then return end

	-- Check player's job.
	if not exports.jobs:IsHired(source, id) then return end

	-- Get target faction.
	local targetFaction = exports.GHMattiMySQL:QueryResult(([[
		SELECT * FROM
			`factions`
		WHERE
			character_id=@characterId AND
			`name`=@name AND
			`group`=%s
		LIMIT 1
	]]):format(
		job.Group and "@group" or "NULL"
	), {
		["@characterId"] = characterId,
		["@name"] = job.Faction,
		["@group"] = job.Group,
	})[1]

	if not targetFaction then return end

	-- Get func.
	local func = Job.update[key]
	if not func then return end

	return func(Job, source, job, characterId, targetFaction, ...)
end

--[[ Events ]]--
RegisterNetEvent("devices:deactivateJobs", function()
	local source = source

	Job.viewing.jobs[source] = nil
	Job.viewing.users[source] = nil
end)