class ChangePriceFromOrderItems < ActiveRecord::Migration[5.1]
  def change
    change_column :order_items, :price, :integer
  end
end
