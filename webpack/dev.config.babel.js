/* eslint-disable import/no-extraneous-dependencies */
const webpack = require('webpack');
const merge = require('webpack-merge');
const base = require('./base.config.babel');
const FriendlyErrorsPlugin = require('friendly-errors-webpack-plugin');

module.exports = merge(base, {
	devtool: 'eval-source-map',
	mode: "development",
	plugins: [
		new FriendlyErrorsPlugin(),
		// strip dev-only code in Vue source
		new webpack.DefinePlugin({
			'process.env.NODE_ENV': JSON.stringify('"development"')
		}),
	]
})
