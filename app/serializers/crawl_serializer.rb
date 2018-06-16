class CrawlSerializer < ActiveModel::Serializer

  attributes :id, :term, :location, :token, :spots_fetched

  has_many :crawl_spots

end
