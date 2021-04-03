class PromotionsController < ApplicationController
  before_action :authenticate_user!
  before_action :set_promotion, only: %i[show edit update destroy generate_coupons]

  def index
    @promotions = Promotion.all
  end
  
  def show

  end

  def new
    @promotion = Promotion.new
  end
  
  def create 
    @promotion = current_user.promotions.new(promotion_params)
    # ou double splat** Promotion.new(**promotion_params, user: current_user)
    if @promotion.save
      redirect_to @promotion, notice: t('.success')
    else
      flash.now[:alert] = t('.fail')
      render :new 
    end
  end

  def edit

  end

  def update
    if @promotion.update(promotion_params)
      redirect_to @promotion, notice: t('.success')
    else
      flash.now[:alert] = t('.fail')
      render 'edit'
    end  
  end

  def destroy
    if @promotion.destroy
      redirect_to promotions_path, notice: t('.success')
    else
      redirect_to promotions_path, alert: t('.fail')
    end
  end

  def generate_coupons
    @promotion.generate_coupons!
    redirect_to @promotion, notice: t('.success')
  end

  def search
    @term = params[:search]
    @filter = params[:filter]

    if @filter == 'Cupons'
      @coupon = Coupon.search(@term)
      render :coupon
    else
      @promotions = Promotion.search(@term)
    end
  end
  

  private
      def set_promotion
        @promotion = Promotion.find(params[:id])
      end
      
      def promotion_params
        params
            .require(:promotion)
            .permit(:name, :expiration_date, :description, :discount_rate, :code, :coupon_quantity)
      end
end