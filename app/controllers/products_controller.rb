class ProductsController < ApplicationController
    before_action :authenticate_user!, except: [:index, :show]
    before_action :find_product, only: [:show, :edit, :update, :destroy]
    before_action :restrict_customer, except: [:index, :show]

    def index
        if (!session[:stripe_session_id].nil?)
            key = session[:stripe_session_id]
            payment = Stripe::Checkout::Session.retrieve(key)
            if payment[:payment_status] == "paid"
                current_user.cart_items.destroy_all
                flash[:alert] = "Thanks for your order, Your Order has been placed successfully"
            else
                flash[:alert] = "Paymenmt cancelled by user"
            end
            session.delete(:stripe_session_id)
        end
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
        @cart_item = CartItem.new
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
    
    def authenticate_user!
        unless current_user && user_signed_in?
          redirect_to new_user_session_path, alert: 'You need to sign in or sign up before continuing.'
        end
      end
end
