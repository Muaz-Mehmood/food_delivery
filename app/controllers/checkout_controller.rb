class CheckoutController < ApplicationController
  
  def create
    if current_user.cart_items.any?
      @order = current_user.orders.create
      @cart_items = current_user.cart_items

      @cart_items.each do |cart_item|
        order_item = @order.order_items.create(product: cart_item.product, quantity: cart_item.quantity)
      end
    end

    line_items = []
    products = current_user.cart_items
    products.each do |cart_item|
      product = Product.find(cart_item.product_id)
      price_in_cents = (product.price * 100).to_i
      line_items << {
        price_data: {
        currency: 'usd',
        unit_amount: price_in_cents,
        product_data: {
            name: product.name
        }
        },
        quantity: cart_item.quantity
      }
    end
    @session = Stripe::Checkout::Session.create({
        payment_method_types: ['card'],
        line_items: line_items,
        mode: 'payment',
        success_url: root_url,
        cancel_url: root_url,
        customer_email: current_user.email,
      })
    session[:stripe_session_id] = @session&.id
    respond_to do |format|
        format.html
    end
  end

  private

  def stripe_success_url
    root_url
    redirect_to
  end
  def stripe_cancel_url
    root_url
  end

end
