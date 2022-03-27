import Vue from "vue"
import Vuex from "vuex"
import developmentWindows from "./development.js"

Vue.use(Vuex)

var _components = {}
if (process.env.NODE_ENV == "development") {
	var i = 0
	for (var component of developmentWindows) {
		_components[i] = component
		i++
	}
}

export default new Vuex.Store({
	state: {
		components: _components,
		objects: {},
		windows: {},
	},
	mutations: {
		addComponent: function(state, component) {
			component = JSON.parse(component)

			var parent = (component.parent != undefined && state.objects[component.parent]) || state
			if (!parent) return

			Vue.set(parent.components, component.id, component)
			
			state.objects[component.id] = component
		},
		updateComponent: function(state, component) {
			component = JSON.parse(component)

			var _component = state.objects[component.id]
			if (!_component) return

			for (var k in _component) {
				var value =  component[k]
				if (value != _component[k]) {
					Vue.set(_component, k, value)
				}
			}
		},
		removeComponent: function(state, id) {
			var component = state.objects[id]
			if (!component) return

			var parent = (component.parent != undefined && state.objects[component.parent]) || state
			if (!parent) return

			Vue.delete(parent.components, id)
			
			delete state.objects[id]
		},
		setModel: function(state, data) {
			var window = state.windows[data.id]
			if (!window?.models) return

			if (data.models) {
				for (var model in data.models) {
					window.$set(window.models, model, data.models[model])
				}
			} else if (data.model) {
				window.$set(window.models, data.model, data.value)
			}
		},
		stopResource: function(state, data) {
			for (var id in state.components) {
				var component = state.components[id]
				if (component?.resource == data.resource) {
					Vue.delete(state.components, id)

					delete state.objects[id]
				}
			}
		},
	},
})