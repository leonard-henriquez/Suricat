# frozen_string_literal: true

class Api::V1::SessionsController < Api::V1::BaseController
  def create
    @user = User.find_for_authentication(email: params[:email])
    response = if @user&.valid_password?(params[:password])
                 {
                   status: true,
                   user: filter_user_attributes
                 }
               else
                 {
                   status: false,
                   errors: 'Unable to find user'
                 }
               end
    render json: response
  end

  private

  def user_visible_attributes
    [:id, :email, :first_name, :last_name, :authentication_token]
  end

  def filter_user_attributes
    @user.as_json.select { |k, _| user_visible_attributes.include? k.to_sym }
  end
end
