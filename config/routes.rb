Rails.application.routes.draw do

  devise_for :users, skip: 'registration', :controllers => {
    :sessions => 'users/sessions',
    :confirmations => 'users/confirmations'
  }
  devise_scope :user do
    get 'users/cancel'=>'users/registrations#cancel', as: 'cancel_user_registration'
    get 'users/edit'=>'users/registrations#edit', as: 'edit_user_registration'
    post 'users'=>'users/registrations#create', as: 'user_registration'
    put 'users'=>'users/registrations#update'
    patch 'users'=>'users/registrations#update'
    delete 'users'=>'users/registrations#destroy'
  end

  resources :users, except: [:new, :show, :create, :edit]

  get 'events/new_for_member' => 'events#new_for_member', as: 'new_event_for_member'
  resources :events
  
  #get 'charges/day_pass' => 'charges#day_pass', as: 'day_pass'
  resources :charges, except: [:edit, :update, :destroy, :index]

  get 'enter' => 'enter_logs#new', as: 'enter'
  post 'enter' => 'enter_logs#create', as: 'enter_logs'

  devise_scope :user do
    patch "/confirm"=>"users/confirmations#confirm"
  end

  root :to => "enter_logs#new"

  
  # The priority is based upon order of creation: first created -> highest priority.
  # See how all your routes lay out with "rake routes".

  # You can have the root of your site routed with "root"
  # root 'welcome#index'

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
