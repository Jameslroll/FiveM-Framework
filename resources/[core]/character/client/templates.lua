Templates = {}

Templates.Characters = {
	type = "window",
	title = "Select Character",
	class = "compact",
	style = {
		["width"] = "45vmin",
		["height"] = "auto",
		["bottom"] = "2vmin",
		["left"] = "2vmin",
	},
	defaults = {
		characters = {},
	},
	components = {
		{
			type = "q-list",
			template = [[
				<div>
					<q-item
						v-for="character in $getModel('characters')"
						:key="character.id"
						@click="$setModel('selection', $getModel('selection') == character.id ? 0 : character.id)"
						clickable
						:active="$getModel('selection') == character.id"
						active-class="text-white bg-grey-8"
					>
						<q-item-section side>
							<q-icon :name="character.gender == 'Non-binary' && 'transgender' || character.gender.toLowerCase()" />
						</q-item-section>
						<q-item-section>
							<q-item-label lines="1">{{character.first_name}} {{character.last_name}}<q-item-label>
							<q-item-label caption lines="2">
								<div>Bank: ${{character.bank}}</div>
							<q-item-label>
						</q-item-section>
						<q-item-section side top>
							{{Math.floor(character.time_played / 3600.0)}} hours {{Math.floor(character.time_played % 3600.0 / 3600.0 * 60.0)}} minutes
						</q-item-section>
					</q-item>
				</div>
			]]
		},
		{
			type = "q-btn",
			text = "Create Character",
			binds = {
				color = "green",
			},
			click = {
				event = "create",
			},
		},
	},
}

Templates.Selection = {
	type = "window",
	class = { "compact", "transparent" },
	style = {
		["width"] = "40vmin",
		["height"] = "auto",
		["top"] = "5vmin",
		["left"] = "50%",
		["transform"] = "translate(-50%, 0%)",
	},
	components = {
		{
			type = "q-card",
			condition = "this.$getModel('name')",
			style = {
				["overflow"] = "hidden",
			},
			components = {
				{
					type = "q-card-section",
					template = [[
						<div>
							<div class="text-h6">{{$getModel("name")}}</div>
							<div class="text-subtitle2" v-html='$getModel("details")'></div>
						</div>
					]],
				},
				{
					type = "q-separator",
				},
				{
					type = "q-card-actions",
					components = {
						{
							type = "q-btn",
							text = "Play",
							binds = {
								color = "blue",
							},
							click = {
								event = "play",
							},
						},
						{
							type = "q-btn",
							text = "Delete",
							condition = "this.$getModel('canDelete')",
							binds = {
								color = "red",
							},
							click = {
								callback = "this.$setModel('delete', true)",
							},
						},
						{
							type = "q-space",
						},
						{
							type = "q-btn",
							icon = "auto_stories",
							model = "expanded",
							binds = {
								flat = true,
								dense = true,
								round = true,
							},
							click = {
								callback = "this.$setModel('expanded', !this.$getModel('expanded'))",
							},
						},
					},
				},
				{
					type = "q-slide-transition",
					class = "q-pa-sm",
					condition = "this.$getModel('expanded')",
					template = "<div>{{$getModel('biography')}}</div>",
					style = {
						["max-height"] = "20vmin",
						["overflow"] = "auto",
					},
				},
			},
		},
		{
			type = "q-dialog",
			model = "delete",
			components = {
				{
					type = "q-card",
					components = {
						{
							type = "q-card-section",
							class = "row items-center",
							template = "<div>Are you sure you would like to delete <b>{{$getModel('name')}}</b>?</div>",
						},
						{
							type = "q-card-actions",
							binds = {
								["align"] = "right",
							},
							components = {
								{
									type = "q-btn",
									text = "Confirm",
									binds = {
										["flat"] = true,
									},
									click = {
										event = "delete",
										callback = "this.$setModel('delete', false)",
									},
								},
								{
									type = "q-btn",
									text = "Cancel",
									binds = {
										["flat"] = true,
									},
									click = {
										callback = "this.$setModel('delete', false)",
									},
								},
							},
						},
					},
				},
			},
		},
	},
}

Templates.Create = {
	type = "window",
	title = "Create Character",
	style = {
		["width"] = "55vmin",
		["height"] = "auto",
		["top"] = "50%",
		["left"] = "50%",
		["transform"] = "translate(-50%, -50%)",
	},
	components = {
		{
			type = "q-form",
			binds = {
				autofocus = true,
			},
			components = {
				{
					type = "div",
					class = "row",
					style = {
						["flex-wrap"] = "nowrap",
					},
					components = {
						{
							type = "name-input",
							model = "firstName",
							icon = "person",
							style = {
								["max-width"] = "49%",
								["flex-grow"] = 1,
							},
							binds = {
								label = "First Name",
								hint = "Your character's name",
								filled = true,
							},
						},
						{
							type = "name-input",
							model = "lastName",
							style = {
								["max-width"] = "49%",
								["flex-grow"] = 1,
							},
							binds = {
								label = "Last Name",
								filled = true,
							},
						},
					},
				},
				{
					type = "date-input",
					model = "dob",
					min = "1900/01/01",
					max = "2003/01/01",
					binds = {
						label = "Date of Birth",
						filled = true,
						lazyRules = true,
					},
				},
				{
					type = "q-input",
					model = "biography",
					rules = { "val => !!val || 'Backstory required'", "val => val.length > 256 || 'Must be at least 256 characters'" },
					prepend = {
						icon = "auto_stories",
					},
					binds = {
						label = "Biography",
						hint = "Tell us about this character",
						counter = true,
						filled = true,
						autogrow = true,
						lazyRules = true,
						maxlength = 65535,
					},
					components = {
						{
							type = "q-tooltip",
							text = "Tell us about your character. This may be reviewed by admins, and failing to take it seriously could result in losing your character. This will also show when sharing your characters in Discord.",
							binds = {
								anchor = "top right",
								self = "top left",
								offset = { 20, 0 },
								["max-width"] = "20vmin",
							},
						},
					},
				},
				{
					type = "div",
					class = "row",
					style = {
						["flex-wrap"] = "nowrap",
					},
					components = {
						{
							type = "q-select",
							model = "gender",
							style = {
								["flex-grow"] = 1,
								["max-width"] = "49%",
							},
							prepend = {
								icon = "transgender",
							},
							binds = {
								label = "Gender",
								filled = true,
								options = { "Male", "Female", "Non-binary" },
							},
							components = {
								{
									type = "q-tooltip",
									text = "What is your character's legal gender?",
									binds = {
										anchor = "top left",
										self = "top right",
										offset = { 20, 0 },
										["max-width"] = "20vmin",
									},
								},
							},
						},
						{
							type = "q-select",
							model = "origin",
							style = {
								["flex-grow"] = 1,
								["max-width"] = "49%",
							},
							prepend = {
								icon = "place",
							},
							binds = {
								label = "Origin",
								filled = true,
								options = { "Legion Square", "Vinewood Hills", "South Side", "Little Seoul", "Vespucci Beach", "Sandy Shores", "Paleto Bay", "Cayo Perico" },
							},
							components = {
								{
									type = "q-tooltip",
									text = "Where will your character spawn for the first time? Selecting Cayo Perico will officially register you as a citizen there and switching may be difficult, so use with caution.",
									binds = {
										anchor = "top right",
										self = "top left",
										offset = { 20, 0 },
										["max-width"] = "20vmin",
									},
								},
							},
						},
					},
				},
				{
					type = "q-separator",
					binds = {
						spaced = true,
					},
				},
				{
					type = "q-btn-group",
					binds = {
						push = true,
						spread = true,
					},
					components = {
						{
							type = "q-btn",
							click = {
								event = "cancel"
							},
							binds = {
								label = "Cancel",
								color = "red",
							},
						},
						{
							type = "q-btn",
							loadingModel = "creating",
							click = {
								event = "create",
								callback = "this.$setModel('creating', true)",
							},
							binds = {
								label = "Create",
								color = "green",
							},
						},
						-- {
						-- 	type = "q-btn",
						-- 	click = {
						-- 		callback = "this.$setModel('random', true)",
						-- 	},
						-- 	style = {
						-- 		["max-width"] = "8vmin",
						-- 	},
						-- 	binds = {
						-- 		icon = "shuffle",
						-- 		color = "blue",
						-- 	},
						-- 	components = {
						-- 		{
						-- 			type = "q-tooltip",
						-- 			html = "Show character generator",
						-- 		},
						-- 		{
						-- 			type = "q-dialog",
						-- 			model = "random",
						-- 			components = {
						-- 				{
						-- 					type = "q-card",
						-- 					components = {
						-- 						{
						-- 							type = "q-card-section",
						-- 							components = {
						-- 								{
						-- 									text = "Random",
						-- 									class = "text-h6",
						-- 								},
						-- 							},
						-- 						},
						-- 					},
						-- 				},
						-- 			},
						-- 		},
						-- 	},
						-- },
					},
				},
			},
		},
	},
}