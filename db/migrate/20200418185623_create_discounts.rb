class CreateDiscounts < ActiveRecord::Migration[5.1]
  def change
    create_table :discounts do |t|
      t.string :code
      t.string :description
      t.integer :discount
      t.integer :number_of_items
      t.boolean :active
      t.references :merchant, foreign_key: true

      t.timestamps
    end
  end
end
