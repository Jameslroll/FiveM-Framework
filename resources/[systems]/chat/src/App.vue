<template>
	<div id="app">
		<toasts></toasts>
		<chat></chat>
	</div>
</template>

<script>
import toasts from "@/components/Toasts.vue"
import chat from "@/components/Chat.vue"

export default {
	name: "App",
	components: {
		chat,
		toasts,
	},
	methods: {
		onMessage: function(e) {
			var data = e.data

			if (data.setter) {
				this.$store.state[data.setter.key] = data.setter.value
			} else if (data.commit) {
				this.$store.commit(data.commit.type, data.commit.payload, data.commit.options)
			}
		},
		onKeyDown: function(e) {
			if (e.key == "Escape") {
				this.$post("close")
			}
		},
	},
	created: function() {
		this.$post("init")
	},
	mounted: function() {
		window.addEventListener("keydown", this.onKeyDown)
		window.addEventListener("message", this.onMessage)

		if (this.$store.state.isDebug) {
			this.$store.state.isEnabled = true
			
			for (var i = 0; i < 4; i++) {
				this.$store.commit("addToast", {
					text: "Where am I?",
					class: "error",
					duration: 5000 + i * 1000,
				})
			}

			this.$store.commit("addToast", {
				text: "You can't do that",
				class: "inform",
				duration: 30000,
			})
			
			this.$store.commit("addToast", {
				text: "The moon landed",
				class: "success",
				duration: 60000,
			})
			
			this.$store.commit("addToast", {
				text: "Wow, this is pretty popping!",
				class: "rainbow",
				duration: 10000,
			})

			// this.$store.commit("addMessage", { class: "transparent", image: "assets/license.png", html: "<img src='https://i.gyazo.com/7d2b86625c021cf72b251b808cd8cb99.png' style='position: absolute; top: 20%; height: 60%; z-index: -1;'>" })
			// this.$store.commit("addMessage", { class: "transparent", image: "https://hatrabbits.com/wp-content/uploads/2017/01/random.jpg" })
			this.$store.commit("addMessage", { class: "advert", text: "Porttitor lacus luctus." })
			this.$store.commit("addMessage", { class: "server", title: "James", text: "Suscipit tellus mauris a diam." })
			this.$store.commit("addMessage", { class: "server", title: "pp is cute", text: "Dui accumsan sit amet nulla." })
			this.$store.commit("addMessage", { class: "server", text: "In egestas erat imperdiet sed euismod nisi. Dui accumsan sit amet nulla. Suscipit tellus mauris a diam." })
			this.$store.commit("addMessage", { class: "system", text: "Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua." })
			this.$store.commit("addMessage", { class: "emergency", text: "Id aliquet risus feugiat in ante. Turpis nunc eget lorem dolor sed viverra ipsum. Dolor morbi non arcu risus. Mi quis hendrerit dolor magna. Nunc id cursus metus aliquam eleifend mi in. Ultrices in iaculis nunc sed augue. Turpis egestas sed tempus urna et." })
			this.$store.commit("addMessage", { class: "rainbow", text: "Turpis nunc eget lorem dolor sed viverra ipsum. Dolor morbi non arcu risus. Mi quis hendrerit dolor magna. Nunc id cursus metus aliquam eleifend mi in. Ultrices in iaculis nunc sed augue. Turpis egestas sed tempus urna et." })

			setTimeout(() => {
				this.$store.commit("addMessage", { class: "nonemergency", text: "Posuere sollicitudin aliquam ultrices sagittis orci a scelerisque. Purus sit amet luctus venenatis lectus magna fringilla urna porttitor. In nulla posuere sollicitudin aliquam ultrices." })
			}, 2000)

			const random = (length = 8) => {
				let chars = "abcdefghijklmnopqrstuvwxyz"
				let str = ""
				for (let i = 0; i < length; i++) {
					str += chars.charAt(Math.floor(Math.random() * chars.length))
				}
				return str
			}

			for (var i = 0; i < 1000; i++) {
				this.$store.commit("addSuggestion", { name: random(), description: random(16) })
			}
		}
	},
}
</script>

<style>
body {
	/* background: url("https://i.imgur.com/omSvyR8.jpg"); */

	font-family: Arial, Helvetica, sans-serif;
	font-size: 1.1em;
	text-shadow: 1px 1px 2px rgba(0, 0, 0, 0.6);
	-webkit-font-smoothing: antialiased;
	-moz-osx-font-smoothing: grayscale;
	
	margin: 0px;
	padding: 0px;

	overflow: hidden;

	--border-radius: 0.5vmin;
}

#app {
	position: absolute;
	display: flex;
	flex-direction: column;

	top: 6vmin;
	left: 2vmin;
	width: 60vmin;
	background: transparent;

	overflow: visible;
}

::-webkit-scrollbar {
	display: none;
}

.fade-enter-active, .fade-leave-active {
	transition: opacity 500ms;
}

.fade-enter, .fade-leave-to {
	opacity: 0;
}
</style>
