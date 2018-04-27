import webpack from 'webpack';
import merge from 'webpack-merge';
import base from './base.config';
import SWPrecachePlugin from 'sw-precache-webpack-plugin';
import VueSSRClientPlugin from 'vue-server-renderer/client-plugin';

export default merge(base, {
	entry: {
		app: './app/assets/entry-client.js'
	},
	plugins: [
		// strip dev-only code in Vue source
		new webpack.DefinePlugin({
			'process.env.NODE_ENV': JSON.stringify(process.env.NODE_ENV || 'development'),
			'process.env.VUE_ENV': '"client"'
		}),
		// extract vendor chunks for better caching
		new webpack.optimize.CommonsChunkPlugin({
			name: 'vendor',
			minChunks (module) {
				// a module is extracted into the vendor chunk if...
				return (
				// it's inside node_modules
					/node_modules/.test(module.context) &&
					// and not a CSS file (due to extract-text-webpack-plugin limitation)
					!/\.css$/.test(module.request)
				)
			}
		}),
		// extract webpack runtime & manifest to avoid vendor chunk hash changing
		// on every build.
		new webpack.optimize.CommonsChunkPlugin({
			name: 'manifest'
		}),
		new VueSSRClientPlugin()
	]
})
