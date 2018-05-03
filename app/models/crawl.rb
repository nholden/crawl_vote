class Crawl < ApplicationRecord

  has_many :crawl_spots
  has_many :spots, through: :crawl_spots

end
