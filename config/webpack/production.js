process.env.NODE_ENV = process.env.NODE_ENV || 'production'

const { merge } = require('@rails/webpacker')
const webpackConfig = require('./base')
const CssMinimizerPlugin = require('css-minimizer-webpack-plugin');

const customConfig = {
   optimization: {
      minimize: true,
      minimizer: [
         new CssMinimizerPlugin({
            minimizerOptions: {
               preset: [
                  'default',
                  {
                     discardComments: { removeAll: true },
                  },
               ],
            },
         }),
      ],
   },
}

module.exports = merge(webpackConfig, customConfig)
