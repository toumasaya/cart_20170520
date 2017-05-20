class Cart
  
  attr_reader :items

  def initialize
    @items = []
  end

  def add_item(id)
    found_item  = items.find { |item| item.product_id == id }

    if found_item
      found_item.increment
    else
      items << CartItem.new(id)
    end
  end

  def empty?
    items.empty?
  end

  def total_price
    items.reduce(0) { |total, item| total + item.subtotal_price }
  end
end