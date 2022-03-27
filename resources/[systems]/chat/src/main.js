import Vue from "vue"
import App from "./App.vue"
import utils from "./utils.js"
import store from "./store"
import feather from "vue-icon"

Vue.config.productionTip = false
Vue.use(utils)
Vue.use(feather, "v-icon")

new Vue({
  store,
  render: h => h(App),
}).$mount("#app")
