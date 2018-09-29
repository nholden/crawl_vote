module Types
  class CrawlSpotType < Types::BaseObject

    description "A spot on a crawl"

    field :id, ID, null: false
    field :votes, VoteConnectionType, "Votes for this crawl spot", null: false
    field :spot, SpotType, "The spot associated with this crawl spot", null: false

  end
end
