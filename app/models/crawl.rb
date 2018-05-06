class Crawl < ApplicationRecord

  has_many :crawl_spots
  has_many :spots, through: :crawl_spots

  before_create :generate_token

  private

  def generate_token
    begin
      self.token = TokenPhrase.generate
    end while Crawl.exists?(token: token)
  end

end
