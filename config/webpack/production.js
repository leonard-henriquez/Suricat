process.env.NODE_ENV = process.env.NODE_ENV || 'production'

const environment = require('./environment')

const UglifyJsPlugin = require('uglifyjs-webpack-plugin');

module.exports = {
  optimization: {
    minimizer: [new UglifyJsPlugin()]
  }
}

module.exports = environment.toWebpackConfig()
