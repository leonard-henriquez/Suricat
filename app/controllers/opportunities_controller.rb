class OpportunitiesController < ApplicationController
  before_action :set_opportunity, only: [:show]
  before_action :set_user_opportunities, only [:review, :pending, :applied, :trash, :set_user_opportunity]
  before_action :set_user_opportunity, only [:set_review, :set_pending, :set_applied, :set_trash, :destroy]
  def show
  end

  def set_review
    @user_opportunity.status = 0
  end

  def review
    @user_opportunities.where(status: 0)
  end

  def set_pending
    @user_opportunity.status = 1
  end

  def pending
    @user_opportunities.where(status: 1)
  end

  def set_applied
    @user_opportunity.status = 2
  end

  def applied
    @user_opportunities.where(status: 2)
  end

  def set_trash
    @user_opportunity.status = 3
  end

  def trash
    @user_opportunities.where(status: 3)
  end

  def destroy
    @user_opportunity.destroy
  end

  private

  def set_opportunity
    @opportunity = Opportunity.find(params[:id])
  end

  def set_user_opportunities
    @user_id = User.find(params[:id])
    @user_opportunities = UserOpportunity.where(user_id: @user_id)
  end

  def set_user_opportunity
    @user_opportunity = @user_opportunities.find(params[:opportunity_id])
  end
end
