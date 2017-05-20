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

  it "will be a Product" do
    p1 = Product.create(name: "P1")
    p2 = Product.create(name: "P2")
    cart = Cart.new

    # p p1
    # p p2

    2.times { cart.add_item(p1.id) }
    3.times { cart.add_item(p2.id) }

    expect(cart.items.first.product).to be_kind_of Product
    expect(cart.items.last.product_id).to be p2.id
  end
end
