# frozen_string_literal: true

class UserOpportunitiesController < ApplicationController
  before_action :set_user_opportunity, only: %i[show update destroy]

  def index
    @status = params[:status]
    @user_opportunities_displayed = @user_opportunities
    @user_opportunities_displayed = @user_opportunities.where(status: @status) unless @status.nil?
    @user_opportunities_displayed.sort_by(&:personnal_grade)
    @user_opportunities_displayed.sort_by(&:automatic_grade)
    # ADD ORDER BY
  end

  def show
    authorize @user_opportunity
    @opportunity = UserOpportunity.find(params[:id])
    unless @opportunity.nil?
      title = "#{@opportunity.title} @#{@opportunity.company_name}"
      @marker =
      {
        lat: @opportunity.latitude,
        lng: @opportunity.longitude,
        infoWindow: {
          content: "<p>#{title}</p>"
        }
      }
    else
      @marker = { lat: nil, lng: nil }
    end
  end

  def update
    @user_opportunity.status = params[:status]
    @user_opportunity.grade_calculation
    @user_opportunity.save
    authorize @user_opportunity
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
