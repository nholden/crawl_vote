module Api
  class VotesController < ApiController

    expose :vote

    def create
      if vote.valid?
        vote.save!
        trigger_crawl_update
        render json: vote, status: :created
      else
        render json: vote.errors, status: :bad_request
      end
    end

    def destroy
      if vote.user_uuid == Current.user_uuid
        vote.destroy
        trigger_crawl_update
        head :no_content
      else
        render plain: 'Forbidden: Vote does not belong to current user.', status: :forbidden
      end
    end

    private

    def vote_params
      params.require(:vote).permit(:crawl_spot_id).merge(user_uuid: Current.user_uuid)
    end

    def trigger_crawl_update
      Pusher.trigger("crawl-#{vote.crawl.token}", 'crawl-updated', {
        message: 'Crawl updated!'
      })
    end

  end
end
