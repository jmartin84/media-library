
<template>
<v-card dark class="media-card" height="400px">
  <v-card-media :src="data.imageUrl" height="260"/>
  <v-card-text>
    <span class="name"><strong>{{data.name}}</strong></span>
    <span class="director">By {{data.director}}</span>
    <span class="rating">{{data.rating}} Stars</span>
  </v-card-text>
  <v-card-actions>
    <v-spacer />
    <v-btn
      flat
      color="red"
      @click.native.stop="deleteItem()"
    >
      DELETE
    </v-btn>
    <v-btn flat color="blue">EDIT</v-btn>
  </v-card-actions>
</v-card>
</template>
<style lang="less">
.card__actions {
  padding: 0;
}
.card__text {
  padding: 10px 16px;
}
</style>

<style lang="less" scoped>
.media-card {
  width: 23%;
  margin: 12px;
  min-width: 310px;

  span {
    text-transform: capitalize;
    display: inline-block;
    width: 100%;
    line-height: 22px;
  }

  .name {
    font-size: 2em;
  }
  .director {
    font-style: italic;
  }
}
</style>

<script lang="babel">
import { MEDIA_DELETE } from '../store/actions';

export default {
  props: ['data'],
  methods: {
    deleteItem() {
      this.$store.dispatch(MEDIA_DELETE, this.data.id);
    },
  },
};
</script>
