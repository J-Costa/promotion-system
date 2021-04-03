class PromotionsController < ApplicationController
  before_action :authenticate_user!
  before_action :set_promotion, only: %i[show edit update destroy generate_coupons approve]
  before_action :can_be_approved, only: [:approve]
  
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

  def approve
    # PromotionApproval.create!(promotion: @promotion, user: current_user)
    current_user.promotion_approvals.create!(promotion: @promotion)
    redirect_to @promotion, notice: I18n.t('messages.approve_success')
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

      def can_be_approved
        redirect_to @promotion,
        alert: I18n.t('messages.non_permitted_action') unless @promotion.can_approve?(current_user)
      end
end