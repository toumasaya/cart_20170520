class OrdersController < ApplicationController
  def create
    # debugger
    @order = Order.new(order_params)
    # @order.build_order_items(@cart)

    @cart.items.each do |item|
      # 從 @order 立場建立很多 @order_items
      @order.order_items.build(product: item.product, 
                               price: item.product.price,
                               quantity: item.quantity)
    end

    if @order.save
      # order 成立後
      # 1. 付錢
      # 2. 清空 cart
      session[:cart9527] = nil
      # 2.5 寄信
      # OrderMailer.order_confirm(@order).deliver_later
      OrderMailer.order_confirm(@order).deliver_now
      # 3. 回到 products_path
      redirect_to products_path, success: "Thank you! Bye!"
    else
      render "carts/checkout"
      # or
      # redirect_to cart_path, danger: "Order has some problem"
    end
  end

  def order_params
    # note 和 state 都不用讓使用者輸入
    params.require(:order).permit(:recipient, :tel, :email)
  end
end
