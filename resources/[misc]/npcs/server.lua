local funcs = {}

IsNpcs = GetCurrentResourceName() == "npcs"
IsNpcsReady = false

--[[ Functions ]]--
local function LoadFile(path)
	local file = LoadResourceFile("npcs", path)
	if not file then return end

	local retval, result = load(file, ("npcs/%s"):format(path), "t", _ENV)
	if not retval then
		print(("failed to load file: %s (%s)"):format(path, result))
		return
	end

	local hasLoaded = false
	repeat
		local _retval, _result = pcall(retval)
		if _retval then
			hasLoaded = true
		else
			print(("failed to execute: %s (%s)"):format(path, _result))
			Citizen.Wait(500)
		end
	until hasLoaded
end

local function Init()
	for _, funcName in ipairs(funcs) do
		local func = assert(_G[funcName])

		-- Create global.
		_G["_"..funcName] = function(...)
			return exports.npcs[funcName](exports.npcs, ...)
		end

		-- Create export.
		if IsNpcs then
			exports(funcName, function(...)
				return func(...)
			end)
		end
	end

	LoadFile("shared/config.lua")
	LoadFile("shared/main.lua")
	LoadFile("shared/npc.lua")
	
	LoadFile("server/main.lua")
	LoadFile("server/npc.lua")

	IsNpcsReady = true
end

Init()