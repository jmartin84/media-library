import path from 'path';
import webpack from 'webpack';
import vueConfig from './vue-loader.config';
import ExtractTextPlugin from 'extract-text-webpack-plugin';
import FriendlyErrorsPlugin from 'friendly-errors-webpack-plugin';
import OptimizeCssAssetsPlugin from 'optimize-css-assets-webpack-plugin';

const isProd = process.env.NODE_ENV === 'production'
const resolve = (file) => path.resolve(__dirname, file)

export default {
	devtool: '#cheap-module-source-map',
	output: {
		path: resolve('../priv/static/dist'),
		filename: '[name].[chunkhash].js'
	},
	resolve: {
		extensions: ['*', '.js', '.json', '.vue'],
		alias: {
			'vue$': 'vue/dist/vue.common.js'
		}
	},
	module: {
		noParse: /es6-promise\.js$/, // avoid webpack shimming process
		rules: [{
			test: /\.vue$/,
			loader: 'vue-loader',
			options: {
				extractCSS: process.env.NODE_ENV === 'production',
				preserveWhitespace: false,
				postcss: [
					require('autoprefixer')({
						browsers: ['last 3 versions']
					})
				]
			}
		}, {
			test: /\.js$/,
			loader: 'babel-loader',
			exclude: /node_modules/
		}, {
			test: /\.css$/,
			loader: ['vue-style-loader', 'css-loader', 'less-loader']
	  }, {
			test: /\.styl$/,
			loader: ['vue-style-loader', 'css-loader', 'stylus-loader']
		}, {
			test: /\.(png|jpe?g|gif|svg)(\?.*)?$/,
			loader: 'url-loader',
			query: {
				limit: 10000,
				name: 'img/[name].[hash:7].[ext]'
			}
		}
		]
	},
	performance: {
		maxEntrypointSize: 300000,
		hints: isProd ? 'warning' : false
	},
	plugins: isProd
		? [
			new webpack.optimize.UglifyJsPlugin({
				compress: { warnings: false }
			}),
			new ExtractTextPlugin({
				filename: 'common.[chunkhash].css'
			}),
			new OptimizeCssAssetsPlugin({
				assetNameRegExp: /\.css$/
			})
		]
		: [
			new FriendlyErrorsPlugin()
		]
}
