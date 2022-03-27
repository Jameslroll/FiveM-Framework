Job = App:Register("job", {
	name = "Business",
	theme = "blue",
})

--[[ Functions: Job ]]--
function Job:Activate(device, data)
	local id = data and data.job
	if not id then return end
	
	local job = exports.jobs:GetJob(id)

	self.job = job

	Citizen.CreateThread(function()
		Job:Load(device)
	end)

	return {
		info = job
	}
end

function Job:Deactivate(device)
	self.job = nil
	self.roster = nil

	TriggerServerEvent("devices:deactivateJobs")
end

function Job:Load(device)
	-- Get job.
	local job = self.job
	if not job then return end

	-- Fetch data.
	local data = Main:Fetch("LoadJob", job.id) or {}
	local rosterData = data.rosterData or {}

	-- Convert roster data.
	for _, row in ipairs(rosterData) do
		-- Convert fields.
		local fields = row.fields and json.decode(row.fields) or {}
		row.fields = fields

		-- Default status.
		row.status = fields.status or "Active"

		-- Convert rank.
		if job.Ranks then
			row.rank = exports.jobs:GetRankByHash(job.id, row.rank, true)
		end
	end

	-- Get rank and permissions.
	local rank = exports.jobs:GetRank(job.id) or {}
	local permissions = Jobs:GenerateUserPermissions(rank.Flags)

	-- Create flags.
	local flags = {}

	if job.Flags then
		for k, flag in pairs(job.Flags) do
			flag.value = k
			flags[#flags + 1] = flag
		end

		table.sort(flags, function(a, b)
			return (a.name or "") > (b.name or "")
		end)
	end

	-- Cache roster.
	self.roster = rosterData

	-- Set app data.
	device:SetAppData(self.id, {
		selfId = exports.character:Get("id"),
		rank = rank,
		flags = flags,
		permissions = permissions,
		rosterData = rosterData
	})
end

--[[ Functions: Device ]]--
function Device:GetJobInfo(characterId)
	-- Get job.
	local job = Job.job
	if not job then return end

	local info = Main:Fetch("GetJobInfo", job.id, characterId)
	if not info then return end

	-- Get from roster.
	local rosterUser
	if Job.roster then
		for k, v in ipairs(Job.roster) do
			if v.id == characterId then
				rosterUser = v
				break
			end
		end
	end

	-- Convert times.
	local times = {}
	local total = 0
	
	for k, v in ipairs(info.times or {}) do
		local rank = exports.jobs:GetRankByHash(job.id, v.level, true)
		if rank then
			local sum = tonumber(v.sum) or 0
			times[rank] = sum
			total = total + sum
		end
	end

	info.times = {}

	for k, v in pairs(times) do
		info.times[#info.times + 1] = {
			rank = k,
			time = v,
			class = k == (rosterUser and rosterUser.rank) and "bg-yellow-3",
		}
	end

	table.sort(info.times, function(a, b)
		return (a.time or 0) > (b.time or 0)
	end)

	if total >= 1 then
		table.insert(info.times, {
			rank = "Total",
			time = total,
			class = "text-bold bg-grey-2",
		})
	end

	if info.monthlyTime then
		table.insert(info.times, {
			rank = "Last 30 days",
			time = info.monthlyTime,
			class = "text-bold bg-grey-2",
		})

		info.monthlyTime = nil
	end
	
	-- Fetch info.
	return info
end

function Device:UpdateJobUser(characterId, key, ...)
	if not characterId then return end

	local job = Job.job
	if not job then return end

	print(Main:Fetch("UpdateJobUser", job.id, characterId, key, ...))
end

function Device:UpdateJob()
	
end

--[[ Events: Net ]]--
RegisterNetEvent("devices:updateJob", function(...)
	for id, device in pairs(Main.devices) do
		if device.open then
			Job:Invoke(id, "update", ...)
		end
	end
end)