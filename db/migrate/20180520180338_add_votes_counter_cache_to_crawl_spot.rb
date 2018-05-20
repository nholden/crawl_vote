class AddVotesCounterCacheToCrawlSpot < ActiveRecord::Migration[5.2]
  def change
    add_column :crawl_spots, :votes_count, :integer, default: 0, null: false
  end
end
