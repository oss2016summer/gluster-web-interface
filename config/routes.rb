Rails.application.routes.draw do
  devise_for :users, controllers: {
    sessions: 'users/sessions',
    registrations: 'users/registrations',
    confirmations: 'users/confirmations',
    passwords: 'users/passwords',
    unlocks: 'users/unlocks'
  }
  # The priority is based upon order of creation: first created -> highest priority.
  # See how all your routes lay out with "rake routes".

  root 'web/home#index'

  get 'file_download' => 'home#file_download'
  post 'file_upload/:volume_name' => 'volume#file_upload'

  scope module: 'web' do
    get 'home/index' => 'home#index'
    post 'home/chdir' => 'home#chdir'
    post 'home/mkdir' => 'home#make_directory'
    post 'home/rmdir' => 'home#rmdir'

    get 'volume/index' => 'volume#index'
    post 'volume/chdir' => 'volume#chdir'
    post 'volume/mount' => "volume#volume_mount"
    post 'volume/create' => "volume#volume_create"
    post 'volume/unmount' => "volume#volume_unmount"
    post 'volume/start' => "volume#volume_start"
    post 'volume/stop' => "volume#volume_stop"
    post 'volume/delete' => "volume#volume_delete"

    get 'node/index' => 'node#index'
    post 'node/add' => "node#node_add"
    get 'node/delete/:node_id' => "node#node_delete"
    get 'node/detail/:node_id' => "node#detail"
    post 'node/update' => "node#node_update"
    post 'node/probe' => "node#node_probe"
    post 'node/detach' => "node#node_detach"
  end
end
