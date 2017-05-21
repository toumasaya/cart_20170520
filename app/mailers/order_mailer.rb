class OrderMailer < ApplicationMailer
  
  def order_confirm(order)
    @total_price = order.order_items.reduce(0) { |sum, item| sum + item.price }
    # mail to: "someone", subject: "Order confirm"
    mail to: order.email, subject: "Order confirm"
  end

end
