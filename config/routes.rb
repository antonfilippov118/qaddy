Qaddy::Application.routes.draw do
  
  ActiveAdmin.routes(self)

  resources :users
  resources :sessions, only: [:new, :create, :destroy]
  resources :password_resets

  # static_pages
  # match '/newhome', to: 'static_pages#index'
  match '/about', to: 'static_pages#about'
  match '/contact', to: 'static_pages#contact'
  match '/help', to: 'static_pages#help'
  match '/news', to: 'static_pages#news'

  # users / sessions
  match '/signup', to: 'users#new'
  match '/signin', to: 'sessions#new'
  match '/signout', to: 'sessions#destroy', via: :delete
  match '/users/:id/change_password', to: 'users#change_password', via: :post, as: :change_password

  # share
  match '/share/emailview/:ref_code', to: 'share#emailview', via: :get, as: :share_emailview
  match '/share/doshare/:ref_code', to: 'share#doshare', via: :get, as: :share_doshare
  match '/share/clicked/:ref_code', to: 'share#clicked', via: :get, as: :share_clicked

  # root for staging
  root :to => "static_pages#index"

  # API routes
  namespace :api do
    namespace :v1 do
      resources :webstores do
        resources :orders
      end
    end
  end


  # root for production
  # root :to => "launchrock#index"
  # match '/launch', to: 'launchrock#launch', via: :get


  #########################
  # The priority is based upon order of creation:
  # first created -> highest priority.

  # Sample of regular route:
  #   match 'products/:id' => 'catalog#view'
  # Keep in mind you can assign values other than :controller and :action

  # Sample of named route:
  #   match 'products/:id/purchase' => 'catalog#purchase', :as => :purchase
  # This route can be invoked with purchase_url(:id => product.id)

  # Sample resource route (maps HTTP verbs to controller actions automatically):
  #   resources :products

  # Sample resource route with options:
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

  # Sample resource route with sub-resources:
  #   resources :products do
  #     resources :comments, :sales
  #     resource :seller
  #   end

  # Sample resource route with more complex sub-resources
  #   resources :products do
  #     resources :comments
  #     resources :sales do
  #       get 'recent', :on => :collection
  #     end
  #   end

  # Sample resource route within a namespace:
  #   namespace :admin do
  #     # Directs /admin/products/* to Admin::ProductsController
  #     # (app/controllers/admin/products_controller.rb)
  #     resources :products
  #   end

  # You can have the root of your site routed with "root"
  # just remember to delete public/index.html.
  # root :to => 'welcome#index'

  # See how all your routes lay out with "rake routes"

  # This is a legacy wild controller route that's not recommended for RESTful applications.
  # Note: This route will make all actions in every controller accessible via GET requests.
  # match ':controller(/:action(/:id))(.:format)'

end
