<template>
	<div id="app">
		<preview></preview>
		<inventory v-if="$store.state.isEnabled"></inventory>
	</div>
</template>

<script>
import preview from "@/components/Preview.vue"
import inventory from "@/components/Inventory.vue"

export default {
	name: "App",
	components: {
		preview,
		inventory,
	},
	mounted: function() {
		window.addEventListener("keydown", this.onKeyDown)
		window.addEventListener("keyup", this.onKeyUp)
		window.addEventListener("message", this.onMessage)

		window.keys = {}

		if (this.$store.state.isDebug) {
			this.$store.state.isEnabled = true
			this.$store.state.station = "Workbench"
			
			this.$commit("cacheItems", JSON.parse(this.$store.state.debugItems))

			for (var containerId in this.$store.state.debugContainers) {
				var container = this.$store.state.debugContainers[containerId]
				this.$commit("addContainer", container)
			}

			window.postMessage({
				setter: {
					key: "recipes",
					value: this.$store.state.debugRecipes,
				}
			})

			this.$nextTick(function() {
				this.$commit("addPreview", {
					key: 0,
					name: "Donut",
					change: "Use",
					use_time: 6000,
				})
				
				setTimeout(() => {
					this.$commit("addPreview", {
						key: 1,
						name: "Apple",
						change: 8,
					})
				}, 500)

				setTimeout(() => {
					this.$commit("addPreview", {
						key: 2,
						name: "Cocaine",
						change: "Use",
					})
				}, 1000)

				setTimeout(() => {
					this.$commit("addPreview", {
						key: 3,
						name: "Donut",
						change: -3,
					})
				}, 1500)

				setTimeout(() => {
					for (var i = 0; i < 3; i++) {
						this.$commit("addPreview", {
							key: 4 + i,
							name: "Bills",
							change: 8621 * (i + 1),
						})
					}
				}, 2000)
			})
		}
	},
	methods: {
		onMessage: function(event) {
			var data = event.data

			if (data.setter) {
				this.$store.state[data.setter.key] = data.setter.value
			} else if (data.commit) {
				this.$commit(data.commit.type, data.commit.payload, data.commit.options)
			}
		},
		onKeyDown: function(event) {
			window.keys[event.key] = true
		},
		onKeyUp: function(event) {
			if (event.key in window.keys) {
				delete window.keys[event.key]
			}
		},
	},
}
</script>

<style>
@font-face {
	font-family: "Open Sans";
	font-style: normal;
	font-weight: normal;
	src: url("./assets/fonts/OpenSans-Regular.ttf");
}

body {
	background: transparent;
	overflow: hidden;
	padding: 0%;
	margin: 0%;
	user-select: none;
	font-family: "Open Sans";
	font-size: 2vmin;
}

#app {
	width: 100vw;
	height: 100vh;
}
</style>
