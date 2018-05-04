class AddUniquenessIndexToVotes < ActiveRecord::Migration[5.2]
  def change
    add_index :votes, [:user_uuid, :crawl_spot_id], unique: true
  end
end
