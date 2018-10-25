Rails.application.routes.draw do
  devise_for :users
  root to: 'pages#home'
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html

  # namespace 'api'
    # namespace 'v1'
      # POST 'opportunities/'
      # POST 'users/sign_in'

  # resources 'opportunities', only: :show do
    # GET 'review'
    # GET 'pending'
    # GET 'applied'
    # GET 'trash'
    # POST ':id/review'
    # POST ':id/pending'
    # POST ':id/applied'
    # POST ':id/trash'
  # end

  # resources 'events'

  # resources 'criteria', except: ;destroy do
    # GET 'importance'
    # POST 'importance'
  # end


  namespace :api, defaults: { format: :json } do
    namespace :v1 do
      resources :sessions, only: [ :create ]
      resources :opportunities, only: [:create]
    end
  end
end
