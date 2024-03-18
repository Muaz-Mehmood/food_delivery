class OrdersController < ApplicationController
    def show
        if user_signed_in?
            @orders = current_user.orders.all.order("created_at   DESC")
        end
    end
end
