# == Schema Information
#
# Table name: order_items
#
#  id         :integer          not null, primary key
#  product_id :integer
#  order_id   :integer
#  price      :string
#  integer    :string
#  quantity   :integer
#  created_at :datetime         not null
#  updated_at :datetime         not null
#
# Indexes
#
#  index_order_items_on_order_id    (order_id)
#  index_order_items_on_product_id  (product_id)
#

FactoryGirl.define do
  factory :order_item do
    product nil
    order nil
    price "MyString"
    integer "MyString"
    quantity 1
  end
end
