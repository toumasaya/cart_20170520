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

require 'rails_helper'

RSpec.describe Order, type: :model do
  pending "add some examples to (or delete) #{__FILE__}"
end
