class CreatePhotos < ActiveRecord::Migration
  def change
    create_table :photos do |t|
      t.integer :item_id
      t.integer :user_id
      t.text :path
      t.text :description
      t.timestamp :taken_at

      t.timestamps
    end
  end
end
