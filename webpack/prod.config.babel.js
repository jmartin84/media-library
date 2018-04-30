/* eslint-disable import/no-extraneous-dependencies */
const webpack = require('webpack');
const merge = require('webpack-merge');
const base = require('./base.config.babel');
const OptimizeCssAssetsPlugin = require('optimize-css-assets-webpack-plugin');

module.exports = merge(base, {
	devtool: 'cheap-module-source-map',
	mode: 'production',
	plugins: [
		new OptimizeCssAssetsPlugin({
			assetNameRegExp: /\.css$/
		}),
		// strip dev-only code in Vue source
		new webpack.DefinePlugin({
			'process.env.NODE_ENV': JSON.stringify('"production"')
		})
	]
})
