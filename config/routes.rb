Rails.application.routes.draw do
  devise_for :users, controllers: { sessions: 'users/sessions' , registrations: 'users/registrations', confirmations: 'users/confirmations', passwords: 'users/passwords', unlocks: 'users/unlocks'}
  # The priority is based upon order of creation: first created -> highest priority.
  # See how all your routes lay out with "rake routes".

  # You can have the root of your site routed with "root"
  root 'home#index'

  get 'index' => 'plainpage#index'

  #Home
  get 'file_download' => 'home#file_download'
  get 'home/index' => 'home#index'
  post 'home/chdir' => 'home#chdir'
  post 'home/mkdir' => 'home#make_directory'
  post 'home/rmdir' => 'home#rmdir'

  #Volume
  get 'volume/index' => 'volume#index'
  post 'volume/chdir' => 'volume#chdir'
  post 'file_upload/:volume_name' => 'volume#file_upload'
  post 'volume/mount' => "volume#volume_mount"
  post 'volume/create' => "volume#volume_create"
  post 'volume/unmount' => "volume#volume_unmount"
  post 'volume/start' => "volume#volume_start"
  post 'volume/stop' => "volume#volume_stop"
  post 'volume/delete' => "volume#volume_delete"

  #Node
  get 'node/index' => 'node#index'
  post 'node/add' => "node#node_add"
  get 'node/delete/:node_id' => "node#node_delete"
  get 'node/detail/:node_id' => "node#detail"
  post 'node/update' => "node#node_update"
  post 'node/probe' => "node#node_probe"
  post 'node/detach' => "node#node_detach"



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
