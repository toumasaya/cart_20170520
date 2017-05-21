require 'rails_helper'

RSpec.describe Cart, type: :model do

  let(:cart) { Cart.new }

  describe "Basic feature" do
    let(:p1) { FactoryGirl.create(:product, :price_100) }
    let(:p2) { FactoryGirl.create(:product, :price_200) }

    it "can add to cart" do
      cart.add_item(1)

      expect(cart).not_to be_empty
    end

    it "can calculate every item's quantity" do
      2.times { cart.add_item(1) }
      3.times { cart.add_item(2) }
      4.times { cart.add_item(1) }

      expect(cart.items.length).to be 2
      expect(cart.items.first.quantity).to be 6
      expect(cart.items.last.quantity).to be 3
    end
  

    it "will be a Product" do
      # p p1
      # p p2

      2.times { cart.add_item(p1.id) }
      3.times { cart.add_item(p2.id) }

      expect(cart.items.first.product).to be_kind_of Product
      expect(cart.items.last.product_id).to be p2.id
    end

    it "can calculate cart's total price" do
      2.times { cart.add_item(p1.id) }
      3.times { cart.add_item(p2.id) }

      expect(cart.total_price).to be 800
    end

    it "has a discount of NT$ 100 for a NT$ 1,000" do
      4.times { cart.add_item(p1.id) }
      5.times { cart.add_item(p2.id) }

      t = Time.local(2017, 6, 18, 12, 0)
      Timecop.travel(t) {
        expect(cart.total_price).to be (1400 - 100)
      }
    end

    it "has a discount of 10% on Christmas day" do
      4.times { cart.add_item(p1.id) }
      5.times { cart.add_item(p2.id) }

      t = Time.local(2017, 12, 25, 0, 0)
      Timecop.travel(t) {
        expect(cart.total_price).to be 1260
      }
    end
  end

  describe "Advance feature" do

    it "can convert to Hash and save in Session" do
      3.times { cart.add_item 1 }
      2.times { cart.add_item 2 }

      expect(cart.to_hash).to eq cart_hash
    end

    it "can convert to Array and save in Cart" do
      cart = Cart.from_hash(cart_hash) # => Cart.new, build a new Cart, cause "Build", use Cart class

      expect(cart.items.length).to be 2
      expect(cart.items.first.product_id).to be 1
      expect(cart.items.last.quantity).to be 2
    end

    private

    def cart_hash
      expected_hash = {
        "items" => [
          { "product_id" => 1, "quantity" => 3 },
          { "product_id" => 2, "quantity" => 2 }
        ]
      }
    end
  end
end
