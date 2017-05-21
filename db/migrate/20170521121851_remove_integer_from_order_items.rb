class RemoveIntegerFromOrderItems < ActiveRecord::Migration[5.1]
  def change
    remove_column :order_items, :integer
  end
end
