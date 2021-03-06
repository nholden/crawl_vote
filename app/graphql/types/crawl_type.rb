module Types
  class CrawlType < Types::BaseObject

    description "A list of crawl spots for users to vote on"

    field :term, String, "The user-provided search term (e.g. tacos)", null: false
    field :location, String, "The user-provided location (e.g. San Diego, CA)", null: false
    field :token, String, "A friendly code used as a unique identifier", null: false
    field :crawl_spots, CrawlSpotConnectionType, "Crawl spots on this crawl", null: false

  end
end
