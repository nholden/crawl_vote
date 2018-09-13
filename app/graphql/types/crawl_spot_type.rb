module Types
  class CrawlSpotType < Types::BaseObject
    field :votes_count, Integer, null: false
    field :has_current_user_vote, Boolean, null: false, method: :has_current_user_vote?
    field :spot, SpotType, null: false
  end
end
