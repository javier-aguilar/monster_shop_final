class Merchant::DiscountsController < Merchant::BaseController

  def new; end

  def index
    merchant = Merchant.find(current_user.merchant.id)
    @discounts = merchant.discounts
  end

  def create
    merchant = Merchant.find(current_user.merchant.id)
    merchant.discounts.create(discount_params)
    redirect_to merchant_discounts_path
  end

  private

  def discount_params
    params.permit(:code, :description, :discount, :number_of_items)
  end

end
