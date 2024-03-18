Rails.application.routes.draw do
  devise_for :users, controllers: {
    sessions: 'users/sessions',
    registrations: 'users/registrations'
  }

  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
  resources :products
  resource :order, only: [:show]
  resource :cart, only: [:show]
  resource :dashboard, only: [:show]

  post 'add_to_cart/:product_id', to: 'carts#add_to_cart', as: :add_to_cart
  delete 'remove_from_cart/:id', to: 'carts#remove_from_cart', as: :remove_from_cart
  post 'checkout', to: 'checkout#create', as: :checkout

  get 'users_list', to: 'dashboards#users_list', as: :users_list
  get 'products_list', to: 'dashboards#products_list', as: :products_list 
  get 'order_list', to: 'dashboards#order_list', as: :order_list 

  post 'update_order_status', to: 'dashboards#update_order_status', as: :update_order_status


  root to: 'products#index'
end
