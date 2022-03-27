<template>
	<div>
		<device
			v-for="(device, key) in devices.types"
			:key="key"
			:type="key"
		/>
		<div v-if="$isDebug" style="position: absolute" class="q-gutter-sm q-pa-sm">
			<q-btn
				@click="$store.commit('reset')"
				label="Reset"
				color="red"
				no-caps
				unelevated
			/>
			<q-btn
				@click="$store.commit('toggleDevice', { name: device.name, value: !device.enabled })"
				v-for="(device, key) in devices.types"
				:key="key"
				:label="`Toggle '${device.name}'`"
				:color="device.enabled && 'red' || 'green'"
				no-caps
				unelevated
			/>
		</div>
	</div>
</template>

<script>
import { defineComponent } from "vue"
import { mapState } from "vuex"
import device from "components/Device"

export default defineComponent({
	name: "App",
	components: {
		device
	},
	computed: {
		...mapState([
			"devices",
		]),
	},
	data() {
		return {
			focused: false,
			focusNames: [
				"INPUT",
				"TEXTAREA",
			],
		}
	},
	mounted() {
		this.$post("init")

		if (this.$isDebug) {
			this.$store.commit("toggleDevice", { name: "tablet", value: true })
			this.$store.commit("toggleDevice", { name: "phone", value: true })

			this.$store.commit("setAppData", {
				device: "phone",
				app: "phone",
				key: "contacts",
				value: [
					{ name: "Alex Cain", letter: "AC", number: "5259397110" },
					{ name: "Leonard Garner", letter: "LG", number: "4402777012" },
					{ name: "Betty Hammond", letter: "BH", number: "3044351895" },
					{ name: "Myrtie Hammond", letter: "MH", number: "8117863506" },
					{ name: "Zachary Fox", letter: "ZF", number: "5882336915" },
					{ name: "Lulu Hart", letter: "LH", number: "8655374693" },
					{ name: "Estelle McGee", letter: "EM", number: "3427838894" },
					{ name: "Chester Bowen", letter: "CB", number: "4369224408" },
					{ name: "Alvin Foster", letter: "AF", number: "3288053924" },
					{ name: "Bertie Harrington", letter: "BH", number: "6473913162" },
					{ name: "Mason Burke", letter: "MB", number: "7422793076" },
					{ name: "Cody Marshall", letter: "CM", number: "2222262713" },
					{ name: "Sadie Holt", letter: "SH", number: "9087424687" },
					{ name: "Winifred Sanchez", letter: "WS", number: "3674366278" },
				]
			})

			this.$store.commit("addApp", {
				app: "test",
				load: (`
					<template>
						<div class="q-pa-md">
							<q-btn @click="increment" color="red" label="Increment" class="q-mr-sm" />
							<q-btn @click="switchApp" color="blue" label="Switch App" />
							<q-separator spaced />
							<div>Index {{count}}</div>
							<div>Changed {{changed}}</div>
							<div>Contact {{test}}</div>
							<div>{{$root.formatDate(Date.now() - 30000)}} {{$root.formatTime(Date.now() - 30000)}}</div>
							<div>{{$root.formatDate(Date.now() - 60000)}} {{$root.formatTime(Date.now() - 60000)}}</div>
							<div>{{$root.formatDate(Date.now() - 3600000*20)}} {{$root.formatTime(Date.now() - 3600000*20)}}</div>
							<div>{{$root.formatDate(Date.now() - 86400000)}} {{$root.formatTime(Date.now() - 86400000)}}</div>
							<div>{{$root.formatDate(Date.now() - 172800000)}} {{$root.formatTime(Date.now() - 172800000)}}</div>
							<div>{{$root.formatDate(Date.now() - 259200000)}} {{$root.formatTime(Date.now() - 259200000)}}</div>
							<div>{{$root.formatDate(Date.now() - 345600000)}} {{$root.formatTime(Date.now() - 345600000)}}</div>
							<div>{{$root.formatDate(Date.now() - 432000000)}} {{$root.formatTime(Date.now() - 432000000)}}</div>
							<div>{{$root.formatDate(Date.now() - 518400000)}} {{$root.formatTime(Date.now() - 518400000)}}</div>
							<div>{{$root.formatDate(Date.now() - 604800000)}} {{$root.formatTime(Date.now() - 604800000)}}</div>
							<div>{{$root.formatDate(Date.now() - 691200000)}} {{$root.formatTime(Date.now() - 691200000)}}</div>
							<div>{{$root.formatDate(Date.now() - 2592000000)}} {{$root.formatTime(Date.now() - 2592000000)}}</div>
						</div>
					</template>

					<_script>
						export default component({
							disposable: true,
							mounted() {
								this.$nextTick(() => {
									this.$store.commit("updateDevice", {
										name: "phone",
										app: "test",
										key: "count",
										value: 1,
									})
								})
							},
							data: {
								"count": 0,
								"changed": 0,
							},
							computed: {
								test() {
									return this.$getData('phone', 'contacts')[this.count]
								},
							},
							methods: {
								increment() {
									console.log(this.count)
									this.count++
								},
								switchApp() {
									this.$emit("setApp", "test2")
								},
							},
						})
					</_script>
				`).replaceAll("_script", "script").replaceAll("_style", "style"),
				data: {
					name: "",
					theme: "blue",
					component: "Custom",
					disposable: true,
				},
			})

			this.$store.commit("addApp", {
				app: "test2",
				load: (`
					<template>
						<div class="q-pa-md">
							{{test}}
						</div>
					</template>

					<_script>
						export default component({
							disposable: true,
							mounted() {
								console.log("mounting 2")
								this.$nextTick(() => {
									console.log(this.test == "yep")
								})
							},
							data: {
								"test": "yep",
							},
							computed: {
							},
							methods: {
							},
						})
					</_script>
				`).replaceAll("_script", "script").replaceAll("_style", "style"),
				data: {
					name: "",
					theme: "blue",
					component: "Custom",
				},
			})

			setTimeout(() => {
				this.$store.commit("setApp", {
					device: "phone",
					app: "test",
				})

				setTimeout(() => {
					this.$store.commit("invokeDevice", {
						name: "phone",
						func: "invokeApp",
						args: [ "test", "increment" ],
					})
				}, 200)
			}, 200)

			// setTimeout(() => {
			// 	this.$store.commit("invokeDevice", { name: "phone", autoPeek: true, func: "addNotification", args: ["call", {
			// 		title: "(420) 666-4200",
			// 		text: "Incoming call.",
			// 		answer: true,
			// 		hangup: true,
			// 		timer: false,
			// 		avatar: {
			// 			name: "",
			// 			color: "black",
			// 		},
			// 		audio: "ring0",
			// 		loopAudio: true,
			// 	}] })

			// 	this.$store.commit("invokeDevice", { name: "phone", autoPeek: true, func: "addNotification", args: [1, {
			// 		title: "Bleeter",
			// 		text: "@JohnDoe How's it going?",
			// 		duration: 4000,
			// 		audio: [ "vibrate", "notify" ],
			// 	}] })
			// }, 2000);

			// setTimeout(() => {
			// 	this.$store.commit("toggleDevice", { name: "phone", value: true })
			// }, 2000)

			// setTimeout(() => {
			// 	this.$store.commit("toggleDevice", { name: "phone", value: true, peek: true })
			// 	this.$store.commit("toggleDevice", { name: "tablet", value: true, peek: true })
			// }, 5000)
		}

		document.addEventListener("keydown", this.keyPress)
		document.addEventListener("focusin", this.focus)
		document.addEventListener("focusout", this.unfocus)
	},
	methods: {
		keyPress(e) {
			if (e.target != document.body) {
				return
			}

			switch(e.key) {
				case "Escape":
					this.$post("close")
					break
				default:
					break
			}
		},
		focus(e) {
			if (!this.focused && e?.target?.nodeName && this.focusNames.includes(e.target.nodeName)) {
				this.focused = true
				this.$post("focus", true)
			}
		},
		unfocus(e) {
			if (this.focused && e?.target?.nodeName && this.focusNames.includes(e.target.nodeName)) {
				this.focused = false
				this.$post("focus", false)
			}
		},
		formatName(name) {
			let initials = [...name.matchAll(new RegExp(/(\p{L}{1})\p{L}+/, "gu"))] || []
			initials = ((initials.shift()?.[1] || "") + (initials.pop()?.[1] || "")).toUpperCase()

			return initials == "" ? "?" : initials
		},
		formatDate(time) {
			if (!time) return ""
			
			var date = new Date(1970, 0, 1)
			var today = Date.now()

			date.setMilliseconds(time)

			var now = new Date().getTime()
			var days = Math.round((now - date) / 8.64e+7)

			if (days == 0) {
				return "Today"
			} else if (days == 1) {
				return "Yesterday"
			} else if (days < 7) {
				return date.toLocaleString("default", { weekday: "long" })
			} else {
				date = new Date(time)

				var month = (1 + date.getMonth()).toString()
				var day = date.getDate().toString().padStart(2, "0")
				var year = date.getFullYear().toString().substring(2)

				return `${month}/${day}/${year}`
			}
		},
		formatTime(time) {
			if (!time) return ""
			
			var date = new Date(1970, 0, 1)
			date.setMilliseconds(time)

			var diff = new Date().getTime() - time
			var secondsAgo = Math.floor(diff / 1000)

			if (secondsAgo < 60) {
				return "Just now"
			}

			var minutesAgo = Math.floor(diff / 60000)
			var hoursAgo = Math.floor(diff / 3.6e+6)
			var daysAgo = Math.floor(diff / 8.64e+7)

			var dateFormat = ""

			if (minutesAgo < 60) {
				return `${minutesAgo} minute${minutesAgo > 1 ? "s" : ""} ago`
			} else if (hoursAgo < 24) {
				return `${hoursAgo} hour${hoursAgo > 1 ? "s" : ""} ago`
			} else {
				date = new Date(time)

				var hours = date.getHours()
				var minutes = date.getMinutes()
				var sign = hours >= 12 ? "PM" : "AM"

				hours = (hours % 12) || 12

				return `${hours}:${minutes.toString().padStart(2, "0")} ${sign}`
			}
		},
		formatPhoneNumber(value) {
			const firstLetter = value.substring(0, 1)
			if (firstLetter == "#" || firstLetter == "*") {
				return value
			}

			const areaCode = value.substring(0, 3)
			const exchange = value.substring(3, 6)
			const lineNumber = value.substring(6, 10)

			let str = ""

			if (areaCode) str += exchange ? `(${areaCode}) ` : areaCode
			if (exchange) str += exchange
			if (lineNumber) str += `-${lineNumber}`

			return str
		},
	},
})
</script>

<style>
body {
	overflow: hidden;
	user-select: none;
	font-size: 1.1vmin;
	background: transparent;
	scrollbar-width: thin;
}

.background {
	position: absolute;
	width: 100%;
	height: 100%;
	object-fit: cover;
	background-position: center;
	background-size: 100% 100%;
	background-repeat: no-repeat;
	pointer-events: none;
}

.q-btn {
	font-size: 1em;
}

::-webkit-scrollbar {
	width: 6px;
}
::-webkit-scrollbar-track {
	background: rgba(240, 240, 240, 0.6);
}
::-webkit-scrollbar-thumb {
	background: rgba(180, 180, 180, 0.8);
}
</style>