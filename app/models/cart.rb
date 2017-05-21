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
    elsif Time.now.month == 12 && Time.now.day == 25
      total = (total * 0.9).round
    else
      total
    end
  end

  def to_hash
    # all_items = [
    #   { "product_id" => 1, "quantity" => 3 },
    #   { "product_id" => 2, "quantity" => 2 }
    # ]

    all_items = items.map { |item| {
      "product_id" => item.product_id,
      "quantity" => item.quantity
    }}

    { "items" => all_items }
  end
end