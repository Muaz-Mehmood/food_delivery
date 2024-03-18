class CartsController < ApplicationController

  def show
    if user_signed_in?
      @cart_items = current_user.cart_items
    end
  end

  def add_to_cart
    @product = Product.find_by_id(params[:product_id].to_i)
    if current_user
        quantity = params[:cart_item][:quantity].to_i
        if @product && quantity > 0
          existing_cart_item = current_user.cart_items.where(product_id: @product.id)
          if existing_cart_item.count > 0
            existing_cart_item.first.update(quantity: existing_cart_item.first.quantity + quantity)
          else
            current_user.cart_items.create(product: @product, quantity: quantity)
          end
        else
          redirect_to root_path, alert: 'Product not found.'
        end
    else
        flash[:alert] = 'You need to sign in to add products to your cart.'
        redirect_to user_session_path
    end
  end

  # def checkout
  #   if current_user.cart_items.any?
  #     @order = current_user.orders.create
  #     @cart_items = current_user.cart_items

  #     @cart_items.each do |cart_item|
  #       order_item = @order.order_items.create(product: cart_item.product, quantity: cart_item.quantity)
  #     end
  #   else
  #     redirect_to root_path
  #   end

  #   if @order.save
  #     @cart_items.destroy_all
  #     redirect_to root_path
  #   end
  # end

  def remove_from_cart
    cart_item = current_user.cart_items.find_by_id(params[:id])
    cart_item.destroy if cart_item
    redirect_to cart_path
  end

end
