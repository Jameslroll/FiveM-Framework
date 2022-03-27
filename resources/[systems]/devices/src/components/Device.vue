<template>
	<transition :duration="500">
		<div
			v-if="enabled"
			class="outer-device"
			:style="style"
		>
			<div
				class="inner-device"
				ref="innerDevice"
				:style="innerStyle"
			>
				<div
					class="screen"
					:style="screenStyle"
				>
					<q-img
						class="background"
						v-if="wallpaper"
						:src="wallpaper"
						alt=""
						spinner-color="white"
					/>
					<component
						class="device-layout"
						ref="deviceComponent"
						:is="settings.layout"
					/>
				</div>
				<img class="frame" :src="background" />
			</div>
		</div>
	</transition>
</template>

<script>
import { defineComponent } from "vue"
import { mapState } from "vuex"

export default defineComponent({
	name: "Device",
	props: [
		"type",
	],
	mounted() {
		if (!this.settings) {
			console.error("no settings for device")
			return
		}
		
		this.$post("loadDevice", this.$device?.type)
		this.settings.component = this
	},
	computed: {
		...mapState([
			"devices",
			"apps",
		]),
		settings() {
			return this.devices.types[this.type]
		},
		enabled() {
			return this.settings?.enabled
		},
		filteredApps() {
			if (!this.settings.apps) return []

			var apps = []

			for (var index in this.settings.apps) {
				var name = this.settings.apps[index]
				var app = name && this.apps[name]

				if (app?.enabled) {
					app.id = name
					apps.push(app)
				}
			}

			return apps
		},
		style() {
			var settings = this.settings
			if (!settings) return

			var size = this.$getData("options", "size") ?? 0
			var scale = (1.0 - size / 3.0) * 0.3 + 0.7
			
			var style = Object.assign({}, settings.style)
			var aspect = (settings.aspect ?? 1.0)
			var vmin = 100 * (settings.size ?? 1.0)

			var width = 0
			var height = 0

			var screenAspect = window.innerWidth / window.innerHeight
			if (aspect > screenAspect) {
				vmin *= 1.0 - (aspect - screenAspect) / aspect
			}

			width = vmin * aspect
			height = vmin
			
			style.width = `${width}vmin`
			style.height = `${height}vmin`
			style.transform = (style.transform ?? "") + `scale(${scale})`
			style.outline = "1px solid transparent"

			return style
		},
		innerStyle() {
			var [x, y] = this.settings?.anims?.close ?? []

			return {
				transform: `translate(${x ?? 0.0}%, ${y ?? 0.0}%)`
			}
		},
		background() {
			return require(`assets/devices/${this.settings.name}-bg.png`)
		},
		wallpaper() {
			return this.$getData("options", "background") ?? this.settings.background
		},
		screenStyle() {
			return this.settings?.screen
		},
		isPeeking() {
			return this.settings?.peek ?? false
		},
	},
	methods: {
		post(name) {
			let args = Array.from(arguments)
			args.shift()

			return this.$post("invoke", {
				name: name,
				device: this.settings?.name,
				args: args,
			})
		},
		getTransform() {
			const innerDevice = this.$refs.innerDevice
			if (!innerDevice) {
				return 0.0
			}

			let innerRect = innerDevice.getBoundingClientRect()
			let outerRect = innerDevice.parentNode.getBoundingClientRect()

			return (innerRect.left - outerRect.left) / outerRect.width * 100.0, (innerRect.top - outerRect.top) / outerRect.height * 100.0
		},
		createAnim(targetX, targetY) {
			const innerDevice = this.$refs.innerDevice
			if (!innerDevice) return

			let x, y = this.getTransform()

			let anim = innerDevice.animate([
				{ transform: `translate(${x ?? 0.0}%, ${y ?? 0.0}%)` },
				{ transform: `translate(${targetX ?? 0.0}%, ${targetY ?? 0.0}%)` }
			], {
				fill: "forwards",
				duration: 400.0,
			})

			return anim
		},
		peek() {
			console.log("peeking", this.settings?.name)
			let anim = this.createAnim(...(this.settings?.anims?.peek ?? []))
			if (anim) {
				anim.play()
			}
		},
		open() {
			console.log("opening", this.settings?.name)
			let anim = this.createAnim()
			if (anim) {
				anim.play()
			}
		},
		close() {
			console.log("closing", this.settings?.name)
			let anim = this.createAnim(...(this.settings?.anims?.close ?? []))
			if (anim) {
				anim.play()
			}
		},
	},
	watch: {
		enabled(val, oldVal) {
			if (val) {
				this.$nextTick(() => {
					if (this.settings?.peek) {
						this.peek()
					} else {
						this.open()
					}
				})
			} else {
				this.close()
			}
		},
		isPeeking(val, oldVal) {
			if (!this.enabled) return

			this.$nextTick(() => {
				if (val) {
					this.peek()
				} else {
					this.open()
				}
			})
		},
	}
})
</script>

<style scoped>
.outer-device {
	position: absolute;
	background-size: 100% 100%;
	background-repeat: no-repeat;
	padding: 0px;
	object-fit: contain;
}

.inner-device {
	position: absolute;

	top: 0%;
	bottom: 0%;
	left: 0%;
	right: 0%;
	width: 100%;
	height: 100%;
}

.frame {
	position: absolute;
	width: 100%;
	height: 100%;
	padding: 0px;
	pointer-events: none;
}

.screen {
	position: absolute;
	overflow: hidden;
	background: rgb(10, 10, 10);
	width: auto;
	height: auto;
}

.device-layout {
	width: 100% !important;
	height: 100% !important;
	min-height: 100% !important;
}
</style>