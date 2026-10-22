module Types
  class CrawlSpotConnectionType < GraphQL::Types::Relay::BaseConnection

    edge_type(CrawlSpotEdgeType)

    field :are_fetched, Boolean, "Whether the app has attempted to fetch crawl spots from Google Places", null: false

    def are_fetched
      object.parent.spots_fetched?
    end

  end
end
