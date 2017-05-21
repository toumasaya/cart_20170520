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
end
