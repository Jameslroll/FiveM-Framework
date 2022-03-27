import { store } from "quasar/wrappers"
import { createStore } from "vuex"

import apps from "./apps"
import data from "./data"
import devices from "./devices"

export default store(function() {
	const Store = createStore({
		modules: {
			apps,
			data,
			devices,
		},
	})

	return Store
})
