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
    @promotion = Promotion.new(promotion_params)
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
    if params[:filter] == 'Cupons'
      @coupon = Coupon.search(params[:search])
      
      render :coupon
    else
      @promotions = Promotion.search(params[:search])
        flash.now[:notice] = t('messages.items_found', quantity: @promotions.count) unless @promotions.empty?
        render :index
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