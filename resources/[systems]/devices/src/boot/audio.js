import { boot } from "quasar/wrappers"
let cache = {}

export default boot(async ({ app, router, store }) => {
	window.addEventListener("message", function(e) {
		var data = e.data

		if (data.audio) {
			app.$playSound(data.audio)
		}
	})
	app.config.globalProperties.$playSound = function(name) {
		let cached = cache[name]
		let audio = cached ?? new Audio(require(`../assets/audio/${name}.ogg`))

		if (!cached) {
			audio.load()
			cache[name] = audio
		}

		audio.currentTime = 0
		audio.play()

		return audio
	}
})
