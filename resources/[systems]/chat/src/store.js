import Vue from "vue"
import Vuex from "vuex"

Vue.use(Vuex);

export default new Vuex.Store({
	mutations: {
		addToast(state, data) {
			data.key = state.keys

			state.keys++
			state.toasts.unshift(data)

			setTimeout(() => {
				state.toasts.pop()
			}, data.duration ?? 7000)
		},
		clearMessages(state) {
			state.messages = []
		},
		addMessage(state, data) {
			data.startTime = new Date().getTime()
			data.key = state.keys
			data.isPreview = true

			state.keys++
			state.messages.push(data)

			setTimeout(() => {
				data.isPreview = false
			}, 7000)
		},
		addSuggestion(state, data) {
			Vue.set(state.commands, data.name, data)
		},
	},
	getters: {
		
	},
	state: {
		isDebug: false,
		isEnabled: false,
		toasts: [],
		messages: [],
		keys: 0,
		commands: {},
		history: [],
	},
})