class Discount < ApplicationRecord
  belongs_to :merchant

  validates_presence_of :code,
                        :description,
                        :number_of_items,
                        :active
  validates :discount,
    :numericality => { greater_than_or_equal_to: 1, less_than_or_equal_to: 100 }
end
