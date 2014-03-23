class CreateItems < ActiveRecord::Migration
  def change
    create_table :items do |t|
      t.string :title
      t.string :path
      t.string :description
      t.string :breed

      t.timestamps
    end
  end
end
