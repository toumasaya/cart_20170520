class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception

  # 所有 controller 都會執行
  before_action :init_cart

  add_flash_types :success, :warning, :danger, :info

  private

  # 把這個方法從 add action 取出來，放在這裡
  def init_cart
    @cart = Cart.from_hash(session[:cart9527])
  end
end
