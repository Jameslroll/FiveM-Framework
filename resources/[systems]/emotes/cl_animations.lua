Animations = {
	maxPerPage = 15,
}

function Animations:ToggleMenu()
	if not self.list then
		self:Load()
	end

	local window = Window:Create({
		type = "window",
		title = "Animations",
		class = "compact",
		style = {
			["width"] = "50vmin",
			["top"] = "50%",
			["right"] = "5vmin",
			["transform"] = "translate(0%, -50%)",
			["overflow"] = "visible",
		},
		prepend = {
			type = "q-icon",
			name = "cancel",
			binds = {
				color = "red",
			},
			click = {
				event = "close"
			}
		},
		defaults = {
			animations = {},
			pages = 1,
			page = 1,
			flag = 0,
		},
		components = {
			{
				type = "q-list",
				template = [[
					<div style="overflow: hidden">
						<div class="flex row">
							<q-input
								style="flex-grow: 1"
								filled
								square
								placeholder="Search"
								@keyup.enter="$invoke('search', $event.target.value)"
							>
								<template v-slot:append>
									<q-icon name="search" />
								</template>
							</q-input>
							<q-input
								filled
								square
								placeholder="Flag"
								type="number"
								:value="$getModel('flag')"
								@input="$setModel('flag', $event)"
							></q-input>
						</div>
						<q-list>
							<q-item
								v-for="(animation, key) in $getModel('animations')"
								:key="key"
								@click.left="$invoke('playanim', animation)"
								@click.right='$copyToClipboard(`{ Dict = "${animation.Dict}", Name = "${animation.Name}", Flag = ${$getModel("flag")} },`)'
								clickable
								active-class="text-white bg-grey-8"
							>
								<q-item-section>
									<q-item-label caption>{{animation.Dict}}<q-item-label>
									<q-item-label class="text-warning">{{animation.Name}}<q-item-label>
								</q-item-section>
							</q-item>
						</q-list>
						<q-separator />
						<q-pagination
							:value="$getModel('page')"
							:max="$getModel('pages')"
							@input="$setModel('page', $event)"
							max-pages=6
							style="width: 100%; justify-content: center"
							input-style="flex-grow: 1"
							dense=true
						></q-pagination>
					</div>
				]]
			},
		}
	})

	window:OnClick("close", function(self)
		UI:Focus(false)
		
		self:Destroy()
		self.list = nil
	end)

	window:AddListener("updateModel", function(self, model, value)
		if model == "page" then
			Animations:UpdatePage(value)
		end
	end)

	window:AddListener("playanim", function(self, anim)
		anim.Flag = tonumber(self.models["flag"])
		
		Main:Play(anim)
	end)

	window:AddListener("search", function(self, filter)
		if filter == "" then
			Animations.search = nil
		else
			Animations:Search(filter)
		end

		self:SetModel("page", 1)
		Animations:UpdatePage(1)
	end)

	self.window = window
	self:UpdatePage()

	UI:Focus(true)
end

function Animations:Load()
	local rawText = LoadResourceFile(GetCurrentResourceName(), "animations.txt")
	if not rawText then return end
	
	local index = 1
	local list = {}

	for line in rawText:gmatch("[^\r\n]+") do
		local dict, name = line:match("([^%s]+)%s([^%s]+)")

		list[index] = {
			Dict = dict,
			Name = name,
		}

		index = index + 1
	end

	self.list = list
end

function Animations:Search(filter)
	local result = {}
	for k, v in ipairs(self.list) do
		if v.Dict:find(filter) or v.Name:find(filter) then
			result[#result + 1] = v
		end
	end
	self.search = result
end

function Animations:UpdatePage(page)
	if not self.window then return end

	local animations = {}
	local list = self.search or self.list
	local maxPerPage = self.maxPerPage

	local offset = maxPerPage * ((tonumber(page) or 1) - 1)
	local pages = math.ceil(#list / maxPerPage)

	for i = 1, maxPerPage do
		animations[i] = list[i + offset]
	end

	self.window:SetModel({
		["animations"] = animations,
		["pages"] = pages,
	})
end