class VotesController < ApplicationController

  skip_forgery_protection

  expose :vote

  def create
    response = if vote.valid?
                 vote.save!
                 trigger_crawl_update
                 { json: vote, status: :created }
               else
                 { json: vote.errors, status: :bad_request }
               end

    render response
  end

  private

  def vote_params
    params.require(:vote).permit(:user_uuid, :crawl_spot_id)
  end

  def trigger_crawl_update
    Pusher.trigger("crawl-#{vote.crawl.token}", 'crawl-updated', {
      message: 'Crawl updated!'
    })
  end

end
