Rails.application.routes.draw do
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html

  ## AUTHENTICATION
  devise_for :users,  path: 'profile', controllers: { registrations: "registrations" }

  ## HOMEPAGE
  authenticated do
    root to: 'user_opportunities#index', :defaults => { :status => :review }
  end
  root to: 'pages#home'

  ## STATIC PAGES
  get '/styleguide', to: 'pages#styleguide'
  get '/extension', to: 'pages#extension'

  ## USER PROFILE
  get '/profile', to: 'profiles#index'

  ## OPPORTUNITIES
  # Build the following routes
  # GET ['review', 'pending', 'applied', 'trash']
  statuses = UserOpportunity.statuses.keys.map(&:to_sym)
  # status = [:review, :pending, :applied, :trash]
  statuses.each do |status|
    # then we create the routes
    # passing a parameter :status to the function in user_opportunity_controller :
    match "/opportunities/#{status.to_s}" =>
      'user_opportunities#index',
      :defaults => { :status => status }, via: :get
  end

  resources :user_opportunities,
    path: 'opportunities',
    only: [:index, :show, :update, :destroy]

  ## EVENTS
  resources :events,
    only: [:index, :create, :update, :destroy]

  ## CRITERIA & IMPORTANCES
  resources :importances,
    only: [:index, :edit, :update] do
      resources :criteria,
        except: [:index, :show]
    end
  put '/importances/', to: 'importances#update_importances', as: :update_importances

  ## API
  namespace :api, defaults: { format: :json } do
    namespace :v1 do
      resources :sessions, only: [ :create ]
      resources :opportunities, only: [:create]
    end
  end
end
