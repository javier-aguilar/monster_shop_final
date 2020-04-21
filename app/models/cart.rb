class Cart
  attr_reader :contents

  def initialize(contents, discounts = 0)
    @contents = contents || {}
    @contents.default = 0
  end

  def add_item(item_id)
    @contents[item_id] += 1
  end

  def less_item(item_id)
    @contents[item_id] -= 1
  end

  def count
    @contents.values.sum
  end

  def items
    @contents.map { |item_id, _| Item.find(item_id) }
  end

  def grand_total
    grand_total = 0.0
    @contents.each { |item_id, _| grand_total += apply_discount(Item.find(item_id)) }
    grand_total
  end

  def count_of(item_id)
    @contents[item_id.to_s]
  end

  def subtotal_of(item_id)
    apply_discount(Item.find(item_id))
  end

  def limit_reached?(item_id)
    count_of(item_id) == Item.find(item_id).inventory
  end

  def apply_discount(item)
    quantity = @contents[item.id.to_s]
    min_num_of_items?(item) ? (discount_price(item) * quantity) : (item.price * quantity)
  end

  def min_num_of_items?(item)
    quantity = @contents[item.id.to_s]
    minimum = discount(item)
    minimum.nil? ? false : quantity >= minimum.number_of_items
  end

  def discount(item)
    Discount.where(merchant_id: item.merchant.id)
            .where("number_of_items <= ?", self.count_of(item.id))
            .order(discount: :desc).first
  end

  def discount_price(item)
    item.price - (item.price * (discount(item).discount / 100.00))
  end

  def display_discount(item)
    "Discount '#{discount(item).code}' has been applied" if min_num_of_items?(item)
  end

end
