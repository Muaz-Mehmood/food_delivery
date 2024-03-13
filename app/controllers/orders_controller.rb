class OrdersController < ApplicationController
    def show
        @orders = current_user.orders.all.order("created_at   DESC")
    end
end
