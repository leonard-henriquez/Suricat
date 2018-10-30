class UserOpportunitiesController < ApplicationController
  before_action :set_user_opportunity, only: [:show, :update, :destroy]

  def index
    @user_opportunities = policy_scope(UserOpportunity)
    @user_opportunities = @user_opportunities.where(status: params[:status]) unless params[:status].nil?
    # ADD ORDER BY
  end

  def show
  end

  def update
    @user_opportunity.status = params[:status]
    @user_opportunity.save
    authorize @user_opportunity
  end

  def destroy
    @user_opportunity.destroy
    authorize @user_opportunity
  end

  private

  def set_user_opportunity
    @user_opportunity = UserOpportunity.find(params[:id])
  end

  def user_opportunity_params
    params.require(:user_opportunity).permit(:status)
  end
end
