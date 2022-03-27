EnableDebug = false
Quests = {}
Quest = {}

--[[ Functions: Quest ]]--
function Quest:Check(source)
	print("checking", source)
	-- Check that the quest is active.
	if not self:Has(source) then
		return false
	end
	-- Check if finished already.
	if self:GetStage(source) == "END" then
		return false
	end
	-- Check requirements.
	local req = self.requirements
	if req then
		local score = 0
		-- Item checks.
		if req.items then
			for k, v in ipairs(req.items) do
				local count = 0
				if source then
					count = exports.inventory:CountItem(exports.inventory:GetPlayerContainer(source), v.name)
				else
					count = exports.inventory:CountItem(v.name)
				end

				if count >= v.amount then
					if not v.sum then
						count = 1
					end
					score = score + (v.score or 1) * count
				end
			end
		end
		return score >= (req.minScore or 1)
	end
	return true
end

--[[ Functions ]]--
function Debug(...)
	if EnableDebug then
		print(...)
	end
end

function Get(id)
	return Quests[id]
end
exports("Get", Get)

function Register(quest)
	if not quest.id then error("no id specified for quest") end

	for k, v in pairs(Quest) do
		quest[k] = v
	end

	local _quest = Quests[quest.id]
	if _quest then
		quest.players = _quest.players
		quest.stage = _quest.stage
	end

	Quests[quest.id] = quest
end
exports("Register", Register)

--[[ Events ]]--
AddEventHandler("quests:start", function()
	if GetResourceState("cache") ~= "started" then return end

	local quests = exports.cache:Get("Quests")
	if quests then
		for id, quest in pairs(quests) do
			Register(quest)
		end
	end
	
	if Players then
		Players = exports.cache:Get("Quests_Players") or Players
	end
end)

AddEventHandler("quests:stop", function()
	if GetResourceState("cache") ~= "started" then return end

	exports.cache:Set("Quests", Quests)
	
	if Players then
		exports.cache:Set("Quests_Players", Players)
	end
end)