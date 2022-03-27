import { boot } from "quasar/wrappers"

export default boot(async ({ app, _, store }) => {
	app.mixin({
		beforeCreate: function() {
			if (this.$options.name === "Device") {
				this.$device = this
				return
			}

			var parent = this.$parent
			while (parent) {
				if (parent.$options.name === "Device") {
					this.$device = parent
					return
				}
	
				parent = parent.$parent
			}
		}
	})
	app.config.globalProperties.$getData = function(app, key) {
		var device = this.$device
		if (!device?.type) return

		var deviceData = store.state.data[device.type]
		if (!deviceData) return
		
		if (!app) {
			app = "SYS"
		}

		var appData = deviceData[app]
		if (!appData) return

		return Reflect.get(appData, key)
	}
	app.config.globalProperties.$setData = function(app, key, value) {
		var device = this.$device
		if (!device?.type) return

		var deviceData = store.state.data[device.type]
		if (!deviceData) {
			deviceData = {}
			store.state.data[device.type] = deviceData
		}
		
		if (!app) {
			app = "SYS"
		}

		var appData = deviceData[app]
		if (!appData) {
			appData = {}
			deviceData[app] = appData
		}

		device.post("UpdateData", device.type, app, key, value, new Date().getTime())
		
		return Reflect.set(appData, key, value)
	}
	app.config.globalProperties.$isPhone = function() {
		return this.$device?.settings?.name == "phone"
	},
	app.config.globalProperties.$isTablet = function() {
		return this.$device?.settings?.name == "tablet"
	},
	app.config.globalProperties.$isDebug = process.env.NODE_ENV == "development"
})
