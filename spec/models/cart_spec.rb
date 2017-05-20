require 'rails_helper'

RSpec.describe Cart, type: :model do

  describe "Basic feature" do

    it "can add to cart" do
      cart = Cart.new

      cart.add_item(1)
      expect(cart).not_to be_empty
    end

    it "can calculate every item's quantity" do
      cart = Cart.new

      2.times { cart.add_item(1) }
      3.times { cart.add_item(2) }
      4.times { cart.add_item(1) }

      expect(cart.items.length).to be 2
      expect(cart.items.first.quantity).to be 6
      expect(cart.items.last.quantity).to be 3
    end
  end
end
