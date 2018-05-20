class Vote < ApplicationRecord

  belongs_to :crawl_spot, counter_cache: true
  has_one :crawl, through: :crawl_spot

  validates :user_uuid,
    presence: true, uniqueness: { scope: :crawl_spot_id, message: 'already has a vote for crawl_spot_id' }
  validates :crawl_spot_id,
    presence: true

end
