class CreateOrderItems < ActiveRecord::Migration[5.1]
  def change
    create_table :order_items do |t|
      t.references :product, foreign_key: true
      t.references :order, foreign_key: true
      t.string :price
      t.string :integer
      t.integer :quantity

      t.timestamps
    end
  end
end
