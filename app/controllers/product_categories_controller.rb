class ProductCategoriesController < ApplicationController
    before_action :authenticate_user!
    before_action :set_product_category, only: %i[show edit update destroy]
    def index
        @product_categories = ProductCategory.all
    end

    def show
       
    end

    def new
        @product_category = ProductCategory.new
    end

    def create
        @product_category = ProductCategory.new(product_category_params)
        if @product_category.save
            redirect_to @product_category, notice: t('.success')
        else
            flash.now[:alert] = t('.fail')
            render :new
        end
    end

    def edit
        
    end

    def update
        if @product_category.update(product_category_params)
            redirect_to @product_category, notice: t('.success')
        else
            flash.now[:alert] = t('.fail')
            render 'edit'
        end
    end

    def destroy
        if @product_category.destroy
            redirect_to product_categories_path, notice: t('.success')
        else
            redirect_to product_categories_path, alert:  t('.fail')
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