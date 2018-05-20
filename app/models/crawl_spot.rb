class CrawlSpot < ApplicationRecord

  belongs_to :crawl
  belongs_to :spot
  has_many :votes
  has_one :current_user_vote,  -> { where(user_uuid: Current.user_uuid) }, class_name: 'Vote'

  def vote_count
    votes.count
  end

end
