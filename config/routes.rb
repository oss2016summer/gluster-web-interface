Rails.application.routes.draw do
  get 'peer/index'

  get 'volume/index'

  get 'home/index'

  devise_for :users, controllers: { sessions: 'users/sessions' , registrations: 'users/registrations', confirmations: 'users/confirmations', passwords: 'users/passwords', unlocks: 'users/unlocks'}
  # The priority is based upon order of creation: first created -> highest priority.
  # See how all your routes lay out with "rake routes".

  # You can have the root of your site routed with "root"
  root 'plainpage#index'

  get 'index' => 'plainpage#index'
   
  #Volume
  get 'volume/index' => 'volume#index'
  
  post 'file_upload' => 'volume#file_upload'
  
  post 'volume/changeDir' => 'volume#checkDir'
  
  get 'volume/mount/:volume_name' => "volume#volume_mount"
  get 'volume/start/:volume_name' => "volume#volume_start"
  get 'volume/stop/:volume_name' => "volume#volume_stop"
  
  
  get 'peer/index' => 'peer#index'
  
   
   
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
