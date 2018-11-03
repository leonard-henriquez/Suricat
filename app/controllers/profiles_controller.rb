class ProfilesController < ApplicationController

  def index
    @user_opportunities_pending = UserOpportunity.where(status: :pending)
    @user_opportunities_pending_id = @user_opportunities_pending.map do |user_opportunity|
      user_opportunity.opportunity_id
    end
    # @opportunities = Opportunity.where(id: @user_opportunities_id).where.not(latitude: nil, longitude: nil)
    @opportunities_pending = Opportunity.where(id: @user_opportunities_pending_id.uniq)
    @markers_pending = @opportunities_pending.map do |opportunity|
      {
        lat: opportunity.latitude,
        lng: opportunity.longitude,
        status: 'pending',
        # infoWindow: { content: render_to_string(partial: “/opportunities/map_box”, locals: { flat: flat }) }
      }
    end

    @user_opportunities_applied = UserOpportunity.where(status: :applied)
    @user_opportunities_applied_id = @user_opportunities_applied.map do |user_opportunity|
      user_opportunity.opportunity_id
    end
    # @opportunities = Opportunity.where(id: @user_opportunities_id).where.not(latitude: nil, longitude: nil)
    @opportunities_applied = Opportunity.where(id: @user_opportunities_applied_id.uniq)
    @markers_applied = @opportunities_applied.map do |opportunity|
      {
        lat: opportunity.latitude,
        lng: opportunity.longitude,
        status: 'applied',
        # infoWindow: { content: render_to_string(partial: “/opportunities/map_box”, locals: { flat: flat }) }
      }
    end

    @markers = @markers_pending << @markers_applied
  end
end
