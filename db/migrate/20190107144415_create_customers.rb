class CreateCustomers < ActiveRecord::Migration[5.1]
  def change
    create_table :customers do |t|
      t.string :first_name
      t.string :last_name
      t.string :email
      t.string :phone
      t.references :user, foreign_key: true
      t.boolean :active

      # t.timestamps
    end
  end
end
