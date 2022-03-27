CodeEditor = {}

local function GetKvp(kvp)
	return "UiEditor-"..kvp
end

function CodeEditor:Create(data, callback, onclose)
	local template = {
		title = "Editor",
		class = "compact",
		style = {
			["width"] = "80vmin",
			["height"] = "80vmin",
			["top"] = "50%",
			["left"] = "50%",
			["transform"] = "translate(-50%, -50%)",
		},
		defaults = {
			code = (data.kvp and GetResourceKvpString(GetKvp(data.kvp))) or "",
		},
		components = {
			{
				type = "editor",
				model = "code",
				style = {
					["width"] = "100%",
					["height"] = "100%",
				},
				binds = {
					lang = "lua",
					theme = "monokai",
				},
				options = {
					enableBasicAutocompletion = false,
					enableLiveAutocompletion = true,
					enableSnippets = true,
					fontSize = 14,
					highlightActiveLine = true,
					showGutter = true,
					showPrintMargin = false,
					tabSize = 4,
					useSoftTabs = false,
				},
			},
		},
		prepend = {
			type = "q-icon",
			name = "cancel",
			style = {
				["font-size"] = "1.3em",
			},
			binds = {
				color = "red",
			},
			click = {
				callback = "this.$invoke('close')",
			},
		},
	}

	if data then
		for k, v in pairs(data) do
			template[k] = v
		end
	end
	
	local window = Window:Create(template)

	if callback then
		window:AddListener("saveEditor", callback)
	end

	if onclose then
		window:AddListener("close", onclose)
	end

	return window
end

RegisterNUICallback("saveEditor", function(data, cb)
	cb(true)

	local window = UI:GetWindow(data.id)
	if window == nil then return end

	window:InvokeListener("saveEditor", data.code)

	if window.kvp then
		SetResourceKvp(GetKvp(window.kvp), data.code)
	end
end)