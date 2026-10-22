// Node 26 implements setImmediate in JavaScript, so Vue 2 no longer treats
// it as native and falls back to MessageChannel. That port stays open and
// the production webpack process never exits.
delete global.MessageChannel

const { environment } = require('@rails/webpacker')
const vue =  require('./loaders/vue')
const webpack = require('webpack')

environment.loaders.append('vue', vue)
module.exports = environment
