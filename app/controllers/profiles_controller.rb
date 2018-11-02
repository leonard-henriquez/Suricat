class ProfilesController < ApplicationController

  def index
    @user_opportunities = UserOpportunity.where(status: [:pending, :applied])
    @user_opportunities_id = @user_opportunities.map do |user_opportunity|
      user_opportunity.opportunity_id
    end
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
