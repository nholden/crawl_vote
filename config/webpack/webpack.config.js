const { generateWebpackConfig } = require('shakapacker')
const { VueLoaderPlugin } = require('vue-loader')

const config = generateWebpackConfig()

// vue-loader 15 rejects a Vue rule that uses oneOf. Shakapacker's raw
// loader is an oneOf rule that also matches .vue files, so the Vue rule
// has to come first.
config.module.rules.unshift({
  test: /\.vue(\.erb)?$/,
  loader: 'vue-loader'
})

// <template lang="pug"> is compiled by the cloned .pug rule before
// vue-loader turns the HTML into a render function. Inline match resources
// force those blocks through as JavaScript and skip this loader.
config.module.rules.push({
  test: /\.pug$/,
  loader: 'pug-plain-loader'
})

config.resolve.extensions.push('.vue')
config.plugins.push(new VueLoaderPlugin())

// Webpack 5 still defaults chunk hashes to MD4. xxhash64 stays inside
// Webpack, so Node 26's OpenSSL does not have to enable the legacy provider.
config.output.hashFunction = 'xxhash64'

// vue-loader imports a default from each <style> block. mini-css-extract
// emits no default for plain CSS, and the loader only re-exports named
// bindings. The stylesheet is still extracted; this warning is that unused
// default import.
config.ignoreWarnings = [
  ...(config.ignoreWarnings || []),
  /export 'default' \(imported as 'style\d+'\) was not found/
]

module.exports = config
