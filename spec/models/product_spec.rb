# == Schema Information
#
# Table name: products
#
#  id          :integer          not null, primary key
#  name        :string
#  price       :integer
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#  description :text
#  image       :string
#

require 'rails_helper'

RSpec.describe Product, type: :model do
end
