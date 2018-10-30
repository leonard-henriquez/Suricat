class UserOpportunitiesController < ApplicationController
  before_action :set_user_opportunity, only: [:show, :set_review, :set_pending, :set_applied, :set_trash, :destroy]

  def index
    @user_opportunities = policy_scope(UserOpportunity).where(status: params[:status])
  end

  def show
  end

  def set_status
    @user_opportunity.status = params[:status]
    @user_opportunity.save
  end

  def destroy
    @user_opportunity.destroy
  end

  private

  def set_user_opportunity
    @user_opportunity = UserOpportunity.find(params[:id])
  end
end
