Cogster::Application.routes.draw do

  match '/payments/payment', :to => 'payments#payment', :as => 'paymentspayment', :via => [:get]

  match '/payments/relay_response', :to => 'payments#relay_response', :as => 'payments_relay_response', :via => [:post]

  match '/payments/receipt', :to => 'payments#receipt', :as => 'payments_receipt', :via => [:get]

  devise_for :users

  as :user do
    get "/register" => "registrations#new", :as => 'register'
    post "/register" => "registrations#create", :as => 'register'
    get "/login" => "devise/sessions#new", :as => 'login'
    get "/lost_password" => "devise/passwords#new", :as => 'lost_password'
    post "/lost_password" => "devise/passwords#create", :as => 'lost_password'
    post "/logout" => "sessions#destroy", :as => 'logout'
  end

  resource :account, :only => [ :show, :edit, :update ] do
    member do
      get :edit_password
    end
  end

  match "certificates/:id" => "accounts#cash", :as => "cash", :via => :get

  match "community/:id" => "communities#show", :as => "community", :via => :get

  resources :community_requests, :only => [ :new, :create, :destroy ]

  resources :businesses, :only => [ :show, :index, :edit, :update ] do
    member do
      get :edit_logo
    end
    resources :coupons
    resources :projects
    resource :purchase, :only => [ :new, :create ], 
                        :path_names => { :new => '' },
                        :constraints => { :protocol => 'https' }
  end

  namespace "admin" do
    resources :businesses
    resources :project_options
    resources :users
    resources :communities
    resources :business_options
  end

  controller :information do
    %w(merchant_agreement member_purchase_agreement terms faq privacy swag contact how_it_works).each do |page|
      get page, :as => page
    end
  end

  %w(facebook twitter).each do |site|
    match "/share/#{site}/:id" => "share##{site}", :as => site, :via => :get
  end

  root :to => "home#index"
  match '/account' => "accounts#show", :as => 'user_root'
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
  # root :to => "welcome#index"

  # See how all your routes lay out with "rake routes"

  # This is a legacy wild controller route that's not recommended for RESTful applications.
  # Note: This route will make all actions in every controller accessible via GET requests.
  # match ':controller(/:action(/:id(.:format)))'
end
