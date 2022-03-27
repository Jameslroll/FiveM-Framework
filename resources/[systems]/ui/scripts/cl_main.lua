local funcs = {
	"Get",
	"Set",
	"HasFocus",
	"SendNUIMessage",
	"SetNuiFocus",
	"SetNuiFocusKeepInput",
}

IsUi = GetCurrentResourceName() == "ui"
IsUiReady = false

--[[ Functions ]]--
local function LoadFile(path)
	local file = LoadResourceFile("ui", path)
	if not file then return end

	local retval, result = load(file, ("ui/%s"):format(path), "t", _ENV)
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

function Get(key)
	return UI.data[key]
end

function Set(key, value)
	UI.data[key] = value
end

function HasFocus()
	return UI.data.hasFocus
end

function Init()
	for _, funcName in ipairs(funcs) do
		local func = assert(_G[funcName])

		-- Create global.
		_G["_"..funcName] = function(...)
			return exports.ui[funcName](exports.ui, ...)
		end

		-- Create export.
		if IsUi then
			exports(funcName, function(...)
				return func(...)
			end)
		end
	end

	LoadFile("scripts/cl_ui.lua")
	LoadFile("scripts/cl_components.lua")
	LoadFile("scripts/cl_window.lua")
	LoadFile("scripts/cl_editor.lua")
	LoadFile("scripts/cl_navigation.lua")

	IsUiReady = true
end

--[[ Threads ]]--
Citizen.CreateThread(function()
	if IsUi then
		Init()
	else
		while GetResourceState("ui") ~= "started" do
			Citizen.Wait(0)
		end

		Init()
	end
end)