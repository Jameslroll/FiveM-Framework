import Vue from "vue"
import App from "./App.vue"
import store from "./store/index.js"
import messages from "./messages.js"
import "./models"
import "./quasar"

Vue.config.productionTip = false

new Vue({
  store,
  render: h => h(App),
  created() {
    this.$store.state.isDebug = process.env.NODE_ENV == "development"
    Vue.use(messages, this)
  }
}).$mount("#app")
