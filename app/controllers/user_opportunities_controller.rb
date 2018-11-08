# frozen_string_literal: true

class UserOpportunitiesController < ApplicationController
  before_action :set_user_opportunity, only: %i[show update destroy]

  def index
    if current_user.intro
      @intro = false
    else
      @intro = true
      current_user.intro = true
      current_user.save
    end
    @status = params[:status]
    @user_opportunities_displayed = @user_opportunities.where(status: @status) unless @status.nil?
    @user_opportunities_displayed = @user_opportunities_displayed.sort_by { |op| [op.personnal_grade, op.automatic_grade] || 0 }.reverse
  end

  def show
    authorize @user_opportunity
    @opportunity = UserOpportunity.find(params[:id])
    if @opportunity.nil?
      @marker = {lat: nil, lng: nil}
    else
      @marker =
        {
          lat: @opportunity.latitude,
          lng: @opportunity.longitude
        }
    end
  end

  def update

    @user_opportunity.status = params[:status]
    @user_opportunity.save
    authorize @user_opportunity
    if params[:from] == 'show'
      redirect_to opportunities_review_path
    end
  end

  def destroy
    @user_opportunity.destroy
    authorize @user_opportunity
  end

  def sidebar?
    true
  end

  private

  def set_user_opportunity
    @user_opportunity = UserOpportunity.find(params[:id])
  end

  def user_opportunity_params
    params.require(:user_opportunity).permit(:status, :opportunity_id)
  end
end
