class OpportunitiesController < ApplicationController
  before_action :set_opportunity, only: [:show]
  before_action :set_user_opportunity, only [:review, :pending, :applied, :trash]
  before_action
  def show
  end

  def review
  end

  def pending
  end

  def applied
  end

  def trash
  end

  def destroy
  end

  private

  def set_opportunity
    @opportunity = Opportunity.find(params[:id])
  end

  def set_user_opportunity
    @user_opportunities = User_opportunity.find(params(opportunity_id))
  end

  def user_opportunity_params
    params.require(:user_opportunity).permit(:opportunity_id, :value, :automatic_grade, :personnal_grade, :status)
  end
end
