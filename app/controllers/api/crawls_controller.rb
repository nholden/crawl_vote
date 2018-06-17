module Api
  class CrawlsController < ApiController

    skip_before_action :authenticate, only: [:create]

    expose :crawl, id: :token, find_by: :token

    def show
      render json: crawl
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
end
