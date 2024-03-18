class Stripe::WebhooksController < ApplicationController
    skip_before_action :verify_authenticity_token
    def create

      # ---------------------Option One-------------------  
        # # Replace this endpoint secret with your endpoint's unique secret
        # # If you are testing with the CLI, find the secret by running 'stripe listen'
        # # If you are using an endpoint defined with the API or dashboard, look in your webhook settings
        # # at https://dashboard.stripe.com/webhooks
        # webhook_secret = 'whsec_db607f4a8802295204d0cdae2173ce0a9f8822d16b1a1c367d29ec04bda203c4'
        # payload = request.body.read
        # if !webhook_secret.empty?
        #   # Retrieve the event by verifying the signature using the raw body and secret if webhook signing is configured.
        #   sig_header = request.env['HTTP_STRIPE_SIGNATURE']
        #   event = nil
        
        #  begin
        #       event = Stripe::Webhook.construct_event(
        #       payload, sig_header, webhook_secret
        #     )
        #   rescue JSON::ParserError => e
        #     # Invalid payload
        #     status 400
        #     return
        #   rescue Stripe::SignatureVerificationError => e
        #     # Invalid signature
        #     puts '⚠️  Webhook signature verification failed.'
        #     status 400
        #     return
        #   end
        # else
        #   data = JSON.parse(payload, symbolize_names: true)
        #   event = Stripe::Event.construct_from(data)
        # end
        # # Get the type of webhook event sent - used to check the status of PaymentIntents.
        # event_type = event['type']
        # data = event['data']
        # data_object = data['object']
    
        # if event.type == 'customer.subscription.deleted'
        #   # handle subscription canceled automatically based
        #   # upon your subscription settings. Or if the user cancels it.
        #   # puts data_object
        #   puts "Subscription canceled: #{event.id}"
        # end
    
        # if event.type == 'customer.subscription.updated'
        #   # handle subscription updated
        #   # puts data_object
        #   puts "Subscription updated: #{event.id}"
        # end
        # if event.type == 'customer.subscription.created'
        #   # handle subscription created
        #   # puts data_object
        #   puts "Subscription created: #{event.id}"
        # end
    
        # if event.type == 'customer.subscription.trial_will_end'
        #   # handle subscription trial ending
        #   # puts data_object
        #   puts "Subscription trial will end: #{event.id}"
        # end
    
        # render json: {message: 'success'}



# ---------------Option Two-----------------
#         require 'stripe'
# require 'sinatra'

# # This is your test secret API key.
# Stripe.api_key = 'sk_test_51Ou7UkLIAgYL7YEp0W3PbxYVOpdgdIGW6BsRs4bQe7zcVg1RPJOOP4BTbE9Ehyt35FQqvHCTuwR3LhToXPruktRT00IgP2Ke3e'

# set :static, true
# set :port, 3000

# YOUR_DOMAIN = 'http://localhost:4242'

# post '/create-checkout-session' do
#   prices = Stripe::Price.list(
#     lookup_keys: [params['lookup_key']],
#     expand: ['data.product']
#   )

#   begin
#     session = Stripe::Checkout::Session.create({
#       mode: 'subscription',
#       line_items: [{
#         quantity: 1,
#         price: prices.data[0].id
#       }],
#       success_url: YOUR_DOMAIN + '/success.html?session_id={CHECKOUT_SESSION_ID}',
#       cancel_url: YOUR_DOMAIN + '/cancel.html',
#     })
#   rescue StandardError => e
#     halt 400,
#         { 'Content-Type' => 'application/json' },
#         { 'error': { message: e.error.message } }.to_json
#   end

#   redirect session.url, 303
# end

# post '/create-portal-session' do
#   content_type 'application/json'
#   # For demonstration purposes, we're using the Checkout session to retrieve the customer ID.
#   # Typically this is stored alongside the authenticated user in your database.
#   checkout_session_id = params['session_id']
#   checkout_session = Stripe::Checkout::Session.retrieve(checkout_session_id)

#   # This is the URL to which users will be redirected after they are done
#   # managing their billing.
#   return_url = YOUR_DOMAIN

#   session = Stripe::BillingPortal::Session.create({
#                                                     customer: checkout_session.customer,
#                                                     return_url: return_url
#                                                   })
#   redirect session.url, 303
# end

# post '/webhook' do
#   # Replace this endpoint secret with your endpoint's unique secret
#   # If you are testing with the CLI, find the secret by running 'stripe listen'
#   # If you are using an endpoint defined with the API or dashboard, look in your webhook settings
#   # at https://dashboard.stripe.com/webhooks
#   webhook_secret = 'whsec_12345'
#   payload = request.body.read
#   if !webhook_secret.empty?
#     # Retrieve the event by verifying the signature using the raw body and secret if webhook signing is configured.
#     sig_header = request.env['HTTP_STRIPE_SIGNATURE']
#     event = nil

#     begin
#       event = Stripe::Webhook.construct_event(
#         payload, sig_header, webhook_secret
#       )
#     rescue JSON::ParserError => e
#       # Invalid payload
#       status 400
#       return
#     rescue Stripe::SignatureVerificationError => e
#       # Invalid signature
#       puts '⚠️  Webhook signature verification failed.'
#       status 400
#       return
#     end
#   else
#     data = JSON.parse(payload, symbolize_names: true)
#     event = Stripe::Event.construct_from(data)
#   end
#   # Get the type of webhook event sent - used to check the status of PaymentIntents.
#   event_type = event['type']
#   data = event['data']
#   data_object = data['object']

#   if event.type == 'customer.subscription.deleted'
#     # handle subscription canceled automatically based
#     # upon your subscription settings. Or if the user cancels it.
#     # puts data_object
#     puts "Subscription canceled: #{event.id}"
#   end

#   if event.type == 'customer.subscription.updated'
#     # handle subscription updated
#     # puts data_object
#     puts "Subscription updated: #{event.id}"
#   end

#   if event.type == 'customer.subscription.created'
#     # handle subscription created
#     # puts data_object
#     puts "Subscription created: #{event.id}"
#   end

#   if event.type == 'customer.subscription.trial_will_end'
#     # handle subscription trial ending
#     # puts data_object
#     puts "Subscription trial will end: #{event.id}"
#   end

#   content_type 'application/json'
#   {
#     status: 'success'
#   }.to_json
# end


payload = request.body.read
sig_header = request.env['HTTP_STRIPE_SIGNATURE']
event = nil

begin
  event = Stripe::Webhook.construct_event(
    payload, sig_header, Rails.application.credentials[:stripe][:webhook]
  )
rescue JSON::ParserError => e
  status 400
  return
rescue Stripe::SignatureVerificationError => e
  # Invalid signature
  puts "Signature error"
  p e
  return
end

# Handle the event
case event.type
when 'checkout.session.completed'
  session = event.data.object
  session_with_expand = Stripe::Checkout::Session.retrieve({ id: session.id, expand: ["line_items"]})
  session_with_expand.line_items.data.each do |line_item|
    product = Product.find_by(stripe_product_id: line_item.price.product)
    product.increment!(:sales_count)
  end
end

render json: { message: 'success' }
end
        
    end
end