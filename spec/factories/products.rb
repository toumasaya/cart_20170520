# == Schema Information
#
# Table name: products
#
#  id          :integer          not null, primary key
#  name        :string
#  price       :integer
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#  description :text
#  image       :string
#

FactoryGirl.define do
  factory :product do
    # 如果沒有加 {} 會做出一樣的結果
    # title Faker::Commerce.product_name
    # price Faker::Number.between(50, 100)
    name { Faker::Commerce.product_name }
    price { Faker::Number.between(50, 100) }

    trait :price_100 do
      price 100
    end

    trait :price_200 do
      price 200
    end
  end
end
