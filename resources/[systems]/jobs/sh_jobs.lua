Main = {
	jobs = {},
}

Job = {}
Job.__index = Job

--[[ Functions ]]--
function RegisterJob(id, data)
	if type(id) ~= "string" then
		error("job id must by string")
	end

	if type(data) ~= "table" then
		error("job data must be table")
	end

	Citizen.CreateThread(function()
		while GetResourceState(GetCurrentResourceName()) == "starting" do
			Citizen.Wait(0)
		end
		
		Main:RegisterJob(id, data)
	end)
end

--[[ Functions: Main ]]--
function Main:RegisterJob(id, data)
	id = id:lower()

	local job = Job:Create(id, data)
	
	self.jobs[id] = job

	if self.OnRegister then
		self:OnRegister(job)
	end
end

function Main:GetAllJobs()
	local ids = {}

	for id, job in pairs(self.jobs) do
		ids[#ids + 1] = id
	end

	return ids
end

function Main:GetJob(id)
	return self.jobs[id]
end

--[[ Functions: Job ]]--
function Job:Create(id, data)
	data.id = id

	return setmetatable(data, Job)
end

function Job:GetRankByHash(hash, useDefault)
	if not self.Ranks then return end

	for k, rank in ipairs(self.Ranks) do
		if type(rank) == "string" then
			rank = { Name = rank }
			self.Ranks[k] = rank
		end

		if not rank.Hash and rank.Name then
			rank.Hash = GetHashKey(rank.Name:lower())
		end

		if rank.Hash == hash then
			rank.Level = k
			return rank
		end
	end

	if useDefault then
		return self.Ranks[1]
	end
end

--[[ Exports ]]--
exports("Register", function(id, data)
	data.resource = GetInvokingResource()

	RegisterJob(id, data)
end)

exports("GetAllJobs", function()
	return Main:GetAllJobs()
end)

exports("GetJob", function(id)
	return Main:GetJob(id)
end)