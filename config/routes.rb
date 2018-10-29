Rails.application.routes.draw do
  devise_for :users
  root to: 'pages#home'
  get '/styleguide', to: 'pages#styleguide'
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html

  # namespace 'api'
    # namespace 'v1'
      # POST 'opportunities/'
      # POST 'users/sign_in'

  resources :user_opportunities, path: 'opportunities', only: [:index, :show] do
    # GET 'review'
    # GET 'pending'
    # GET 'applied'
    # GET 'trash'
    # POST ':id/review'
    # POST ':id/pending'
    # POST ':id/applied'
    # POST ':id/trash'
  end

  resources :events, only: [:index, :create, :update, :destroy]

  resources :importances, only: [:index, :update] do
    resources :criteria, except: [:index, :show]
  end
end
