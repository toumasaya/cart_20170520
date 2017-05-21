class CartsController < ApplicationController
  # before_action :init_cart

  def add
    # 按下 add_cart_path , 把 cart 送進 session 裡
    # cart = Cart.new # 每次都會新建一台購物車，這樣變成每次點擊都會是新的，無法加入項目
    # 應該是要先去把 session 裡的 hash 抓回購物車（如果有東西的話）
    # cart = Cart.from_hash(session[:cart9527])
    # init_cart
    @cart.add_item(params[:id])

    session[:cart9527] = @cart.to_hash

    # debugger
    redirect_to products_path, success: "Add to cart successfully"
  end

  def checkout
    @order = Order.new
  end

  def destroy
    session[:cart9527] = nil
    redirect_to products_path, success: "Cart is empty now!"
  end
end
