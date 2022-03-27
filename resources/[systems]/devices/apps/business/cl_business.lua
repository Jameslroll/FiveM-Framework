Business = App:Register("business", {
	enabled = true,
	name = "Business",
	theme = "blue",
}, {
	["phone"] = true,
	["tablet"] = true,
})

--[[ Functions: Business ]]--
function Business:Activate(device)
	local currentJob = exports.jobs:GetCurrentJob()
	local jobs = exports.jobs:GetActiveJobs(true)
	local data = {
		jobs = {},
	}

	for id, job in pairs(jobs) do
		if job.Name then
			local rank = exports.jobs:GetRank(id)

			table.insert(data.jobs, {
				id = id,
				title = job.Title,
				name = job.Name,
				duty = currentJob == id,
				rank = rank and rank.Name,
			})
		end
	end

	table.sort(data.jobs, function(a, b)
		return a.name > b.name
	end)

	return data

	-- {
	-- 	id = "police",
	-- 	name = "Police",
	-- 	rank = "Recruit",
	-- 	business = "LSSD",
	-- },
end