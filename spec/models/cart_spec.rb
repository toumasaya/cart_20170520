require 'rails_helper'

RSpec.describe Cart, type: :model do
  describe "Basic feature" do
    it "can add to cart" do
      cart = Cart.new

      cart.add_item(1)
      expect(cart).not_to be_empty
    end
  end
end
