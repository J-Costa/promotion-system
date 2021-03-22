class PromotionsController < ApplicationController
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
            redirect_to @promotion
        else
            render :new
        end
    end

    def edit

    end

    def update
        if @promotion.update(promotion_params)
            flash[:notice] = "Atualizado com sucesso!"
            redirect_to @promotion
        else
            flash[:alert] = "Não foi possível atualizar!"
            render 'edit'
        end  
    end

    def destroy
        if @promotion.destroy
            flash[:notice] = "Deletado com sucesso"
            redirect_to promotions_path
        else
            flash[:alert] = "Não foi possível deletar"
            redirect_to promotions_path
        end
    end

    def generate_coupons
        @promotion.generate_coupons!
        flash[:notice] = 'Cupons gerados com sucesso'
        redirect_to @promotion
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