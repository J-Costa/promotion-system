class Api::V1::PromotionsController < Api::V1::ApiController
  def index
    @promotions = Promotion.all
    render json: @promotions
  end

  def show
    @promotion = Promotion.find_by(code: params[:code])
    render json: @promotion
  end

  def create
    @promotion = Promotion.new(promotion_params)
    if @promotion.save
      render json: @promotion
    else
      render json: @promotion.errors
    end
  end

  private

    def promotion_params
      params.require(:promotion)
            .permit(:name, :expiration_date, :description, :discount_rate,
                    :code, :coupon_quantity, :user_id)
    end
end
