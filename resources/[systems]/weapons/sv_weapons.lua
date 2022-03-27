Weapons = {
	queue = {},
}

--[[ Functions: Weapons ]]--
function Weapons:UpdateQueue()
	for source, buffer in pairs(self.queue) do
		self:UpdateBuffer(source, buffer.slotId, buffer.count)
		self.queue[source] = nil
	end
end

function Weapons:UpdateBuffer(source, slotId, count)
	-- Get player container id.
	local containerId = exports.inventory:GetPlayerContainer(source, true)
	if not containerId then return end

	-- Get item in slot.
	local item = exports.inventory:ContainerInvokeSlot(containerId, slotId, "GetItem")
	if not item or item.usable ~= "Weapon" then return end

	-- Take throwables.
	if item.category == "Throwable" then
		exports.inventory:ContainerInvokeSlot(containerId, slotId, "Destroy")
		return
	end

	-- Decay slot (1 / shots).
	exports.inventory:ContainerInvokeSlot(containerId, slotId, "Decay", (1.0 / 1000) * count)

	-- Take ammo.
	local ammoField = item.fields and item.fields[1]
	if ammoField and ammoField.name == "Ammo" then
		local slot = exports.inventory:ContainerGetSlot(containerId, slotId)
		local ammo = slot and slot.fields and slot.fields[1] or 0
		if ammo > 0 then
			exports.inventory:ContainerInvokeSlot(containerId, slotId, "SetField", 1, math.max(ammo - count, 0))
		end
	end
end

function Weapons:Shoot(source, didHit, coords, hitCoords, entity, weapon, slotId)
	-- Check slot.
	if type(slotId) ~= "number" then return end

	-- Add to queue.
	local queue = self.queue[source]
	if not queue then
		queue = {
			slotId = slotId,
			count = 0,
		}
		self.queue[source] = queue
	end

	queue.count = queue.count + 1
end

function Weapons:Load(source, weaponSlotId, magazineSlotId)
	-- Get player container id.
	local containerId = exports.inventory:GetPlayerContainer(source, true)
	if not containerId then return end

	-- Get weapon.
	local weaponSlot = exports.inventory:ContainerGetSlot(containerId, weaponSlotId)
	if not weaponSlot then return end

	local weaponItem = exports.inventory:GetItem(weaponSlot.item_id)
	local loadedAmmo = weaponSlot.fields and weaponSlot.fields[1] or -1
	local loadedDurability = (weaponSlot.fields and weaponSlot.fields[2] or 1.0) - 0.01
	local magazineName = weaponItem.ammo.." Magazine"

	-- Get magazine.
	local magazineSlot = exports.inventory:ContainerGetSlot(containerId, magazineSlotId)
	local ammo, durability

	if magazineSlot then
		local magazineItem = exports.inventory:GetItem(magazineSlot.item_id)
	
		-- Check compatibility.
		if magazineItem.name ~= magazineName then return end
	
		-- Get ammo count.
		ammo = magazineSlot.fields and magazineSlot.fields[1] or 0
		if ammo == 0 then return end
	
		-- Take magazine.
		if not exports.inventory:TakeItem(source, magazineItem.id, 1, magazineSlot.slot_id) then return end

		-- Set durability.
		durability = magazineSlot.durability or 1.0
	end

	-- Unload weapon.
	if loadedAmmo >= 0 and loadedDurability > 0.0 then
		exports.inventory:GiveItem(source, {
			item = magazineName,
			durability = loadedDurability,
			quantity = 1,
			fields = {
				[1] = loadedAmmo,
			},
		})
	end
	
	-- -- Set ammo in gun.
	exports.inventory:ContainerInvokeSlot(containerId, weaponSlot.slot_id, "SetField", 1, ammo or -1)
	exports.inventory:ContainerInvokeSlot(containerId, weaponSlot.slot_id, "SetField", 2, durability)
end

--[[ Threads ]]--
Citizen.CreateThread(function()
	while true do
		Weapons:UpdateQueue()
		Citizen.Wait(1000)
	end
end)

--[[ Events ]]--
RegisterNetEvent("shoot", function(...)
	local source = source
	Weapons:Shoot(source, ...)
end)

AddEventHandler("playerDropped", function(reason)
	local source = source
	Weapons.queue[source] = nil
end)

AddEventHandler("inventory:use", function(source, item, slot)
	if item.ammo and item.count and item.usable == "Magazine" then
		-- Get player container id.
		local containerId = exports.inventory:GetPlayerContainer(source, true)
		if not containerId then return end

		-- Get fields.
		local fields = slot.fields
		if not fields then
			fields = {}
		end

		-- Get ammo.
		local ammoName = item.ammo
		local ammo = fields[1] or 0

		local bullets = math.min(exports.inventory:ContainerCountItem(containerId, ammoName), item.count - ammo)
		if bullets == 0 then return end

		ammo = ammo + bullets

		-- Take bullets.
		if not exports.inventory:TakeItem(source, ammoName, bullets) then return end

		-- Set fields.
		exports.inventory:ContainerInvokeSlot(containerId, slot.slot_id, "SetField", 1, ammo)
	end
end)

RegisterNetEvent("weapons:loadMagazine", function(weaponSlotId, magazineSlotId)
	local source = source

	-- Check input.
	if type(weaponSlotId) ~= "number" or (magazineSlotId ~= nil and type(magazineSlotId) ~= "number") then return end
	
	-- Load magazine.
	Weapons:Load(source, weaponSlotId, magazineSlotId)
end)