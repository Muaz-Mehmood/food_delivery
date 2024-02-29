class ProductsController < ApplicationController

    before_action :find_product, only: [:show, :edit, :update]
    before_action :restrict_customer, except: [:index, :show]

    def index
        @product = Product.all.order("created_at DESC")
    end
    def new
        @product = Product.new
    end
    def create
        @product = Product.new(product_params)
        if @product.save
            redirect_to @product
        else
            render 'new'
        end
    end
    def show
    end
    def edit
    end
    def update
        if @product.update(product_params)
            redirect_to @product
        else
            render 'edit'
        end
    end
    def destroy
        @product = Product.find_by_id(params[:id])
        
        @product.destroy if @product
        redirect_to root_path
    end

    private

    def find_product
        @product = Product.find_by_id(params[:id])
    end

    def product_params
        params.require(:product).permit(:name, :description, :price, :image)
    end

    def restrict_customer
        unless current_user && current_user.admin?
            redirect_to root_path
        end
    end
end
