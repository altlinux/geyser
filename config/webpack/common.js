/*
 * Webpack config with Babel, Sass and PostCSS support.
 */

global.env = process.env.RAILS_ENV || process.env.NODE_ENV || 'development'

const path = require('path');
const join = path.join
var PROD = global.env === 'production'
var DEBUG = !PROD

if (__dirname.match(/config/)) {
   global.rootpath = path.normalize(join(__dirname, '../../'))
} else {
   global.rootpath = __dirname
}

console.log("Env:", global.env)
console.log("Root:", global.rootpath)

var webpack = require('webpack')
const MiniCssExtractPlugin = require('mini-css-extract-plugin');
const postcssOpts = {sourceMap: true}
const ManifestPlugin = require('webpack-manifest-plugin');

module.exports = {
   cache: true,

   context: global.rootpath,

   entry: {
      'application': './app/assets/javascripts/application.js',
   },

   module: {
      // noParse: /lodash/, // ignore parsing for modules ex.lodash

      rules: [
         {
            test: /~$/,
            loader: 'ignore-loader'
         },
         {
            test: /\.(sa|sc)ss$/,
            use: [
               {
                  loader: MiniCssExtractPlugin.loader,
                  options: {
                     hmr: DEBUG,
                     reloadAll: true,
                  },
               },
               { loader: 'css-loader', options: { sourceMap: true, importLoaders: 1 } },
               { loader: 'postcss-loader', options: { options: {}, } },
               { loader: 'sass-loader', options: { sourceMap: true } },
            ],
         },
         {
            test: /\.css$/,
            use: [
               {
                  loader: MiniCssExtractPlugin.loader,
                  options: {
                     hmr: DEBUG,
                     reloadAll: true,
                  },
               },
               { loader: 'css-loader', options: { sourceMap: true, importLoaders: 1 } },
               { loader: 'postcss-loader', options: { options: {}, } },
            ],
         },
         {
            test: /\.(png|jpe?g|gif|svg)$/,
            loaders: [
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

   output: {
      path: join(global.rootpath, 'vendor/assets'),
      filename: DEBUG ? '[name].js' : '[name]-[hash].js',
      devtoolModuleFilenameTemplate: 'webpack:///[absolute-resource-path]'
   },

   resolve: {
      extensions: [ '.js', '.jsx' ],
      modules: ['components','node_modules'],
      alias: {
         components: path.join(global.rootpath, 'app/webpack/js/components')
      }
   },

   plugins: [
      new MiniCssExtractPlugin({ filename: DEBUG ? '[name].css' : '[name]-[hash].css',
                                 chunkFilename: DEBUG ? '[id].css' : '[id]-[hash].css',
                                 ignoreOrder: DEBUG ? false : true }),

      // Ignore locales because it's around 400kb
      // new webpack.IgnorePlugin(/^\.\/locale$/, /moment$/),
      new webpack.LoaderOptionsPlugin({
         test: /\.xxx$/, // may apply this only for some modules
         debug: DEBUG ? true : false,
         options: {
            sassLoader: {
               includePaths: join(global.rootpath, 'node_modules'),
               outputStyle: DEBUG ? 'nested' : 'compressed'
            },
         },
         postcss: [
            require('autoprefixer')(),
         ],
      }),
      new ManifestPlugin(),
   ],
}
