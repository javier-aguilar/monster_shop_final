require 'rails_helper'

RSpec.describe Discount do
  describe 'Relationships' do
    it {should belong_to :merchant}
  end

  describe 'Validations' do
    it {should validate_presence_of :code}
    it {should validate_presence_of :description}
    it {should validate_presence_of :discount}
    it {should validate_presence_of :number_of_items}
    it {should validate_presence_of :active}
  end
end