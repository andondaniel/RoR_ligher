require 'resque/server'

Spylight::Application.routes.draw do

  mount Resque::Server.new, at: "/resque"

  get "errors/show"
  ActiveAdmin.routes(self)

  apipie

  resources :users

  resources :brands

  resources :product_categories

  resources :colors

  resources :stores

  resources :sources

  resources :product_images

  resources :character_images

  resources :characters

  resources :scene_appearances

  resources :scenes

  resources :outfits

  resources :categories

  resources :episode_links

  resources :movies

  resources :shows

  resources :results

  #nested routes for products
  concern :has_products do
    resources :products
  end

  resources :shows, concerns: :has_products do
    # look for way to override what we call the param for show_id, it should be show_slug
    resources :characters, concerns: :has_products
    resources :episodes, concerns: :has_products do
      resources :scenes, concerns: :has_products
    end
  end

  resources :products
  # login / logout
  match '/auth/:service/callback' => 'sessions#create', via: [:get, :post]
  match '/auth/failure' => 'services#failure', via: [:get, :post]

  get "/logout" => "sessions#destroy", as: :destroy_session
  get "/login" => "sessions#new", as: :new_session
  resources :sessions

  resource :feedback, only: [:new, :create]

  get 'home/network_menu' => 'home#network_menu'
  get 'home/character_menu' => 'home#character_menu'
  get 'home/mailchimp' => 'home#mailchimp'
  get 'home/requestaccess' => 'home#requestaccess'
  get 'episodes/seasons' => 'episodes#seasons'

  resources :home
  resources :episodes

  root 'home#index'

  match '/episodes' => 'episodes#index', via: [:get, :post]

  match '/search' => 'search#index', via: [:get, :post]

  match '/about' => 'home#about', via: [:get, :post]

  match '/contact' => 'home#contact', via: [:get, :post]


  #api resources
  #to use an api subdomain substitute this line in
  # namespace :api, :path => "", :constraints => {:subdomain => "api"}, defaults: {format: 'json'} do
  #should probably clean this up
  namespace :api, defaults: {format: 'json'} do
    namespace :v1 do
      resources :shows, only: [:index, :show, :create, :update, :destroy], concerns: :has_products do
        resources :outfits, only: [:index, :show]
        resources :characters, only: [:index, :show, :create, :update, :destroy], concerns: :has_products do
          resources :outfits, only: [:index, :show]
        end
        resources :episodes, only: [:index, :show, :create, :update, :destroy], concerns: :has_products do
          resources :scenes, only: [:index, :show, :create, :update, :destroy], concerns: :has_products do
            resources :outfits, only: [:index, :show]
          end
          resources :outfits, only: [:index, :show]
        end
      end
      resources :movies, only: [:index, :show], concerns: :has_products do
        resources :scenes, only: [:index, :show], concerns: :has_products do
          resources :outfits, only: [:index, :show]
        end
        resources :outfits, only: [:index, :show]
        resources :characters, only: [:index, :show, :create, :update, :destroy], concerns: :has_products do
          resources :outfits, only: [:index, :show]
        end
      end

      resources :products, only: [:index, :show, :create, :update, :destroy]
      resources :outfits, only: [:index, :show]

      #May not be necessary to have these outside of the show scoping, but im currently adding them to allow for quick cache updates on all models
      resources :episodes, only: [:index, :show, :create, :update, :destroy]
      resources :characters, only: [:index, :show, :create, :update, :destroy]

    
      resources :users, only: [:index, :show, :create, :update, :destroy] do
        collection do
          post 'authenticate'
          post 'authenticate_or_create_with_omniauth'
        end
      end
      resources :search, only: [:index]
      resources :feedback, only: [:create]
      resources :stars, only: [:create, :destroy]
      resources :product_categories, only: [:index, :show]
    end
  end

  # Define routes for error codes
  %w( 404 422 500 ).each do |code|
    get code, :to => "errors#show", :code => code
  end


end
