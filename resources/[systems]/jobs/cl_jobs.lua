--[[ Functions: Main ]]--
function Main:OnRegister(job)
	if job.Clocks then
		job:RegisterClocks(job.Clocks)
	end
end

function Main:GetActiveJobs(getJob)
	local factions = exports.factions:GetFactions()
	local jobs = {}
	
	for id, job in pairs(self.jobs) do
		local faction = factions[job.Faction]
		local level = faction and faction[job.Group or ""]

		if level then
			jobs[id] = getJob and job or level
		end
	end

	return jobs
end

function Main:GetCurrentJob(getJob)
	local id = LocalPlayer.state.job
	if not id then return end

	if getJob then
		return self.jobs[id]
	end

	return id
end

function Main:GetRank(id)
	local job = self.jobs[id]
	if not job then return end

	local faction = exports.factions:Get(job.Faction, job.Group)
	if not faction then return end

	return job:GetRankByHash(faction.level, true)
end

function Main:GetRankByHash(id, hash, getName)
	local job = self.jobs[id]
	if not job then return end

	local rank = job:GetRankByHash(hash, true)

	return rank and getName and rank.Name or rank
end

--[[ Functions: Job ]]--
function Job:RegisterClocks(clocks)
	local job = self

	self.clockEntities = {}

	for k, clock in ipairs(clocks) do
		self.clockEntities[k] = exports.entities:Register({
			id = "clock-"..self.id..k,
			name = "Clock ("..self.id..")",
			coords = clock.Coords,
			radius = clock.Radius,
			navigation = {
				icon = "work",
				text = "Clock",
				job = self.id,
				clock = k,
			},
			condition = function(self)
				return job:IsHired()
			end,
		})
	end
end

function Job:IsHired()
	return exports.factions:Has(self.Faction, self.Group)
end

--[[ Events ]]--
AddEventHandler("interact:onNavigate", function(id, option)
	if not option.job and not option.clock then return end

	TriggerServerEvent("jobs:clock", option.job)
end)

--[[ Exports ]]--
exports("GetActiveJobs", function(...)
	return Main:GetActiveJobs(...)
end)

exports("GetRank", function(...)
	return Main:GetRank(...)
end)

exports("GetCurrentJob", function(...)
	return Main:GetCurrentJob(...)
end)

exports("GetRankByHash", function(...)
	return Main:GetRankByHash(...)
end)

--[[ Commands ]]--
exports.chat:RegisterCommand("a:jobs", function(source, args, command, cb)
	local output = ""

	for id, job in pairs(Main.jobs) do
		if output ~= "" then
			output = output..", "
		end
		output = output.."'"..id.."'"
	end

	TriggerEvent("chat:addMessage", "Jobs: "..output)
end, {
	description = "Look at all the jobs.",
}, "Admin")