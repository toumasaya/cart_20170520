# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)

5.times do
  Product.create(
    name: Faker::Commerce.product_name,
    price: Faker::Number.between(100, 10000),
    description: Faker::Lorem.sentence,
    image: Faker::Placeholdit.image("200x200") 
  )
end