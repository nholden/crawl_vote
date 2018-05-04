class CrawlSpotSerializer < ActiveModel::Serializer

  attributes :id, :vote_count, :current_user_vote_count

  has_one :spot

end
