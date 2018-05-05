class CrawlsController < ApplicationController

  before_action :find_or_create_user_uuid

  expose :crawl

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

  def find_or_create_user_uuid
    session[:current_user_uuid] ||= SecureRandom.uuid
    Current.user_uuid = params[:user_uuid] || session[:current_user_uuid]
  end

  def crawl_params
    params.require(:crawl).permit(:term, :location)
  end

end
