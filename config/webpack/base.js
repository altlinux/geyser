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
            test: /\.(png|jpe?g|gif|svg)$/,
            use: [
               'file-loader?hash=sha512&digest=hex&name=[hash].[ext]',
               {
                  loader: 'image-webpack-loader?bypassOnDebug',
                  options: {
                     query: {
                        mozjpeg: {
                           progressive: true,
                        },
                        gifsicle: {
                           interlaced: true,
                        },
                        optipng: {
                           optimizationLevel: 7,
                        }
                     }
                  }
               }
            ]
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
