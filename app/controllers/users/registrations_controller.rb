# frozen_string_literal: true

class Users::RegistrationsController < Devise::RegistrationsController
  # before_action :configure_sign_up_params, only: [:create]
  # before_action :configure_account_update_params, only: [:update]

  # GET /resource
  def index
    @user_opportunities = UserOpportunity.where(status: [:pending, :applied])
    @user_opportunities_id = @user_opportunities.map do |user_opportunity|
      user_opportunity.opportunity
    end
    # @opportunities = Opportunity.where(id: @user_opportunities_id).where.not(latitude: nil, longitude: nil)
    @opportunities = Opportunity.where(id: @user_opportunities_id.uniq)
    @markers = @opportunities.map do |opportunity|
      {
        lat: opportunity.latitude,
        lng: opportunity.longitude,
        # infoWindow: { content: render_to_string(partial: "/opportunities/map_box", locals: { flat: flat }) }
      }
    end
  end

  # GET /resource/sign_up
  # def new
  #   super
  # end

  # POST /resource
  # def create
  #   super
  # end

  # GET /resource/edit
  # def edit
  #   super
  # end

  # PUT /resource
  # def update
  #   super
  # end

  # DELETE /resource
  # def destroy
  #   super
  # end

  # GET /resource/cancel
  # Forces the session data which is usually expired after sign
  # in to be expired now. This is useful if the user wants to
  # cancel oauth signing in/up in the middle of the process,
  # removing all OAuth session data.
  # def cancel
  #   super
  # end

  protected

  # If you have extra params to permit, append them to the sanitizer.
  # def configure_sign_up_params
  #   devise_parameter_sanitizer.permit(:sign_up, keys: [:first_name, :last_name])
  # end

  # If you have extra params to permit, append them to the sanitizer.
  # def configure_account_update_params
  #   devise_parameter_sanitizer.permit(:sign_up, keys: [:first_name, :last_name])
  # end

  # The path used after sign up.
  # def after_sign_up_path_for(resource)
  #   super(resource)
  # end

  # The path used after sign up for inactive accounts.
  # def after_inactive_sign_up_path_for(resource)
  #   super(resource)
  # end
end
