module Types
  class SpotType < Types::BaseObject

    description "A physical location"

    field :name, String, "The name of the spot", null: false
    field :rating, Float, "The Google Maps rating of the spot", null: true
    field :review_count, Integer, "How many Google Maps reviews the spot has received", null: true
    field :url, String, "The Google Maps URL of the spot", null: false
    field :image_url, String, "A photo of the spot", null: true
    field :image_attribution, String, "The name of the person who took the photo", null: true
    field :image_attribution_url, String, "A link to the photographer's Google Maps profile", null: true
    field :address1, String, "The first line of the spot's street address", null: true
    field :city, String, "The city the spot is in", null: true
    field :state, String, "The state/province the spot is in", null: true

  end
end
