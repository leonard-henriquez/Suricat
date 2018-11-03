# frozen_string_literal: true

class ProfilesController < ApplicationController
  def index
    @user_opportunities = UserOpportunity.where(status: %i[pending applied])
    @user_opportunities_id = @user_opportunities.map(&:opportunity_id)
    # @opportunities = Opportunity.where(id: @user_opportunities_id).where.not(latitude: nil, longitude: nil)
    @opportunities = Opportunity.where(id: @user_opportunities_id.uniq)
    @markers = @opportunities.map do |opportunity|
      {
        lat: opportunity.latitude,
        lng: opportunity.longitude,
        # infoWindow: { content: render_to_string(partial: "/opportunities/map_box", locals: { flat: flat }) }
      }
    end
  end
end
