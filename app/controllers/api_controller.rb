class ApiController < ApplicationController

  skip_forgery_protection
  before_action :authenticate

  private

  def authenticate
    authenticate_or_request_with_http_token do |token, options|
      Current.user_uuid = token
    end
  end

end
