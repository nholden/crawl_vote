class CrawlsController < ApplicationController

  expose :crawl, id: :token, find_by: :token
  before_action :set_user_uuid

  private

  def set_user_uuid
    session[:current_user_uuid] ||= SecureRandom.uuid
    Current.user_uuid = session[:current_user_uuid]
  end

end
