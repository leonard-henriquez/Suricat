# frozen_string_literal: true

class UserOpportunitiesController < ApplicationController
  layout 'sidebar'

  before_action :set_user_opportunity, only: [:show, :update, :destroy]

  def index
    if current_user.intro
      @intro = false
      @status = params[:status]
      @user_opportunities_displayed = @user_opportunities.where(status: @status) unless @status.nil?
      @user_opportunities_displayed = @user_opportunities_displayed.sort_by { |op| [op.personnal_grade || 0, op.automatic_grade || 0] }.reverse unless @user_opportunities_displayed.nil?
    else
      @intro = true
      current_user.intro = true
      current_user.save
      @user_opportunities_displayed = [UserOpportunity.first]
    end
  end

  def show
    authorize @user_opportunity
    @opportunity = UserOpportunity.find(params[:id])
    @marker = if @opportunity.nil?
                { lat: nil, lng: nil }
              else
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
    redirect_to opportunities_review_path if params[:from] == 'show'
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
    params.require(:user_opportunity).permit(:status, :opportunity_id)
  end
end
