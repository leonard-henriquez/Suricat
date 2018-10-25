class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception
  before_action :authenticate_user!

  # Move partial views to folder '/frontend'
  prepend_view_path Rails.root.join("frontend", "views")
end
