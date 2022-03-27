Inspector = {
	colors = {
		[0] = { 255, 0, 0 },
		[1] = { 0, 255, 0 },
		[2] = { 255, 255, 0 },
		[3] = { 0, 255, 255 },
	},
	names = {
		[0] = "None",
		[1] = "Ped",
		[2] = "Vehicle",
		[3] = "Object",
	},
	lines = {},
}

--[[ Functions: Inspector ]]--
function Inspector:Update()
	-- Update targets.
	self:UpdateHit()

	-- Draw lines.
	self:DrawLines()

	-- Update input.
	self:UpdateInput()
end

function Inspector:UpdateHit()
	local retval, didHit, hitCoords, surfaceNormal, materialHash, entity = Raycast()
	
	if not didHit then
		self.entity = nil
		return
	end

	if self.entity ~= entity then
		self.lastEntity = self.entity or self.lastEntity
		self.entity = entity
		self.material = materialHash
	end

	self.hitCoords = hitCoords
	self.surfaceNormal = surfaceNormal
	
	-- Get entity info.
	local entityType = GetEntityType(entity) or 0
	local target = hitCoords + surfaceNormal * math.max(math.log(#(hitCoords - GetFinalRenderedCamCoord())) * 0.5, 0.1)

	-- Create line.
	local r, g, b = table.unpack(self.colors[entityType])
	local lastLine = self.lines[#self.lines]

	-- Draw line.
	if lastLine and #(hitCoords - vector3(lastLine[1], lastLine[2], lastLine[3])) < 0.1 then
		DrawLine(
			hitCoords.x, hitCoords.y, hitCoords.z,
			target.x, target.y, target.z,
			r, g, b, 255
		)

		return
	end

	-- Cache line.
	table.insert(self.lines, {
		hitCoords.x, hitCoords.y, hitCoords.z,
		target.x, target.y, target.z,
		r, g, b, 255
	})

	if #self.lines > 20 then
		table.remove(self.lines, 1)
	end
end

function Inspector:UpdateInput()
	-- Delete entity.
	local entity = self.entity
	if DoesEntityExist(entity or 0) and IsDisabledControlJustPressed(0, 214) then
		if IsEntityAPed(entity) and IsPedAPlayer(entity) then
			local player = NetworkGetEntityOwner(entity)
			local serverId = GetPlayerServerId(player)
			local state = (Player(serverId) or {}).state

			ExecuteCommand(("a:%s %s"):format(state.immobile and "revive" or "slay", serverId))
		else
			if NetworkGetEntityIsNetworked(entity) then
				TriggerServerEvent("admin:delete", NetworkGetNetworkIdFromEntity(entity))
			else
				DeleteEntity(entity)
			end
		end
	end

	-- Focus.
	if IsDisabledControlJustPressed(0, 207) then
		local hasFocus = not _Get("hasFocus")
		UI:Focus(hasFocus, hasFocus)
	end

	-- Lock entity.
	if IsDisabledControlPressed(0, 209) and IsDisabledControlJustPressed(0, 121) then -- Left shift & insert.
		if self.editing then
			SetEntityDrawOutline(self.editing, false)
			self.editing = nil
		else
			SetEntityDrawOutline(self.entity, true)
			self.editing = self.entity
		end
	elseif IsDisabledControlJustPressed(0, 121) then -- Insert.
		self.locked = not self.locked

		if self.window then
			self.window:SetModel("locked", self.locked)
		end
	end

	-- Editing entities.
	if self.editing and DoesEntityExist(self.editing) then
		local coords = GetEntityCoords(self.editing)
		local rotation = GetEntityRotation(self.editing)

		local horizontal = GetDisabledControlNormal(0, 30) -- Left/right.
		local vertical = GetDisabledControlNormal(0, 31) -- Forward/back.
		local height = (IsDisabledControlPressed(0, 205) and -1.0) or (IsDisabledControlPressed(0, 206) and 1.0) or 0.0 -- Q/e.

		if IsDisabledControlPressed(0, 209) then -- Left shift.
			rotation = rotation + vector3(horizontal, vertical, height) * GetFrameTime() * 35.0
		else
			coords = coords + vector3(horizontal, vertical, height) * GetFrameTime() * 0.5
		end

		DisableControlAction(0, 30)
		DisableControlAction(0, 31)
		DisableControlAction(0, 44)
		DisableControlAction(0, 46)

		SetEntityCoords(self.editing, coords)
		SetEntityRotation(self.editing, rotation)
	end
end

function Inspector:UpdateMenu()
	-- Clear options.
	self.options = {}

	-- Add ped options.
	local ped = PlayerPedId() or 0
	if DoesEntityExist(ped) then
		local coords = GetEntityCoords(ped)
		local heading = GetEntityHeading(ped)
		
		self:AddOption("Ped")

		self:AddOption("Coords (vector3)", tostring(vector3(coords.x, coords.y, coords.z)), true)
		self:AddOption("Coords (vector4)", tostring(vector4(coords.x, coords.y, coords.z, heading)), true)

		self:AddOption("Group", GetPedRelationshipGroupHash(ped) or "None", true)
	end

	-- Add camera options.
	local camCoords = GetFinalRenderedCamCoord()
	local camRot = GetFinalRenderedCamRot()

	self:AddOption("Camera")

	self:AddOption("Coords", tostring(camCoords), true)
	self:AddOption("Rotation", tostring(camRot), true)

	-- Other information where the camera is.
	local interiorId = GetInteriorAtCoords(camCoords)
	if interiorId and IsValidInterior(interiorId) then
		self:AddOption("Interior", interiorId)

		local roomHash = GetRoomKeyForGameViewport()
		local roomId = GetInteriorRoomIndexByHash(interiorId, roomHash)
		local roomName = GetInteriorRoomName(interiorId, roomId)

		self:AddOption("Room", ("%s (%s)"):format(roomName or "?", roomId))
	end

	self:AddOption("Zone (ID)", GetZoneAtCoords(camCoords))
	self:AddOption("Zone (Name)", GetNameOfZone(camCoords))

	-- Hit.
	if self.entity then
		self:AddOption("Hit")

		self:AddOption("Coords", tostring(self.hitCoords), true)
		self:AddOption("Normal", tostring(self.surfaceNormal), true)
		self:AddOption("Material", self.material, true)
	end

	-- Check entity.
	local entity = self.entity and GetEntityType(self.entity) ~= 0 and self.entity or self.lastEntity
	local _type = entity and GetEntityType(entity) or 0

	if entity and _type ~= 0 then
		-- Add entity options.
		local speed = GetEntitySpeed(entity)
	
		self:AddOption(self.entity and "Target" or "Target (Previous)")
	
		self:AddOption("Script", GetEntityScript(entity) or 0, true)
		self:AddOption("Type", self.names[_type], true)
		self:AddOption("Network ID", NetworkGetEntityIsNetworked(entity) and NetworkGetNetworkIdFromEntity(entity) or "None", true)
		self:AddOption("Entity", entity, true)
		self:AddOption("Owner", GetPlayerServerId(NetworkGetEntityOwner(entity)), true)
		self:AddOption("Model", GetEntityModel(entity), true)
		self:AddOption("Coords", tostring(GetEntityCoords(entity)), true)
		self:AddOption("Rotation", tostring(GetEntityRotation(entity)), true)
		self:AddOption("Invincible", not GetEntityCanBeDamaged(entity), true)
		self:AddOption("Health", ("%s/%s"):format(GetEntityHealth(entity), GetEntityMaxHealth(entity)), true)
		self:AddOption("Speed (KMH)", speed * 3.6, true)
		self:AddOption("Speed (MPH)", speed * 2.236936, true)
		self:AddOption("Attached To", GetEntityAttachedTo(entity), true)
		self:AddOption("Upright Value", GetEntityUprightValue(entity), true)
		self:AddOption("Is Upright", IsEntityUpright(entity) == 1, true)
		self:AddOption("Is Upsidedown", IsEntityUpsidedown(entity) == 1, true)
		self:AddOption("Submerged Level", GetEntitySubmergedLevel(entity), true)

		-- Ped stuff.
		if IsEntityAPed(entity) then
			self:AddOption("Scenario", GetScenarioPedIsUsing(entity) or "None", true)
			self:AddOption("Group", GetPedRelationshipGroupHash(entity) or "None", true)
		end
	
		-- Proofs.
		local retval, bulletProof, fireProof, explosionProof, collisionProof, meleeProof, steamProof, p7, drownProof = GetEntityProofs(entity)
		if retval then
			self:AddOption("Proofs")

			self:AddOption("Bullet", bulletProof, true)
			self:AddOption("Fire", fireProof, true)
			self:AddOption("Explosion", explosionProof, true)
			self:AddOption("Collision", collisionProof, true)
			self:AddOption("Melee", meleeProof, true)
			self:AddOption("Steam", steamProof, true)
			self:AddOption("Drown", drownProof, true)
		end
	end

	-- Update menu.
	self.window:SetModel("options", self.options)
end

function Inspector:DrawLines()
	for k, line in ipairs(self.lines) do
		line[10] = math.ceil(k / #self.lines * 255)
		DrawLine(table.unpack(line))
	end
end

function Inspector:Activate()
	if self.active then return end
	self.active = true
	
	self.window = Window:Create({
		type = "Window",
		title = "Inspector",
		class = "compact",
		style = {
			["width"] = "25vmin",
			["height"] = "auto",
			["top"] = "5vmin",
			["bottom"] = "5vmin",
			["right"] = "4vmin",
		},
		defaults = {
			options = self.options or {},
			locked = self.locked,
		},
		components = {
			{
				type = "div",
				style = {
					["display"] = "flex",
					["flex-direction"] = "column",
					["height"] = "100%",
				},
				template = [[
					<div>
						<div
							v-for="(property, index) in $getModel('options')"
							:key="index"
						>
							<q-field
								v-if="property.text != null"
								:label="property.title"
								:style="$getModel('locked') ? 'background: rgba(255, 20, 20, 0.4)' : null"
								class="q-ma-sm"
								stack-label
								filled
								readonly
								dense
							>
								<template v-slot:control>
									<span style="white-space: nowrap; overflow: hidden">{{property.text}}</span>
								</template>
								<template v-slot:append>
									<q-btn
										@click="$copyToClipboard(property.text)"
										icon="copy_all"
										transparent
										flat
										dense
									/>
								</template>
							</q-field>
							<div
								v-if="property.text == null"
								class="text-caption q-ma-sm"
							>
								{{property.title}}
							</div>
						</div>
					</div>
				]],
			},
		},
	})
end

function Inspector:Deactivate()
	if not self.active then return end
	self.active = false
	
	if self.window then
		self.window:Destroy()
		self.window = nil

		UI:Focus(false)
	end
end

function Inspector:AddOption(title, text, fallback)
	if text == true then
		text = "Yes"
	elseif text == false then
		text = "No"
	end

	self.options[#self.options + 1] = { title = title, text = text or (fallback and "Unknown") or nil }
end

--[[ Threads ]]--
Citizen.CreateThread(function()
	while true do
		if Inspector.active then
			Inspector:Update()
		end

		Citizen.Wait(0)
	end
end)

Citizen.CreateThread(function()
	while true do
		if Inspector.active and not Inspector.locked then
			Inspector:UpdateMenu()
		end

		Citizen.Wait(50)
	end
end)

--[[ Commands ]]--
RegisterKeyMapping("+roleplay_inspector", "Admin - Inspector", "KEYBOARD", "PRIOR")
RegisterCommand("+roleplay_inspector", function(source, args, command)
	if not exports.user:IsMod() then return end

	if Inspector.active then
		Inspector:Deactivate()
	else
		Inspector:Activate()
	end
end, true)