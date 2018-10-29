class UserOpportunitiesController < ApplicationController
  before_action :set_user_opportunity, only: [:show, :set_review, :set_pending, :set_applied, :set_trash, :destroy]

  def index
    @user_opportunities = policy_scope(UserOpportunity)
  end

  def show
  end

  def set_review
    @user_opportunity.status = 0
  end


  def set_pending
    @user_opportunity.status = 1
  end


  def set_applied
    @user_opportunity.status = 2
  end

  def set_trash
    @user_opportunity.status = 3
  end

  def destroy
    @user_opportunity.destroy
  end

  private

  def set_user_opportunity
    @user_opportunity = UserOpportunity.find(params[:id])
  end
end
