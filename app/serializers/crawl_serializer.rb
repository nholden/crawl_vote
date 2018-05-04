class CrawlSerializer < ActiveModel::Serializer

  attributes :id, :term, :location

  has_many :crawl_spots

end
