class CreateCrawls < ActiveRecord::Migration[5.2]
  def change
    create_table :crawls do |t|
      t.string :slug
      t.string :term
      t.string :location

      t.timestamps
    end
  end
end
