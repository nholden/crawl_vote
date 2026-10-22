# Laravel Cloud precompiles assets with SECRET_KEY_BASE_DUMMY and without
# the runtime Pusher credentials. A real boot still requires every key.
unless ENV['SECRET_KEY_BASE_DUMMY']
  Pusher.app_id = ENV.fetch('PUSHER_APP_ID')
  Pusher.key = ENV.fetch('PUSHER_KEY')
  Pusher.secret = ENV.fetch('PUSHER_SECRET')
  Pusher.cluster = ENV.fetch('PUSHER_CLUSTER')
end

Pusher.logger = Rails.logger
# Pusher 2 defaults to TLS. pusher-fake serves plain HTTP in test.
Pusher.encrypted = !Rails.env.test?
