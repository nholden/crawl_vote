class CrawlsController < ApplicationController

  before_action :authenticate

  expose :crawl, id: :token, find_by: :token

  def show
    respond_to do |format|
      format.html
      format.json { render json: crawl }
    end
  end

  def create
    if crawl.valid?
      crawl.save!
      CrawlSpotWorker.perform_async(crawl.id)
      redirect_to crawl_path(crawl)
    else
      render :new
    end
  end

  private

  def authenticate
    respond_to do |format|
      format.html do
        session[:current_user_uuid] ||= SecureRandom.uuid
        Current.user_uuid = session[:current_user_uuid]
      end

      format.json do
        authenticate_or_request_with_http_token do |token, options|
          Current.user_uuid = token
        end
      end
    end
  end

  def crawl_params
    params.require(:crawl).permit(:term, :location)
  end

end
