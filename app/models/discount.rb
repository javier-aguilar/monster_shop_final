class Discount < ApplicationRecord
  belongs_to :merchant

  validates_presence_of :code,
                        :description,
                        :discount,
                        :number_of_items,
                        :active


end
