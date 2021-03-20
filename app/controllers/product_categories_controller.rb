class ProductCategoriesController < ApplicationController
    def index
        @product_categories = ProductCategory.all
    end

    def show
        @product_category = ProductCategory.find(params[:id])
    end

    def new
        @product_category = ProductCategory.new
    end

    def create
        @product_category = ProductCategory.new(product_category_params)
        if @product_category.save
            redirect_to @product_category
        else
            render :new
        end
    end

    def edit
        set_product_category
    end

    def update
        set_product_category
        if @product_category.update(product_category_params)
            flash[:notice] = "Atualizado com sucesso"
            redirect_to @product_category
        else
            flash[:alert] = 'Não foi possível atualizar'
            render 'edit'
        end
    end

    def destroy
        @product_category = set_product_category
        if @product_category.destroy
            flash[:notice] = "Deletado com sucesso"
            redirect_to product_categories_path
        else
            flash[:alert] = "Não foi possível deletar"
            redirect_to product_categories_path
        end
    end
    
    private 
        def set_product_category
            @product_category = ProductCategory.find(params[:id])
        end

        def product_category_params
            params.require(:product_category).permit(:name, :code)
        end
end