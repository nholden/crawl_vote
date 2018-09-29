module Types
  class CrawlSpotConnectionType < GraphQL::Types::Relay::BaseConnection

    edge_type(CrawlSpotEdgeType)

    field :areFetched, Boolean, "Whether the app has attempted to fetch data on the crawl spots from Yelp's API", null: false

    def are_fetched
      object.parent.spots_fetched?
    end

  end
end
