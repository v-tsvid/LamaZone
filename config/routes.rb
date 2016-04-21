Rails.application.routes.draw do

  devise_for :customers, controllers: { omniauth_callbacks: "customers/omniauth_callbacks", 
    sessions: "customers/sessions", registrations: "customers/registrations" } 
  devise_for :admins, controllers: { sessions: "admins/sessions" }

  root to: 'static_pages#home'

  scope "/:locale" do
    
    resources :checkouts
    
    get    'static_pages/home', path: 'home'
    
    
    resources :customers, except: [:index, :destroy] do
      resources :ratings, only: :index
    end

    resources :addresses, only: [:create, :update]

    mount RailsAdmin::Engine => '/admin', as: 'rails_admin'
    
    resources :credit_cards
    resources :countries

    post   'order_items/add_to_cart'
    post   'order_items/remove_from_cart'
    delete 'order_items/empty_cart'
    post   'order_items/update_cart'
    get    'order_items/index', path: 'cart'
    
    resources :order_items
    resources :orders
    resources :authors
    resources :categories, only: :show
    
    resources :books, only: [:index, :show] do
      resources :ratings, shallow: true
    end
  end
end
