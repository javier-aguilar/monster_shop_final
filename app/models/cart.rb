class Cart
  attr_reader :contents, :discounts

  def initialize(contents, discounts = 0)
    @contents = contents || {}
    @contents.default = 0
    @discounts = discounts || {}
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
    @contents.map do |item_id, _|
      Item.find(item_id)
    end
  end

  def grand_total
    grand_total = 0.0
    @contents.each do |item_id, quantity|
      price = Item.find(item_id).price
      grand_total += apply_discount(item_id, price, quantity)
    end
    grand_total
  end

  def count_of(item_id)
    @contents[item_id.to_s]
  end

  def subtotal_of(item_id)
    price = Item.find(item_id).price
    quantity = @contents[item_id.to_s]
    apply_discount(item_id, price, quantity)
  end

  def limit_reached?(item_id)
    count_of(item_id) == Item.find(item_id).inventory
  end

  def apply_discount(item_id, price, quantity)
    if min_num_of_items?(item_id, quantity)
      discount_price(item_id, price) * quantity
    else
      price * quantity
    end
  end

  def min_num_of_items?(item_id, quantity)
    item = Item.find(item_id)
    minimum = Discount.where(merchant_id: item.merchant.id).minimum(:number_of_items)
    minimum.nil? ? false : quantity >= minimum
  end

  def discount(item_id)
    item = Item.find(item_id)
    Discount.where(merchant_id: item.merchant.id)
            .where("number_of_items <= ?", self.count_of(item_id))
            .maximum(:discount)
  end

  def discount_price(item_id, price)
    price - (price * (discount(item_id) / 100.00))
  end

  def display_discount(item_id, quantity)
    item = Item.find(item_id)
    discount = Discount.where(merchant_id: item.merchant.id, discount: discount(item_id))
    "Discount '#{discount.first.code}' has been applied" if min_num_of_items?(item_id, quantity)
  end

end
