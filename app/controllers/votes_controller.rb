class VotesController < ApplicationController

  skip_forgery_protection

  def create
    vote = Vote.new(vote_params)

    response = if vote.valid?
                 vote.save!
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

end
