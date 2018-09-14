module Types
  class CrawlSpotType < Types::BaseObject
    field :id, ID, null: false
    field :votes_count, Integer, null: false
    field :current_user_vote_id, Integer, null: true
    field :spot, SpotType, null: false
  end
end
