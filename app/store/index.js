import Vue from 'vue'
import Vuex from 'vuex'
import * as modules from './modules';

Vue.use(Vuex)

export function createStore () {
	return new Vuex.Store({
		modules,
		state: {
			isLoading: false
		},
		actions: {
			toggleLoading: ({ commit }, isLoading) => commit('isLoading', isLoading)
		},
		mutations: {
			isLoading: (state, isLoading) => state.isLoading = isLoading
		},
		getters: {
			isLoading: (state) => state.isLoading
		}
	})
}
