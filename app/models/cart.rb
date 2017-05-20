class Cart
  def initialize
    @item = []
  end

  def add_item(n)
    @item << n
  end

  def empty?
    @item.empty?
  end
end