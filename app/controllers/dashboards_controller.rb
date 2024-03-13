class DashboardsController < ApplicationController
    def show
    end

    def users_list
        @users = User.all.order("id ASC")
    end

    def products_list
        @products = Product.all.order("created_at DESC")
    end

    def order_list
        @orders = Order.all.order("created_at DESC")
        @order = Order.new
    end
    def update_order_status
        @order = Order.find(params[:order][:order_id])
        if @order.update(status: params[:order][:status])
            redirect_to order_list_path
        end
    end
end
