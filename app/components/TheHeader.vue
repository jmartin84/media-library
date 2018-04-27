<template>
    <v-toolbar fixed app>
      <v-btn
        to="/"
        flat
        dark
        depressed
        active-class=""
        :ripple="false"
      >
        <v-toolbar-title v-text="title"></v-toolbar-title>
      </v-btn>
      <v-spacer></v-spacer>
      <v-slide-x-reverse-transition origin="center right">
        <v-text-field
          name="search-text"
          v-model="searchValue"
          v-if="isSearchActive"
          :autofocus="isSearchActive"
          clearable
          dark
          solo
        />
      </v-slide-x-reverse-transition>
      <v-btn
        icon
        dark
        @click.native.stop="isSearchActive = !isSearchActive"
      >
        <v-icon>search</v-icon>
      </v-btn>
      <v-btn
        icon
        dark
        @click.native.stop="createMovie()"
      >
        <v-icon>add</v-icon>
      </v-btn>
    </v-toolbar>
</template>

<script>
import debounce from 'lodash/debounce';
import throttle from 'lodash/throttle';

import {
	DASHBOARD_SEARCH,
	APP_TOGGLE_LOADING,
	MEDIA_SHOW_CREATE_DIALOG
} from '../store/actions';

export default {
	data: () => ({
		title: 'Media Library',
		isSearchActive: false,
		searchValue: ''
	}),
	watch: {
		searchValue (val) {
			this.toggleLoading().test;
			this.search(val);
		}
	},
	methods: {
		search: debounce(function (val) {
			this.$store.dispatch(DASHBOARD_SEARCH, val);
		}, 500),
		toggleLoading: throttle(function () {
			this.$store.dispatch(APP_TOGGLE_LOADING, true);
		}, 500, { trailing: false }),
		createMovie() {
			this.$store.dispatch(MEDIA_SHOW_CREATE_DIALOG);
		}
	}
}
</script>
