Rails.application.routes.draw do
  resources :shopping_cart_items
  resources :shopping_carts
  root 'books#index'
  # devise_scope :customer do
  #   delete 'sign_out', :to => 'devise/sessions#destroy', :as => :destroy_customer_session
  # end
  # devise_for :customers, :controllers => {  }
  devise_for :customers, controllers: { omniauth_callbacks: "customers/omniauth_callbacks", 
    sessions: "customers/sessions" }
  devise_for :admins, controllers: { sessions: "admins/sessions" }
  mount RailsAdmin::Engine => '/admin', as: 'rails_admin'
  # resources :admins
  resources :credit_cards
  resources :countries
  resources :addresses
  resources :order_items
  resources :orders
  # resources :customers
  # resources :ratings
  resources :authors
  resources :categories
  resources :books, only: [:index, :show] do
    resources :ratings, except: [:edit, :update], shallow: true
  end
  # The priority is based upon order of creation: first created -> highest priority.
  # See how all your routes lay out with "rake routes".

  # You can have the root of your site routed with "root"
  # root 'books#index'

  # Example of regular route:
  #   get 'products/:id' => 'catalog#view'

  # Example of named route that can be invoked with purchase_url(id: product.id)
  #   get 'products/:id/purchase' => 'catalog#purchase', as: :purchase

  # Example resource route (maps HTTP verbs to controller actions automatically):
  #   resources :products

  # Example resource route with options:
  #   resources :products do
  #     member do
  #       get 'short'
  #       post 'toggle'
  #     end
  #
  #     collection do
  #       get 'sold'
  #     end
  #   end

  # Example resource route with sub-resources:
  #   resources :products do
  #     resources :comments, :sales
  #     resource :seller
  #   end

  # Example resource route with more complex sub-resources:
  #   resources :products do
  #     resources :comments
  #     resources :sales do
  #       get 'recent', on: :collection
  #     end
  #   end

  # Example resource route with concerns:
  #   concern :toggleable do
  #     post 'toggle'
  #   end
  #   resources :posts, concerns: :toggleable
  #   resources :photos, concerns: :toggleable

  # Example resource route within a namespace:
  #   namespace :admin do
  #     # Directs /admin/products/* to Admin::ProductsController
  #     # (app/controllers/admin/products_controller.rb)
  #     resources :products
  #   end
end
