class AllowMorePreciseSpotDistances < ActiveRecord::Migration[5.2]
  def up
    change_column :spots, :distance, :decimal, precision: 20, scale: 15
  end

  def down
  end
end
