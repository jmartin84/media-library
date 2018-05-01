/* eslint-disable import/no-extraneous-dependencies */
const path = require('path');
const ManifestPlugin = require('webpack-manifest-plugin');
const { VueLoaderPlugin } = require('vue-loader');
const MiniCssExtractPlugin = require('mini-css-extract-plugin');

const resolve = (file) => path.resolve(__dirname, file)

module.exports = {
	entry: {
		app: './app/assets/entry-client.js'
	},
	output: {
		path: resolve('../priv/static'),
		filename: '[name].[chunkhash].js'
	},
	resolve: {
		extensions: ['*', '.js', '.json', '.vue'],
		alias: {
			'vue$': 'vue/dist/vue.common.js',
			phoenix_html: path.resolve(__dirname, "/deps/phoenix_html/web/static/js/phoenix_html.js"),
			phoenix: path.resolve(__dirname, "/deps/phoenix/web/static/js/phoenix.js")
		}
	},
	module: {
		noParse: /es6-promise\.js$/, // avoid webpack shimming process
		rules: [{
			test: /\.vue$/,
			use: ['vue-loader']
		}, {
			test: /\.js$/,
			exclude: /node_modules/,
			use: ['babel-loader']
		}, {
			test: /\.less$/,
			use: ['vue-style-loader', MiniCssExtractPlugin.loader, 'css-loader', 'less-loader']
		}, {
			test: /\.styl$/,
			use: ['vue-style-loader', MiniCssExtractPlugin.loader, 'css-loader', 'stylus-loader']
		}, {
			test: /\.(png|jpe?g|gif|svg)(\?.*)?$/,
			use: [{
				loader: 'url-loader',
				options: {
					limit: 10000,
					name: 'img/[name].[hash:7].[ext]'
				}
			}]
		}
		]
	},
	plugins: [
		new VueLoaderPlugin(),
		new MiniCssExtractPlugin({
			filename: "[name].css",
		}),
		new ManifestPlugin({
			fileName: 'manifest.json'
		})
	]
}