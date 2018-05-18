import Vue from 'vue'
import {
  Vuetify,
  VList,
  VCheckbox,
  VApp,
  VFooter,
  VTooltip,
  VCard,
  VGrid,
  VToolbar,
  VBtn,
  VIcon,
  VDialog,
  VTextField,
  VProgressCircular,
  VDivider,
  VSubheader,
  VMenu,
  VForm,
  VSelect,
  transitions
} from 'vuetify'

import '../../node_modules/vuetify/src/stylus/app.styl'
import { sync } from 'vuex-router-sync'
import App from './App.vue'
import Components from '../components/_index'

import { createStore } from '../store/index'
import { createRouter } from '../router/index'

Vue.use(Vuetify, {
  components: {
    VApp,
    VForm,
    VSelect,
    VDialog,
    VDivider,
    VSubheader,
    VTooltip,
    VCheckbox,
    VFooter,
    VMenu,
    VCard,
    VGrid,
    VToolbar,
    VBtn,
    VIcon,
    VTextField,
    VList,
    VProgressCircular,
    transitions
  }
})

Object.keys(Components).forEach(key => {
  Vue.component(key, Components[key])
})

// Expose a factory function that creates a fresh set of store, router,
export function createApp () {
  // create store and router instances
  const store = createStore()
  const router = createRouter()

  // sync the router with the vuex store.
  // this registers `store.state.route`
  sync(store, router)

  // create the app instance.
  // making them available everywhere as `this.$router` and `this.$store`.
  const app = new Vue({
    router,
    store,
    render: h => h(App)
  })

  // expose the app, the router and the store.
  // note we are not mounting the app here, since bootstrapping will be
  // different depending on whether we are in a browser or on the server.
  return { app, router, store }
}
