class AddItemToUser < ActiveRecord::Migration
  def change
    change_table :items do |t|
      t.integer :user_id
    end
  end
end
