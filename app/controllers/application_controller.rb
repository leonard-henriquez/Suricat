# frozen_string_literal: true

class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception
  before_action :configure_permitted_parameters, if: :devise_controller?
  before_action :authenticate_user!
  before_action :set_constants
  include Pundit

  # Pundit: white-list approach.
  after_action :verify_authorized, except: :index, unless: :skip_pundit?
  after_action :verify_policy_scoped, only: :index, unless: :skip_pundit?

  rescue_from Pundit::NotAuthorizedError, with: :user_not_authorized
  def user_not_authorized
    flash[:alert] = "You are not authorized to perform this action."
    redirect_to(root_path)
  end

  # Move partial views to folder '/frontend'
  # self.view_paths = self.view_paths.reject do |path_object|
  #   path_object.to_path =~ /app.views/
  # end
  # prepend_view_path Rails.root.join("frontend","views")

  def default_url_options
    { host: ENV["www.suricat.co"] || "localhost:3000" }
  end


  protected

  def after_sign_in_path_for(_resource)
    opportunities_review_path
  end

  def after_update_path_for(_resource)
    opportunities_review_path
  end

  def configure_permitted_parameters
    devise_parameter_sanitizer.permit(:sign_up, keys: %i[first_name last_name])
  end

  def skip_pundit?
    devise_controller? || params[:controller] =~ /(^(rails_)?admin)|(^pages$)/
  end

  def set_constants
    @sidebar = sidebar?
    @user_opportunities = policy_scope(UserOpportunity)
  end

  def sidebar?
    false
  end
end
