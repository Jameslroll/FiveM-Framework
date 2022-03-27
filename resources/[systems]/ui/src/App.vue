<template>
	<div id="app">
		<node
			v-for="component in nodes"
			:key="component.id"
			:info="component"
		>
		</node>
	</div>
</template>

<script>
import node from "@/components/Node.vue"

export default {
	name: "App",
	components: {
		node
	},
	data: function() {
		return {
			keys: {},
		}
	},
	computed: {
		nodes: function() {
			let components = []
			for (var id in this.$store.state.components) {
				var component = this.$store.state.components[id]
				if (component) {
					components.push(component)
				}
			}

			return components
		}
	},
	methods: {
		debug: function() {
			this.$store.state.components = {}
			
			const store = this.$store
		
			let components = {}
			let lastId = 0

			let add = function(component, parent) {
				let id = lastId++

				component.id = id
				component.parent = parent?.id
				component.components = {}

				store.commit("addComponent", JSON.stringify(component))

				components[id] = component

				return component
			}

			let update = function(component) {
				store.commit("updateComponent", JSON.stringify(component))
			}

			var x = add({
				type: "window",
				title: "Window X",
				style: {
					top: "5vmin",
					width: "50vmin",
					height: "50vmin",
				},
			})

			var y = add({
				type: "q-form",
			}, x)

			for (var i = 0; i < 10; i++) {
				let abc = add({
					type: "q-item",
					text: "HELLO WORLD " + (i + 1),
				}, y)

				if (i == 2 - 1) {
					setTimeout(() => {
						store.commit("removeComponent", abc.id)
					}, 1000 + i * 100)
				}
			}

			var eee = add({
				type: "window",
				title: "Test EEE",
				id: 2,
				style: {
					top: "5vmin",
					right: "0px",
					width: "20vmin",
					height: "20vmin",
				},
			})

			let e = add({
				type: "div",
				text: "6969696",
			}, y)

			setTimeout(() => {
				e.text = "Hello World"
				update(e)
			}, 3000)
		}
	},
	mounted: function() {
		this.$post("init")

		document.addEventListener("keydown", e => {
			if (!this.keys[e.key]) {
				this.$post("keydown", e.key)
				this.keys[e.key] = true
			}
		})

		document.addEventListener("keyup", e => {
			this.$post("keyup", e.key)
			delete this.keys[e.key]
		})

		// this.debug()
	},
}
</script>

<style>
body {
	position: relative;

	margin: 0px;
	padding: 0px;

	overflow: hidden;
	/* background: url("https://i.imgur.com/omSvyR8.jpg") !important; */
	background: transparent !important;

	-webkit-user-select: none;
	user-select: none;

	--border-radius: 0.5vmin;
}

#app {
	position: relative;
	display: block;

	width: 100vw;
	height: 100vh;

	font-family: Arial, Helvetica, sans-serif;
	-webkit-font-smoothing: antialiased;
	-moz-osx-font-smoothing: grayscale;
}

/* Scrollbars */
::-webkit-scrollbar {
	width: 6px;
}

::-webkit-scrollbar-track {
	background: rgba(20, 20, 20, 0.6);
}

::-webkit-scrollbar-thumb {
	background: rgba(255, 255, 255, 0.8);
	border-radius: var(--border-radius);
}

/* Tables */
.q-table__card {
	background: transparent !important;
}

td, th, tr, thead, tbody {
	border-color: transparent !important;
	background: transparent !important;
}

tr {
	background: rgba(50, 50, 50, 0.8) !important;
}

tr:nth-child(2n) {
	background: rgba(40, 40, 40, 0.8) !important;
}

thead tr {
	background: linear-gradient(to bottom, rgba(50, 50, 50, 0.8), rgba(30, 30, 30, 0.8)) !important;
}

th {
	font-weight: 800 !important;
}

/* Cards */
.q-card {
	background: linear-gradient(to bottom, rgba(50, 50, 50, 0.8), rgba(30, 30, 30, 0.8)) !important;
}

/* Other */
.title {
	font-weight: 800;
	font-size: 1em;
}

.spoiler {
	color: transparent;
	background: rgba(0, 0, 0, 0.8);
}

.spoiler:hover {
	color: inherit;
	background: transparent;
	user-select: all;
}
</style>
