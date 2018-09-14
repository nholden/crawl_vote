module Types
  class CrawlSpotType < Types::BaseObject

    description "A spot on a crawl"

    field :id, ID, null: false
    field :votes_count, Integer, "How many votes this crawl spot has received", null: false
    field :current_user_vote_id, Integer, "The ID of the user's vote on this crawl spot or null if none exists", null: true
    field :spot, SpotType, "The spot associated with this crawl spot", null: false

  end
end
