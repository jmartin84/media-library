export default {
	namespaced: true,
	state: {
		showDialog: false,
		items: [{
			id: 1,
			cast: ['Josue quevo', 'James Goodwin'],
			director: 'Sam Raini',
			name: 'movie 1',
			rating: 3,
			imageUrl: "https://dummyimage.com/300x250/000/fff",
			releasedOn: '2018-04-04',
			source: ['Netflix'],
			tags: ['Comedy'],
			type: ['Movie']
		}, {
			id: 2,
			cast: ['quevo', 'James'],
			director: 'Sam Raini',
			name: 'movie 2',
			rating: 5,
			imageUrl: "https://dummyimage.com/300x250/000/fff",
			releasedOn: '2018-04-04',
			source: ['Netflix'],
			tags: ['Comedy'],
			type: ['Movie']
		}, {
			id: 3,
			cast: ['Josue quevo', 'James Goodwin'],
			director: 'Sam Raini',
			name: 'movie 3',
			rating: 3,
			imageUrl: "https://dummyimage.com/300x250/000/fff",
			releasedOn: '2018-04-04',
			source: ['Netflix'],
			tags: ['Comedy'],
			type: ['Movie']
		}, {
			id: 4,
			cast: ['quevo', 'James'],
			director: 'Sam Raini',
			name: 'movie 4',
			rating: 5,
			imageUrl: "https://dummyimage.com/300x250/000/fff",
			releasedOn: '2018-04-04',
			source: ['Netflix'],
			tags: ['Comedy'],
			type: ['Movie']
		}, {
			id: 5,
			cast: ['Josue quevo', 'James Goodwin'],
			director: 'Sam Raini',
			name: 'movie 5',
			rating: 3,
			imageUrl: "https://dummyimage.com/300x250/000/fff",
			releasedOn: '2018-04-04',
			source: ['Netflix'],
			tags: ['Comedy'],
			type: ['Movie']
		}, {
			id: 6,
			cast: ['quevo', 'James'],
			director: 'Sam Raini',
			name: 'movie 6',
			rating: 5,
			imageUrl: "https://dummyimage.com/300x250/000/fff",
			releasedOn: '2018-04-04',
			source: ['Netflix'],
			tags: ['Comedy'],
			type: ['Movie']
		}, {
			id: 7,
			cast: ['Josue quevo', 'James Goodwin'],
			director: 'Sam Raini',
			name: 'movie 7',
			rating: 3,
			imageUrl: "https://dummyimage.com/300x250/000/fff",
			releasedOn: '2018-04-04',
			source: ['Netflix'],
			tags: ['Comedy'],
			type: ['Movie']
		}, {
			id: 8,
			cast: ['quevo', 'James'],
			director: 'Sam Raini',
			name: 'movie 8',
			rating: 5,
			imageUrl: "https://dummyimage.com/300x250/000/fff",
			releasedOn: '2018-04-04',
			source: ['Netflix'],
			tags: ['Comedy'],
			type: ['Movie']
		}, {
			id: 9,
			cast: ['Josue quevo', 'James Goodwin'],
			director: 'Sam Raini',
			name: 'movie 9',
			rating: 3,
			imageUrl: "https://dummyimage.com/300x250/000/fff",
			releasedOn: '2018-04-04',
			source: ['Netflix'],
			tags: ['Comedy'],
			type: ['Movie']
		}, {
			id: 10,
			cast: ['quevo', 'James'],
			director: 'Sam Raini',
			name: 'movie 10',
			rating: 5,
			imageUrl: "https://dummyimage.com/300x250/000/fff",
			releasedOn: '2018-04-04',
			source: ['Netflix'],
			tags: ['Comedy'],
			type: ['Movie']
		}],
		tagList: ['Comedy', 'Horror', 'Kid Friendly'],
		sourceList: ['Blueray', 'DVD', 'Netflix', 'Amazon', 'iTunes'],
		typeList: ['Book', 'TV Show', 'Video Game', 'Music']
	},
	actions: {
		showDialog: ({commit}) => commit('showDialog', true),
		closeDialog: ({commit}) => commit('showDialog', false),
		create: ({commit}, data) => {
			commit('addMedia', {
				...data, ...{
					cast: ['Jeff Goldbum', 'Samuel L Jackson'],
					imageUrl: "https://dummyimage.com/300x250/000/fff",
					director: 'George Lucas',
					rating: 5,
					releasedOn: '2018-04-03'
				}
			});
			commit('showDialog', false);
		},
		delete: ({commit}, id) => commit('removeMedia', id)
	},

	mutations: {
		showDialog: (state, shouldShow) => Object.assign(state, { showDialog: shouldShow }),
		addMedia: (state, data) => Object.assign(state, { items: [...state.items, data] }),
		removeMedia: (state, id) => {
			const items = state.items.filter(item => item.id !== id);
			Object.assign(state, { items });
		}
	},

	getters: {
		shouldShowDialog: (state) => state.showDialog,
		get: (state) => state.items,
		selectItems: ({tagList, sourceList, typeList}) => ({
			tagList,
			sourceList,
			typeList
		})
	}
}
