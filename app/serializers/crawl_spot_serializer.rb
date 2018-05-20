class CrawlSpotSerializer < ActiveModel::Serializer

  attributes :id, :vote_count

  has_one :spot
  has_one :current_user_vote

end
