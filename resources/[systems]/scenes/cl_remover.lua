Remover = {}

function Remover:Begin(slotId)
	self.slot = slotId
	self.removing = true

	self.hint = Window:Create({
		template = ([[
			<div class="column">
				<div style="display: flex; justify-content: space-between">
					<span>Remove</span>
					<span>%s</span>
				</div>
			</div>
		]]):format(GetControlInstructionalButton(0, Config.Remover.Control, true):gsub("._", "")),
		style = {
			["right"] = "10vmin",
			["top"] = "20vmin",
			["width"] = "15vmin",
		}
	})
end

function Remover:End()
	self.removing = false
	
	if self.hint then
		self.hint:Destroy()
		self.hint = nil
	end
end

function Remover:Update()
	-- Display.
	local retval, didHit, hitCoords, surfaceNormal, materialHash, entity = table.unpack(Raycast())
	local ped = PlayerPedId()
	local coords = GetEntityCoords(ped)

	if not didHit or #(coords - hitCoords) > Config.Remover.MaxDistance then
		return
	end

	DrawSphere(hitCoords.x, hitCoords.y, hitCoords.z, Config.Remover.Radius, 255, 0, 0, 0.2)

	-- Control.
	DisableControlAction(0, Config.Remover.Control)
	
	if IsDisabledControlJustPressed(0, Config.Remover.Control) then
		self:End()
		TriggerServerEvent(Main.event.."remove", hitCoords, self.slot)
	end
end

--[[ Threads ]]--
Citizen.CreateThread(function()
	while true do
		if Remover.removing then
			Remover:Update()
			Citizen.Wait(0)
		else
			Citizen.Wait(200)
		end
	end
end)

--[[ Events ]]--
RegisterNetEvent("inventory:use_"..Config.Remover.Item)
AddEventHandler("inventory:use_"..Config.Remover.Item, function(item, slotId)
	if Remover.removing then
		Remover:End()
	else
		Remover:Begin(slotId)
	end
end)