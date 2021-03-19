class PromotionsController < ApplicationController
    def index
        @promotions = Promotion.all
    end
    
    def show
        @promotion = Promotion.find(params[:id])
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
        set_promotion
    end

    def update
        set_promotion
        if @promotion.update(promotion_params)
            flash[:notice] = "Atualizado com sucesso!"
            redirect_to @promotion
        else
            flash[:alert] = "Não foi possível atualizar!"
            render 'edit'
        end  
    end

    def destroy
        @promotion = set_promotion
        if @promotion.destroy
            flash[:notice] = "Deletado com sucesso"
            redirect_to promotions_path
        else
            flash[:alert] = "Não foi possível deletar"
            redirect_to promotions_path
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