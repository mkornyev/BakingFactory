class CreateItemPrices < ActiveRecord::Migration[5.1]
  def change
    create_table :item_prices do |t|
      t.references :item, foreign_key: true
      t.float :price
      t.date :start_date
      t.date :end_date

      # t.timestamps
    end
  end
end
