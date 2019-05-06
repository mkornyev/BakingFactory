class AddPictureToItem < ActiveRecord::Migration[5.1]
  def change
    add_column :items, :picture, :string
  end
end
