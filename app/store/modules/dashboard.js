// import { DASHBOARD_SEARCH, APP_TOGGLE_LOADING } from '../actions';

export default {
  namespaced: true,
  state: {
    searchTerm: ''
  },
  actions: {
    search: ({ commit }, searchTerm) => {
      commit('searchTerm', searchTerm);
    }
  },
  mutations: {
    searchTerm: (state, searchTerm) => state.searchTerm = searchTerm
  },

  getters: {}
}
