process.env.NODE_ENV = process.env.NODE_ENV || 'development'

const environment = require('./environment')
const dotenv = require('dotenv')
const webpack = require('webpack')

const dotenvFiles = [
  '.env',
]
dotenvFiles.forEach((dotenvFile) => {
  dotenv.config({ path: dotenvFile, silent: true })
})

environment.plugins.prepend('Environment', new webpack.EnvironmentPlugin(JSON.parse(JSON.stringify(process.env))))

module.exports = environment.toWebpackConfig()
