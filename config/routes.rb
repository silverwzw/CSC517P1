Project1::Application.routes.draw do



  match 'categories/api_list' => 'categories#api_list'
  match 'users/login' => 'users#login'
  match 'users/:id/toggle' => 'users#toggle'
  match 'posts/api_list' => 'posts#api_list'
  match 'posts/api_list_voter' => 'posts#api_list_voter'
  match 'posts/api_reply' => 'posts#api_reply'
  match 'posts/api_show' => 'posts#api_show'
  match 'users/api_is_login' => 'users#api_is_login'
  match 'users/api_is_admin' => 'users#api_is_admin'
  match 'users/api_list' => 'users#api_list'
  match 'votes/api_delete' => 'votes#api_delete'
  match 'posts/api_delete' => 'posts#api_delete'
  match 'db_init' => 'application#db_reset'
  match 'db_check' => 'application#db_check'
  match 'votes/api_add' => 'votes#api_add'

  resources :users
  resources :categories
  resources :posts


  #resources :votes




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
