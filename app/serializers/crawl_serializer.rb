class CrawlSerializer < ActiveModel::Serializer

  attributes :id, :term, :location, :token

  has_many :crawl_spots

end
