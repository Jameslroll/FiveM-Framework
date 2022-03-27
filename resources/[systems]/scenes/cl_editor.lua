Editor = {}

function Editor:Open()
	local window = Window:Create({
		type = "window",
		title = "Scene Creator",
		class = "compact",
		style = {
			["width"] = "50vmin",
			["height"] = "auto",
			["top"] = "50%",
			["left"] = "50%",
			["transform"] = "translate(-50%, -50%)",
		},
		defaults = self.modelCache or {
			scene = "",
			size = 0.2,
			lifetime = 4,
		},
		prepend = {
			type = "q-icon",
			name = "help",
			components = {
				{
					type = "q-tooltip",
					html = [[
						To format text, use a modifier inside parenthesis before the text.
						<br><br>
						Fonts: marker, crayon, pen<br>
						Colors: white, red, yellow, blue, purple, green, orange<br>
						Tags: bold, italic, mark, strike
						<br><br>
						Example: (red)Red text. (crayon)Crayon font. (bold)Bold text. ()Back to normal.
					]],
				},
			},
		},
		components = {
			{
				class = "flex",
				style = {
					["flex-direction"] = "column",
					["flex-grow"] = 1,
					["height"] = "auto",
					["bottom"] = "0px",
				},
				components = {
					{
						type = "editor",
						model = "scene",
						class = "q-dark",
						style = {
							["flex-grow"] = 1,
							["height"] = "20vmin",
							["overflow-x"] = "hidden",
							["overflow-y"] = "auto",
							["border"] = "none !important",
							["border-radius"] = "0px !important",
						},
						binds = {
							lang = "txt",
							theme = "monokai",
						},
						options = {
							enableBasicAutocompletion = false,
							enableLiveAutocompletion = false,
							enableSnippets = false,
							fontSize = 14,
							highlightActiveLine = true,
							showGutter = false,
							showPrintMargin = false,
							tabSize = 4,
							useSoftTabs = false,
							wrap = true,
							indentedSoftWrap = false,
						},
					},
					{
						type = "div",
						class = "q-pa-sm q-pl-lg q-pr-lg q-dark",
						components = {
							{
								type = "q-badge",
								template = "<span>Size: {{($getModel('size') * 100).toFixed()}}%</span>",
							},
							{
								type = "q-slider",
								model = "size",
								binds = {
									min = 0.2,
									max = 1.0,
									step = 0.05,
								},
							},
							{
								type = "q-badge",
								template = "<span>Lifetime: {{$getModel('lifetime')}} hours</span>",
							},
							{
								type = "q-slider",
								model = "lifetime",
								binds = {
									min = 1,
									max = 72,
									step = 1,
								},
							},
						},
					},
					{
						type = "q-btn-group",
						binds = {
							spread = true,
						},
						components = {
							{
								type = "q-btn",
								text = "Save",
								binds = {
									color = "green",
								},
								click = {
									event = "save",
								},
							},
							{
								type = "q-btn",
								text = "Cancel",
								binds = {
									color = "red",
								},
								click = {
									event = "cancel",
								},
							},
						},
					},
				},
			},
		}
	})

	-- Cancel button.
	window:OnClick("cancel", function(self)
		Editor:Close()
	end)

	-- Save button.
	window:OnClick("save", function(self)
		local text = self.models["scene"]
		if not text then return end

		text = FormatText(text:gsub("\n", "&br;"))
		if text == "" or text == " " then return end

		local size = tonumber(self.models["size"])
		if not size then return end

		local lifetime = tonumber(self.models["lifetime"]) or 4

		Editor:Close()

		Preview:UseScene({
			type = Main.placing,
			text = text,
			width = size,
			height = size,
			lifetime = lifetime,
		})

		Editor.modelCache = self.models
	end)
	
	-- Cache window.
	self.window = window

	-- Focus.
	UI:Focus(true)
end

function Editor:Close()
	if not self.window then return end

	-- Destroy/uncache window.
	self.window:Destroy()
	self.window = nil

	-- Unfocus.
	UI:Focus(false)
end