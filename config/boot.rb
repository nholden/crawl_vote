ENV['BUNDLE_GEMFILE'] ||= File.expand_path('../Gemfile', __dir__)

require 'bundler/setup' # Set up gems listed in the Gemfile.
require 'bootsnap/setup' # Speed up boot time by caching expensive operations.

# Webpack 3 hashes with MD4. Node 17+ ships OpenSSL 3, which disables MD4
# unless the legacy provider is enabled. Laravel Cloud precompiles assets
# with Node 26.
begin
  node_major = IO.popen(%w[node -p process.versions.node], &:read).to_s.split('.').first.to_i
  if node_major >= 17
    flag = '--openssl-legacy-provider'
    current = ENV['NODE_OPTIONS'].to_s.split
    ENV['NODE_OPTIONS'] = (current + [flag]).uniq.join(' ') unless current.include?(flag)
  end
rescue Errno::ENOENT
end
