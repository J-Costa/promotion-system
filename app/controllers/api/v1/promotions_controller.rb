class Api::V1::PromotionsController < Api::V1::ApiController
  def index
    @promotions = Promotion.all
    render json: @promotions
  end

  def show
    @promotion = Promotion.find_by(code: params[:code])
    render json: @promotion
  end
end
