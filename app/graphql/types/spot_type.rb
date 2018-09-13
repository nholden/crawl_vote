module Types
  class SpotType < Types::BaseObject
    field :name, String, null: false
    field :rating, Float, null: false
    field :review_count, Integer, null: false
    field :url, String, null: false
    field :image_url, String, null: false
    field :address1, String, null: false
    field :city, String, null: false
    field :state, String, null: false
  end
end
