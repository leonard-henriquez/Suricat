class Api::V1::OpportunitiesController < Api::V1::BaseController
  acts_as_token_authentication_handler_for User

  def create
    @user = current_user
    if @user
      response = {
        status: true,
        user: @user
      }
      render json: response
    else
      response = { status: false, errors: "Unable to find user" }
      render json: response
    end
  end

  private
  def params_sessions
    params.permit()
  end
end
