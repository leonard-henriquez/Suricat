# frozen_string_literal: true

class ProfilesController < ApplicationController
  def index
    @importances = policy_scope(Importance)
    @importances = @importance.order(:name) unless @importance.nil?
    @importances_values = @importances.all.map {|i| [i.name, i.value] }.to_h

    @markers_pending = @user_opportunities.where(status: :pending).map do |u_op|
      title = "#{u_op.title} @#{u_op.company_name}"
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
      title = "#{u_op.title} @#{u_op.company_name}"
      {
        title: title,
        lat: u_op.opportunity.latitude,
        lng: u_op.opportunity.longitude,
        infoWindow: {
          content: "<p>#{title}</p>",
        }
      }
    end
  end
end
