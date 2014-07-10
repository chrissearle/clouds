Rails.application.routes.draw do
  resources :users
  resources :welcome

  resources :points do
    member do
      get 'streetview'
    end
  end

  get '/current/:lat/:lng' => 'points#current', :as => 'current', :lat => /\d+(\.\d+)?/, :lng => /\d+(\.\d+)?/
  get '/coords/:lat/:lng' => 'points#coord', :as => 'coords', :lat => /\d+(\.\d+)?/, :lng => /\d+(\.\d+)?/

  get '/cache/all' => 'admin#cache_content'

  get '/auth/:provider/callback' => 'sessions#create'
  get '/logout' => 'sessions#destroy', :as => 'logout'
  get '/login' => 'sessions#index', :as => 'login'

  get '/cron' => proc { |env| [200, {'Content-Type' => 'text/plain'}, ['OK']] }

  root :to => 'points#index'
end
