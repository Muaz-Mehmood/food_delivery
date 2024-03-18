class AddStripeCustomerIdToUsers < ActiveRecord::Migration[6.1]
  def change
    add_column :users, :stripeCustomerId, :string
  end
end
