Treatment = {
	labels = {},
	full = { 0, 240, 0 },
	empty = { 220, 0, 0 },
	controls = {
		0,
		22,
		23,
		24,
		25,
		30,
		31,
		32,
		33,
		34,
		35,
		51,
		52,
		199,
		200,
		245,
		246,
	},
}

function Treatment:GetText(boneId, info)
	if not info then return end
	
	local settings = Config.Bones[boneId or false]
	if not settings then return end

	local health = info.health or 1.0
	if health > 0.98 then return end

	local color = {}
	for i = 1, 3 do
		color[i] = Lerp(self.empty[i], self.full[i], health)
	end

	local text = settings.Label
	local function appendText(icon)
		text = text.."<img style='margin-left: 0.5vmin' src='nui://health/html/images/icons/"..icon..".png' width=auto height=10vmin />"
	end

	if info.fractured then
		appendText("Fracture")
	end

	if info.bleed and info.bleed > 0.001 then
		appendText("Blood")
	end

	return [[
		<div style="width: auto; height: auto;">
			<div style='
				position: absolute;
				border-radius: 3px;
				background: rgba(]]..color[1]..[[, ]]..color[2]..[[, ]]..color[3]..[[, 0.8);
				left: 0%;
				right: ]]..(100.0 - health * 100.0)..[[%;
				bottom: 0%;
				top: 0%;
			'></div>
			<div style='
				display: flex;
				justify-content: center;
				align-items: center;
				flex-direction: row;
				position: relative;
				font-size: 0.8em;
			'>]]..text..[[</div>
		</div>
	]]
end

function Treatment:Begin(ped, bones, serverId, status)
	self:End()

	self.ped = ped
	self.isLocal = ped == PlayerPedId()
	self.serverId = serverId

	self:SetBones(bones)
	self:CreateCam()

	local state = LocalPlayer.state or {}
	local canTreat = not state.immobile and not state.restrained
	local groups = self:GetGroups()

	-- Play emote.
	if self.isLocal and canTreat then
		self.emote = exports.emotes:Play(Config.Examining.Anims.Self)
	end

	-- Create menu.
	local window = Window:Create({
		type = "Window",
		style = {
			["width"] = "50vmin",
			["height"] = "auto",
			["top"] = "10vmin",
			["right"] = "5vmin",
		},
		defaults = {
			active = groups and (groups[1] or {}).name,
			groups = groups,
			isLocal = self.isLocal,
			canTreat = canTreat,
			status = status,
		},
		components = {
			{
				template = [[
					<div>
						<q-input
							:value="$getModel('action')"
							@input="$setModel('action', $event)"
							@keypress.enter.prevent="$invoke('performAction')"
							class="q-mb-sm"
							label="Action"
							maxlength=256
							filled
							dense
							clearable
						/>
						<q-input
							:readonly="!$getModel('isLocal')"
							:value="$getModel('status')"
							@input="$setModel('status', $event)"
							@clear="$invoke('setStatus', true)"
							@keypress.enter.prevent="$invoke('setStatus')"
							class="q-mb-sm"
							label="Status"
							maxlength=256
							autogrow
							filled
							dense
							clearable
						/>
					</div>
				]]
			},
			{
				type = "q-btn",
				text = "Close",
				class = "q-mb-sm",
				click = {
					callback = "this.$invoke('close')",
				},
				binds = {
					color = "red",
				}
			},
			{
				template = [[
					<div
						style="display: flex; flex-direction: row; overflow: hidden"
					>
						<q-card
							style="min-width: 49%; flex-grow: 1"
						>
							<q-expansion-item
								v-for="group in $getModel('groups')"
								:key="group.name"
								:style="`background-color: rgba(200, 0, 0, ${0.5 * (1.0 - (group.health ?? 1.0))})`"
								@input="if ($event) $setModel('active', group.name)"
								:value="$getModel('active') == group.name"
								group="groups"
								expand-separator
								dense
							>
								<template v-slot:header>
									<q-item-section>
										<q-item-label>{{group.name}}</q-item-label>
									</q-item-section>
									<q-item-section side class="q-gutter-sm">
										<div>
											<q-icon name="healing" v-if="group.events.find(x => x.treatment)" />
											<q-icon name="security" v-if="group.armor" />
										</div>
									</q-item-section>
								</template>
								<q-item
									v-for="(event, key) in group.events"
									:key="key"
									:style="`background: rgba(${(event.treatment ? '0, 200, 0' : '200, 0, 0')}, 0.4)`"
									:clickable="event.removable"
									@click="$invoke('useTreatment', group.name, event.name, true)"
									inset-level="0.2"
									dense
								>
									<q-item-section>
										{{event.name}}
									</q-item-section>
									<q-item-section side>
										{{event.amount ?? 1}}
									</q-item-section>
								</q-item>
							</q-expansion-item>
						</q-card>
						<q-card
							style="min-width: 49%; margin-left: 1%"
							v-for="group in $getModel('groups')"
							:key="group.name"
							v-if="$getModel('canTreat') && group.name == $getModel('active')"
						>
							<q-item
								v-for="(treatment, key) in group.treatments"
								:key="key"
								:disabled="treatment.Disabled"
								:clickable="!treatment.Disabled"
								@click="$invoke('useTreatment', group.name, treatment.Text, false)"
							>
								<q-item-section avatar>
									<q-img contain :src="`nui://inventory/icons/${treatment.Icon}.png`" width="4vmin" height="4vmin" />
								</q-item-section>
								<q-item-section>
									<q-item-label>{{treatment.Text}}</q-item-label>
									<q-item-label caption>{{treatment.Description}}</q-item-label>
								</q-item-section>
								<q-item-section side>
									{{treatment.Amount ?? 1}}
								</q-item-section>
							</q-item>
						</q-card>
					</div>
				]]
			},
			{
				type = "q-linear-progress",
				condition = "this.$getModel('cooldown')",
				style = {
					["position"] = "absolute",
					["bottom"] = "0px",
					["left"] = "0px",
					["right"] = "0px",
				},
				binds = {
					query = true,
					color = "blue",
				}
			},
		},
	})
	
	window:AddListener("close", function(window)
		Treatment:End()
	end)

	window:AddListener("useTreatment", function(window, groupName, treatmentName, isRemoving)
		local state = LocalPlayer.state or {}
		local canTreat = not state.immobile and not state.restrained
		if not canTreat then print("trick or treat") return end

		-- Get group.
		local group = Config.Groups[groupName]
		if not group then return end

		-- Get bone from group.
		local bone = Treatment.bones[group.Part]

		-- Get treatment.
		local treatment = Config.Treatments[treatmentName]
		if not treatment then return end

		-- Check conditions.
		if not isRemoving and treatment.Condition and (not bone or not treatment.Condition(bone)) then
			return
		end

		-- Check limits.
		if not isRemoving and treatment.Limit and bone and bone.history then
			local count = 0
			for k, event in ipairs(bone.history) do
				if event.name == treatmentName then
					count = count + 1
					if count >= treatment.Limit then
						return
					end
				end
			end
		end

		-- Check cooldown.
		local cooldown = 3000
		if LastTreatment and GetGameTimer() - LastTreatment < cooldown then return end
		LastTreatment = GetGameTimer()

		-- Tell server to apply treatment.
		TriggerServerEvent("health:treat", Treatment.serverId or false, groupName, treatmentName, isRemoving)

		-- Play emote.
		exports.emotes:Play(Config.Examining.Anims.Action)

		-- Set cooldown.
		window:SetModel("cooldown", true)

		-- Timeout.
		Citizen.SetTimeout(cooldown, function()
			if Treatment.window then
				Treatment.window:SetModel("cooldown", false)
			end
		end)
	end)

	window:AddListener("performAction", function(window)
		local action = window.models["action"]
		if not action or (LastAction and GetGameTimer() - LastAction < 3000) then return end

		LastAction = GetGameTimer()

		ExecuteCommand(("me %s"):format(action))

		window:SetModel("action", "")
	end)

	window:AddListener("setStatus", function(window, isClearing)
		local status = not isClearing and window.models["status"] or ""
		if (LastStatus and GetGameTimer() - LastStatus < 1000) then return end

		LastStatus = GetGameTimer()
		Status = status

		TriggerServerEvent("health:setStatus", status)

		if isClearing then
			window:SetModel("status", "")
		end
	end)
	
	self.window = window

	UI:Focus(true, true)
end

function Treatment:End()
	if not self.ped then return end

	-- Remove labels.
	for boneId, label in pairs(self.labels) do
		exports.interact:RemoveText(label)
	end

	-- Clear cache.
	self.labels = {}
	self.ped = nil
	self.isLocal = nil

	-- Destroy camera.
	if self.camera then
		self.camera:Destroy()
		self.camera = nil
	end
	
	-- Unsubscribe to player.
	if self.serverId then
		TriggerServerEvent("health:subscribe", self.serverId, false)
		self.serverId = nil
	end

	-- Stop emote.
	if self.emote then
		exports.emotes:Stop(self.emote)
		self.emote = nil
	end

	-- Destroy window.
	if self.window then
		self.window:Destroy()
		self.window = nil
	end

	UI:Focus(false)
end

function Treatment:Update()
	if not self.ped or not self.bones then return end
	
	-- Check other players.
	if not self.isLocal then
		local localPed = PlayerPedId()
		local localCoords = GetEntityCoords(localPed)
		local coords = GetEntityCoords(self.ped)

		if #(coords - localCoords) > 3.0 then
			self:End()
			return
		end
	end

	-- Disable controls.
	for _, control in ipairs(self.controls) do
		DisableControlAction(0, control)
	end

	-- Get cursor stuff.
	local camCoords = GetFinalRenderedCamCoord()
	local mouseX, mouseY = GetNuiCursorPosition()
	local width, height = GetActiveScreenResolution()
	local activeBone, activeDist = nil

	-- Selecting bones.
	if IsDisabledControlJustReleased(0, 237) and self.activeBone and self.window then
		local bone = Main:GetBone(self.activeBone)
		local settings = bone and bone:GetSettings()

		if settings then
			self.window:SetModel("active", settings.Group)
		end
	end

	-- Suppress interacts.
	TriggerEvent("interact:suppress")

	-- Cooldowns.
	if self.lastUpdateCursor and GetGameTimer() - self.lastUpdateCursor < 100 then
		return
	end

	self.lastUpdateCursor = GetGameTimer()

	-- Check bones.
	for boneId, bone in pairs(self.bones) do
		local coords = GetPedBoneCoords(self.ped, boneId, 0.0, 0.0, 0.0)
		local retval, screenX, screenY = GetScreenCoordFromWorldCoord(coords.x, coords.y, coords.z)

		if retval then
			screenX = screenX * width
			screenY = screenY * height

			local screenDist = ((screenX - mouseX)^2 + (screenY - mouseY)^2)^0.5
			local isActive = screenDist < 100.0

			if isActive and (activeBone == nil or screenDist < activeDist) then
				activeBone = boneId
				activeDist = screenDist
			end
		end
	end

	-- Update active.
	if self.activeBone ~= activeBone then
		self.activeBone = activeBone
	end
end

function Treatment:CreateCam()
	local camera = Camera:Create({
		fov = 80.0,
	})

	local ped = self.ped
	local offset = Config.Examining.Camera.Offset
	local target = Config.Examining.Camera.Target

	function camera:Update()
		if Treatment.isLocal then
			AttachCamToEntity(self.handle, ped, offset.x, offset.y, offset.z, true)
		else
			local _ped = PlayerPedId()
			AttachCamToPedBone(self.handle, _ped, 0x2E28, 0.5, 0.0, 0.8, true)
		end

		PointCamAtPedBone(self.handle, ped, 0x2E28, target.x, target.y, target.z, true)
		SetCamFov(self.handle, Config.Examining.Camera.Fov)
	end

	camera:Activate()

	self.camera = camera
end

function Treatment:SetBones(bones)
	if not self.ped then return end

	self.bones = bones

	for boneId, bone in pairs(bones) do
		local label = self.labels[boneId]
		local text = self:GetText(boneId, bone.info, self.activeBone == boneId)

		if label and text then
			exports.interact:SetText(label, text)
		elseif text then
			self.labels[boneId] = exports.interact:AddText({
				text = text,
				bone = boneId,
				entity = self.ped,
			})
		elseif label then
			exports.interact:RemoveText(label)
			self.labels[boneId] = nil
		end
	end

	if self.window then
		self.window:SetModel("groups", self:GetGroups())
	end
end

function Treatment:GetGroups()
	local groups = {}
	local groupCache = {}
	local isDebug = exports.inventory:HasItem("Orb of Bias")

	for boneId, settings in pairs(Config.Bones) do
		local bone = self.bones[boneId] or {}
		if not settings.Group then goto skipBone end

		-- Get group.
		local groupSettings = Config.Groups[settings.Group]
		if not groupSettings then goto skipBone end

		-- Get info.
		local info = bone.info or {}

		-- Find/create the group.
		local groupIndex = groupCache[settings.Group]
		local group = nil

		if groupIndex then
			group = groups[groupIndex]
		else
			groupIndex = #groups + 1

			group = {
				name = settings.Group,
				health = 1.0,
				treatments = {},
				treatmentCache = {},
				events = {},
				eventsCache = {},
			}

			groups[groupIndex] = group
			groupCache[settings.Group] = groupIndex
		end

		-- Update health.
		group.health = group.health * (info.health or 1.0)

		-- Update armor.
		if info.armor and info.armor > 0.001 then
			group.armor = true
		end

		-- Add events.
		if bone.history then
			for _, event in ipairs(bone.history) do
				local eventIndex = group.eventsCache[event.name]
				local _event = nil
	
				if eventIndex then
					_event = group.events[eventIndex]
				else
					eventIndex = #group.events + 1
					
					local treatment = Config.Treatments[event.name]
	
					_event = {
						name = event.name,
						amount = 0,
						treatment = treatment ~= nil,
						removable = treatment and treatment.Removable,
					}
	
					group.events[eventIndex] = _event
					group.eventsCache[event.name] = eventIndex
				end

				_event.amount = _event.amount + 1
			end
		end

		-- Add treatments.
		for _, treatmentName in ipairs(groupSettings.Treatments) do
			local treatment = Config.Treatments[treatmentName]
			if not treatment or group.treatmentCache[treatmentName] then goto skipTreatment end

			treatment.Text = treatmentName

			if treatment.Item then
				-- Check for item.
				treatment.Disabled = not isDebug and not exports.inventory:HasItem(treatment.Item)

				-- Set icon.
				treatment.Icon = treatment.Icon or treatment.Item:gsub("%s+", "")
			end

			group.treatments[#group.treatments + 1] = treatment
			group.treatmentCache[treatmentName] = true

			::skipTreatment::
		end

		::skipBone::
	end

	-- Uncache events in groups.
	for _, group in ipairs(groups) do
		group.eventsCache = nil
		group.treatmentCache = nil
	end

	-- Sort groups.
	table.sort(groups, function(a, b)
		return (a and a.name or "") < (b and b.name or "")
	end)

	-- Return groups.
	return groups
end

function Treatment:Treat(serverId, groupName, treatmentName, isRemoving)
	local player = serverId == 0 and PlayerId() or GetPlayerFromServerId(serverId)
	if not player then return end

	local ped = GetPlayerPed(player)
	if not ped or not DoesEntityExist(ped) then return end

	local group = Config.Groups[groupName or false]
	if not group then return end
	
	local treatment = Config.Treatments[treatmentName or false]
	if not treatment then return end

	-- Add proximity text.
	exports.players:AddText(ped,
		(
			isRemoving and
			("%s Removes %s."):format(group.Bone, treatment.Item) or
			("%s %s"):format(group.Bone, treatment.Action)
		),
		12000
	)

	-- Update current treatment.
	if self.serverId == serverId then
		local bone = self.bones[group.Part]
		if not bone then
			bone = {
				info = {},
				history = {},
			}
			self.bones[group.Part] = bone
		end

		if isRemoving then
			for k, event in ipairs(bone.history) do
				if event.name == treatmentName then
					table.remove(bone.history, k)
					break
				end
			end
		else
			table.insert(bone.history, {
				time = GetNetworkTime(),
				name = treatmentName,
			})
		end

		self:SetBones(self.bones)
	end

	-- Check for self.
	if player ~= PlayerId() then
		return
	end

	-- Treat bones.
	local bone = Main.bones[group.Part]
	if not bone then return end

	if isRemoving then
		bone:RemoveTreatment(treatmentName)
	else
		bone:AddTreatment(treatmentName)
	end
end

function Treatment:Heal(delay)
	local treated = {}

	local function cacheTreatment(group, name)
		local _treated = treated[group]
		if not _treated then
			_treated = {}
			treated[group] = _treated
		end
		_treated[name] = true
	end

	local function wasTreated(group, name)
		local _treated = treated[group]
		return _treated and _treated[name]
	end

	-- Clear treatments.
	for boneId, bone in pairs(Main.bones) do
		for i = #bone.history, 1, -1 do
			local event = bone.history[i] or {}
			if Config.Treatments[event.name] then
				bone:RemoveHistory(i)
			end
		end
	end

	-- Treat injuries bones.
	for boneId, bone in pairs(Main.bones) do
		local groupName, groupSettings, groupBone = bone:GetGroup()
		for k, event in ipairs(bone.history) do
			local injury = Config.Injuries[event.name]
			if injury and injury.Treatment then
				for stage, treatment in ipairs(injury.Treatment) do
					-- Get treatment.
					local treatmentType = type(treatment)
					local _groupName, treatmentName

					-- Check the treatment type.
					if treatmentType == "string" then
						treatmentName = treatment
						_groupName = groupName
					elseif treatmentType == "table" then
						treatmentName = treatment.Name
						_groupName = treatment.Group
					elseif treatmentType == "function" then
						treatmentName, _groupName = treatment(bone, event, groupName)
					end

					-- Check treatment redundancy.
					if _groupName and treatmentName and not wasTreated(_groupName, treatmentName) then
						-- Apply the treatment.
						self:Treat(0, _groupName, treatmentName)
						cacheTreatment(_groupName, treatmentName)

						-- Wait a little.
						if delay then
							Citizen.Wait(GetRandomIntInRange(2000, 4000))
						end
					end
				end
			end
		end
	end

	-- Give some health.
	if Main:GetHealth() < 0.1 then
		Main:SetEffect("Health", 0.1)
	end
end

RegisterCommand("testheal", function()
	Treatment:Heal(true)
end)

--[[ Listeners ]]--
Main:AddListener("UpdateSnowflake", function()
	if Treatment.ped == PlayerPedId() then
		Treatment:SetBones(Main.bones)
	end
end)

--[[ Events ]]--
AddEventHandler("interact:onNavigate_healthExamine", function(option)
	if Treatment.ped then
		Treatment:End()
	else
		Treatment:Begin(PlayerPedId(), Main.bones, nil, Status)
	end
end)

AddEventHandler("health:examine", function(player)
	if not player then return end

	TriggerServerEvent("health:subscribe", GetPlayerServerId(player), true)
end)

AddEventHandler("health:help", function(player)
	if not player or not NetworkIsPlayerActive(player) then return end

	exports.emotes:Play(Config.Examining.Anims.Action)

	TriggerServerEvent("health:help", GetPlayerServerId(player))
end)

--[[ Events: Net ]]--
RegisterNetEvent("health:treat", function(serverId, groupName, treatmentName, isRemoving)
	Treatment:Treat(serverId, groupName, treatmentName, isRemoving)
end)

--[[ Threads ]]--
Citizen.CreateThread(function()
	while true do
		if Treatment.ped then
			Treatment:Update()
			Citizen.Wait(0)
		else
			Citizen.Wait(200)
		end
	end
end)