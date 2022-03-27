Main.entities = {}

--[[ Functions ]]--
function Main:Init()
	for item, settings in pairs(Decorations) do
		self:CheckModel(item, settings.Model)
	end
end

function Main:CheckModel(item, model)
	if type(model) == "table" then
		if #model == 0 then
			self:CheckModel(item, model.Name)
		else
			for k, v in ipairs(model) do
				self:CheckModel(item, v)
			end
		end
		return
	end

	if not IsModelValid(model) then
		print(("invalid model '%s' for decoration '%s'"):format(model, item))
	end
end

function Main:Update()
	local ped = PlayerPedId()
	local coords = GetEntityCoords(ped)
	
	for id, decoration in pairs(self.decorations) do
		decoration:Update(#(decoration.coords - coords))
	end
end

function Main:GetTarget()
	-- Get player coords.
	local ped = PlayerPedId()
	local coords = GetEntityCoords(ped)

	-- Get camera coords.
	local camCoords = GetFinalRenderedCamCoord()
	local camDir = FromRotation(GetFinalRenderedCamRot() + vector3(0, 0, 90))

	-- Update decorations.
	local target, targetDot = nil, 0.0
	for id, decoration in pairs(self.decorations) do
		if decoration.coords then
			local dist = #(coords - decoration.coords)
			if dist and dist < Config.Pickup.MaxDistance then
				local dir = Normalize(decoration.coords - camCoords)
				local dot = Dot(dir, camDir)

				if dot > 0.85 and (not target or targetDot < dot) then
					target = decoration
					targetDot = dot
				end
			end
		end
	end

	return target, targetDot
end

function Main:GetModel(settings, variant)
	local model = settings.Model
	return type(model) == "table" and model[variant or 1] or model
end

function Main:ClearAll()
	for id, decoration in pairs(self.decorations) do
		decoration:Destroy()
	end
end

function Main:Pickup(decoration)
	-- Record snowflake.
	local snowflake = GetGameTimer()
	self.pickingUp = snowflake

	-- Get settings.
	local settings = decoration.settings
	if not settings then
		print("No settings while picking up.")
		return
	end

	-- Get emote.
	local anim = Config.Pickup.Anim
	anim.Locked = true
	
	-- Perform emote.
	exports.emotes:Play(anim)

	-- Wait for anim.
	Citizen.Wait(anim.Duration or 0)

	-- Check placement is same.
	if self.pickingUp ~= snowflake then return end
	
	-- Trigger events.
	TriggerServerEvent(Main.event.."pickup", decoration.id)
end

--[[ Threads ]]--
Citizen.CreateThread(function()
	while true do
		Main:Update()
		Citizen.Wait(50)
	end
end)

--[[ Events ]]--
AddEventHandler(Main.event.."clientStart", function()
	Main:Init()
end)

AddEventHandler(Main.event.."stop", function()
	Main:ClearAll()
end)

AddEventHandler("onResourceStop", function(resourceName)
	for id, decoration in pairs(Main.decorations) do
		if decoration.resource == resourceName then
			decoration:Destroy()
		end
	end
end)

AddEventHandler("inventory:use", function(item, slot, cb)
	if item.usable ~= "Decoration" then return end

	cb()
end)

AddEventHandler("inventory:useFinish", function(item, slot)
	if item.usable ~= "Decoration" then return end

	local settings = Decorations[item.name]
	if not settings then
		error("decoration not configured for item: "..tostring(item.name))
	end

	Editor:Use(item.name, slot)
end)

AddEventHandler("interact:navigate", function(value)
	if not value then
		if Main.selection then
			Main.selection:OnDeselect()
		end
		return
	end

	local ped = PlayerPedId()
	if IsPedArmed(ped, 1 | 2 | 4) then
		return
	end

	local target = Main:GetTarget()
	if not target then return end

	if target:OnSelect() then
		Main.selection = target
	end
end)

AddEventHandler("interact:onNavigate", function(id)
	if Main.selection then
		Main.selection:OnNavigate(id)
	end
end)

AddEventHandler("interact:on_decorationContainer", function(interactable)
	local decorationId = interactable.decoration
	if not decorationId then return end

	local decoration = Main.decorations[decorationId]
	if not decoration then return end
	
	if decoration.container_id then
		TriggerServerEvent(Main.event.."access", decorationId)
	end
end)

AddEventHandler("shoot", function(didHit, coords, hitCoords, entity)
	local decoration = Main.entities[entity]
	if not decoration then return end

	print("shooting decoration")
end)

--[[ Events: Net ]]--
RegisterNetEvent(Main.event.."sync", function(grids)
	Debug("Syncing decorations")

	if not grids then
		Main:ClearAll()
		return
	end

	for gridId, grid in pairs(Main.grids) do
		if not grids[gridId] then
			for id, decoration in pairs(grid) do
				Queue:Remove(id)
			end
		end
	end
	
	for gridId, grid in pairs(grids) do
		for id, decoration in pairs(grid) do
			Queue:Add(decoration)
		end
	end
end)

RegisterNetEvent(Main.event.."add", function(data)
	Queue:Add(data)
end)

RegisterNetEvent(Main.event.."remove", function(id)
	Queue:Remove(id)
end)

RegisterNetEvent(Main.event.."updateDecoration", function(id, key, value)
	local decoration = Main.decorations[id]
	if decoration then
		decoration[key] = value
	end
end)