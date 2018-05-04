class CreateVotes < ActiveRecord::Migration[5.2]
  def change
    create_table :votes do |t|
      t.integer :crawl_spot_id
      t.string :user_uuid

      t.timestamps
    end
    add_index :votes, :crawl_spot_id
  end
end
