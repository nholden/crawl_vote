class CrawlsController < ApplicationController

  include Authenticatable
  before_action :authenticate, only: [:show], if: -> { request.format.json? }

  expose :crawl, id: :token, find_by: :token

  def show
    respond_to do |format|
      format.html do
        session[:current_user_uuid] ||= SecureRandom.uuid
        authenticate
      end

      format.json { render json: crawl }
    end
  end

  def create
    if crawl.valid?
      crawl.save!
      CrawlSpotWorker.perform_async(crawl.id)
      render json: crawl
    else
      render json: crawl.errors, status: :bad_request
    end
  end

  private

  def crawl_params
    params.require(:crawl).permit(:term, :location)
  end

end
