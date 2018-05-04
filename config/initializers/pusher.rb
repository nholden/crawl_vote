Pusher.app_id = ENV.fetch('PUSHER_APP_ID')
Pusher.key = ENV.fetch('PUSHER_KEY')
Pusher.secret = ENV.fetch('PUSHER_SECRET')
Pusher.cluster = ENV.fetch('PUSHER_CLUSTER')
Pusher.logger = Rails.logger
Pusher.encrypted = true unless Rails.env.test?
