class AddYelpIdToSpots < ActiveRecord::Migration[5.2]
  def change
    add_column :spots, :yelp_id, :string
  end
end
