require 'rails_helper'

RSpec.describe CartItem, type: :model do

  describe "Basic feature" do
    let(:cart) { Cart.new }
    let(:p1) { FactoryGirl.create(:product, :price_100) }
    let(:p2) { FactoryGirl.create(:product, :price_200) }
    
    it "can calculate every item's subtotal price" do
      2.times { cart.add_item(p1.id) }
      3.times { cart.add_item(p2.id) }

      expect(cart.items.first.subtotal_price).to be 200
      expect(cart.items.last.subtotal_price).to be 600
    end
  end
end
