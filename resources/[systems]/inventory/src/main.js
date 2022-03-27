import Vue from "vue"
import App from "./App.vue"
import store from "./store"
import utils from "./plugins/utils.js"
import feather from "vue-icon"

Vue.config.productionTip = false

Vue.use(utils)
Vue.use(feather, "v-icon")

new Vue({
  store,
  render: h => h(App),
}).$mount("#app")