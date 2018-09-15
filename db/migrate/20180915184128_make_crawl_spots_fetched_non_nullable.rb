class MakeCrawlSpotsFetchedNonNullable < ActiveRecord::Migration[5.2]
  def change
    change_column :crawls, :spots_fetched, :boolean, null: false, default: false
  end
end
