class Api::V1::SessionsController < Api::V1::BaseController
  def create
    @user = User.find_for_authentication(email: params[:email])
    if @user && @user.valid_password?(params[:password])
      response = {
        status: true,
        user: filter_user_attributes
      }
      render json: response
    else
      response = { status: false, errors: "Unable to find user" }
      render json: response
    end
  end

  private
  def user_visible_attributes
    [:id, :email, :first_name, :last_name, :authentication_token]
  end

  def filter_user_attributes
    @user.as_json.select { |k,_| user_visible_attributes.include? k.to_sym }
  end
end
