class CrawlsController < ApplicationController

  expose :crawl

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

  def crawl_params
    params.require(:crawl).permit(:term, :location)
  end

end
