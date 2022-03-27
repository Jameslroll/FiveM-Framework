Impound = {}

--[[ Functions: Impound ]]--
function Impound:Update()
	if not self:CanImpound() then
		if self.target then
			self.target:StopImpound()
		end
		return
	end

	for entity, marked in pairs(Marking.objects) do
		local coords = GetEntityCoords(entity)
		local siteId, site = self:GetSite(coords)

		if siteId ~= nil and not marked.impound then
			marked:StartImpound()
			self.target = marked
		elseif siteId == nil and marked.impound then
			marked:StopImpound()
		end
	end
end

function Impound:CanImpound()
	-- Check job.
	if not exports.jobs:IsOnDuty(Config.Marking.Faction) then
		return false
	end

	-- Get coords.
	local ped = PlayerPedId()
	local coords = GetEntityCoords(ped)

	-- No result.
	local id, site = self:GetSite(coords)
	
	-- Set site.
	self.site = id

	-- Check site.
	return id ~= nil
end

function Impound:GetSite(coords)
	for id, site in pairs(Config.Impounding.Sites) do
		if #(site.Coords - coords) < site.Distance then
			return id, site
		end
	end
end

function Impound:Start(entity)
	-- Check vehicle.
	if entity ~= exports.oldutils:GetFacingVehicle() then
		return
	end

	-- Animation.
	if not WaitForAnimWhileFacingVehicle(Config.Impounding.Anim, entity) then return end

	-- Get marked.
	local marked = Marking.objects[entity or false]
	if marked == nil then return end

	-- Check site.
	if self.site == nil then return end

	-- Trigger event.
	local netId = VehToNet(entity)
	TriggerServerEvent("impound:finish", netId, self.site)
end

--[[ Functions: Marked ]]--
function Marked:StartImpound()
	local interactable = "impound-"..self.entity
	exports.interact:Register({
		id = interactable,
		text = "Impound Vehicle",
		entity = self.entity,
		event = "impound",
	})

	self.impound = interactable
end

function Marked:StopImpound()
	exports.interact:Destroy(self.impound)
end

--[[ Events ]]--
AddEventHandler("interact:on_impound", function(interactable)
	Impound:Start(interactable.entity)
end)

--[[ Threads ]]--
Citizen.CreateThread(function()
	while true do
		Impound:Update()
		Citizen.Wait(2000)
	end
end)