# Manifest
- Include the files in your manifest.
- Remove unused references.
```Lua
shared_scripts {
	'@utils/shared/math.lua',
}

client_scripts {
	'@utils/client/blips.lua',
	'@utils/client/entities.lua',
	'@utils/client/loading.lua',
	'@utils/client/misc.lua',
	'@utils/client/vectors.lua',
	'@utils/client/vehicles.lua',
}

server_scripts {
	'@utils/server/database.lua',
	'@utils/server/date.lua',
}
```

## Shared
### Math
```Lua
local value = Lerp(
	a --[[ number ]],
	b --[[ number ]],
	t --[[ number ]]
)
```

## Client
### Blips
```Lua
SetBlipInfo(
	blip --[[ Blip ]],
	info --[[ table ]]
)
```

### Entities
```Lua
for entity, _ in EnumerateEntities(initFunc, moveFunc, disposeFunc) do end
for object, _ in EnumerateObjects() do end
for ped, _ in EnumeratePeds() do end
for vehicle, _ in EnumerateVehicles() do end
for pickup, _ in EnumeratePickups() do end
```

### Loading
```Lua
local hasGround, groundZ
repeat
	hasGround, groundZ = WaitForGround(coords --[[ vector3 ]], timeout --[[ number ]])
	Citizen.Wait(0)
until hasGround
```

### Misc
```Lua
local retval, didHit, hitCoords, surfaceNormal, materialHash, entity = Raycast(ignore)
local streetText = GetStreetText(coords, noZone)
local netId = GetNetworkId(entity)
local distance = Distance(a, b)
```
**Asynchronous**
```Lua
Delete(entity)
```

**Synchronous**
```Lua
MoveToCoords(coords, heading, snap, timeout)
WaitForRequestModel(model)
```

### Vectors
```Lua
local vector = GetDirection(heading)
local vector = FromRotation(vector)
local rotation = ToRotation(vector)
local rotation = ToRotation2(vector)
local cross = Cross(vector1, vector2)
local dot = Dot(vector1, vector2)
local vector = Normalize(vector)
```

### Vehicles
```Lua
local vehicle, dist = GetNearestVehicle(coords, maxDist)
local boneName, dist = GetClosestDoor(coords, vehicle)
local seatIndex, dist = GetClosestSeat(coords, vehicle, mustBeEmpty)
local vehicle, hitCoords, hitDist = GetFacingVehicle(ped, maxDist) -- Find the nearest vehicle that the ped is facing.
```

## Server
#### Date
```Lua
local date = DateFromTime(time)
```

#### Database
```Lua
local retval = DescribeTable(table)
local retval = GetTableReferences(table, column)
local retval = ConvertTableResult(result)
local query = LoadQuery(path)

RunQuery(path)
WaitForTable(table)
```

#### Players
`GetActivePlayers` is only available on the client-side, but this function creates a useful alternative for the server-side.
```Lua
for source in GetActivePlayers() do
	-- Do something with player.
end
```