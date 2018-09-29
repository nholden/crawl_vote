class CrawlSpot < ApplicationRecord

  belongs_to :crawl
  belongs_to :spot
  has_many :votes

end
