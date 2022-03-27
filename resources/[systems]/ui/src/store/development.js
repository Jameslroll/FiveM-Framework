export default [
	{
		type: "window",
		title: "Create Character",
		style: {
			"width": "60vmin",
			"height": "auto",
			"top": "50%",
			"left": "50%",
			"transform": "translate(-50%, -50%)",
		},
		components: [
			{
				type: "q-form",
				components: [
					{
						type: "div",
						class: "row",
						binds: {
							style: {
								"flex-wrap": "nowrap",
							}
						},
						components: [
							{
								type: "name-input",
								model: "firstName",
								icon: "person",
								binds: {
									label: "First Name",
									hint: "Your character's name",
									filled: true,
									style: {
										"width": "auto",
										"flex-grow": 1,
									},
								},
							},
							{
								type: "name-input",
								model: "lastName",
								style: {
									"width": "auto",
									"flex-grow": 1,
								},
								binds: {
									label: "Last Name",
									filled: true,
								},
							},
						]
					},
					{
						type: "date-input",
						model: "dob",
						min: "1900/01/01",
						max: "2003/01/01",
						binds: {
							label: "Date of Birth",
							filled: true,
							lazyRules: true,
						},
					},
					{
						type: "q-input",
						model: "biography",
						rules: [ "val => !!val || 'Backstory required'", "val => val.length > 256 || 'Must be at least 256 characters'" ],
						prepend: {
							icon: "auto_stories",
						},
						binds: {
							label: "Biography",
							hint: "Tell us about this character",
							counter: true,
							filled: true,
							autogrow: true,
							lazyRules: true,
							maxlength: 65535,
						},
					},
					{
						type: "q-btn-group",
						binds: {
							push: true,
							spread: true,
						},
						components: [
							{
								type: "q-btn",
								click: {
									event: "cancel"
								},
								binds: {
									label: "Cancel",
									color: "red",
								},
							},
							{
								type: "q-btn",
								loadingModel: "creating",
								click: {
									event: "create",
									callback: "this.$setModel('creating', true)",
								},
								binds: {
									label: "Next",
									color: "green",
									type: "submit",
								},
							},
						]
					},
					{
						type: "slider-item",
						name: "This is a test",
						style: {
							"max-width": "30vmin",
						},
						input: true,
						minIcon: "chevron_left",
						maxIcon: "chevron_right",
						slider: {
							model: "testingSlider",
							min: 1,
							max: 10,
							step: 2,
							default: 1,
						},
					},
				],
			},
		],
	},
	{
		type: "window",
		title: "Tree",
		style: {
			"width": "20vmin",
			"height": "auto",
			"bottom": "5vmin",
			"right": "5vmin",
		},
		components: [
			{
				type: "q-tree",
				binds: {
					defaultExpandAll : true,
					nodes: [
						{
							label: "Root",
							children: [
								{
									label: "Option 1",
								},
								{
									label: "Option 2",
								},
							]
						},
					],
					nodeKey: "label",
				}
			}
		],
	},
	{
		type: "window",
		title: "Garage",
		class: "compact",
		style: {
			"width": "50vmin",
			"height": "auto",
			"top": "4vmin",
			"left": "2vmin",
		},
		prepend: {
			type: "q-icon",
			name: "help",
		},
		components: [
			{
				type: "q-table",
				class: "no-padding",
				clicks: {
					"row-click": {
						event: "rowClick",
					},
				},
				binds: {
					rowKey: "id",
					rowsPerPageOptions: [ -1 ],
					hideBottom: true,
					dense: true,
					data: [
						{
							id: 247,
							model: "Adder",
							license: "AB7E38841"
						},
						{
							id: 39507,
							model: "Adder",
							license: "19709B753"
						},
						{
							id: 22855,
							model: "Adder",
							license: "D4538D1C1"
						},
						{
							id: 41503,
							model: "Adder",
							license: "9DF9C0C25"
						},
						{
							id: 65260,
							model: "Cock",
							license: "BEA655C91"
						},
						{
							id: 24709,
							model: "Adder",
							license: "CD36CC152"
						},
						{
							id: 15794,
							model: "Adder",
							license: "CA5FB2DC3"
						},
						{
							id: 26474,
							model: "Adder",
							license: "C9AB31158"
						},
						{
							id: 15059,
							model: "Adder",
							license: "BDDD9740A"
						},
						{
							id: 31933,
							model: "Adder",
							license: "07BC84E7B"
						},
						{
							id: 16811,
							model: "Adder",
							license: "CF0D34D82"
						},
					],
					columns: [
						{
							name: "license",
							label: "License",
							align: "left",
							field: "license",
							sortable: true,
						},
						{
							name: "model",
							label: "Model",
							align: "left",
							field: "model",
							sortable: true,
						},
						{
							name: "id",
							required: true,
							label: "ID",
							align: "left",
							field: "id",
							sortable: true,
						},
					]
				},
			},
		],
	},
	{
		type: "window",
		title: "Select Character",
		class: "compact",
		style: {
			"width": "45vmin",
			"height": "auto",
			"bottom": "2vmin",
			"left": "2vmin",
		},
		defaults: {
			selection: [ { id: 1 } ],
			characters: [
				{
					id: 1,
					name: "John Doe",
					hours: 1.8,
					bank: 7435,
				},
				{
					id: 2,
					name: "Jane Doe",
					hours: 1203.2,
					bank: 21325,
				},
				{
					id: 3,
					name: "James John",
					hours: 69.6,
					bank: 745,
				},
			]
		},
		components: [
			{
				type: "q-table",
				model: "selection",
				data: "characters",
				binds: {
					rowKey: "id",
					rowsPerPageOptions: [ -1 ],
					hideBottom: true,
					dense: true,
					selection: "single",
					columns: [
						{
							name: "id",
							required: true,
							label: "Name",
							align: "left",
							field: "name",
							sortable: true,
						},
						{
							name: "bank",
							label: "Bank",
							align: "left",
							field: "bank",
							sortable: true,
						},
						{
							name: "hours",
							label: "Hours",
							align: "left",
							field: "hours",
							sortable: true,
						},
					]
				},
			},
		],
	},
	{
		type: "window",
		class: [ "compact", "transparent" ],
		style: {
			"width": "40vmin",
			"height": "auto",
			"top": "5vmin",
			"left": "50%",
			"transform": "translate(-50%, 0%)",
		},
		defaults: {
		},
		components: [
			{
				type: "q-card",
				style: {
					overflow: "hidden",
				},
				components: [
					{
						type: "q-card-section",
						template: `
							<div>
								<div class="text-h6">John Doe</div>
								<div class="text-subtitle2">
									Test<br>
									<span class='spoiler'>THIS IS A SPOIL</span>
								</div>
							</div>
						`,
					},
					{
						type: "q-separator",
					},
					{
						type: "q-card-actions",
						components: [
							{
								type: "q-btn",
								text: "Play",
								binds: {
									color: "blue",
								},
								click: {
									event: "play",
								},
							},
							{
								type: "q-btn",
								text: "Delete",
								binds: {
									color: "red",
								},
								click: {
									callback: "this.$setModel('delete', true)",
								},
								components: [
									{
										type: "q-dialog",
										model: "delete",
										components: [
											{
												type: "q-card",
												components: [
													{
														type: "q-card-section",
														class: "row items-center",
														template: "<div>Are you sure you would like to delete <b>{{$getModel('name')}}</b>?</div>",
													},
													{
														type: "q-card-actions",
														binds: {
															"align": "right",
														},
														components: [
															{
																type: "q-btn",
																text: "Confirm",
																binds: {
																	"flat": true,
																},
																click: {
																	event: "delete",
																	callback: "this.$setModel('delete', false)",
																},
															},
															{
																type: "q-btn",
																text: "Cancel",
																binds: {
																	"flat": true,
																},
																click: {
																	callback: "this.$setModel('delete', false)",
																},
															},
														],
													},
												],
											},
										],
									},
								],
							},
							{
								type: "q-space",
							},
							{
								type: "q-btn",
								icon: "auto_stories",
								model: "expanded",
								binds: {
									flat: true,
									dense: true,
									round: true,
								},
								click: {
									callback: "this.$setModel('expanded', !this.$getModel('expanded'))",
								},
							},
						],
					},
					{
						type: "q-slide-transition",
						class: "q-pa-sm",
						condition: "this.$getModel('expanded')",
						template: "<div>{{$getModel('biography')}}</div>",
						style: {
							"max-height": "20vmin",
							"overflow": "auto",
						}
					},
				]
			}
		],
	},
	// {
	// 	type: "window",
	// 	title: "Appearance",
	// 	class: "compact",
	// 	style: {
	// 		"width": "60vmin",
	// 		"height": "90vmin",
	// 		"top": "50%",
	// 		"right": "2vmin",
	// 		"transform": "translate(0%, -50%)",
	// 	},
	// 	defaults: {
	// 		tab: "features",
	// 	},
	// 	components: [
	// 		{
	// 			type: "q-card",
	// 			components: [
	// 				{
	// 					type: "q-tabs",
	// 					model: "tab",
	// 					components: [
	// 						{
	// 							type: "q-tab",
	// 							name: "features",
	// 							binds: {
	// 								label: "Features",
	// 								icon: "face",
	// 							},
	// 						},
	// 						{
	// 							type: "q-tab",
	// 							name: "clothes",
	// 							binds: {
	// 								label: "Clothes",
	// 								icon: "checkroom",
	// 							},
	// 						},
	// 						{
	// 							type: "q-tab",
	// 							name: "accessories",
	// 							binds: {
	// 								label: "Accessories",
	// 								icon: "watch",
	// 							},
	// 						},
	// 					],
	// 				},
	// 			],
	// 		},
	// 		{
	// 			type: "q-tab-panels",
	// 			model: "tab",
	// 			style: "height: 100%",
	// 			tabs: [
	// 				{
	// 					type: "q-list",
	// 					name: "features",
	// 					components: [
	// 						{
	// 							type: "q-btn",
	// 							class: "full-width",
	// 							binds: {
	// 								label: "Randomize",
	// 								color: "red",
	// 							},
	// 						},
	// 						{
	// 							type: "div",
	// 							text: "Base",
	// 							class: "title q-mt-md",
	// 						},
	// 						{
	// 							type: "q-separator",
	// 							binds: {
	// 								spaced: true
	// 							},
	// 						},
	// 						{
	// 							type: "slider-item",
	// 							name: "Parent",
	// 							minIcon: "looks_one",
	// 							input: true,
	// 							slider: {
	// 								default: 1,
	// 								model: "slider1",
	// 								min: 1,
	// 								max: 20,
	// 								step: 1,
	// 								color: "white",
	// 								snap: true,
	// 								markers: false,
	// 							},
	// 						},
	// 						{
	// 							type: "slider-item",
	// 							name: "Parent",
	// 							minIcon: "looks_two",
	// 							input: true,
	// 							slider: {
	// 								default: 1,
	// 								model: "slider2",
	// 								min: 1,
	// 								max: 20,
	// 								step: 1,
	// 								color: "white",
	// 								snap: true,
	// 								markers: false,
	// 							},
	// 						},
	// 						{
	// 							type: "slider-item",
	// 							name: "Face Blend",
	// 							minIcon: "looks_one",
	// 							maxIcon: "looks_two",
	// 							input: true,
	// 							slider: {
	// 								model: "slider5",
	// 								default: 0.5,
	// 								min: 0.0,
	// 								max: 1.0,
	// 								step: 0.05,
	// 								color: "white",
	// 								snap: true,
	// 								markers: false,
	// 							},
	// 						},
	// 						{
	// 							type: "slider-item",
	// 							name: "Skin Blend",
	// 							minIcon: "looks_one",
	// 							maxIcon: "looks_two",
	// 							input: true,
	// 							slider: {
	// 								model: "slider3",
	// 								default: 0.5,
	// 								min: 0.0,
	// 								max: 1.0,
	// 								step: 0.05,
	// 								color: "white",
	// 								snap: true,
	// 								markers: false,
	// 							},
	// 						},
	// 						{
	// 							type: "div",
	// 							text: "Proportions",
	// 							class: "title q-mt-md",
	// 						},
	// 						{
	// 							type: "q-separator",
	// 							binds: {
	// 								spaced: true
	// 							},
	// 						},
	// 						{
	// 							type: "slider-item",
	// 							name: "Something",
	// 							minIcon: "arrow_back",
	// 							maxIcon: "arrow_forward",
	// 							input: true,
	// 							slider: {
	// 								model: "slider4",
	// 								default: 0.5,
	// 								min: 0.0,
	// 								max: 1.0,
	// 								step: 0.05,
	// 								color: "white",
	// 								snap: true,
	// 								markers: false,
	// 							},
	// 						},
	// 						{
	// 							type: "div",
	// 							text: "More",
	// 							class: "title q-mt-md",
	// 						},
	// 						{
	// 							type: "q-separator",
	// 							binds: {
	// 								spaced: true
	// 							},
	// 						},
	// 						{
	// 							type: "slider-item",
	// 							name: "Other",
	// 							minIcon: "arrow_back",
	// 							maxIcon: "arrow_forward",
	// 							input: true,
	// 							slider: {
	// 								model: "slider6",
	// 								default: 0.5,
	// 								min: 0.0,
	// 								max: 1.0,
	// 								step: 0.05,
	// 								color: "white",
	// 								snap: true,
	// 								markers: false,
	// 							},
	// 							secondary: {
	// 								model: "slider6-opacity",
	// 								default: 0.0,
	// 								min: 0.0,
	// 								max: 1.0,
	// 								step: 0.05,
	// 								color: "white",
	// 								snap: true,
	// 								markers: false,
	// 								labelValue: "Opacity",
	// 							},
	// 						},
	// 					],
	// 				},
	// 				{
	// 					name: "clothes",
	// 				},
	// 			],
	// 		},
	// 	],
	// },
	{
		type: "window",
		title: "Editor",
		class: "compact",
		style: {
			"width": "20vmin",
			"height": "20vmin",
			"top": "5vmin",
			"right": "5vmin",
		},
		components: [
			{
				type: "editor",
				model: "code",
				style: {
					"width": "100%",
					"height": "100%",
				},
				binds: {
					lang: "lua",
					theme: "monokai",
				},
				options: {
					enableBasicAutocompletion: true,
					enableLiveAutocompletion: true,
					fontSize: 14,
					highlightActiveLine: true,
					enableSnippets: true,
					showLineNumbers: true,
					tabSize: 4,
					showPrintMargin: false,
					showGutter: true,
				},
			},
		],
	},
]