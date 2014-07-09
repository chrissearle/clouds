Rails.application.routes.draw do
  resources :users
  resources :welcome

  resources :private_points do
    collection do
      get 'map'
    end

    member do
      get 'clear_cache'
    end
  end

  resources :points

  get '/current/:lat/:lng' => 'points#current', :as => 'current', :lat => /\d+(\.\d+)?/, :lng => /\d+(\.\d+)?/

  get '/cache/all' => 'admin#cache_content'

  get '/auth/:provider/callback' => 'sessions#create'
  get '/logout' => 'sessions#destroy', :as => 'logout'
  get '/login' => 'sessions#index', :as => 'login'

  get '/cron' => proc { |env| [200, {'Content-Type' => 'text/plain'}, ['OK']] }

  root :to => 'points#index'
end
