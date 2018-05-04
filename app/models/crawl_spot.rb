class CrawlSpot < ApplicationRecord

  belongs_to :crawl
  belongs_to :spot
  has_many :votes

  def vote_count
    votes.count
  end

  def current_user_vote_count
    votes.where(user_uuid: Current.user_uuid).count
  end

end
