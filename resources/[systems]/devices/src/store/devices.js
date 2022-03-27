import Desktop from "layouts/Desktop"
import Mobile from "layouts/Mobile"

export default {
	state: () => ({
		types: {
			laptop: {
				name: "laptop",
				enabled: false,
				aspect: 1.4536489151873768,
				size: 1.0,
				layout: Desktop,
				background: "https://wallpaperaccess.com/full/1964965.jpg",
				style: {
					top: "50%",
					left: "50%",
					marginTop: "14.5vmin",
					transform: "translate(-50%, -50%)",
				},
				screen: {
					top: "2.7%",
					bottom: "29.8%",
					left: "9%",
					right: "9.7%",
					borderRadius: "0.5vmin",
				},
			},
			tablet: {
				name: "tablet",
				enabled: false,
				aspect: 1.5103806228373702,
				size: 0.95,
				layout: Mobile,
				background: "https://c4.wallpaperflare.com/wallpaper/312/851/784/dolomiti-italy-autumn-lago-antorno-landscape-photography-desktop-hd-wallpaper-for-pc-tablet-and-mobile-3840%C3%972400-wallpaper-preview.jpg",
				style: {
					top: "50%",
					left: "50%",
					transform: "translate(-50%, -50%)",
				},
				screen: {
					top: "8.2%",
					bottom: "8.15%",
					left: "5.3%",
					right: "5.6%",
					borderRadius: "0.5vmin",
				},
				anims: {
					close: [ 0.0, -120.0 ],
				},
				apps: [
					"options",
				],
			},
			phone: {
				name: "phone",
				enabled: false,
				aspect: 0.4688372093023256,
				size: 0.8,
				layout: Mobile,
				background: "https://iae.news/wp-content/uploads/2021/04/9a0985904bf1cca3be1a90010fa81ff1-5.gif",
				style: {
					bottom: "-2vmin",
					right: "10%",
					transformOrigin: "bottom center",
				},
				screen: {
					top: "2.3%",
					bottom: "4.5%",
					left: "3.6%",
					right: "4.6%",
					borderRadius: "3vmin",
				},
				anims: {
					close: [ 0.0, 100.0 ],
					peek: [ 0.0, 80.0 ],
				},
				apps: [
					"phone",
					"contacts",
					"options",
				],
			},
		},
	}),
	mutations: {
		toggleDevice(state, payload) {
			const device = state.types[payload.name]
			if (!device) return

			device.enabled = payload.value == true
			device.peek = payload.peek == true
		},
		invokeDevice(state, payload) {
			const device = state.types[payload.name]
			if (!device) {
				console.error(`no device '${payload.name}' to invoke`)
				return
			}

			const enabled = device.enabled
			if (!enabled && (payload.autoEnable || payload.autoPeek)) {
				device.peek = payload.autoPeek
				device.enabled = true
			} else if (!enabled) {
				return
			}

			device.component.$nextTick(() => {
				const component = device.component.$refs["deviceComponent"]
				const func = component[payload.func]

				if (!func) {
					console.error(`no func '${payload.func}' for device '${payload.name}' to invoke`)
					return
				}

				func(...(payload.args ?? []))
			})
		},
		updateDevice(state, payload) {
			const device = state.types[payload.name]
			if (!device) {
				console.error(`no device '${payload.name}' to update`)
				return
			}

			const component = device.component.$refs["deviceComponent"]
			if (!component) return

			const contentRef = component.$refs["content"]
			if (!contentRef || contentRef.app?.id != payload.app) return

			if (typeof payload.key === "object") {
				for (var key in payload.key) {
					var value = payload.key[key]

					contentRef.$data[key] = value
					contentRef[key] = value
				}
			} else {
				contentRef.$data[payload.key] = payload.value
				contentRef[payload.key] = payload.value
			}
		},
		setAppActive(state, payload) {
			const device = state.types[payload.device]
			if (!device) return

			var index = device.apps.indexOf(payload.app)

			if (payload.value && index == -1) {
				device.apps.push(payload.app)
			} else if (!payload.value && index != -1) {
				device.apps.splice(index, 1)
			}
		},
		setApp(state, payload) {
			const device = state.types[payload.device]
			if (!device) {
				console.error(`no device '${payload.device}' to update`)
				return
			}

			const component = device.component.$refs["deviceComponent"]
			if (!component?.setApp) return

			component.setApp(payload.app, payload.data)
		},
		reset(state, payload) {
			for (var id in state.types) {
				var device = state.types[id]

				// Invoke method.
				var component = device.component
				var innerComponent = component && component.$refs["deviceComponent"]

				if (innerComponent?.reset) {
					innerComponent?.reset()
				}

				// Clear cahce.
				delete device.cache
			}
		},
	}
}