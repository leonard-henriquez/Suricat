# frozen_string_literal: true

class UserOpportunitiesController < ApplicationController
  before_action :set_user_opportunity, only: %i[show update destroy]

  def index
    @user_opportunities_displayed = @user_opportunities
    @user_opportunities_displayed = @user_opportunities.where(status: params[:status]) unless params[:status].nil?
    # ADD ORDER BY
  end

  def show
    authorize @user_opportunity
    @opportunity = Opportunity.where(params[:opportunity_id]).first
    @markers =
      {
        lat: @opportunity.latitude,
        lng: @opportunity.longitude,
        # infoWindow: { content: render_to_string(partial: "/opportunities/map_box", locals: { flat: flat }) }
      }
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
