class ProfilesController < ApplicationController

  def index
    @markers_pending = @user_opportunities.where(status: :pending).map do |u_op|
      title = "#{u_op.job_title} @#{u_op.company_name}"
      {
        title: title,
        lat: u_op.opportunity.latitude,
        lng: u_op.opportunity.longitude,
        infoWindow: {
          content: "<p>#{title}</p>"
        }
      }
    end
    @markers_applied = @user_opportunities.where(status: :applied).map do |u_op|
      title = "#{u_op.job_title} @#{u_op.company_name}"
      {
        title: title,
        lat: u_op.opportunity.latitude,
        lng: u_op.opportunity.longitude,
        infoWindow: {
          content: "<p>#{title}</p>"
        }
      }
    end

    @length_markers_pending = @markers_pending.length
    @length_markers_applied = @markers_applied.length
  end
end
