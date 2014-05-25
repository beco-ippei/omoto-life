class CreateItems < ActiveRecord::Migration
  def change
    create_table :items do |t|
      t.string :title
      t.string :description
      t.string :breed
      t.integer :user_id

      t.timestamps
    end
  end
end
