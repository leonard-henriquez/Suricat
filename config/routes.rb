Rails.application.routes.draw do
  devise_for :users,  path: 'profile', controllers: { registrations: "registrations" }
  get '/profile', to: 'profiles#index'

  root to: 'pages#home'
  get '/styleguide', to: 'pages#styleguide'
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html

  # namespace 'api'
    # namespace 'v1'
      # POST 'opportunities/'
      # POST 'users/sign_in'

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


  resources :events,
    only: [:index, :create, :update, :destroy]

  resources :importances,
    only: [:index, :edit, :update] do
      resources :criteria,
        except: [:index, :show]
  end
end
