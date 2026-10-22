class StoreGooglePlaceIdsOnSpots < ActiveRecord::Migration[8.1]
  def change
    rename_column :spots, :yelp_id, :google_place_id
    add_index :spots, :google_place_id
    add_column :spots, :image_attribution, :string
    add_column :spots, :image_attribution_url, :string
  end
end
