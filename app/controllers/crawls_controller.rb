class CrawlsController < ApplicationController

  expose :crawl, id: :token, find_by: :token

  def show
    session[:current_user_uuid] ||= SecureRandom.uuid
    Current.user_uuid = session[:current_user_uuid]
  end

end
