/* eslint-disable no-return-assign */
import 'es6-promise/auto';
import { createApp } from './app';

const { app, router, store } = createApp();

// wait until router has resolved all async before hooks
// and async components...
router.onReady(() => {
  // Add router hook for handling asyncData.
  // Doing it after initial route is resolved so that we don't double-fetch
  // the data that we already have. Using router.beforeResolve() so that all
  // async components are resolved.
  router.beforeResolve((to, from, next) => {
    const matched = router.getMatchedComponents(to);
    const prevMatched = router.getMatchedComponents(from);
    let diffed = false;
    const activated = matched.filter((c, i) => diffed || (diffed = (prevMatched[i] !== c)));
    if (!activated.length) {
      return next();
    }
    return Promise.all(activated.map((c) => {
      if (c.asyncData) {
        return c.asyncData({ store, route: to });
      }
      return null;
    })).then(() => {
      next();
    }).catch(next);
  });

  // actually mount to DOM
  app.$mount('#app');
});
