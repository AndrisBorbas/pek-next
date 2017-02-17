Rails.application.routes.draw do

  #root 'users#index'
  get '/auth/oauth/callback', to: 'sessions#create'
  get '/register', to: 'registration#new'
  post '/register/create', to: 'registration#create', as: :registration
  resources :users
  get '/search', to: 'search#search'
  get '/search/suggest', to: 'search#suggest'
  get '/profile/', to: 'profiles#show_self'
  get '/profile/:id', to: 'profiles#show', as: 'other_profile'
  get '/settings', to: 'profiles#settings'
  post '/settings', to: 'profiles#settings'
  post '/settings/upload', to: 'profiles#upload'
  post '/settings/save', to: 'profiles#save_settings'
  get '/profile/picture/:username', to: 'profiles#picture'
  get '/profile/picture/leszezmegrestapi/raw', to: 'profiles#raw_picture'

  # The priority is based upon order of creation: first created -> highest priority.
  # See how all your routes lay out with "rake routes".

  # You can have the root of your site routed with "root"
  root :to => redirect('/profile')

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
