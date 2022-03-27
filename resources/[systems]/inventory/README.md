# Reference

## Definitions
### Inventory
The back-bone of the entire system. Keeps track of containers and players.

### Containers
Holds slots and handles players subscribed to them, among other things.

### Slots
Contained inside containers, slots store information about the item occupying that slot.

Updating slots invokes the following events:

```Lua
-- Client - after a slot is set.
AddEventHandler("inventory:updateSlot", function(containerId, slotId, slot, item) end)
```

### Items
Pre-defined items that have attributes such as name, weight, and etc..

Using items invokes the following events:

```Lua
-- Client - before item is used.
AddEventHandler("inventory:use", function(item, slot, cb)
	cb(duration, emote)
end)

-- Client - after item is used, before wait.
AddEventHandler("inventory:useBegin", function(item, slot) end)

-- Client - after item is used, after wait.
AddEventHandler("inventory:useFinish", function(item, slot) end)

-- Client - while item is used, if canceled.
AddEventHandler("inventory:useCancel", function(item, slot) end)

-- Server - after item is used.
AddEventHandler("inventory:use", function(source, item, slot) end)
```

### Players
Each player has their own container for their character, among other things like cooldowns.

## Exports
```Lua
-- Server - general.
local isLoaded = exports.inventory:IsLoaded() -- if everything initialized.
local containers = exports.inventory:GetContainers() -- returns every single container. (slow)
local container = exports.inventory:LoadContainer(data, create)
local container = exports.inventory:RegisterContainer(data)

exports.inventory:DestroyContainer(id, save) -- destroy container, from database too?

-- Server - player related.
local containerId = exports.inventory:GetPlayerContainer(source, onlyId) -- return container or the id of a player.
local hasItem = exports.inventory:HasItem(source, name, minDurability)
local quantity = exports.inventory:CountItem(source, name)
local hasSpace = exports.inventory:HasSpace(source) -- are any slots empty?

exports.inventory:TakeItem(source, name, amount)
exports.inventory:GiveItem(source, name, amount, fields, slot)
exports.inventory:Subscribe(source, containerId, value)

-- Server - station related.
exports.inventory:RegisterRecipe(recipe)
exports.inventory:RegisterStation(id, _type, isAuto)
exports.inventory:UnloadStation(id)
exports.inventory:SubscribeStation(source, id, value)

-- Shared - general.
local container = exports.inventory:GetContainer(id) -- get container by id.
local value = exports.inventory:GetFromContainer(id, key) -- get key from container by id.
local item = exports.inventory:GetItem(name or id)
local itemId = exports.inventory:GetItemId(name) -- get item id from name.
local items = exports.inventory:GetItems() -- gets all items. (slow)

-- Client - general.
local container = exports.inventory:GetPlayerContainer()
local hasItem = exports.inventory:HasItem(name)
local quantity = exports.inventory:CountItem(name)

exports.inventory:RegisterContainer(data)
exports.inventory:UpdateContainer(id, data)
exports.inventory:Subscribe(id)
exports.inventory:Unsubscribe(id)
```

### Containers
On the server-side, container meta-functions can be invoked using `Container` followed by the function name.

```Lua
local result = exports.inventory:ContainerFUNC(containerId, ...)
```

Available slot-meta functions are:
```Lua
-- Server.
AddItem(data, ...)
AddMoney(quantity, useWallet)
CalculateSlots(item, quantity, offset)
CheckFilter(item)
CountItems()
CountSlots()
Create(data)
Destroy(save)
GetFirstEmptySlot(sourceSlot)
GetParent()
GetSlot(id)
Inform(target)
InformAll(payload)
InformSlots(slotA, slotB)
InvokeSlot(slotId, funcName, ...)
IsEmpty()
IsNested()
IsSubscribed(source)
LoadSlots()
MergeSlots(sourceSlot, targetSlot, targetContainer, quantity)
MoveSlot(id, target, quantity, source)
RemoveItem(data, quantity, slotId)
SetSlot(id, info)
Subscribe(source, value)
SwapSlots(sourceSlot, targetSlot, targetContainer)
UpdateMoney()
UpdateNestedSlot(updated)

-- Shared.
CanCarry(weight)
CompareSnowflake(snowflake)
CountItem(name)
CountMoney(checkWallet)
FindFirst(name, func)
Get(key)
GetSettings(key)
GetSize()
GetWeight()
HasItem(name, minDurability)
IsVirtual()
UpdateSnowflake()
UpdateWeight()
```

### Slots
On the server-side, slot meta-functions can be invoked using `ContainerInvokeSlot`.
```Lua
local result = exports.inventory:ContainerInvokeSlot(containerId, slotId, func, ...)
```

Available slot meta-functions are:

```Lua
-- Getters.
GetWeight() -- returns the total weight of the slot.
GetItem() -- return the item bound to the slot.
GetContainer() -- return the container the slot is in. (redundant)
GetField(key) -- return a field value.

-- Setters.
SetField(key, value) -- set a field value.
SetInfo(info) -- sets all slot data. (volatile)

-- Invokers.
Create(id) -- (volatile)
Destroy(skipInform) -- (volatile)
Save(setLastUpdate) -- (volatile)
Split(targetContainer, targetSlotId, quantity) -- move some of the quantity. (volatile)
Subtract(quantity) -- take from the quantity. (volatile)
Decay(amount) -- remove an amount from the slot's durability.
```

```Lua
-- Server.
exports.inventory:RegisterContainer()
```

## Hooks
Many events within the system trigger hooks with data passed through. By hooking into them, data can be modified during certain events. For example, moving an item, subscribing to a container, or destroying containers.

### Generics
```Lua
-- Shared - after inventory loaded.
Inventory:AddHook("init")
```

### Containers
```Lua
-- Shared - after containers are registered.
Inventory:AddHook("registerContainer", function(container) end)

-- Server - before containers are destroyed.
Inventory:AddHook("destroyContainer", function(container)
	return true, ""
end)

-- Server - before players subscribe to containers.
Inventory:AddHook("subscribe", function(container, player, value)
	return true, ""
end)
```

### Slots
```Lua
-- Client - before slots are moved.
Inventory:AddHook("moveSlot", function(container, sourceItem, sourceSlot, target, quantity)
	return true, ""
end)

-- Server - before slots are moved.
Inventory:AddHook("moveSlot", function(sourceContainer, sourceSlot, target, quantity, source)
	return true, ""
end)

-- Server - after slots are moved.
Inventory:AddHook("slotMoved", function(sourceContainer, sourceSlot, targetContainer, targetSlot) end)

-- Server - after an item is added.
Inventory:AddHook("itemAdded", function(container, slot, quantity) end)

-- Shared - before slots are used.
Inventory:AddHook("useItem", function(container, slot, item) end)
```

### Players
```Lua
-- Server - after player is registered (character selected).
Inventory:AddHook("registerPlayer", function(player) end)

-- Server - after player is destroyed (disconnecting or switching characters).
Inventory:AddHook("destroyPlayer", function(player) end)
```

# Building

## Project setup
```
npm install
```

### Compiles and hot-reloads for development
```
npm run serve
```

### Compiles and minifies for production
```
npm run build
```

### Lints and fixes files
```
npm run lint
```

### Customize configuration
See [Configuration Reference](https://cli.vuejs.org/config/).