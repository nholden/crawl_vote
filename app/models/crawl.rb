class Crawl < ApplicationRecord

  has_many :crawl_spots, -> { joins(:spot).order('crawl_spots.votes_count desc, spots.rating desc, spots.review_count desc') }
  has_many :spots, through: :crawl_spots

  before_create :generate_token

  def to_param
    # https://hackernoon.com/using-custom-slugs-for-rails-urls-500eb3f58f3c
    token
  end

  private

  def generate_token
    begin
      self.token = TokenPhrase.generate
    end while Crawl.exists?(token: token)
  end

end
