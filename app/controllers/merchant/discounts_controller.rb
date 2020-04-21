class Merchant::DiscountsController < Merchant::BaseController

  def new
    @discount = Discount.new
  end

  def index
    merchant = Merchant.find(current_user.merchant.id)
    @discounts = merchant.discounts
  end

  def create
    merchant = Merchant.find(current_user.merchant.id)
    @discount = merchant.discounts.new(discount_params)
    if @discount.save
      flash[:success] = "New discount '#{@discount.code}' created"
      redirect_to merchant_discounts_path
    else
      flash[:error] = @discount.errors.full_messages.to_sentence
      render :new
    end
  end

  def show
    @discount = Discount.find(params[:id])
  end

  def edit
    @discount = Discount.find(params[:id])
  end

  def update
    @discount = Discount.find(params[:id])
    if @discount.update(discount_params)
      redirect_to merchant_discounts_path
    else
      flash[:error] = @discount.errors.full_messages.to_sentence
      render :edit
    end
  end

  def destroy
    Discount.destroy(params[:id])
    redirect_to merchant_discounts_path
  end

  private

  def discount_params
    params.require(:discount).permit(:code,
                                     :description,
                                     :discount,
                                     :number_of_items,
                                     :active)
  end

end
