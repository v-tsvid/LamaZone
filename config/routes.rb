Rails.application.routes.draw do

  filter :locale, exclude: /^\/customers\/auth/

  root to: 'static_pages#home'

  devise_for :customers, controllers: { 
    omniauth_callbacks: "customers/omniauth_callbacks", 
    sessions: "customers/sessions", registrations: "customers/registrations" } 
  devise_for :admins, controllers: { sessions: "admins/sessions" }

  mount RailsAdmin::Engine => '/admin', as: 'rails_admin'

  get    'static_pages/home', path: 'home'
  post   'order_items/add_to_cart'
  post   'order_items/remove_from_cart'
  delete 'order_items/empty_cart'
  post   'order_items/update_cart'
  get    'order_items/index', path: 'cart'

  resources :addresses
  resources :authors, only: :show
  resources :books, only: [:index, :show] do
    resources :ratings, shallow: true, only: [:new, :create]
  end
  resources :categories, only: :show
  resources :checkouts, only: [:new, :create, :show, :update]
  resources :customers, except: [:index, :destroy]
  resources :order_items, only: :index
  resources :orders, only: [:index, :show]


  # match "*path", to: "application#routing_error", via: :all
end
