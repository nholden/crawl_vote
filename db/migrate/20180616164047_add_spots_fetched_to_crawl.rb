class AddSpotsFetchedToCrawl < ActiveRecord::Migration[5.2]
  def change
    add_column :crawls, :spots_fetched, :boolean
  end
end
