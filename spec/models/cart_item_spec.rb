require 'rails_helper'

RSpec.describe CartItem, type: :model do

  describe "Basic feature" do
    
    it "can calculate every item's subtotal price" do
      p1 = Product.create(name: "P1", price: 100)
      p2 = Product.create(name: "P2", price: 200)
      cart = Cart.new

      2.times { cart.add_item(p1.id) }
      3.times { cart.add_item(p2.id) }

      expect(cart.items.first.subtotal_price).to be 200
      expect(cart.items.last.subtotal_price).to be 600
    end
  end
end
