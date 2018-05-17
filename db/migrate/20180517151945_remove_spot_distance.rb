class RemoveSpotDistance < ActiveRecord::Migration[5.2]
  def change
    remove_column :spots, :distance
  end
end
