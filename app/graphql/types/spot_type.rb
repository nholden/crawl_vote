module Types
  class SpotType < Types::BaseObject

    description "A physical location"

    field :name, String, "The name of the spot", null: false
    field :rating, Float, "The Yelp rating of the spot", null: false
    field :review_count, Integer, "How many Yelp reviews the spot has received", null: false
    field :url, String, "The Yelp URL of the spot", null: false
    field :image_url, String, "The URL to an image related to the spot", null: false
    field :address1, String, "The first line of the spot's street address", null: false
    field :city, String, "The city the spot is in", null: false
    field :state, String, "The state/province the spot is in", null: false

  end
end
