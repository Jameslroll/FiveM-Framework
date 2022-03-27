export default {
	install: function(Vue, app) {
		window.addEventListener("message", function(e) {
			var data = e.data

			if (data.setter) {
				app.$store.state[data.setter.key] = data.setter.value
			} else if (data.commit) {
				app.$store.commit(data.commit.type, data.commit.payload, data.commit.options)
			} else if (data.notify) {
				app.$q.notify(data.notify)
			} else if (data.dialog) {
				app.$q.dialog(data.dialog).onOk(_data => {
					app.$post("dialogFinish", {
						status: "ok",
						data: _data,
					}, data.resource)
				}).onCancel(() => {
					app.$post("dialogFinish", {
						status: "cancel",
					}, data.resource)
				})
			} else if (data.copy) {
				app.$copyToClipboard(data.copy)
			}
		})
		Vue.prototype.$post = function(callback, payload, resource) {
			if (window["GetParentResourceName"] == undefined) {
				return
			}

			fetch(`https://${resource ?? GetParentResourceName()}/${callback}`, {
				method: "POST",
				headers: { "Content-Type": "application/json; charset=UTF-8" },
				body: JSON.stringify(payload)
			})
		}
		Vue.prototype.$invoke = function(name) {
			let args = Array.from(arguments)
			args.shift()
			
			var window = this.$window
			if (!window) return

			this.$post("invoke", {
				window: window.info?.id,
				name: name,
				args: args,
			}, window.info?.resource)
		}
	}
}