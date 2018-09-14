class CrawlSpot < ApplicationRecord

  belongs_to :crawl
  belongs_to :spot
  has_many :votes
  has_one :current_user_vote,  -> { where(user_uuid: Current.user_uuid) }, class_name: 'Vote'

  delegate :id, to: :current_user_vote, prefix: true, allow_nil: true

end
