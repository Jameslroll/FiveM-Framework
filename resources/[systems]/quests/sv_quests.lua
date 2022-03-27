Players = {}

--[[ Functions: Quest ]]--
function Quest:Start(source)
	self:SetStage(source, "INIT")
end

function Quest:Finish(source)
	self:SetStage(source, "END")
end

function Quest:Stop(source)
	self = Quests[self.id]

	-- Debug messages.
	Debug(source, "Stop", self.id)

	-- Get character id.
	local characterId = exports.character:Get(source, "id")
	if not characterId then return end

	-- Uncache the player.
	local player = Players[characterId]
	if player ~= nil then
		player[self.id] = nil
	end
	
	-- Uncache the quest.
	if self.players ~= nil then
		self.players[characterId] = nil
	end
end

function Quest:SetStage(source, stageId)
	self = Quests[self.id]

	-- Debug messages.
	Debug(source, "SetStage", self.id, stageId)

	-- Get character id.
	local characterId = exports.character:Get(source, "id")
	if not characterId then return end

	-- Setup players table.
	if self.players == nil then
		self.players = {}
	end

	-- Get player cache and check difference.
	local player = self.players[characterId]
	if player == stageId then return end

	-- Last stage callbacks.
	if self.stages ~= nil and player ~= nil then
		local lastStage = self.stages[player]
		if lastStage and lastStage.onEnd then
			lastStage.onEnd(self, source)
		end
	end

	-- Trigger client events.
	TriggerClientEvent("quests:setStage", source, self.id, stageId)

	-- Cache player.
	local cachedPlayer = Players[characterId]
	if cachedPlayer == nil then
		cachedPlayer = {}
		Players[characterId] = cachedPlayer
	end
	cachedPlayer[self.id] = stageId
	
	-- Cache quest.
	self.players[characterId] = stageId

	-- Rewards.
	local rewards = self.rewards
	if rewards ~= nil and stageId == "END" then
		if rewards.random then
			local seed = math.floor(os.clock() * 1000)
			math.randomseed(seed)

			local item = rewards.random[math.random(1, #rewards.random)]
			local amount = item.amount
			
			exports.inventory:GiveItem(source, item.name, amount)
			if item.name == "Bills" then
				exports.log:AddEarnings(source, "Quests", amount)
			end
		end
		if rewards.items then
			for _, item in ipairs(rewards.items) do
				local amount = item.amount
				exports.inventory:GiveItem(source, item.name, amount)
				if item.name == "Bills" then
					exports.log:AddEarnings(source, "Quests", amount)
				end
			end
		end
		if rewards.custom then
			rewards.custom(self, source)
		end
	end

	-- Invoke quest callback.
	if self.onStageChange then
		self:onStageChange(stageId, source)
	end

	if self.stages ~= nil then
		-- Get the stage.
		local stage = self.stages[stageId]
		if stage ~= nil then
			-- Invoke stage callback.
			if stage.onStart then
				stage.onStart(self, source)
			end
		end
	end
end

function Quest:GetStage(source)
	self = Quests[self.id]

	-- Get character id.
	local characterId = exports.character:Get(source, "id")
	if not characterId then return end

	-- Get the player's stage.
	if self.players ~= nil then
		return self.players[characterId]
	end
end

function Quest:NextStage()
	self = Quests[self.id]
end

function Quest:Has(source)
	self = Quests[self.id]

	-- Get character id.
	local characterId = exports.character:Get(source, "id")
	if not characterId then return end

	-- Get the players.
	local players = self.players
	if not players then
		return false
	end

	return players[characterId] ~= nil
end

--[[ Functions ]]--
function ClearCache(source)
	Debug("Clearing cache", source)

	local player = Players[source]
	if not player then return end

	for id, _ in pairs(player) do
		local quest = Quests[id]
		if quest and quest.players then
			quest.players[source] = nil
		end
	end

	Players[source] = nil
end

--[[ Events ]]--
RegisterNetEvent("quests:begin")
AddEventHandler("quests:begin", function(id)
	local source = source

	local quest = Quests[id]
	if not quest or quest.server then return end

	quest:Start(source)
end)

RegisterNetEvent("quests:finish")
AddEventHandler("quests:finish", function(id)
	local source = source

	local quest = Quests[id]
	if not quest or not quest:Check(source) then return end

	local req = quest.requirements
	if req then
		local score = 0
		if req.items then
			for k, v in ipairs(req.items) do
				if score < (req.minScore or 1) then
					local amount = v.amount
					local scoreMult = 1
					if v.sum then
						amount = math.min((req.minScore or 1) / v.score - score, exports.inventory:CountItem(exports.inventory:GetPlayerContainer(source), v.name) or 0)
						scoreMult = amount
					end
					exports.inventory:TakeItem(source, v.name, amount)
					score = score + (v.score or 1) * scoreMult
				else
					break
				end
			end
		end
	end

	quest:Finish(source)
end)

AddEventHandler("character:loaded", function(source, character)
	if not character or not character.id then return end
	
	Debug("Syncing", character.id)
	
	TriggerClientEvent("quests:sync", source, Players[character.id])
end)

--[[ Commands ]]--
RegisterCommand("quests:clearCache", function(source, args, command)
	if source ~= 0 then return end

	print("[QUESTS] Clearing cache")

	Players = {}
	for id, quest in pairs(Quests) do
		if quest.players then
			Debug(("Resetting %s"):format(id))
			quest.players = {}
		end
	end

	TriggerClientEvent("quests:clearCache", -1)
end, true)