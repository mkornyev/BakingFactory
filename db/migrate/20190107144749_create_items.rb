class CreateItems < ActiveRecord::Migration[5.1]
  def change
    create_table :items do |t|
      t.string :name
      t.text :description
      t.string :category
      t.integer :units_per_item
      t.float :weight
      t.boolean :active

      # t.timestamps
    end
  end
end
