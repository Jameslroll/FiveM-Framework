export default {
	state: () => ({
		"options": {
			enabled: true,
			name: "Options",
			theme: "red",
			component: "Options",
		},
		"phone": {
			enabled: true,
			name: "Phone",
			theme: "blue",
			component: "Phone",
			data: {
				tab: "keypad",
			},
		},
		"contacts": {
			enabled: true,
			name: "Contacts",
			parent: "phone",
			data: {
				tab: "contacts",
			},
		},
		"messages": {
			enabled: true,
			name: "Messages",
			theme: "blue",
			component: "Chat",
		},
		// "bleeter": {
		// 	enabled: true,
		// 	name: "Bleeter",
		// 	theme: "blue",
		// 	component: "Chat",
		// },
		// "lifeinvader": {
		// 	enabled: true,
		// 	name: "Life Invader",
		// 	theme: "blue",
		// 	component: "",
		// },
		// "mail": {
		// 	enabled: true,
		// 	name: "Mail",
		// 	theme: "blue",
		// 	component: "",
		// },
		// "bank": {
		// 	enabled: true,
		// 	name: "Bank",
		// 	theme: "blue",
		// 	component: "",
		// },
		// "garages": {
		// 	enabled: true,
		// 	name: "Garages",
		// 	theme: "blue",
		// 	component: "",
		// },
		// "properties": {
		// 	enabled: true,
		// 	name: "Real Estate",
		// 	theme: "blue",
		// 	component: "",
		// },
		// "business": {
		// 	enabled: true,
		// 	name: "My Business",
		// 	theme: "blue",
		// 	component: "Custom",
		// 	data: {
		// 		"count": 0,
		// 	},
		// 	methods: {
		// 		"increment": `
		// 			(x) {
		// 				this.count += x
		// 			}
		// 		`,
		// 	},
		// 	template: `
		// 		<div class="q-ma-sm">
		// 			<q-btn @click='increment(1)' label="Increment" color="green">
		// 				<q-badge :label="count" floating />
		// 			</q-btn>
		// 		</div>
		// 	`,
		// },
		// "racing": {
		// 	enabled: true,
		// 	name: "Racing",
		// 	theme: "blue",
		// 	component: "General",
		// },
	}),
	mutations: {
		addApp(state, payload) {
			var data = payload.data
			if (!data) return
			
			var load = payload.load
			if (load) {
				// Load template.
				var template = load.match(/<template>([\s\S]+)<\/template>/)
				template = template && template[1]

				data.template = template

				// Load global styles.
				var style = load.match(/<style>([\s\S]+?)<\/style>/)
				style = style && style[1]

				if (style) {
					data.style = style
				}

				// Load scoped styles.
				var scopedStyle = load.match(/<style scoped>([\s\S]+?)<\/style>/)
				scopedStyle = scopedStyle && scopedStyle[1]

				if (scopedStyle) {
					data.scopedStyle = scopedStyle
				}
				
				// Load script.
				var script = load.match(/<script>([\s\S]+)<\/script>/)
				script = script && script[1]
				script = script && script.match(/export default \w+\(({[\S\s]+})\)/)[1]

				if (script) {
					var options = Function(`return ${script}`)()
					if (options) {
						for (var key in options) {
							var value = options[key]
							if (key == "data") {
								key = "pData"
							}
							data[key] = value
						}
					}
				}
			}

			Reflect.set(state, payload.app, data)
		},
		updateApp(state, payload) {
			var app = state[payload.app]
			if (app) {
				Reflect.set(app, payload.key, payload.value)
			}
		},
	}
}