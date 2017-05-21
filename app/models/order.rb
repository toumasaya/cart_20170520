# == Schema Information
#
# Table name: orders
#
#  id         :integer          not null, primary key
#  recipient  :string
#  tel        :string
#  email      :string
#  note       :text
#  state      :string
#  created_at :datetime         not null
#  updated_at :datetime         not null
#

class Order < ApplicationRecord
  has_many :order_items

  include AASM

  # aasm do # default column: aasm_state
  aasm column: "state" do # 改成 order state column
    # 初始狀態
    state :pending, :initial => true
    # 其他狀態
    state :canceled, :paid, :shipped, :delivered, :rejected, :refunded

    # 透過事件觸發狀態，事件會是動詞
    event :pay do
      # transitions from: :pending, to: :paid
      transitions :from => :pending, :to => :paid

      # after_transitions do
      #   # 付款後發送簡訊
      #   puts "send SMS to #{tel}"
      # end
    end

    event :ship do
      transitions :from => :paid, :to => :shipped
    end

    event :deliver do
      transitions :from => :shipped, :to => :delivered
    end

    event :reject do
      transitions :from => :delivered, :to => :rejected
    end

    event :refund do
      transitions :from => [:rejected, :paid], :to => :refunded
    end

    event :cancel do
      transitions :from => [:pending, :refunded], :to => :canceled
    end
  end

end
