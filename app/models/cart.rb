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
    total = items.reduce(0) { |total, item| total + item.subtotal_price }

    if Time.now.month == 6 && total >= 1000
      total -= 100
    else
      total
    end
  end
end