class CreateAddresses < ActiveRecord::Migration[5.1]
  def change
    create_table :addresses do |t|
      t.references :customer, foreign_key: true
      t.boolean :is_billing
      t.string :recipient
      t.string :street_1
      t.string :street_2
      t.string :city
      t.string :state
      t.string :zip
      t.boolean :active

      # t.timestamps
    end
  end
end
