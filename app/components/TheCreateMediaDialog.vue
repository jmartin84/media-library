<template>
<v-dialog
  v-model="shouldShowDialog"
  lazy
  transition="dialog-bottom-transition"
  max-width="500px"
  persistent
  scrollable
>
  <v-card
    tile>
    <v-toolbar card dark color="primary">
      <v-btn icon @click.native="close()" dark>
        <v-icon>close</v-icon>
      </v-btn>
      <v-toolbar-title>Add Media</v-toolbar-title>
      <v-spacer></v-spacer>
      <v-toolbar-items>
        <v-btn dark flat @click.native="save()">Save</v-btn>
      </v-toolbar-items>
      <v-menu bottom right offset-y>
      </v-menu>
    </v-toolbar>
    <v-card-text>
      <v-text-field
        label="Name"
        v-model="name"
        dark
        required
        />
      <v-select
        label="Type"
        v-model="type"
        dark
        chips
        tags
        multiple
        :items="typeListItems"
        required
        />
      <v-select
        label="Tags"
        v-model="tags"
        chips
        dark
        tags
        multiple
        :items="tagListItems"
        required
        />
      <v-select
        label="Source"
        v-model="source"
        chips
        dark
        tags
        multiple
        :items="sourceListItems"
        required
        />
    </v-card-text>

    <div style="flex: 1 1 auto;"></div>
  </v-card>
</v-dialog>
</template>
<style lang=less>
  .dialog {
    justify-content: center;
  }
</style>

<script lang="babel">
import {
  GET_MEDIA_SHOW_DIALOG_STATE,
  GET_MEDIA_SELECT_ITEMS
} from '../store/getters';

import {
  MEDIA_CLOSE_CREATE_DIALOG,
  MEDIA_CREATE
} from '../store/actions';

export default {
  data: () => ({
    name: '',
    tags: [],
    source: [],
    type: ''
  }),
  computed: {
    shouldShowDialog () {
      return this
        .$store
        .getters[GET_MEDIA_SHOW_DIALOG_STATE];
    },
    tagListItems() {
      return this
        .$store
        .getters[GET_MEDIA_SELECT_ITEMS]
        .tagList;
    },
    sourceListItems() {
      return this
        .$store
        .getters[GET_MEDIA_SELECT_ITEMS]
        .sourceList;
    },
    typeListItems() {
      return this
        .$store
        .getters[GET_MEDIA_SELECT_ITEMS]
        .typeList;
    }
  },
  methods: {
    close () {
      this.$store.dispatch(MEDIA_CLOSE_CREATE_DIALOG);
    },
    save () {
      const { name, tags, source, type } = this;
      this.$store.dispatch(MEDIA_CREATE, {
        name,
        tags,
        source,
        type
      });

      Object.assign(this, {
        name: '',
        type: [],
        source: [],
        tags: []
      });
    }
  }
}
</script>
