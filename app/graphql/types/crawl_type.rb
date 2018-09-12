module Types
  class CrawlType < Types::BaseObject
    field :term, String, null: false
    field :location, String, null: false
    field :token, String, null: false
    field :spots_fetched, Boolean, null: false
  end
end
