module Authenticatable

  private

  def authenticate
    if user_uuid_from_session = session[:current_user_uuid]
      Current.user_uuid = user_uuid_from_session
    else
      authenticate_or_request_with_http_token do |token, options|
        Current.user_uuid = token
      end
    end
  end

end
