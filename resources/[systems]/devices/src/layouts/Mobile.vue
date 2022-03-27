<template>
	<div :class="['root', isHome ? 'home' : '', themeClass]">
		<div class="bar">
			<q-icon
				v-for="(icon, key) in barIcons"
				:key="key"
				:name="icon"
			/>
			<q-space />
			<q-icon name="signal_cellular_4_bar" />
			<div>100%</div>
			<q-icon name="battery_full" />
			<div>{{$getData(null, "time") ?? "12:00 PM"}}</div>
		</div>
		<div class="app-header" v-if="currentApp">
			{{currentApp.name}}
		</div>
		<div class="outer-content">
			<transition name="change">
				<component
					class="inner-content"
					ref="content"
					:is="contentComponent"
					:app="currentApp"
					:name="device.name"
					@setApp="setApp"
					@goBack="goBack"
				></component>
			</transition>
		</div>
		<div class="menu">
			<q-btn round flat @click="goBack()" icon="arrow_left" />
			<q-btn round flat @click="goHome()" icon="radio_button_checked" />
			<q-btn round flat @click="close()" icon="more_horiz" />
		</div>
		<div class="notifications">
			<div
				v-for="(notification, key) in notifications"
				:key="key"
				class="notification"
			>
				<div v-if="notification.avatar">
					<q-avatar :color="$colors[notification.avatar.color ?? 0] ?? 'primary'" size="2.5vmin" class="q-mr-sm">
						<q-img :src="notification.avatar.icon" v-if="notification.avatar.icon" style="object-fit: cover;" />
						<q-item-label v-if="!notification.avatar.icon" class="text-white">{{$root.formatName(notification.avatar.name)}}</q-item-label>
						<q-badge v-if="notification.avatar.unread" rounded floating color="red">{{notification.avatar.unread}}</q-badge>
					</q-avatar>
				</div>
				<q-item-section>
					<q-item-label v-if="notification.title" class="text-weight-bold">{{notification.title}}</q-item-label>
					<q-item-label>{{notification.text}}</q-item-label>
				</q-item-section>
				<q-space />
				<span class="q-mr-sm" v-if="notification.timer">
					{{notification.timer}}
				</span>
				<q-btn
					@click="callAnswer"
					v-if="notification.answer"
					icon="call"
					color="green"
					size="0.8vmin"
					style="margin-right: 0.5vmin"
					round
				/>
				<q-btn
					@click="callEnd"
					v-if="notification.hangup"
					icon="call_end"
					color="red"
					size="0.8vmin"
					round
				/>
			</div>
		</div>
	</div>
</template>

<script>
import { defineComponent } from "vue"
import Home from "pages/Home"

export default defineComponent({
	name: "Mobile",
	data() {
		return {
			styleRef: undefined,
			currentApp: undefined,
			contentComponent: Home,
			themeClass: "default",
			notifications: {},
			notificationCount: 0,
		}
	},
	mounted() {
		setInterval(this.updateTimer, 1000)

		let cache = this.$device.settings.cache
		let app = cache?._app

		if (app) {
			this.$nextTick(() => {
				this.setApp(app)
			})
		} else if (!cache) {
			this.$device.settings.cache = {}
		}

		if (!this.$device.settings.history) {
			this.$device.settings.history = []
		}
	},
	beforeUnmount() {
		var cache = this.$device.settings.cache
		if (!cache) return

		// Cache app.
		this.cacheApp()
		cache._app = this.currentApp

		// Close triggers.
		if (this.currentApp?.id) {
			this.device.post("CloseApp", this.currentApp.id)
		}
	},
	computed: {
		device() {
			return this.$device
		},
		isHome() {
			return this.contentComponent?.name == "Home"
		},
		barIcons() {
			var icons = []

			if (this.device.settings.name == "phone") {
				let notify = this.$getData("options", "notify") ?? 0
				switch (notify) {
					case 0:
						icons.push("notifications")
						break
					case 1:
					case 2:
						icons.push("notifications_active")
						break
					case 3:
						icons.push("notifications_off")
						break
				}
			}

			return icons
		},
	},
	methods: {
		reset() {
			this.goHome()
		},
		close() {
			if (this.$isDebug) {
				this.$store.commit("toggleDevice", { name: this.$device.settings.name, value: false })
			} else {
				this.$post("close")
			}
		},
		goHome() {
			this.setApp()
		},
		goBack() {
			// Remove current history.
			this.$device.settings.history.pop()

			// Get previous history.
			var last = this.$device.settings.history.pop()
			
			// Set app, if undefined then goes home.
			this.setApp(last)
		},
		setApp(id, data) {
			// Get the app.
			var app = undefined
			if (typeof id == "object") {
				app = id
				id = id.id
			} else {
				app = this.device.apps[id]
			}

			if (app?.parent) {
				this.setApp(app.parent, app.data)
				return
			}

			// Create or clear styles.
			var styleRef = this.styleRef
			if (!styleRef) {
				styleRef = document.createElement("style")
				styleRef.type = "text/css"

				this.styleRef = styleRef

				document.querySelector("head").appendChild(styleRef)
			} else if ((styleRef?.childNodes?.length ?? 0) > 0) {
				styleRef.childNodes[0].remove()
			}

			// Cache app id.
			if (app) {
				app.id = id
			}

			// Event responses for last app.
			var contentRef = this.$refs["content"]
			if (contentRef?.$options?.deactivated) {
				contentRef.$options.deactivated()
			}

			// Cache data.
			this.cacheApp()

			// Trigger event.
			if (this.currentApp?.id) {
				this.device.post("CloseApp", this.currentApp.id)
			}

			// Destroy last app.
			if (contentRef?.$destroy) {
				contentRef.$destroy()
			}

			// Load the app.
			if (app) {
				import(`pages/${app.component ?? app.name}`).then(c => {
					this.contentComponent = undefined
					this.currentApp = undefined

					this.$nextTick(() => {
						// Cache everything.
						this.contentComponent = c.default
						this.currentApp = app
						this.themeClass = app.theme ?? "default"
	
						// Save history.
						var history = this.$device.settings.history
						if (history.length == 0 || history[history.length - 1] != app.id) {
							history.push(app.id)
						}
	
						// Wait til next frame.
						this.$nextTick(() => {
							// Get component reference.
							let contentRef = this.$refs["content"]
	
							// Set persistent data.
							if (app.pData) {
								for (var key in app.pData) {
									var value = app.pData[key]

									contentRef[key] = value
									Reflect.set(contentRef.$data, key, value)
								}
							}
	
							// Load styles.
							if (app.style) {
								styleRef.appendChild(document.createTextNode(app.style))
							}
	
							if (app.scopedStyle) {
								var scopeId = contentRef.$options.__scopeId
								if (scopeId) {
									var styleData = app.scopedStyle.replaceAll(/([\.\#].+?)(\s*[\{\:])/gm, `$1[${scopeId}]$2`)
									styleRef.appendChild(document.createTextNode(styleData))
								}
							}

							// Set cached data.
							var cache = this.$device.settings.cache[this.currentApp.id]
							if (cache) {
								for (var key in cache) {
									var value = cache[key]

									contentRef[key] = value
									Reflect.set(contentRef.$data, key, value)
								}
								this.$device.settings.cache = {}
							}
	
							// Set dynamic data.
							if (data) {
								for (var key in data) {
									var value = data[key]

									contentRef[key] = value
									Reflect.set(contentRef.$data, key, value)
								}
							}

							// Event responses for new app.
							this.device.post("OpenApp", app.id, contentRef.$data).then(response => {
								if (typeof response == "object") {
									for (var key in response) {
										var value = response[key]

										contentRef[key] = value
										Reflect.set(contentRef.$data, key, value)
									}
								}

								contentRef.loaded = true
								Reflect.set(contentRef.$data, "loaded", true)
							})
						})
					})
				}).catch()
			} else {
				this.contentComponent = Home
				this.currentApp = undefined
				this.themeClass = "default"

				// Clear history.
				this.$device.settings.history = []
			}
		},
		cacheApp() {
			const contentRef = this.$refs["content"]
			if (!contentRef || !this.currentApp?.id || this.currentApp?.disposable) return

			var _data = contentRef.$data
			var cached = {}
			if (_data) {
				for (var key in _data) {
					cached[key] = _data[key]
				}
			}

			this.$device.settings.cache[this.currentApp.id] = cached
		},
		invokeApp(app, name) {
			var args = Array.from(arguments)

			args.splice(0, 2)

			var contentRef = this.$refs["content"]
			if (!contentRef || this.currentApp?.id != app)
			
			var func = null

			// Because indexing is stupid.
			for (var x in contentRef) {
				if (x == name) {
					func = contentRef[x]
					break
				}
			}
			
			// Invoke function.
			if (typeof func == "function") {
				func(...args)
			}
		},
		updateTimer() {
			var time = new Date().getTime()
			var updated = false

			for (var id in this.notifications) {
				var notification = this.notifications[id]
				if (notification.timerStart != undefined) {
					Reflect.set(notification, "timer", new Date(time - notification.timerStart).toISOString().slice(11, 19))
					
					updated = true
				}
			}

			if (updated) {
				this.$forceUpdate()
			}
		},
		addNotification(id, data) {
			// Check object.
			if (typeof data != "object") {
				return
			}

			// Remove old notification.
			var notification = this.notifications[id]
			if (notification) {
				this.removeNotification(id)
			}

			// Create timer.
			if (data.timer === true) {
				data.timerStart = new Date().getTime()
				delete data.timer
			}

			// Setup timeout.
			if (this.$isDebug && data.duration) {
				setTimeout(() => {
					this.removeNotification(id)
				}, data.duration)
			}

			// Play sound.
			if (data.audio) {
				if (typeof data.audio == "object") {
					for (var name of data.audio) {
						this.$playSound(name)
					}
				} else {
					let audio = this.$playSound(data.audio)
					audio.loop = data.loopAudio === true
					data.audioObject = audio
				}
			}
			
			// Cache notification.
			this.notificationCount++
			this.notifications[id] = data
		},
		removeNotification(id) {
			// Get/check notification.
			var notification = this.notifications[id]
			if (!notification) return

			// Stop sound.
			var audio = notification.audioObject
			if (audio) {
				audio.pause()
			}

			// Uncache notification.
			this.notificationCount--
			delete this.notifications[id]

			// Close device when peeking.
			if (this.notificationCount == 0 && this.device.settings.peek) {
				if (this.$isDebug) {
					 this.$store.commit("toggleDevice", { name: this.device.settings.name, value: false })
				} else {
					this.device.post("Close")
				}
			}
		},
		callAnswer() {
			if (this.$isDebug) {
				this.$store.commit("invokeDevice", { name: this.device.settings.name, func: "removeNotification", args: ["call"] })
			} else {
				this.device.post("CallAnswer")
			}
		},
		callEnd() {
			if (this.$isDebug) {
				this.$store.commit("invokeDevice", { name: this.device.settings.name, func: "removeNotification", args: ["call"] })
			} else {
				this.device.post("CallEnd")
			}
		},
	},
})
</script>

<style lang="scss" scoped>
.root {
	display: flex;
	flex-direction: column;
	color: white;
	max-height: 100%;
}

.root:not(.home) {
	color: rgb(40, 40, 40);
}

.bar {
	position: relative;
	display: flex;
	width: 100%;
	padding-top: 0.75vmin;
	padding-bottom: 0vmin;
	padding-left: 2vmin;
	padding-right: 2vmin;
}

.root:not(.home) .bar {
	color: white;
	background: rgb(0, 110, 240);
}

.red .bar {
	background: rgb(209, 52, 41) !important;
}

.green .bar {
	background: rgb(64, 150, 3) !important;
}

.outer-content {
	position: relative;
	flex-grow: 1;
	height: 0%;
}

.inner-content {
	position: absolute;
	width: 100%;
	height: 100%;
	background: rgb(240, 240, 240);
}

.inner-content.apps {
	background: transparent !important;
}

.app-header {
	position: relative;
	display: flex;
	align-content: center;
	justify-content: center;
	padding: 0.5vmin;
	color: white;
	background: rgb(20, 130, 255);
	font-size: 1.5em;
}

.red .app-header {
	background: rgb(242, 60, 47) !important;
}

.green .app-header {
	background: rgb(75, 174, 5) !important;
}

.menu {
	display: flex;
	justify-content: space-around;
	position: relative;
	display: flex;
	padding: 0.5vmin;
}

.notifications {
	display: flex;
	flex-direction: column;
	position: absolute;
	left: 5%;
	width: 90%;
	height: auto;
	margin-top: 3vmin;
}

.notifications .notification {
	display: flex;
	align-items: center;
	width: 100%;
	background: rgba(255, 255, 255, 0.6);
	color: black;
	border-radius: 0.5vmin;
	margin-bottom: 0.5vmin;
	padding: 0.5vmin;
	backdrop-filter: blur(0.5vmin);
}

.root:not(.home) .menu {
	background: rgb(240, 240, 240);
}

.change-enter-active,
.change-leave-active {
	transition: transform 200ms ease;
}

.change-enter-from,
.change-leave-to {
	transform: translate(0%, 100%);
}
</style>