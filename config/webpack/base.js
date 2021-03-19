const { webpackConfig, merge } = require('@rails/webpacker')
const MiniCssExtractPlugin = require('mini-css-extract-plugin');

var PROD = global.env === 'production' || global.env === 'staging'
var DEBUG = !PROD

const customConfig = {
   cache: true,

   module: {
      rules: [
         {
            test: /~$/,
            loader: 'ignore-loader'
         },
         {
            test: /\.(woff|woff2|ttf|eot)$/,
            use: [{
               loader: 'file-loader',
            }]
         },
      ],
   },

   plugins: [
      new MiniCssExtractPlugin({ filename: '[name]-[fullhash].css',
                                 chunkFilename: '[id].css',
                                 ignoreOrder: DEBUG ? false : true }),
   ],

   stats: {
      errorDetails: true,
      children: true
   },
}

module.exports = merge(webpackConfig, customConfig)
