class CrawlSpotSerializer < ActiveModel::Serializer

  attributes :id

  has_one :spot

end
