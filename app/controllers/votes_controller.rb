class VotesController < ApplicationController

  skip_forgery_protection
  before_action :authenticate

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

  def authenticate
    authenticate_or_request_with_http_token do |token, options|
      @user_uuid = token
    end
  end

  def vote_params
    params.require(:vote).permit(:crawl_spot_id).merge(user_uuid: @user_uuid)
  end

  def trigger_crawl_update
    Pusher.trigger("crawl-#{vote.crawl.token}", 'crawl-updated', {
      message: 'Crawl updated!'
    })
  end

end
