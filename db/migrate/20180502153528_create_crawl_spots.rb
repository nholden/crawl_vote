class CreateCrawlSpots < ActiveRecord::Migration[5.2]
  def change
    create_table :crawl_spots do |t|
      t.integer :crawl_id
      t.integer :spot_id

      t.timestamps
    end
    add_index :crawl_spots, :crawl_id
    add_index :crawl_spots, :spot_id
  end
end
