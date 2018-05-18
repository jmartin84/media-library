<template>
<v-app dark>
  <header>
    <the-header />
  </header>
  <main>
    <v-content>
      <v-container fluid fill-height>
        <v-layout row justify-center align-center>
          <the-loader v-if='isLoading' />
          <v-slide-y-transition mode="out-in" v-if='!isLoading'>
            <router-view></router-view>
          </v-slide-y-transition>
        </v-layout>
      </v-container>
    </v-content>
    <the-create-media-dialog />
  </main>
  <footer>
    <v-footer app>
      <span>&copy; 2017</span>
    </v-footer>
  </footer>
</v-app>
</template>

<script>

export default {
  computed: {
    isLoading() {
      return this.$store.getters.isLoading;
    }
  }
};
</script>
