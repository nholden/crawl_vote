class CreateSpots < ActiveRecord::Migration[5.2]
  def change
    create_table :spots do |t|
      t.float :rating
      t.string :price
      t.integer :review_count
      t.string :name
      t.string :url
      t.string :image_url
      t.string :city
      t.string :country
      t.string :address1
      t.string :address2
      t.string :address3
      t.string :state
      t.string :zip_code
      t.float :distance

      t.timestamps
    end
  end
end
