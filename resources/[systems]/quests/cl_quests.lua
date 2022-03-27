--[[ Functions: Quest ]]--
function Quest:Start()
	TriggerServerEvent("quests:begin", self.id)
end

function Quest:Finish()
	TriggerServerEvent("quests:finish", self.id)
end

function Quest:GetStage()
	self = Quests[self.id]

	return self.stage
end

function Quest:Has()
	self = Quests[self.id]

	return self.stage ~= nil
end

--[[ Events ]]--
RegisterNetEvent("quests:setStage")
AddEventHandler("quests:setStage", function(id, stage)
	Debug("Setting stage", id, stage)

	local quest = Quests[id]
	if not quest then return end

	quest.stage = stage

	if quest.onStageChange then
		quest:onStageChange(stage)
	end

	if stage == "END" then
		TriggerEvent("npcs:invoke", "*", {
			{ "GotoStage", "QUEST_END" },
			{ "InvokeDialogue" },
		})

		local rewards = quest.rewards
		if rewards then
			if rewards.custom then
				rewards.custom(quest)
			end
		end
	end
end)

RegisterNetEvent("quests:sync")
AddEventHandler("quests:sync", function(data)
	if EnableDebug then
		print("Syncing", json.encode(data))
	end
	for id, quest in pairs(Quests) do
		if data == nil then
			quest.stage = nil
		else
			quest.stage = data[id]
		end
	end
end)

RegisterNetEvent("quests:clearCache")
AddEventHandler("quests:clearCache", function()
	print("Clearing cache")

	for id, quest in pairs(Quests) do
		if quest.stage then
			Debug(("Resetting %s->%s"):format(id, quest.stage))
			quest.stage = nil
		end
	end
end)

--[[ NUI Callbacks ]]--