class WindowEnv

  WINDOW_SAFE_ENV_KEYS = %w(
    BASE_URL
    PUSHER_CLUSTER
    PUSHER_KEY
    PUSHER_LOG_TO_CONSOLE
  )

  def self.to_json
    ENV.to_hash.select { |key, value| WINDOW_SAFE_ENV_KEYS.include? key }.to_json.html_safe
  end

end
